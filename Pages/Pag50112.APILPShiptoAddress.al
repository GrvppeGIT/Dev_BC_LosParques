namespace FJH.API.LPCustom;

using Microsoft.Sales.Customer;
using System.Reflection;

page 50112 "APILP - Ship-to Address"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'API LP ShipToAddress';
    DelayedInsert = true;
    EntityName = 'LPShipToAddress';
    EntitySetName = 'LPShipToAddresses';
    PageType = API;
    SourceTable = "Ship-to Address";
    EntityCaption = 'Ship-to Address';
    EntitySetCaption = 'Ship-to Addresses';
    ODataKeyFields = SystemId;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Customer No."));
                    end;
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                    trigger OnValidate()
                    begin
                        if (Rec."Customer No." = '') and
                            (Rec.Code = '') then
                            error(CustomerandCodeNotSpecifiedErr);

                        RegisterFieldSet(Rec.FieldNo("Code"));
                    end;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    trigger OnValidate()
                    begin
                        AddressName := Rec.Name;
                        RegisterFieldSet(Rec.FieldNo(Name));
                    end;
                }
                field(gln; Rec.GLN)
                {
                    Caption = 'GLN';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(GLN));
                    end;
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Address));
                    end;
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Address 2"));
                    end;
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(City));
                    end;
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Post Code"));
                    end;
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Country/Region Code"));
                    end;
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Phone No."));
                    end;
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Contact));
                    end;
                }
                field(faxNo; Rec."Fax No.")
                {
                    Caption = 'Fax No.';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Fax No."));
                    end;
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("E-Mail"));
                    end;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Location Code"));
                    end;
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipment Method Code"));
                    end;
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                    Caption = 'Shipping Agent Code';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipping Agent Code"));
                    end;
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    Caption = 'Shipping Agent Service Code';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipping Agent Service Code"));
                    end;
                }
            }
        }
    }
    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        IsInsert: boolean;
        ShipToAddress: Record "Ship-to Address";
        AddressRecordRef: RecordRef;
        EditedRecordRef: RecordRef;
        AssignedFieldRef: FieldRef;
        APIFieldRef: FieldRef;
    begin
        IsInsert := false;
        if (Rec."Customer No." <> '') and
            (Rec.Code <> '') then begin
            ShipToAddress.Reset();
            ShipToAddress.SetRange("Customer No.", Rec."Customer No.");
            ShipToAddress.SetRange(Code, Rec.Code);
            if ShipToAddress.IsEmpty() then
                IsInsert := true;
        end else
            error(CustomerandCodeNotSpecifiedErr);
        if IsInsert then begin
            Rec.Insert(true);
        end;
        ShipToAddress.Reset();
        ShipToAddress.SetRange("Customer No.", Rec."Customer No.");
        ShipToAddress.SetRange(Code, Rec.Code);
        ShipToAddress.FindFirst();
        AddressRecordRef.GetTable(ShipToAddress);
        EditedRecordRef.GetTable(Rec);
        If TempFieldSet.FindSet() then
            repeat
                AssignedFieldRef := EditedRecordRef.Field(TempFieldSet."No.");
                APIFieldRef := AddressRecordRef.Field(TempFieldSet."No.");
                APIFieldRef.Value := AssignedFieldRef.Value();
            until TempFieldSet.Next() = 0;

        AddressRecordRef.SetTable(Rec);
        Rec.Modify(true);

        if isAddressNameValue() then begin
            Rec.Name := AddressName;
            Rec.Modify(true);
        end;
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        PatchMsgErr: Label 'PATCH call not allowed.  Use POST for insert and modify.';
    begin
        error(PatchMsgErr);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    var
        TempFieldSet: Record "Field" temporary;
        CustomerandCodeNotSpecifiedErr: Label '"Customer No." and "Code" must be specified.';
        AddressName: Text[100];

    local procedure ClearCalculatedFields()
    begin
        Clear(Rec.SystemId);
        TempFieldSet.DeleteAll();
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(Database::"Ship-to Address", FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::"Ship-to Address";
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;

    local procedure isAddressNameValue() result: Boolean
    begin
        Result := False;
        TempFieldSet.Reset();
        TempFieldSet.SetRange(TableNo, Database::"Ship-to Address");
        TempFieldSet.SetRange("No.", Rec.FieldNo(Name));
        if TempFieldSet.FindSet() then
            result := true;
        TempFieldSet.Reset();
        exit(Result);
    end;
}
