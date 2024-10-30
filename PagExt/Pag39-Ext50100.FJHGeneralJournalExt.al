namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Ledger;

pageextension 50100 "FJH General Journal Ext" extends "General Journal"
{
    layout
    {
        addbefore("Currency Code")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Post)
        {
            Action(PostWithGLRegister)
            {
                ApplicationArea = Basic, Suite;
                Visible = False;
                Caption = 'Post With &GL Register';
                Image = PostedVendorBill;

                trigger OnAction()
                var
                    GenJournalBatch: Record "Gen. Journal Batch";
                    DocumentList: list of [Code[20]];
                    DateList: list of [Date];
                    TypeList: list of [Integer];
                    RegisterList: List of [integer];
                    RegisterNo: integer;
                    GenJournalLine: record "Gen. Journal Line";
                    OldDocument: code[20];
                    Response: text;
                    ThereIsNothingToPostErr: Label 'There is nothing to post.';
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
                    clear(Response);
                    f := 1;
                    foreach OldDocument in DocumentList do begin
                        Message('Document %1\Tipo %3\Date %2', OldDocument, DateList.Get(f), TypeList.Get(f));
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
                        if RegisterNo <> 0 then begin
                            if Response = '' then
                                Response := Format(RegisterNo)
                            else
                                Response += ', ' + Format(RegisterNo);
                        end;
                        f += 1;
                        RegisterNo += 1;
                    end;

                    message(Response);
                end;
            }
            Action(FindGLRegister)
            {
                ApplicationArea = Basic, Suite;
                Visible = False;
                Caption = 'Find &GL Register';
                Image = Find;

                trigger OnAction()
                var
                    DocumentList: list of [Code[20]];
                    DateList: list of [Date];
                    TypeList: list of [Integer];
                    RegisterList: List of [integer];
                    OldDocument: code[20];
                    Response: text;
                    f: integer;
                    GLEntry: Record "G/L Entry";
                    GLRegister: Record "G/L Register";
                    RegisterNo: integer;
                    TemplateName: Code[10];
                    BatchName: Code[10];
                begin
                    clear(OldDocument);
                    clear(DocumentList);
                    clear(DateList);
                    clear(TypeList);
                    TemplateName := 'GENERAL';
                    BatchName := 'PRUEBA';
                    DocumentList.Add('D-GEN00000001');
                    TypeList.Add(0);
                    DateList.Add(20240610D);

                    f := 1;
                    foreach OldDocument in DocumentList do begin
                        Message('Document %1\Tipo %3\Date %2', OldDocument, DateList.Get(f), TypeList.Get(f));
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
                        if RegisterNo <> 0 then begin
                            if Response = '' then
                                Response := Format(RegisterNo)
                            else
                                Response += ', ' + Format(RegisterNo);
                        end;
                        f += 1;
                        RegisterNo += 1;
                    end;

                    message(Response);
                end;

            }
        }
    }
    local procedure PostBatch(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
        ThereIsNothingToPostErr: Label 'There is nothing to post.';

    begin
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if not GenJournalLine.FindFirst() then
            Error(ThereIsNothingToPostErr);

        Codeunit.RUN(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
    end;

    local procedure GetBatch(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        CannotFindBatchErr: Label 'The General Journal Batch with ID %1 cannot be found.', Comment = '%1 - the System ID of the general journal batch';
    begin
        GenJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalBatch.SetRange(Name, Rec."Journal Batch Name");
        if not GenJournalBatch.FindFirst() then
            Error(CannotFindBatchErr, Rec."Journal Batch Name");
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; GenJournalBatchId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::Microsoft.API.V2."APIV2 - Journals");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), GenJournalBatchId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Get);
    end;

}
