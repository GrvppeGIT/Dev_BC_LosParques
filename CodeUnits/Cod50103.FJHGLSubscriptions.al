namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Document;

codeunit 50103 "FJH GL Subscriptions"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnFillInvoicePostBufferOnAfterInitAmounts, '', false, false)]
    local procedure "Purch.-Post_OnFillInvoicePostBufferOnAfterInitAmounts"(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var PurchLineACY: Record "Purchase Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var TotalAmount: Decimal; var TotalAmountACY: Decimal)
    begin
        if PurchLine."Job Task No." <> '' then begin
            InvoicePostBuffer."Job Task No." := PurchLine."Job Task No.";
            TempInvoicePostBuffer."Job Task No." := PurchLine."Job Task No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", OnAfterCopyToGenJnlLine, '', false, false)]
    local procedure "Invoice Post. Buffer_OnAfterCopyToGenJnlLine"(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer" temporary)
    begin
        if InvoicePostBuffer."Job Task No." <> '' then begin
            GenJnlLine."Job Task No." := InvoicePostBuffer."Job Task No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostGLAccOnBeforeInsertGLEntry, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostGLAccOnBeforeInsertGLEntry"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean; Balancing: Boolean)
    begin
        if GenJournalLine."Job Task No." <> '' then begin
            GLEntry."FJH.Job Task No." := GenJournalLine."Job Task No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", OnAfterCopyToGenJnlLine, '', false, false)]
    local procedure "Invoice Posting Buffer_OnAfterCopyToGenJnlLine"(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary)
    begin
        if InvoicePostingBuffer."Job Task No." <> '' then begin
            GenJnlLine."Job Task No." := InvoicePostingBuffer."Job Task No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", OnBeforeInitGenJnlLine, '', false, false)]
    local procedure "Purch. Post Invoice Events_OnBeforeInitGenJnlLine"(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var IsHandled: Boolean)
    begin
        if InvoicePostingBuffer."Job Task No." <> '' then begin
            GenJnlLine."Job Task No." := InvoicePostingBuffer."Job Task No.";
        end;
    end;


}
