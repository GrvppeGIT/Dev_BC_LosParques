namespace FJH.Dev_BC_LosParques;

using Microsoft.Finance.ReceivablesPayables;

tableextension 50112 "Invoice Posting Buffer Ext" extends "Invoice Posting Buffer"
{
    fields
    {
        //field(1001; "Job Task No."; Code[20])
        field(50101; "Job Task No."; Code[20])
        {
            Caption = 'Project Task No.';
            DataClassification = CustomerContent;
        }
    }
}
