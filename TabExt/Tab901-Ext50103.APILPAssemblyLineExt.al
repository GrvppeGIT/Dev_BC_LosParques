namespace FJH.API.LPCustom;

using Microsoft.Assembly.Document;

tableextension 50103 "APILP Assembly Line Ext" extends "Assembly Line"
{
    fields
    {
        field(50100; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            DataClassification = CustomerContent;
        }
    }

    trigger OnAfterInsert()
    var
        AssemblyHeader: record "Assembly Header";
    begin
        if IsNullGuid(Rec."Document Id") then begin
            AssemblyHeader.Reset();
            if (AssemblyHeader."No." <> Rec."Document No.") and (Rec."Document No." <> '') then
                AssemblyHeader.Get(Rec."Document Type", Rec."Document No.");
            if not IsNullGuid(AssemblyHeader.SystemId) then begin
                Rec."Document Id" := AssemblyHeader.SystemId;
                Rec.Modify();
            end;
        end;
    end;

    trigger OnAfterModify()
    var
        AssemblyHeader: record "Assembly Header";
    begin
        if IsNullGuid(Rec."Document Id") then begin
            AssemblyHeader.Reset();
            if (AssemblyHeader."No." <> Rec."Document No.") and (Rec."Document No." <> '') then
                AssemblyHeader.Get(Rec."Document Type", Rec."Document No.");
            if not IsNullGuid(AssemblyHeader.SystemId) then begin
                Rec."Document Id" := AssemblyHeader.SystemId;
                Rec.Modify();
            end;
        end;
    end;
}
