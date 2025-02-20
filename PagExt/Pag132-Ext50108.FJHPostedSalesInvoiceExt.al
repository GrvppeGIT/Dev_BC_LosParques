namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.History;

pageextension 50108 "FJH Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter(FJHElectronicaStatus)
        {
            field(FJHHasWatermark; Rec."FJH.Has Watermark")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
