namespace Dev_BC_LosParques.Dev_BC_LosParques;

using Microsoft.Purchases.Vendor;

pageextension 50102 "FJH Vendor Bank Acc. List Ext" extends "Vendor Bank Account List"
{
    layout
    {
        addafter(Code)
        {
            field("FJH Payment Mode"; Rec."FJH Payment Mode")
            {
                ApplicationArea = All;
            }
        }
    }
}
