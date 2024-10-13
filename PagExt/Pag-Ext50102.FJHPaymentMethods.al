namespace FJH.ElectronicPayments;

using Microsoft.Bank.BankAccount;

pageextension 50102 "FJH Payment Methods" extends "Payment Methods"
{
    layout
    {
        addafter(Description)
        {
            field("FJH Payment Mode"; Rec."FJH Payment Mode")
            {
                ApplicationArea = All;
            }
        }
    }
}
