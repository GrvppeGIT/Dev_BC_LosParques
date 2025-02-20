namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.History;

tableextension 50109 "FJH Sales Invoice Header Ext." extends "Sales Invoice Header"
{
    fields
    {
        field(56101; "FJH.Has Watermark"; Boolean)
        {
            Caption = 'Has Watermark', Comment = 'ESM=Lleva marca de agua';
            DataClassification = CustomerContent;
        }
    }
}
