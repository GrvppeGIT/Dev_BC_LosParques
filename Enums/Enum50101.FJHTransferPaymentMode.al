namespace FJH.ElectronicPayments;

enum 50101 "FJH Transfer Payment Mode"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Branch Cash Voucher")
    {
        Caption = 'Branch Cash Voucher';
    }
    value(2; "Company Cash Voucher")
    {
        Caption = 'Company Cash Voucher';
    }
    value(3; "Checking Account")
    {
        Caption = 'Checking Account';
    }
    value(4; "Savings Account")
    {
        Caption = 'Savings Account';
    }
}
