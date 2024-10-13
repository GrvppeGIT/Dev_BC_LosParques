namespace FJH.ElectronicPayments;

using Microsoft.Bank.BankAccount;

tableextension 50104 "FJH Payment Method Ext" extends "Payment Method"
{
    fields
    {
        field(50101; "FJH Payment Mode"; Enum "FJH Transfer Payment Mode")
        {
            Caption = 'Payment Mode';
            DataClassification = CustomerContent;
            ToolTip = 'Payment Mode for Electronic Transfers';
        }
    }
}
