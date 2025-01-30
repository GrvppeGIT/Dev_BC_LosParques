namespace FJH.ElectronicPayments;

using Microsoft.Bank.Payment;

tableextension 50102 "FJH Payment Export Data Ext." extends "Payment Export Data"
{
    fields
    {
        field(50101; "FJH Recipient RUT"; Code[20])
        {
            Caption = 'Recipient RUT';
            DataClassification = CustomerContent;
        }
        field(50102; "FJH Recipient Bank No."; Code[20])
        {
            Caption = 'Recipient Bank Number';
            DataClassification = CustomerContent;
        }
        field(50103; "FJH Agreement No."; Code[3])
        {
            Caption = 'Agreement Number';
            DataClassification = CustomerContent;
        }
        field(50104; "FJH Destination Branch"; Code[10])
        {
            Caption = 'Destination Branch';
            DataClassification = CustomerContent;
        }
        field(50105; "FJH Economic Activity"; Code[10])
        {
            Caption = 'Economic Activity';
            DataClassification = CustomerContent;
        }
        field(50106; "FJH Payment Mode"; enum "FJH Transfer Payment Mode")
        {
            Caption = 'Payment Mode';
            DataClassification = CustomerContent;
        }
        field(50107; "FJH Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(50108; "FJH Vendor Address"; Text[100])
        {
            Caption = 'Vendor Address';
        }
        field(50109; "FJH Vendor Address 2"; Text[50])
        {
            Caption = 'Vendor Address 2';
        }
        field(50110; "FJH Vendor City"; Text[50])
        {
            Caption = 'Vendor City';
        }
    }
}
