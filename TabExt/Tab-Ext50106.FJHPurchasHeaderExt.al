namespace FJH.Dev_BC_LosParques;

using Microsoft.Purchases.Document;

tableextension 50106 "FJH Purchas Header Ext" extends "Purchase Header"
{
    fields
    {
        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            var
                NonNumericCharPos: Integer;
                NonNumericCharErr: label 'The Vendor Invoice No. field must contain only numeric characters. Invalid character at position %1.';
            begin
                NonNumericCharPos := FindNonNumericChar("Vendor Invoice No.");
                if NonNumericCharPos > 0 then
                    Error(NonNumericCharErr, NonNumericCharPos);
            end;
        }

        modify("Vendor Cr. Memo No.")
        {
            trigger OnAfterValidate()
            var
                NonNumericCharPos: Integer;
                NonNumericCharErr: label 'The Vendor Invoice No. field must contain only numeric characters. Invalid character at position %1.';
            begin
                NonNumericCharPos := FindNonNumericChar("Vendor Cr. Memo No.");
                if NonNumericCharPos > 0 then
                    Error(NonNumericCharErr, NonNumericCharPos);
            end;
        }
    }

    local procedure FindNonNumericChar(Value: Text): Integer
    var
        i: Integer;
    begin
        for i := 1 to StrLen(Value) do begin
            if not (Value[i] in ['0' .. '9']) then
                exit(i);
        end;
        exit(0);
    end;
}
