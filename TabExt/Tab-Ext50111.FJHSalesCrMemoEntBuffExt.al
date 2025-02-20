namespace FJH.Dev_BC_LosParques;

using Microsoft.Integration.Entity;

tableextension 50111 "FJH Sales Cr.Memo Ent.Buff.Ext" extends "Sales Cr. Memo Entity Buffer"
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
