namespace FJH.Dev_BC_LosParques;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50100 "PDR General Journal" extends "General Journal"
{
    layout
    {
        addbefore("Currency Code")
        {
            field(PDRPaymentMethodCode; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
