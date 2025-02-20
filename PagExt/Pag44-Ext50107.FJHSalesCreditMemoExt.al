namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.Document;

pageextension 50107 "FJH Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        addafter(FJHProvince)
        {
            field(FJHHasWatermark; Rec."FJH.Has Watermark")
            {
                ApplicationArea = All;
            }
        }
    }
}
