namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Integration.Graph;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Ledger;

page 50100 "APILP - Journals"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apilpJournals';
    DelayedInsert = true;
    EntityName = 'LPjournal';
    EntitySetName = 'LPjournals';
    PageType = API;
    EntityCaption = 'Journal';
    EntitySetCaption = 'Journals';
    ChangeTrackingAllowed = true;
    ODataKeyFields = SystemId;
    SourceTable = "Gen. Journal Batch";
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
                field("code"; Rec.Name)
                {
                    Caption = 'Code';
                    ShowMandatory = true;
                }
                field(displayName; Rec.Description)
                {
                    Caption = 'Display Name';
                }
                field(templateDisplayName; Rec."Journal Template Name")
                {
                    Caption = 'Template Display Name';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last  Modified Date Time';
                }
                field(balancingAccountId; Rec.BalAccountId)
                {
                    Caption = 'Balancing Account Id';
                }
                field(balancingAccountNumber; Rec."Bal. Account No.")
                {
                    Caption = 'Balancing Account No.';
                    Editable = false;
                }
                part(LPjournalLines; "APILP - JournalLines")
                {
                    Caption = 'Journal Lines';
                    EntityName = 'LPJournalLine';
                    EntitySetName = 'LPJournalLines';
                    SubPageLink = "Journal Batch Id" = field(SystemId);
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Journal Template Name" := GraphMgtJournal.GetDefaultJournalLinesTemplateName();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        TemplateNameFilter: Text[10];
        IdFilter: Text;
    begin
        TemplateNameFilter := CopyStr(Rec.GetFilter("Journal Template Name"), 1, 10);
        IdFilter := Rec.GetFilter(SystemId);
        if IdFilter <> '' then
            exit(Rec.GetBySystemId(IdFilter));

        if TemplateNameFilter = '' then
            TemplateNameFilter := GraphMgtJournal.GetDefaultJournalLinesTemplateName();
        Rec.SetRange("Journal Template Name", TemplateNameFilter);
        exit(Rec.FindSet());
    end;

    var
        GraphMgtJournal: Codeunit "Graph Mgt - Journal";
        ThereIsNothingToPostErr: Label 'There is nothing to post.';
        CannotFindBatchErr: Label 'The General Journal Batch with ID %1 cannot be found.', Comment = '%1 - the System ID of the general journal batch';

    /*
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure post(var ActionContext: WebServiceActionContext)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GetBatch(GenJournalBatch);
        //PostBatch(GenJournalBatch);
        SetActionResponse(ActionContext, Rec.SystemId);
    end;
    */

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure postAndReturn() Response: text
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        DocumentList: list of [Code[20]];
        DateList: list of [Date];
        RegisterList: List of [integer];
        TypeList: list of [Integer];
        ResponseList: list of [Integer];
        RegisterNo: integer;
        GenJournalLine: record "Gen. Journal Line";
        OldDocument: code[20];
        f: integer;
        GLEntry: Record "G/L Entry";
        GLRegister: Record "G/L Register";
        TemplateName: Code[10];
        BatchName: Code[10];
    begin
        clear(OldDocument);
        clear(DocumentList);
        clear(DateList);
        clear(TypeList);
        clear(ResponseList);
        GetBatch(GenJournalBatch);
        //Guardar los datos de los asientos para buscarlo luego de haber registrado.
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if not GenJournalLine.FindFirst() then
            Error(ThereIsNothingToPostErr)
        else begin
            TemplateName := GenJournalLine."Journal Template Name";
            BatchName := GenJournalLine."Journal Batch Name";
            repeat
                if GenJournalLine."Document No." <> OldDocument then begin
                    OldDocument := GenJournalLine."Document No.";
                    DocumentList.Add(GenJournalLine."Document No.");
#pragma warning disable AL0603
                    TypeList.Add(GenJournalLine."Document Type");
#pragma warning restore AL0603
                    DateList.Add(GenJournalLine."Posting Date");
                end;
            until GenJournalLine.Next() = 0;
        end;
        //Registrar el asiento.
        PostBatch(GenJournalBatch);
        //Buscar el Nro. de Asiento en la tabla G/L Register
        f := 1;
        foreach OldDocument in DocumentList do begin
            //Message('Document %1\Tipo %3\Date %2', OldDocument, DateList.Get(f), TypeList.Get(f));
            //T45 G/L Registers
            //T17 G/L Entry
            RegisterNo := 0;
            GLEntry.Reset();
            GLEntry.SetRange("Journal Templ. Name", TemplateName);
            GLEntry.SetRange("Journal Batch Name", BatchName);
            GLEntry.SetRange("Document No.", OldDocument);
            GLEntry.SetRange("Document Type", TypeList.Get(f));
            GLEntry.SetRange("Posting Date", DateList.Get(f));
            if GLEntry.FindFirst() then begin
                GLRegister.Reset();
                GLRegister.SetFilter("From Entry No.", '..%1', GLEntry."Entry No.");
                GLRegister.SetFilter("To Entry No.", '%1..', GLEntry."Entry No.");
                if GLRegister.FindFirst() then
                    RegisterNo := GLRegister."No.";
            end;
            if RegisterNo <> 0 then
                if Not RegisterList.Contains(RegisterNo) then
                    RegisterList.Add(RegisterNo);
            f += 1;
        end;

        clear(Response);
        foreach RegisterNo in RegisterList do
            if Response = '' then
                Response := Format(RegisterNo)
            else
                Response += ', ' + Format(RegisterNo);

        exit(Response);
    end;

    local procedure PostBatch(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if not GenJournalLine.FindFirst() then
            Error(ThereIsNothingToPostErr);

        Codeunit.RUN(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
    end;

    local procedure GetBatch(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        if not GenJournalBatch.GetBySystemId(Rec.SystemId) then
            Error(CannotFindBatchErr, Rec.SystemId);
    end;
}

