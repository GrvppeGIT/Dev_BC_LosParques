namespace FJH.ElectronicPayments;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.Payment;
using Microsoft.Foundation.NoSeries;

pageextension 50101 "FJH Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addafter(CreditTransferRegisters)
        {
            action(ViewTransferErrors)
            {
                Caption = 'View Transfer Errors';
                ApplicationArea = Basic, Suite;
                Visible = true;
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                var
                    JnlPErr: record "Payment Jnl. Export Error Text";
                begin
                    JnlPErr.Reset();
                    if JnlPErr.JnlLineHasErrors(Rec) then begin
                        JnlPerr.Reset();
                        JnlPErr.SetRange("Journal Template Name", Rec."Journal Template Name");
                        JnlPErr.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        JnlPErr.SetRange("Document No.", Rec."Document No.");
                        JnlPErr.SetRange("Journal Line No.", Rec."Line No.");
                        if JnlPErr.FindFirst() then
                            Message('Line No.: %1\%2\%3', JnlPErr."Journal Line No.", JnlPErr."Error Text", JnlPErr."Additional Information")
                        else
                            Message('No error found.');
                    end else
                        Message('No error found.');
                end;
            }
        }

        addbefore(VoidPayments)
        {
            action(ClearTransfers)
            {
                Promoted = true;
                PromotedCategory = Category4;
                Caption = 'Clear Transfers';
                ApplicationArea = Basic, Suite;
                Image = ClearLog;
                //Visible = false;

                trigger OnAction()
                var
                    CredTransfEntry: record "Credit Transfer Entry";
                    CredTransfReg: record "Credit Transfer Register";
                    NoSeriesLine: record "No. Series Line";
                    GenJnl: record "Gen. Journal Line";
                begin
                    //On erros see table 1228 
                    CredTransfEntry.Reset();
                    CredTransfEntry.DeleteAll();

                    CredTransfReg.Reset();
                    CredTransfReg.DeleteAll();

                    NoSeriesLine.Reset();
                    NoSeriesLine.Setrange("Series Code", 'BANK-TRANSFER');
                    If NoSeriesLine.FindSet() then begin
                        NoSeriesLine."Last Date Used" := 0D;
                        NoSeriesLine."Last No. Used" := '';
                        NoSeriesLine.Modify();
                    end;

                    GenJnl.Reset();
                    GenJnl.SetRange("Journal Template Name", 'PAYMENTS');
                    If GenJnl.FindSet() then
                        repeat
                            If GenJnl."Exported to Payment File" = true then begin
                                GenJnl."Exported to Payment File" := false;
                                GenJnl.Modify();
                            end;
                        until GenJnl.Next() = 0;

                    Message('Transfers Cleared.');
                end;
            }
        }
    }
}