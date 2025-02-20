namespace FJH.Dev_BC_LosParques;

using Microsoft.Integration.Entity;

tableextension 50108 "FJH Sales Inv. Entity Aggr.ext" extends "Sales Invoice Entity Aggregate"
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