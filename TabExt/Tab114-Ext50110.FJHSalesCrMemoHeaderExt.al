namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.History;

tableextension 50110 "FJH Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
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
