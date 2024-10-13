namespace FJH.API.LPCustom;

using Microsoft.Assembly.Document;

page 50110 "APILP - Assembly Order Header"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apilpAssemblyOrderHeader';
    DelayedInsert = true;
    EntityName = 'LPassemblyHeader';
    EntitySetName = 'LPassemblyHeaders';
    PageType = API;
    SourceTable = "Assembly Header";
    ODataKeyFields = SystemId;
    EntityCaption = 'LP Assembly Order Header';
    EntitySetCaption = 'LP Assembly Order Headers';
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
                field(number; Rec."No.")
                {
                    Caption = 'Number';
                    Editable = false;
                }
                field(creationDate; Rec."Creation Date")
                {
                    Caption = 'Creation Date';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Editable = False;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    Editable = False;
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                    Editable = False;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    Editable = false;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    Editable = false;
                }
                field(quantityToAssemble; Rec."Quantity to Assemble")
                {
                    Caption = 'Quantity to Assemble';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                    Editable = false;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(endingDate; rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }
                field(remainingQuantity; Rec."Remaining Quantity")
                {
                    Caption = 'Remaining Quantity';
                    Editable = false;
                }
                field(assembledQuantity; Rec."Assembled Quantity")
                {
                    Caption = 'Assembled Quantity';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                part(LPAssemblyOrderLines; "APILP - Assembly Order Lines")
                {
                    Caption = 'Lines';
                    EntityName = 'LPassemblyLine';
                    EntitySetName = 'LPassemblyLines';
                    SubPageLink = "Document Id" = field(SystemId);
                }
            }
        }
    }
    var
        cannotModifyReleaseOrder: Label 'Released orders cannot be modified or deleted.';
        cannotInsertOrder: Label 'Cannot create new Assembly-to-order records.  It is created in the Sales Order';

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status <> Rec.Status::Open then
            error(cannotModifyReleaseOrder);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Status <> Rec.Status::Open then
            error(cannotModifyReleaseOrder);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        error(cannotInsertOrder);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Order;
        Rec."Assemble to Order" := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.SetRange("Assemble to Order", true);
    end;
}
