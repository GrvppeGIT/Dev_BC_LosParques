namespace FJH.ElectronicPayments;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.Payment;
using Microsoft.Foundation.NoSeries;

pageextension 50104 "FJH Payment Journal Ext" extends "Payment Journal"
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
        addbefore(Post)
        {
            action(Summarize)
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Summarize Payment';
                ToolTip = 'Summarizes all the lines and insert a Bank line with the total amount.';
                ApplicationArea = Basic, Suite;
                Image = BankAccountRec;
                //Visible = false;

                trigger OnAction()
                var
                    GenJnlLine: record "Gen. Journal Line";
                    TotalBalance: decimal;
                    DocumentType: Enum "Gen. Journal Document Type";
                    DocumentNo: Code[20];
                    BankAccount: Code[20];
                    PostingDate: date;
                    NewLine: integer;
                    DimSetID: integer;
                    PaymentMethodCode: Code[20];
                    ErrBankAcctNotFound: label 'Balancing Bank Account not found';
                    TempDimSetId: integer;
                begin

                    TotalBalance := 0;
                    DocumentType := DocumentType::" ";
                    DocumentNo := '';
                    BankAccount := '';
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if GenJnlLine.FindSet() Then begin
                        DocumentType := GenJnlLine."Document Type";
                        DocumentNo := GenJnlLine."Document No.";
                        PostingDate := GenJnlLine."Posting Date";
                        repeat
                            If (BankAccount = '') AND (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") then
                                BankAccount := GenJnlLine."Bal. Account No.";
                            if (DimSetID = 0) AND (GenJnlLine."Dimension Set ID" <> 0) then
                                DimSetID := GenJnlLine."Dimension Set ID";
                            if (PaymentMethodCode = '') AND (GenJnlLine."Payment Method Code" <> '') then
                                PaymentMethodCode := GenJnlLine."Payment Method Code";
                            TotalBalance += -GenJnlLine.Amount;
                            NewLine := GenJnlLine."Line No.";
                        until GenJnlLine.Next() = 0;
                    end;
                    NewLine += 10000;
                    if BankAccount = '' then
                        error(ErrBankAcctNotFound);
                    if GenJnlLine.FindSet() then
                        repeat
                            TempDimSetId := GenJnlLine."Dimension Set ID";
                            if GenJnlLine."Document Type" <> DocumentType then
                                GenJnlLine.Validate("Document Type", DocumentType);
                            if GenJnlLine."Document No." <> DocumentNo then
                                GenJnlLine.Validate("Document No.", DocumentNo);
                            GenJnlLine.Validate("Bal. Account No.", '');
                            //GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                            if GenJnlLine."Dimension Set ID" <> TempDimSetId then
                                GenJnlLine.Validate("Dimension Set ID", TempDimSetId);
                            GenJnlLine.Modify();
                        until GenJnlLine.Next() = 0;

                    GenJnlLine.Reset();
                    GenJnlLine.InitNewLine(PostingDate, PostingDate, PostingDate, '', '', '', 0, '');
                    GenJnlLine."Journal Template Name" := Rec."Journal Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Journal Batch Name";
                    GenJnlLine."Line No." := NewLine;
                    GenJnlLine.Validate("Document Type", DocumentType);
                    GenJnlLine.Validate("Document No.", DocumentNo);
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.Validate("Account No.", BankAccount);
                    if PaymentMethodCode <> '' then
                        GenJnlLine.Validate("Payment Method Code", PaymentMethodCode);
                    if DimSetID <> 0 then
                        GenJnlLine.Validate("Dimension Set ID", DimSetID);
                    GenJnlLine.Validate(Amount, TotalBalance);
                    GenJnlLine.Insert();
                end;
            }
        }
    }
}