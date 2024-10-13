namespace FJH.API.LPCustom;

using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Receivables;

table 50100 "LP Cust. Ledger Entry Buffer"
{
    Caption = 'Customer Ledger Entry Buffer';
    TableType = Temporary;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(47; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
        }
        field(48; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
        }
        field(49; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(50; "Applied Amount"; Decimal)
        {
            Caption = 'Applied Amount';
        }
        field(63; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(8001; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
        }
        field(8002; "Gen. Journal Line Id"; Guid)
        {
            Caption = 'Gen. Journal Line Id';
        }
        field(50001; "CLE Entry No."; Integer)
        {
            Caption = 'CLE Entry No.';
        }
        Field(50002; "CLE Applied Entry No."; Integer)
        {
            Caption = 'CLE Applied Entry No.';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        CreateCustLedgEntry: Record "Cust. Ledger Entry";

    procedure LoadDataFromCLE(EntryNo: integer)
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        AppCLE: Record "Cust. Ledger Entry";
        DetCLE: Record "Detailed Cust. Ledg. Entry";
        Customer: Record Customer;
        LineNo: Integer;
        Applied: boolean;
        AuxCLE: record "Cust. Ledger Entry";
    begin
        CustomerLedgerEntry.Reset();
        if CustomerLedgerEntry.Get(EntryNo) then begin
            Clear(Rec);
            Rec.TransferFields(CustomerLedgerEntry);
            CustomerLedgerEntry.CalcFields(Amount, "Remaining Amount");
            Rec."Remaining Amount" := CustomerLedgerEntry."Remaining Amount";
            Rec.Amount := CustomerLedgerEntry.Amount;
            Rec.SystemId := CustomerLedgerEntry.SystemId;
            Rec."Customer Id" := Customer.SystemId;
            Rec."CLE Entry No." := CustomerLedgerEntry."Entry No.";
            LineNo := CustomerLedgerEntry."Entry No.";
            LineNo := LineNo * 100;
            Applied := false;
            Customer.Reset();
            if Customer.Get(Rec."Customer No.") then
                Rec."Customer Name" := Customer.Name;
            DetCLE.Reset();
            DetCLE.SetRange("Cust. Ledger Entry No.", CustomerLedgerEntry."Entry No.");
            DetCLE.SetFilter("Applied Cust. Ledger Entry No.", '<>%1', CustomerLedgerEntry."Entry No.");
            DetCLE.SetRange("Entry Type", DetCLE."Entry Type"::Application);
            DetCLE.SetRange(Unapplied, false);
            If DetCLE.FindSet() then begin
                repeat
                    Rec."Entry No." := LineNo;
                    Rec."Applies-to Doc. Type" := DetCLE."Document Type";
                    Rec."Applies-to Doc. No." := DetCLE."Document No.";
                    Rec."Applied Amount" := DetCLE.Amount;
                    Rec."CLE Applied Entry No." := DetCLE."Applied Cust. Ledger Entry No.";
                    Rec.Insert();
                    LineNo += 1;
                    applied := true;
                until DetCLE.Next() = 0;
            end;
            DetCLE.Reset();
            DetCLE.SetRange("Applied Cust. Ledger Entry No.", CustomerLedgerEntry."Entry No.");
            DetCLE.SetFilter("Cust. Ledger Entry No.", '<>%1', CustomerLedgerEntry."Entry No.");
            DetCLE.SetRange("Entry Type", DetCLE."Entry Type"::Application);
            DetCLE.SetRange(Unapplied, false);
            If DetCLE.FindSet() then begin
                repeat
                    Rec."Entry No." := LineNo;
                    AuxCLE.Reset();
                    if AuxCLE.Get(DetCLE."Cust. Ledger Entry No.") then begin
                        Rec."Applies-to Doc. Type" := AuxCLE."Document Type";
                        Rec."Applies-to Doc. No." := AuxCLE."Document No.";
                    end;
                    Rec."Applied Amount" := DetCLE.Amount;
                    Rec."CLE Applied Entry No." := DetCLE."Cust. Ledger Entry No.";
                    Rec.Insert();
                    LineNo += 1;
                    applied := true;
                until DetCLE.Next() = 0;
            end;
            if not Applied then begin
                Rec."Entry No." := LineNo;
                Rec."Applies-to Doc. Type" := Rec."Applies-to Doc. Type"::" ";
                Rec."Applies-to Doc. No." := '';
                Rec.Insert();
            end;
        end;
    end;
}