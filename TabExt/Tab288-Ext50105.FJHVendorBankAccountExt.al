namespace FJH.ElectronicPayments;

using Microsoft.Purchases.Vendor;

tableextension 50105 "FJH Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {
        field(50101; "FJH Destination Branch"; Code[10])
        {
            Caption = 'Destination Branch';
            DataClassification = CustomerContent;
        }
        field(50102; "FJH Economic Activity"; Code[10])
        {
            Caption = 'Economic Activity';
            DataClassification = CustomerContent;
            TableRelation = "FJH.Economic Activity";
        }
        field(50103; "FJH CV Withdrawer VAT No."; Code[20])
        {
            Caption = 'CV Withdrawer VAT No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CUFiscalValidators: Codeunit "FJH. Tax Id Validators";
            begin
                if "FJH CV Withdrawer VAT No." <> '' then
                    "FJH CV Withdrawer VAT No." := CUFiscalValidators.validateRUT("FJH CV Withdrawer VAT No.", 'RUT');
            end;
        }
        field(50104; "FJH Payment Mode"; Enum "FJH Transfer Payment Mode")
        {
            Caption = 'Payment Mode';
            DataClassification = CustomerContent;
            ToolTip = 'Payment Mode for Electronic Transfers';
        }

        modify("Transit No.")
        {
            TableRelation = "FJH.Bank Code";
            Caption = 'Bank Code';
        }
    }
}
