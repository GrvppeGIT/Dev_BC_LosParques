namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Integration.Entity;
using Microsoft.Sales.History;
using Microsoft.Integration.Graph;
using Microsoft.API.V2;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Bank.BankAccount;

page 50104 "APILP - Customer Payments"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apilpCustomerPayments';
    DelayedInsert = true;
    PageType = API;
    EntityCaption = 'Customer Payment';
    EntitySetCaption = 'Customer Payments';
    ODataKeyFields = SystemId;
    EntityName = 'LPcustomerPayment';
    EntitySetName = 'LPcustomerPayments';
    SourceTable = "Gen. Journal Line";
    Extensible = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(journalId; Rec."Journal Batch Id")
                {
                    Caption = 'Journal Id';

                    trigger OnValidate()
                    begin
                        if (not IsNullGuid(xRec."Journal Batch Id")) and (xRec."Journal Batch Id" <> Rec."Journal Batch Id") then
                            Error(CannotEditJournalIdErr);
                    end;
                }
                field(journalDisplayName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Display Name';

                    trigger OnValidate()
                    begin
                        if (xRec."Journal Batch Name" <> '') and (xRec."Journal Batch Name" <> Rec."Journal Batch Name") then
                            Error(CannotEditBatchNameErr);
                    end;
                }
                field(lineNumber; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';

                    trigger OnValidate()
                    begin
                        if Rec."Customer Id" = BlankGUID then begin
                            Rec."Account No." := '';
                            exit;
                        end;

                        if not Customer.GetBySystemId(Rec."Customer Id") then
                            Error(CustomerIdDoesNotMatchACustomerErr);

                        Rec."Account No." := Customer."No.";
                    end;
                }
                field(customerNumber; Rec."Account No.")
                {
                    Caption = 'Customer No.';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        if Customer."No." <> '' then begin
                            if Customer."No." <> Rec."Account No." then
                                Error(CustomerValuesDontMatchErr);
                            exit;
                        end;

                        if Rec."Account No." = '' then begin
                            Rec."Customer Id" := BlankGUID;
                            exit;
                        end;

                        if not Customer.Get(Rec."Account No.") then
                            Error(CustomerNumberDoesNotMatchACustomerErr);

                        Rec."Customer Id" := Customer.SystemId;
                    end;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNumber; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(externalDocumentNumber; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                    trigger OnValidate()
                    begin
                        tmpPaymentMethodCode := Rec."Payment Method Code";
                    end;
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(appliesToInvoiceId; AppliesToInvoiceIdText)
                {
                    Caption = 'Applies To Invoice Id';

                    trigger OnValidate()
                    var
                        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
                    begin
                        Rec."Applies-to Invoice Id" := AppliesToInvoiceIdText;
                        if Rec."Applies-to Invoice Id" = BlankGUID then begin
                            AppliesToInvoiceNumberText := '';
                            exit;
                        end;

                        SalesInvoiceHeader.Reset();
                        if not SalesInvoiceAggregator.GetSalesInvoiceHeaderFromId(Format(AppliesToInvoiceIdText), SalesInvoiceHeader) then
                            Error(AppliesToInvoiceIdDoesNotMatchAnInvoiceErr);

                        AppliesToInvoiceNumberText := SalesInvoiceHeader."No.";

                        if Rec."Account No." = '' then
                            if SalesInvoiceHeader."Bill-to Customer No." <> '' then
                                Rec."Account No." := SalesInvoiceHeader."Bill-to Customer No."
                            else
                                Rec."Account No." := SalesInvoiceHeader."Sell-to Customer No.";
                    end;
                }
                field(appliesToInvoiceNumber; AppliesToInvoiceNumberText)
                {
                    Caption = 'Applies To Invoice No.';

                    trigger OnValidate()
                    var
                        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
                        BlankGUID: Guid;
                    begin
                        Rec."Applies-to Doc. No." := AppliesToInvoiceNumberText;

                        if SalesInvoiceHeader."No." <> '' then begin
                            if SalesInvoiceHeader."No." <> AppliesToInvoiceNumberText then
                                Error(AppliesToDocValuesDontMatchErr);
                            exit;
                        end;

                        if SalesInvoiceHeader.Get(AppliesToInvoiceNumberText) then begin
                            AppliesToInvoiceIdText := SalesInvoiceAggregator.GetSalesInvoiceHeaderId(SalesInvoiceHeader);
                            if Rec."Account No." = '' then
                                if SalesInvoiceHeader."Bill-to Customer No." <> '' then
                                    Rec."Account No." := SalesInvoiceHeader."Bill-to Customer No."
                                else
                                    Rec."Account No." := SalesInvoiceHeader."Sell-to Customer No.";
                        end else
                            AppliesToInvoiceIdText := BlankGUID;
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(balanceAccountType; Rec."Bal. Account Type")
                {
                    Caption = 'Balance Account Type';
                    trigger OnValidate();
                    begin
                        tmpBalAccType := Rec."Bal. Account Type";
                    end;
                }
                field(balancingAccountId; Rec."Balance Account Id")
                {
                    Caption = 'Balancing Account Id';

                    trigger OnValidate()
                    begin
                        if Rec."Balance Account Id" = BlankGUID then begin
                            Rec."Bal. Account No." := '';
                            exit;
                        end;
                        case Rec."Bal. Account Type" of
                            Rec."Bal. Account Type"::"G/L Account":
                                begin
                                    if not GLAccount.GetBySystemId(Rec."Balance Account Id") then
                                        Error(BalAccountIdDoesNotMatchAnAccountErr);
                                    Rec."Bal. Account No." := GLAccount."No.";
                                    tmpBalAccNo := GLAccount."No.";
                                end;
                            Rec."Bal. Account Type"::"Bank Account":
                                begin
                                    if not BankAccount.GetBySystemId(Rec."Balance Account Id") then
                                        Error(BalAccountIdDoesNotMatchAnAccountErr);
                                    Rec."Bal. Account No." := BankAccount."No.";
                                    tmpBalAccNo := BankAccount."No.";
                                end;
                        end;
                    end;
                }
                field(balancingAccountNumber; Rec."Bal. Account No.")
                {
                    Caption = 'Balancing Account No.';
                    trigger OnValidate()
                    begin
                        if Rec."Bal. Account No." = '' then begin
                            Clear(Rec."Balance Account Id");
                            exit;
                        end;
                        case Rec."Bal. Account Type" of
                            Rec."Bal. Account Type"::"G/L Account":
                                begin
                                    if not GLAccount.Get(Rec."Bal. Account No.") then
                                        Error(BalAccountIdDoesNotMatchAnAccountErr);
                                    Rec."Balance Account Id" := GLAccount.SystemId;
                                    tmpBalAccNo := GLAccount."No.";
                                end;
                            Rec."Bal. Account Type"::"Bank Account":
                                begin
                                    if not BankAccount.Get(Rec."Bal. Account No.") then
                                        Error(BalAccountIdDoesNotMatchAnAccountErr);
                                    Rec."Balance Account Id" := BankAccount.SystemId;
                                    tmpBalAccNo := BankAccount."No.";
                                end;
                        end;
                    end;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
                part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                {
                    Caption = 'Dimension Set Lines';
                    EntityName = 'dimensionSetLine';
                    EntitySetName = 'dimensionSetLines';
                    SubPageLink = "Parent Id" = field(SystemId), "Parent Type" = const("Journal Line");
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if not FiltersChecked then begin
            CheckFilters();
            FiltersChecked := true;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        TempGenJournalLine: Record "Gen. Journal Line" temporary;
        JournalBatchId: Guid;
        JournalBatchIdFilter: Text;
    begin
        if IsNullGuid(Rec."Journal Batch Id") then begin
            JournalBatchIdFilter := Rec.GetFilter("Journal Batch Id");
            if JournalBatchIdFilter = '' then
                Error(FiltersNotSpecifiedErr);
            JournalBatchId := JournalBatchIdFilter;
        end else begin
            JournalBatchIdFilter := Rec.GetFilter("Journal Batch Id");
            if (JournalBatchIdFilter <> '') then begin
                JournalBatchId := JournalBatchIdFilter;
                if (JournalBatchId <> Rec."Journal Batch Id") then
                    Error(JournalBatchIdNameNotMatchErr)
            end else
                JournalBatchId := Rec."Journal Batch Id";
        end;

        ProcessAppliesToInvoiceNumberAndId();

        TempGenJournalLine.Reset();
        TempGenJournalLine.Copy(Rec);

        Clear(Rec);
        GraphMgtCustomerPayments.SetCustomerPaymentsTemplateAndBatch(
          Rec, LibraryAPIGeneralJournal.GetBatchNameFromId(JournalBatchId));
        LibraryAPIGeneralJournal.InitializeLine(
          Rec, TempGenJournalLine."Line No.", TempGenJournalLine."Document No.", TempGenJournalLine."External Document No.");
        TransferGeneratedFieldsFromInitializeLine(TempGenJournalLine);

        GraphMgtCustomerPayments.SetCustomerPaymentsValues(Rec, TempGenJournalLine);

        if tmpBalAccNo <> '' then begin
            Rec.Validate("Bal. Account Type", tmpBalAccType);
            Rec.Validate("Bal. Account No.", tmpBalAccNo);
        end;

        if tmpPaymentMethodCode <> '' then
            Rec.Validate("Payment Method Code", tmpPaymentMethodCode);

        SetCalculatedFields();
    end;

    trigger OnModifyRecord(): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        ProcessAppliesToInvoiceNumberAndId();

        GenJournalLine.GetBySystemId(Rec.SystemId);

        if Rec."Line No." = GenJournalLine."Line No." then
            Rec.Modify(true)
        else begin
            GenJournalLine.TransferFields(Rec, false);
            GenJournalLine.Rename(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Line No.");
            Rec.TransferFields(GenJournalLine, true);
        end;

        SetCalculatedFields();

        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();

        Rec."Document Type" := Rec."Document Type"::Payment;
        Rec."Account Type" := Rec."Account Type"::Customer;
        Rec."Applies-to Doc. Type" := Rec."Applies-to Doc. Type"::Invoice;
    end;

    trigger OnOpenPage()
    begin
        GraphMgtCustomerPayments.SetCustomerPaymentsFilters(Rec);
    end;

    var
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        GraphMgtCustomerPayments: Codeunit "Graph Mgt - Customer Payments";
        LibraryAPIGeneralJournal: Codeunit "Library API - General Journal";
        AppliesToInvoiceNumberText: Code[20];
        AppliesToInvoiceIdText: Guid;
        FiltersNotSpecifiedErr: Label 'You must specify a journal batch ID or a journal ID to get a journal line.';
        JournalBatchIdNameNotMatchErr: Label 'The Journal Id and Journal Display Name do not match.';
        CannotEditBatchNameErr: Label 'The Journal Batch Display Name cannot be changed.';
        CannotEditJournalIdErr: Label 'The Journal Id cannot be changed.';
        CustomerValuesDontMatchErr: Label 'The customer values do not match to a specific Customer.';
        CustomerIdDoesNotMatchACustomerErr: Label 'The "customerId" does not match to a Customer.', Comment = 'customerId is a field name and should not be translated.';
        CustomerNumberDoesNotMatchACustomerErr: Label 'The "customerNumber" does not match to a Customer.', Comment = 'customerNumber is a field name and should not be translated.';
        AppliesToDocValuesDontMatchErr: Label 'The Applies To Invoice values do not match to the same Invoice.';
        AppliesToInvoiceIdDoesNotMatchAnInvoiceErr: Label 'The "appliesToInvoiceId" should be the ID of an Open, Paid, Corrective, or Canceled Invoice.', Comment = 'appliesToInvoiceId is a field name and should not be translated.';
        BalAccountIdDoesNotMatchAnAccountErr: Label 'The "balancingAccountId" does not match to an Account.', Comment = 'balancingAccountId is a field name and should not be translated.';
        FiltersChecked: Boolean;
        BlankGUID: Guid;
        tmpBalAccType: enum "Gen. Journal Account Type";
        tmpBalAccNo: code[20];
        tmpPaymentMethodCode: code[20];

    local procedure TransferGeneratedFieldsFromInitializeLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Document No." = '' then
            GenJournalLine."Document No." := Rec."Document No.";
    end;

    local procedure SetCalculatedFields()
    begin
        AppliesToInvoiceNumberText := Rec."Applies-to Doc. No.";
        AppliesToInvoiceIdText := Rec."Applies-to Invoice Id";
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(AppliesToInvoiceIdText);
        Clear(AppliesToInvoiceNumberText);
    end;

    local procedure ProcessAppliesToInvoiceNumberAndId()
    begin
        if AppliesToInvoiceNumberText <> '' then
            Rec."Applies-to Doc. No." := AppliesToInvoiceNumberText;
        Rec."Applies-to Invoice Id" := AppliesToInvoiceIdText;
    end;

    local procedure CheckFilters()
    begin
        if (Rec.GetFilter("Journal Batch Id") = '') and
           (Rec.GetFilter(SystemId) = '')
        then
            Error(FiltersNotSpecifiedErr);
    end;
}

