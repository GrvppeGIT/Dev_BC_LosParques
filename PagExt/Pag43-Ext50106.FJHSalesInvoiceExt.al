namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.Document;

pageextension 50106 "FJH Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter(FJHElectronicShipment)
        {
            field(FJHHasWatermark; Rec."FJH.Has Watermark")
            {
                ApplicationArea = All;
            }
        }
    }
}
