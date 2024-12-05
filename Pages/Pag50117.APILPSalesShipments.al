namespace FJH.API.LPCustom;

using Microsoft.API.V2;
using Microsoft.Sales.History;
using Microsoft.Integration.Graph;

page 50117 "APILP - Sales Shipments"
{
    APIGroup = 'LPCustom';
    APIPublisher = 'LP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apilpSalesShipments';
    DelayedInsert = true;
    PageType = API;
    EntityCaption = 'Sales Shipment';
    EntitySetCaption = 'Sales Shipments';
    ChangeTrackingAllowed = true;
    Editable = false;
    EntityName = 'LPsalesShipment';
    EntitySetName = 'LPsalesShipments';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    SourceTable = "Sales Shipment Header";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                }
                field(externalDocumentNumber; Rec."External Document No.")
                {
                    Caption = 'External Document No.', Comment = 'ESM=Nº documento externo';
                }
                field(invoiceDate; Rec."Document Date")
                {
                    Caption = 'Invoice Date', Comment = 'ESM=Fecha emisión documento';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date', Comment = 'ESM=Fecha registro';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date', Comment = 'ESM=Fecha entrega requerida';
                }
                field(customerPurchaseOrderReference; Rec."Your Reference")
                {
                    Caption = 'Customer Purchase Order Reference', Comment = 'ESM=Referencia';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id', Comment = 'ESM=Id Cliente';
                }
                field(customerNumber; Rec."Sell-to Customer No.")
                {
                    Caption = 'Customer No.', Comment = 'ESM=Venta-a Nº cliente';
                }
                field(customerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name', Comment = 'ESM=Venta-a Nombre';
                    Editable = false;
                }
                field(billToCustomerId; Rec."Bill-to Customer Id")
                {
                    Caption = 'Bill-to Customer Id', Comment = 'ESM=Factura-a Id cliente';
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-To Name', Comment = 'ESM=Factura-a nombre';
                    Editable = false;
                }
                field(billToCustomerNumber; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-To Customer No.', Comment = 'ESM=Factura-a Nº cliente';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name', Comment = 'ESM=Nombre envío';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact', Comment = 'ESM=Contacto envío';
                }
                field(sellToAddressLine1; Rec."Sell-to Address")
                {
                    Caption = 'Sell-to Address Line 1', Comment = 'ESM=Venta-a Dirección';
                }
                field(sellToAddressLine2; Rec."Sell-to Address 2")
                {
                    Caption = 'Sell-to Address Line 2', Comment = 'ESM=Venta-a Colonia';
                }
                field(sellToCity; Rec."Sell-to City")
                {
                    Caption = 'Sell-to City', Comment = 'ESM=Venta-a Ciudad';
                }
                field(sellToCountry; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Sell-to Country/Region Code', Comment = 'ESM=Venta-a País/Región';
                }
                field(sellToState; Rec."Sell-to County")
                {
                    Caption = 'Sell-to State', Comment = 'ESM=Venta-a Municipio/Ciudad';
                }
                field(sellToPostCode; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code', Comment = 'ESM=Venta-a código postal';
                }
                field(billToAddressLine1; Rec."Bill-To Address")
                {
                    Caption = 'Bill-to Address Line 1', Comment = 'ESM=Factura-a dirección';
                    Editable = false;
                }
                field(billToAddressLine2; Rec."Bill-To Address 2")
                {
                    Caption = 'Bill-to Address Line 2', Comment = 'ESM=FActura-a colonia';
                    Editable = false;
                }
                field(billToCity; Rec."Bill-To City")
                {
                    Caption = 'Bill-to City', Comment = 'ESM=Factura-a ciudad';
                    Editable = false;
                }
                field(billToCountry; Rec."Bill-To Country/Region Code")
                {
                    Caption = 'Bill-to Country/Region Code', Comment = 'ESM=Factura-a país/región';
                    Editable = false;
                }
                field(billToState; Rec."Bill-To County")
                {
                    Caption = 'Bill-to State', Comment = 'ESM=Factura-a Municipio/Ciudad';
                    Editable = false;
                }
                field(billToPostCode; Rec."Bill-To Post Code")
                {
                    Caption = 'Bill-to Post Code', Comment = 'ESM=Factura-a código postal';
                    Editable = false;
                }
                field(shipToAddressLine1; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address Line 1', Comment = 'ESM=Dirección envío';
                }
                field(shipToAddressLine2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address Line 2', Comment = 'ESM=Colonia envío';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City', Comment = 'ESM=Ciudad envío';
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code', Comment = 'ESM=País/región envío';
                }
                field(shipToState; Rec."Ship-to County")
                {
                    Caption = 'Ship-to State', Comment = 'ESM=Municipio/ciudad envío';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code', Comment = 'ESM=Código postal envío';
                }
                field(currencyCode; CurrencyCodeTxt)
                {
                    Caption = 'Currency Code', Comment = 'ESM=Cód. divisa';
                }
                field(orderNumber; Rec."Order No.")
                {
                    Caption = 'Order No.', Comment = 'ESM=Nº pedido';
                    Editable = false;
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code', Comment = 'ESM=Cód. términos pago';
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code', Comment = 'ESM=Método envío';
                }
                field(salesperson; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson', Comment = 'ESM=Cód. vendedor';
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Include Tax', Comment = 'ESM=Precios IVA incluído';
                    Editable = false;
                }
                part(lpSalesShipmentLines; "APILP - Sales Shipment Lines")
                {
                    Caption = 'Lines';
                    EntityName = 'LPsalesShipmentLine';
                    EntitySetName = 'LPsalesShipmentLines';
                    SubPageLink = "Document Id" = field(SystemId);
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
                field(phoneNumber; Rec."Sell-to Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(email; Rec."Sell-to E-Mail")
                {
                    Caption = 'Email';
                }
                part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                {
                    Caption = 'Dimension Set Lines';
                    EntityName = 'dimensionSetLine';
                    EntitySetName = 'dimensionSetLines';
                    SubPageLink = "Parent Id" = field(SystemId), "Parent Type" = const("Sales Shipment");
                }
                //NATIONAL FIELDS
                field(documentTypeCode; Rec."FJH.Document Type Code")
                {
                    Caption = 'Document Type Code', Comment = 'ESM=Tipo de documento';
                    Editable = false;
                }
                field(salesPoint; Rec."FJH.Sales Point")
                {
                    Caption = 'Sales Point', Comment = 'ESM=Punto de venta';
                    Editable = false;
                }
                field(fiscalType; Rec."FJH.Fiscal Type")
                {
                    Caption = 'Fiscal Type', Comment = 'ESM=Tipo fiscal';
                    Editable = false;
                }
                field(Province; Rec."FJH.Province")
                {
                    Caption = 'Province', Comment = 'ESM=Provincia';
                    Editable = false;
                }
                field(electronicShipment; Rec."FJH.Electronic Shipment")
                {
                    Caption = 'Electronic Shipment', Comment = 'ESM=Guía electrónica';
                    Editable = false;
                }
                field(globalDocumentId; Rec."FJH.Electronic Authorization C")
                {
                    Caption = 'Global Document ID', Comment = 'ESM=Global document ID';
                    Editable = false;
                }
                field(statusAuthorization; Rec."FJH.Fiscal Authorization")
                {
                    Caption = 'Status Authorization', Comment = 'ESM=Estado de autorización';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
    end;

    var
        CurrencyCodeTxt: Text;

    local procedure SetCalculatedFields()
    var
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];
    begin
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
    end;
}