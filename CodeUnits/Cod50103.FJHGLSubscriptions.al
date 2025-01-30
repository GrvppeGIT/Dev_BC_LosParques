namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Ledger;

codeunit 50103 "FJH GL Subscriptions"
{
    Permissions = TableData "G/L Entry" = rimd;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostGLAccOnBeforeInsertGLEntry, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostGLAccOnBeforeInsertGLEntry"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean; Balancing: Boolean)
    begin
        if GenJournalLine."Job Task No." <> '' then begin
            GLEntry."FJH.Job Task No." := GenJournalLine."Job Task No.";
        end;
    end;

}
