namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Integration.Entity;
using Microsoft.Sales.History;
using Microsoft.Integration.Graph;
using Microsoft.API.V2;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.ReceivablesPayables;


page 50105 "APILP - CustomerApplyEntry"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'LPCustomerApplyEntry';
    DelayedInsert = true;
    EntityName = 'LPCcustomerPaymentApply';
    EntitySetName = 'LPcustomerPaymentApplies';
    PageType = API;
    ODataKeyFields = SystemId;
    SourceTable = "LP Cust. Ledger Entry Buffer";
    SourceTableTemporary = true;
    Extensible = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customerName; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(extDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(open; Rec.Open)
                {
                    Caption = 'Open';
                }
                field(remainingAmount; Rec."Remaining Amount")
                {
                    Caption = 'Remaining Amount';
                }
                field(appliedToDocType; Rec."Applies-to Doc. Type")
                {
                    Caption = 'Applies to Doc. Type';
                }
                field(appliedToDocNo; Rec."Applies-to Doc. No.")
                {
                    Caption = 'Applies to Doc. Number';
                }
                field(appliedAmount; Rec."Applied Amount")
                {
                    Caption = 'Applied Amount';
                }
                field(ApplyOperation; ApplyOperation)
                {
                    Caption = 'Apply Operation';
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        CustomerIDFilter: Text;
        CustomerNoFilter: Text;
        DocumentTypeFilter: Text;
        DocumentNoFilter: Text;
        ExtDocumentNoFilter: Text;
        FilterView: Text;
        AuxCLE: record "Cust. Ledger Entry";
    begin
        CustomerNoFilter := Rec.GetFilter("Customer No.");
        DocumentTypeFilter := Rec.GetFilter("Document Type");
        DocumentNoFilter := Rec.GetFilter("Document No.");
        ExtDocumentnoFilter := Rec.GetFilter("External Document No.");
        if (CustomerNoFilter = '') or (DocumentTypeFilter = '') or (DocumentNoFilter = '') then
            Error(FiltersNotSpecifiedErr);
        if RecordsLoaded then
            exit(true);
        AuxCLE.Reset();
        AuxCLE.SetFilter("Customer No.", CustomerNoFilter);
        AuxCLE.SetFilter("Document Type", DocumentTypeFilter);
        AuxCLE.SetFilter("Document No.", DocumentNoFilter);
        if ExtDocumentNoFilter <> '' then
            AuxCLE.SetFilter("External Document No.", ExtDocumentNoFilter);
        AuxCLE.FindFirst();

        FilterView := Rec.GetView();
        Rec.LoadDataFromCLE(AuxCLE."Entry No.");
        Rec.SetView(FilterView);
        if not Rec.FindFirst() then
            exit(false);
        RecordsLoaded := true;
        exit(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        applyCLE: record "Cust. Ledger Entry";
        appliedCLE: record "Cust. Ledger Entry";
        AmountToApply: decimal;
        CLESetApply: codeunit "Cust. Entry-SetAppl.ID";
        CLEPostApply: codeunit "CustEntry-Apply Posted Entries";
        ApplyParam: record "Apply Unapply Parameters" temporary;
        DtldCustLedgEntry: record "Detailed Cust. Ledg. Entry";
    begin
        If ApplyOperation = ApplyOperation::Apply then begin
            Clear(CLESetApply);
            Clear(CLEPostApply);

            applyCLE.Reset();
            applyCLE.SetRange("Customer No.", Rec."Customer No.");
            applyCLE.SetFilter("Document Type", '=%1', Rec."Document Type");
            applyCLE.SetRange("Document No.", Rec."Document No.");
            if Rec."External Document No." <> '' then
                applyCLE.SetRange("External Document No.", Rec."External Document No.");
            applyCLE.SetRange(Open, true);
            if not applyCLE.FindFirst() then
                error('Document: %1 %2 open, not found.', Rec."Document Type", Rec."Document No.");

            applyCLE.CalcFields(Amount, "Remaining Amount");
            if applyCLE."Remaining Amount" = 0 then
                error('Document: %1 %2 not open.', Rec."Document Type", Rec."Document No.");

            appliedCLE.Reset();
            appliedCLE.SetRange("Customer No.", Rec."Customer No.");
            appliedCLE.SetFilter("Document Type", '=%1', Rec."Applies-to Doc. Type");
            appliedCLE.SetRange("Document No.", Rec."Applies-to Doc. No.");
            appliedCLE.SetRange(Open, true);
            if not appliedCLE.FindFirst() then
                error('Document: %1 %2 open, not found.', Rec."Applies-to Doc. Type", Rec."Applies-to Doc. No.");

            appliedCLE.CalcFields(Amount, "Remaining Amount");
            if appliedCLE."Remaining Amount" = 0 then
                error('Document: %1 %2 not open.', Rec."Applies-to Doc. Type", Rec."Applies-to Doc. No.");

            if round(ABS(applyCLE."Remaining Amount") / applyCLE."Remaining Amount", 1) =
                round(ABS(appliedCLE."Remaining Amount") / appliedCLE."Remaining Amount", 1) then
                error('Cannot apply documents with the same sign.');

            AmountToApply := Rec."Applied Amount";

            applyCLE."Applying Entry" := True;
            applyCLE."Applies-to ID" := USERID;
            ApplyCLE.Validate("Amount to Apply", AmountToApply);
            CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", ApplyCLE);
            CLESetApply.SetApplId(appliedCLE, applyCLE, USERID);

            ApplyParam.Reset();
            ApplyParam.CopyFromCustLedgEntry(appliedCLE);
            if Rec."Posting Date" <> 0D then
                ApplyParam."Posting Date" := Rec."Posting Date";

            CLEPostApply.Apply(ApplyCLE, ApplyParam);

        end;

        if ApplyOperation = ApplyOperation::Unapply then begin
            applyCLE.Reset();
            applyCLE.SetRange("Customer No.", Rec."Customer No.");
            applyCLE.SetFilter("Document Type", '=%1', Rec."Document Type");
            applyCLE.SetRange("Document No.", Rec."Document No.");
            if not applyCLE.FindFirst() then
                error('Document: %1 %2 open, not found.', Rec."Document Type", Rec."Document No.");
            applyCLE.Calcfields(Amount, "Remaining Amount");
            if applyCLE.Amount = applyCLE."Remaining Amount" then
                Error('Document: %1 %2 not applied.', Rec."Document Type", Rec."Document No.");

            Clear(CLEPostApply);
            CLEPostApply.CheckCustLedgEntryToUnapply(ApplyCLE."Entry No.", DtldCustLedgEntry);
            ApplyParam.Reset();
            ApplyParam."Document No." := Rec."Document No.";
            ApplyParam."Posting Date" := Rec."Posting Date";
            CLEPostApply.PostUnApplyCustomer(DtldCustLedgEntry, ApplyParam);
        end;

        if ApplyOperation = ApplyOperation::Query then
            error('Invalid Apply Operation: %1', ApplyOperation);

        exit(false);
    end;

    var
        FiltersNotSpecifiedErr: Label 'You must specify a Customer, Document type and Document No.';
        RecordsLoaded: boolean;
        ApplyOperation: Enum "LP Apply Operation";
}
