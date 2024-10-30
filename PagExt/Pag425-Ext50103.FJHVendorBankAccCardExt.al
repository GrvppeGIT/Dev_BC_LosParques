namespace FJH.ElectronicPayments;

using Microsoft.Purchases.Vendor;

pageextension 50103 "FJH Vendor Bank Acc. Card Ext" extends "Vendor Bank Account Card"
{
    layout
    {
        modify("Transit No.")
        {
            Visible = False;
        }
        addbefore("Bank Branch No.")
        {
            field("Bank Code"; Rec."Transit No.")
            {
                ApplicationArea = All;
                Caption = 'Bank Code';
            }
        }
        addafter("Transit No.")
        {
            field("FJH Destination Branch"; Rec."FJH Destination Branch")
            {
                ApplicationArea = All;
            }
            field("FJH Economic Activity"; Rec."FJH Economic Activity")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("FJH Payment Mode"; Rec."FJH Payment Mode")
            {
                ApplicationArea = All;
            }

            field("FJH CV Withdrawer VAT No."; Rec."FJH CV Withdrawer VAT No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
