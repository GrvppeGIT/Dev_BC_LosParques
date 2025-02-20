namespace FJH.API.LPCustom;

using Microsoft.Integration.Entity;

tableextension 50100 "APILP - Sales Ord Ent Buff Ext" extends "Sales Order Entity Buffer"
{
    fields
    {
        field(50100; "Assembly Id"; Guid)
        {
            Caption = 'Assembly Id';
            DataClassification = CustomerContent;
        }
        field(56101; "FJH.Has Watermark"; Boolean)
        {
            Caption = 'Has Watermark', Comment = 'ESM=Lleva marca de agua';
            DataClassification = CustomerContent;
        }
    }
}
