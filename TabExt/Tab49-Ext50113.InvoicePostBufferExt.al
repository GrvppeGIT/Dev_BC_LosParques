namespace Dev_BC_LosParques.Dev_BC_LosParques;

using Microsoft.Finance.ReceivablesPayables;

tableextension 50113 "Invoice Post. Buffer Ext" extends "Invoice Post. Buffer"
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
