namespace FJH.API.LPCustom;

using Microsoft.Assembly.Document;
using Microsoft.API.V2;

page 50111 "APILP - Assembly Order Lines"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apilpAssemblyOrderLine';
    DelayedInsert = true;
    EntityName = 'LPassemblyLine';
    EntitySetName = 'LPassemblyLines';
    PageType = API;
    SourceTable = "Assembly Line";
    ODataKeyFields = SystemId;
    EntityCaption = 'LP Assembly Order Line';
    EntitySetCaption = 'LP Assembly Order Line';
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';

                    trigger OnValidate()
                    begin
                        if (not IsNullGuid(xRec."Document Id")) and (xRec."Document Id" <> Rec."Document Id") then
                            Error(CannotChangeDocumentIdNoErr);
                    end;
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                    Editable = false;
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    Editable = false;
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'Sequence';
                }
                field(lineType; Rec.Type)
                {
                    Caption = 'Line Type';
                }
                field(lineObjectNumber; Rec."No.")
                {
                    Caption = 'Line Object No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(quantityPer; Rec."Quantity per")
                {
                    Caption = 'Quantity Per';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    Editable = false;
                }
                field(quantityToConsume; Rec."Quantity to Consume")
                {
                    Caption = 'Quantity to Consume';
                    Editable = false;
                }
                field(consumedQuantity; Rec."Consumed Quantity")
                {
                    Caption = 'Consumed Quantity';
                    Editable = false;
                }
                field(remainingQuantity; Rec."Remaining Quantity")
                {
                    Caption = 'Remaining Quantity';
                    Editable = false;
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(resourceUsageType; Rec."Resource Usage Type")
                {
                    Caption = 'Resource Usage Type';
                }





            }
        }
    }
    var
        cannotModifyReleaseOrder: Label 'Released orders cannot be modified or deleted.';
        CannotChangeDocumentIdNoErr: Label 'The value for "documentId" cannot be modified.', Comment = 'documentId is a field name and should not be translated.';

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyHeader: record "Assembly Header";
    begin
        AssemblyHeader.Get(Rec."Document Type", Rec."Document No.");
        if AssemblyHeader.Status <> AssemblyHeader.Status::Open then
            error(cannotModifyReleaseOrder);
    end;

    trigger OnModifyRecord(): Boolean
    var
        AssemblyHeader: record "Assembly Header";
    begin
        if AssemblyHeader.Status <> AssemblyHeader.Status::Open then
            error(cannotModifyReleaseOrder);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
    end;

    trigger OnOpenPage()
    begin
    end;

}
