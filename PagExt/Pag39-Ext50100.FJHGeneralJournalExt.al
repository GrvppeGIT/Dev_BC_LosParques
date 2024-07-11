namespace FJH.Dev_BC_LosParques;

using Microsoft.Finance.GeneralLedger.Journal;

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
}
