namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.Document;

pageextension 50105 "FJH Sales Order Ext" extends "Sales Order"
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