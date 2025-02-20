namespace FJH.Dev_BC_LosParques;

using Microsoft.Sales.Document;

tableextension 50107 "FJH Sales Header Ext" extends "Sales Header"
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
