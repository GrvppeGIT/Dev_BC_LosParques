namespace FJH.ElectronicPayments;

using Microsoft.Bank.Payment;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.HumanResources.Employee;
using System.Utilities;
using Microsoft.Bank.Setup;
using Microsoft.Bank.DirectDebit;
using Microsoft.Sales.Receivables;
using Microsoft.Purchases.Payables;
using Microsoft.HumanResources.Payables;
using System.Reflection;

codeunit 50102 "FJH CT-Fill Export Buffer"
{
    Permissions = TableData "Payment Export Data" = rimd;
    TableNo = "Payment Export Data";

    trigger OnRun()
    begin
    end;

    var
        HasErrorsErr: Label 'The file export has one or more errors.\\For each line to be exported, resolve the errors displayed to the right and then try to export again.';
        FieldIsBlankErr: Label 'Field %1 must be specified.', Comment = '%1=field name, e.g. Post Code.';
        SameBankErr: Label 'All lines must have the same bank account as the balancing account.';
        RemitMsg: Label '%1 %2', Comment = '%1=Document type, %2=Document no., e.g. Invoice A123';

    procedure FillExportBuffer(var GenJnlLine: Record "Gen. Journal Line"; var PaymentExportData: Record "Payment Export Data")
    var
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        TempInteger: Record "Integer" temporary;
        VendorBankAccount: Record "Vendor Bank Account";
        CustomerBankAccount: Record "Customer Bank Account";
        CreditTransferRegister: Record "Credit Transfer Register";
        CreditTransferEntry: Record "Credit Transfer Entry";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        MessageID: Code[20];
    begin
        TempGenJnlLine.CopyFilters(GenJnlLine);
        CODEUNIT.Run(CODEUNIT::"SEPA CT-Prepare Source", TempGenJnlLine);

        TempGenJnlLine.Reset();
        TempGenJnlLine.FindSet();
        BankAccount.Get(TempGenJnlLine."Bal. Account No.");
        BankAccount.GetBankExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TestField("Check Export Codeunit");
        //TempGenJnlLine.DeletePaymentFileBatchErrors();
        repeat
            TempGenJnlLine.DeletePaymentFileBatchErrors();
            CODEUNIT.Run(BankExportImportSetup."Check Export Codeunit", TempGenJnlLine);
            if TempGenJnlLine."Bal. Account No." <> BankAccount."No." then
                TempGenJnlLine.InsertPaymentFileError(SameBankErr);
        until TempGenJnlLine.Next() = 0;

        if TempGenJnlLine.HasPaymentFileErrorsInBatch() then begin
            Commit();
            Error(HasErrorsErr);
        end;

        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");

        MessageID := BankAccount.GetCreditTransferMessageNo();
        CreditTransferRegister.CreateNew(MessageID, BankAccount."No.");

        PaymentExportData.Reset();
        if PaymentExportData.FindLast() then;

        TempGenJnlLine.FindSet();
        repeat
            PaymentExportData.Init();
            PaymentExportData."Entry No." += 1;
            PaymentExportData.SetPreserveNonLatinCharacters(BankExportImportSetup."Preserve Non-Latin Characters");
            PaymentExportData.SetBankAsSenderBank(BankAccount);

            PaymentExportData."General Journal Template" := TempGenJnlLine."Journal Template Name";
            PaymentExportData."General Journal Batch Name" := TempGenJnlLine."Journal Batch Name";
            PaymentExportData."General Journal Line No." := TempGenJnlLine."Line No.";
            PaymentExportData."FJH Agreement No." := BankAccount."Creditor No.";

            PaymentExportData."Transfer Date" := TempGenJnlLine."Posting Date";
            PaymentExportData."Document No." := TempGenJnlLine."Document No.";
            PaymentExportData."Applies-to Ext. Doc. No." := TempGenJnlLine."Applies-to Ext. Doc. No.";
            PaymentExportData.Amount := TempGenJnlLine.Amount;
            if TempGenJnlLine."Currency Code" = '' then
                PaymentExportData."Currency Code" := GeneralLedgerSetup."LCY Code"
            else
                PaymentExportData."Currency Code" := TempGenJnlLine."Currency Code";

            case TempGenJnlLine."Account Type" of
                TempGenJnlLine."Account Type"::Customer:
                    begin
                        Customer.Get(TempGenJnlLine."Account No.");
                        CustomerBankAccount.Get(Customer."No.", TempGenJnlLine."Recipient Bank Account");
                        PaymentExportData.SetCustomerAsRecipient(Customer, CustomerBankAccount);
                    end;
                TempGenJnlLine."Account Type"::Vendor:
                    begin
                        Vendor.Get(TempGenJnlLine."Account No.");
                        VendorBankAccount.Get(Vendor."No.", TempGenJnlLine."Recipient Bank Account");
                        PaymentExportData.SetVendorAsRecipient(Vendor, VendorBankAccount);
                    end;
                TempGenJnlLine."Account Type"::Employee:
                    begin
                        Employee.Get(TempGenJnlLine."Account No.");
                        PaymentExportData.SetEmployeeAsRecipient(Employee);
                    end;
            end;

            PaymentExportData.Validate(PaymentExportData."SEPA Instruction Priority", PaymentExportData."SEPA Instruction Priority"::NORMAL);
            PaymentExportData.Validate(PaymentExportData."SEPA Payment Method", PaymentExportData."SEPA Payment Method"::TRF);
            PaymentExportData.Validate(PaymentExportData."SEPA Charge Bearer", PaymentExportData."SEPA Charge Bearer"::SLEV);
            PaymentExportData."SEPA Batch Booking" := false;
            PaymentExportData.SetCreditTransferIDs(MessageID);

            if PaymentExportData."Applies-to Ext. Doc. No." <> '' then
                PaymentExportData.AddRemittanceText(StrSubstNo(RemitMsg, TempGenJnlLine."Applies-to Doc. Type", PaymentExportData."Applies-to Ext. Doc. No."))
            else
                PaymentExportData.AddRemittanceText(TempGenJnlLine.Description);
            if TempGenJnlLine."Message to Recipient" <> '' then
                PaymentExportData.AddRemittanceText(TempGenJnlLine."Message to Recipient");

            //Add Message to Recipient for reference on payment.
            PaymentExportData."Message to Recipient 1" := TempGenJnlLine."Message to Recipient";

            ValidatePaymentExportData(PaymentExportData, TempGenJnlLine);
            PaymentExportData.Insert(true);
            TempInteger.DeleteAll();
            GetAppliesToDocEntryNumbers(TempGenJnlLine, TempInteger);
            if TempInteger.FindSet() then
                repeat
                    CreateNewCreditTransferEntry(
                        PaymentExportData, CreditTransferEntry, CreditTransferRegister, TempGenJnlLine, 0, TempInteger.Number);
                until TempInteger.Next() = 0
            else
                CreateNewCreditTransferEntry(
                    PaymentExportData, CreditTransferEntry, CreditTransferRegister, TempGenJnlLine,
                    CreditTransferEntry."Entry No." + 1, TempGenJnlLine.GetAppliesToDocEntryNo());
        until TempGenJnlLine.Next() = 0;

    end;

    local procedure CreateNewCreditTransferEntry(var PaymentExportData: Record "Payment Export Data"; var CreditTransferEntry: Record "Credit Transfer Entry"; CreditTransferRegister: Record "Credit Transfer Register"; var TempGenJnlLine: Record "Gen. Journal Line" temporary; EntryNo: Integer; LedgerEntryNo: Integer)
    begin
        CreditTransferEntry.CreateNew(
                CreditTransferRegister."No.", EntryNo,
                TempGenJnlLine."Account Type", TempGenJnlLine."Account No.", LedgerEntryNo,
                PaymentExportData."Transfer Date", PaymentExportData."Currency Code", PaymentExportData.Amount, CopyStr(PaymentExportData."End-to-End ID", 1, MaxStrLen(PaymentExportData."End-to-End ID")),
                TempGenJnlLine."Recipient Bank Account", TempGenJnlLine."Message to Recipient");

    end;

    internal procedure GetAppliesToDocEntryNumbers(GenJournalLine: Record "Gen. Journal Line"; var TempInteger: Record "Integer" temporary)
    var
        AccNo: Code[20];
        AccType: Enum "Gen. Journal Account Type";
    begin
        if GenJournalLine."Bal. Account Type" in [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor, GenJournalLine."Account Type"::Employee] then begin
            AccType := GenJournalLine."Bal. Account Type";
            AccNo := GenJournalLine."Bal. Account No.";
        end else begin
            AccType := GenJournalLine."Account Type";
            AccNo := GenJournalLine."Account No.";
        end;
        case AccType of
            GenJournalLine."Account Type"::Customer:
                GetAppliesToDocCustLedgEntries(GenJournalLine, TempInteger, AccNo);
            GenJournalLine."Account Type"::Vendor:
                GetAppliesToDocVendLedgEntries(GenJournalLine, TempInteger, AccNo);
            GenJournalLine."Account Type"::Employee:
                GetAppliesToDocEmplLedgEntries(GenJournalLine, TempInteger, AccNo);
        end;
    end;

    local procedure GetAppliesToDocCustLedgEntries(GenJournalLine: Record "Gen. Journal Line"; var TempInteger: Record "Integer" temporary; AccNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentKey(CustLedgEntry."Customer No.", CustLedgEntry."Document No.");
        CustLedgEntry.SetRange(CustLedgEntry."Customer No.", AccNo);
        CustLedgEntry.SetRange(CustLedgEntry.Open, true);
        case true of
            GenJournalLine."Applies-to Doc. No." <> '':
                begin
                    CustLedgEntry.SetRange(CustLedgEntry."Document Type", GenJournalLine."Applies-to Doc. Type");
                    CustLedgEntry.SetRange(CustLedgEntry."Document No.", GenJournalLine."Applies-to Doc. No.");
                end;
            GenJournalLine."Applies-to ID" <> '':
                begin
                    CustLedgEntry.SetCurrentKey(CustLedgEntry."Customer No.", CustLedgEntry."Applies-to ID");
                    CustLedgEntry.SetRange(CustLedgEntry."Applies-to ID", GenJournalLine."Applies-to ID");
                end;
            else
                exit;
        end;

        GetEntriesFromSet(TempInteger, CustLedgEntry);
    end;

    local procedure GetAppliesToDocVendLedgEntries(GenJournalLine: Record "Gen. Journal Line"; var TempInteger: Record "Integer" temporary; AccNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SetCurrentKey(VendLedgEntry."Vendor No.", VendLedgEntry."Document No.");
        VendLedgEntry.SetRange(VendLedgEntry."Vendor No.", AccNo);
        VendLedgEntry.SetRange(VendLedgEntry.Open, true);
        case true of
            GenJournalLine."Applies-to Doc. No." <> '':
                begin
                    VendLedgEntry.SetRange(VendLedgEntry."Document Type", GenJournalLine."Applies-to Doc. Type");
                    VendLedgEntry.SetRange(VendLedgEntry."Document No.", GenJournalLine."Applies-to Doc. No.");
                end;
            GenJournalLine."Applies-to ID" <> '':
                begin
                    VendLedgEntry.SetCurrentKey(VendLedgEntry."Vendor No.", VendLedgEntry."Applies-to ID");
                    VendLedgEntry.SetRange(VendLedgEntry."Applies-to ID", GenJournalLine."Applies-to ID");
                end;
            else
                exit;
        end;

        GetEntriesFromSet(TempInteger, VendLedgEntry);
    end;

    local procedure GetAppliesToDocEmplLedgEntries(GenJournalLine: Record "Gen. Journal Line"; var TempInteger: Record "Integer" temporary; AccNo: Code[20])
    var
        EmplLedgEntry: Record "Employee Ledger Entry";
    begin
        EmplLedgEntry.SetCurrentKey(EmplLedgEntry."Employee No.", EmplLedgEntry."Document No.");
        EmplLedgEntry.SetRange(EmplLedgEntry."Employee No.", AccNo);
        EmplLedgEntry.SetRange(EmplLedgEntry.Open, true);
        case true of
            GenJournalLine."Applies-to Doc. No." <> '':
                begin
                    EmplLedgEntry.SetRange(EmplLedgEntry."Document Type", GenJournalLine."Applies-to Doc. Type");
                    EmplLedgEntry.SetRange(EmplLedgEntry."Document No.", GenJournalLine."Applies-to Doc. No.");
                end;
            GenJournalLine."Applies-to ID" <> '':
                begin
                    EmplLedgEntry.SetCurrentKey(EmplLedgEntry."Employee No.", EmplLedgEntry."Applies-to ID");
                    EmplLedgEntry.SetRange(EmplLedgEntry."Applies-to ID", GenJournalLine."Applies-to ID");
                end;
            else
                exit;
        end;

        GetEntriesFromSet(TempInteger, EmplLedgEntry);
    end;

    local procedure GetEntriesFromSet(var TempInteger: Record "Integer" temporary; RecVariant: Variant)
    var
        FieldRef: FieldRef;
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(RecVariant);
        FieldRef := RecordRef.FieldIndex(1);
        if RecordRef.FindSet() then
            repeat
                TempInteger.Number := FieldRef.Value;
                TempInteger.Insert();
            until RecordRef.Next() = 0;
    end;

    local procedure ValidatePaymentExportData(var PaymentExportData: Record "Payment Export Data"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FieldName("Sender Bank Account No."));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FieldName("Recipient Name"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FieldName("Recipient Bank Acc. No."));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FieldName("Transfer Date"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FieldName("Payment Information ID"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FieldName("End-to-End ID"));
    end;

    local procedure ValidatePaymentExportDataField(var PaymentExportData: Record "Payment Export Data"; var GenJnlLine: Record "Gen. Journal Line"; FieldName: Text)
    var
        "Field": Record "Field";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.GetTable(PaymentExportData);
        Field.SetRange(TableNo, RecRef.Number);
        Field.SetRange(FieldName, FieldName);
        Field.FindFirst();
        FieldRef := RecRef.Field(Field."No.");
        if (Field.Type = Field.Type::Text) and (Format(FieldRef.Value) <> '') then
            exit;
        if (Field.Type = Field.Type::Code) and (Format(FieldRef.Value) <> '') then
            exit;
        if (Field.Type = Field.Type::Decimal) and (Format(FieldRef.Value) <> '0') then
            exit;
        if (Field.Type = Field.Type::Integer) and (Format(FieldRef.Value) <> '0') then
            exit;
        if (Field.Type = Field.Type::Date) and (Format(FieldRef.Value) <> '0D') then
            exit;

        PaymentExportData.AddGenJnlLineErrorText(GenJnlLine, StrSubstNo(FieldIsBlankErr, Field."Field Caption"));
    end;

}
