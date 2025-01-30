namespace FJH.API.LPCustom;

using Microsoft.Integration.Entity;

tableextension 50101 "APILP - Sales Inv Line Aggr Ex" extends "Sales Invoice Line Aggregate"
{
    fields
    {
        field(50100; "APILP - Assembly Order No."; Code[20])
        {
            Caption = 'Assembly Order No.';
            DataClassification = CustomerContent;
        }
        field(50101; "APILP - Assembly Order Id"; Guid)
        {
            Caption = 'Assembly Order Id';
            DataClassification = CustomerContent;
        }
    }
}
