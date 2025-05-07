namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.API.V2;
using Microsoft.Projects.Project.Ledger;

page 50114 "APILP - G/L Entries"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apilpGLEntries';
    DelayedInsert = true;
    EntityName = 'lpGeneralLedgerEntry';
    EntitySetName = 'lpGeneralLedgerEntries';
    PageType = API;
    SourceTable = "G/L Entry";
    EntityCaption = 'LP General Ledger Entry';
    EntitySetCaption = 'LP General Ledger Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Extensible = false;
    ODataKeyFields = SystemId;

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
                field(entryNumber; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    Editable = false;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNumber; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(accountId; Rec."Account Id")
                {
                    Caption = 'Account Id';
                }
                field(accountNumber; Rec."G/L Account No.")
                {
                    Caption = 'Account No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(debitAmount; Rec."Debit Amount")
                {
                    Caption = 'Debit Amount';
                    AutoFormatType = 0;
                    DecimalPlaces = 0;
                }
                field(creditAmount; Rec."Credit Amount")
                {
                    Caption = 'Credit Amount';
                    AutoFormatType = 0;
                    DecimalPlaces = 0;
                }
                field(additionalCurrencyDebitAmount; Rec."Add.-Currency Debit Amount")
                {
                    Caption = 'Additional Currency Debit Amount';
                    AutoFormatType = 0;
                    DecimalPlaces = 0;
                }
                field(additionalCurrencyCreditAmount; Rec."Add.-Currency Credit Amount")
                {
                    Caption = 'Additional Currency Credit Amount';
                    AutoFormatType = 0;
                    DecimalPlaces = 0;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }
                field(sourceCode; Rec."Source Code")
                {
                    Caption = 'Source Code';
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(glRegisterNo; GLRegNo)
                {
                    Caption = 'G/L Register No.';
                }
                field("jobNumber"; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(JobTaskNumber; Rec."FJH.Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                part(attachments; "APIV2 - Attachments")
                {
                    Caption = 'Attachments';
                    EntityName = 'attachment';
                    EntitySetName = 'attachments';
                    SubPageLink = "Document Id" = field(SystemId), "Document Type" = const(Journal);
                }
                part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                {
                    Caption = 'Dimension Set Lines';
                    EntityName = 'dimensionSetLine';
                    EntitySetName = 'dimensionSetLines';
                    SubPageLink = "Parent Id" = field(SystemId), "Parent Type" = const("General Ledger Entry");
                }
            }
        }
    }
    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GLRegNo := getGLRegisterNo(Rec);
        //Workaround to get the Job Task No. for missing info in GL entries.
        if Rec."Job No." <> '' then
            if Rec."FJH.Job Task No." = '' then
                Rec."FJH.Job Task No." := GetTaskNofromGLEntry(Rec."Entry No.", Rec."Job No.");
    end;

    var
        GLRegNo: Integer;

    procedure getGLRegisterNo(GLEntry: record "G/L Entry") GLRegisterNo: Integer
    var
        GLRegister: Record "G/L Register";
    begin
        GLRegisterNo := 0;
        GLRegister.Reset();
        GLRegister.SetFilter("From Entry No.", '..%1', GLEntry."Entry No.");
        GLRegister.SetFilter("To Entry No.", '%1..', GLEntry."Entry No.");
        if GLRegister.FindFirst() then
            GLRegisterNo := GLRegister."No.";
        exit(GLRegisterNo);
    end;

    local procedure GetTaskNofromGLEntry(EntryNo: Integer; JobNo: Code[20]): Code[20]
    var
        JobEntries: Record "Job Ledger Entry";
        JobTaskNo: Code[20];
    begin
        JobTaskNo := '';
        JobEntries.Reset();
        JobEntries.SetRange("Job No.", JobNo);
        JobEntries.SetRange("Ledger Entry No.", EntryNo);
        if JobEntries.FindFirst() then
            JobTaskNo := JobEntries."Job Task No.";
        exit(JobTaskNo);
    end;
}
