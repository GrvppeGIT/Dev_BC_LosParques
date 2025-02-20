namespace Dev_BC_LosParques.Dev_BC_LosParques;

using Microsoft.Sales.History;

pageextension 50109 "FJH Posted Sales Cr.Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter(FJHElectronicID)
        {
            field(FJHHasWatermark; Rec."FJH.Has Watermark")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
