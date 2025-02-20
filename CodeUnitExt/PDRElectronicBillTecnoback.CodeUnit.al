codeunit 50120 PDRElectronicBillTecnoback
{
    trigger OnRun()
    begin

    end;

    var
        FJHElectBillFunctions: Codeunit "FJH.Elect. Bill. Functions";

    [EventSubscriber(ObjectType::Codeunit, 35004507, SalesShipmentDetail_Json, '', false, false)]
    local procedure SalesShipmentDetail_Json(SalesShipmentLine: Record "Sales Shipment Line"; var JsonAPIArray: JsonArray; var I: Integer; var IsHandled: Boolean)
    var
        PostedAssembleToOrderLink: Record "Posted Assemble-to-Order Link";
        PostedAssemblyLine: Record "Posted Assembly Line";
        JsonAPIObjectDetalle: JsonObject;
    begin
        IsHandled := false;
        if not PostedAssembleToOrderLink.AsmExistsForPostedShipmentLine(SalesShipmentLine) then
            exit;
        PostedAssemblyLine.SetRange("Document No.", PostedAssembleToOrderLink."Assembly Document No.");
        if (PostedAssemblyLine.FindSet()) then
            repeat
                Clear(JsonAPIObjectDetalle);

                if not IsHandled then begin
                    JsonAPIObjectDetalle.add('TpoCodigo', 'INT1');
                    JsonAPIObjectDetalle.add('VlrCodigo', PostedAssemblyLine."No.");
                    JsonAPIObjectDetalle.add('NmbItem', FJHElectBillFunctions.SpecialCharactersNew(PostedAssemblyLine.Description));
                    JsonAPIObjectDetalle.add('QtyItem', FJHElectBillFunctions.FormatDecimalNoToText(PostedAssemblyLine.Quantity));
                    JsonAPIObjectDetalle.add('UnmdItem', UnmdItem(SalesShipmentLine."Unit of Measure Code"));
                    JsonAPIObjectDetalle.add('PrcItem', 0);
                    JsonAPIObjectDetalle.add('MontoItem', 0);
                    //JsonAPIObjectDetalle.add('PrcItem', FORMAT(PostedAssemblyLine."Unit Cost", 0, '<Integer>'));
                    //JsonAPIObjectDetalle.add('MontoItem', FORMAT(PostedAssemblyLine."Unit Cost" * PostedAssemblyLine.Quantity, 0, '<Integer>'));
                    JsonAPIObjectDetalle.add('NroLinDet', FORMAT(I));
                    I += 1;
                    JsonAPIArray.add(JsonAPIObjectDetalle);
                end

            until PostedAssemblyLine.Next() = 0;
        IsHandled := true

    end;

    [EventSubscriber(ObjectType::Codeunit, 35004507, CalculateTotalAssembleAmounts, '', false, false)]
    local procedure CalculateTotalAssembleAmounts(SalesShipmentLine: Record "Sales Shipment Line"; var ExentAmount: Decimal; var VATAmount: Decimal; var NetAmount: Decimal; var IsHandled: Boolean)
    var
        PostedAssembleToOrderLink: Record "Posted Assemble-to-Order Link";
    //PostedAssemblyLine: Record "Posted Assembly Line";
    begin
        IsHandled := false;
        if not PostedAssembleToOrderLink.AsmExistsForPostedShipmentLine(SalesShipmentLine) then
            exit;
        ExentAmount += 0;
        NetAmount += 0;
        VATAmount += 0;
        /*
        PostedAssemblyLine.SetRange("Document No.", PostedAssembleToOrderLink."Assembly Document No.");
        if (PostedAssemblyLine.FindSet()) then
        repeat
            if PostedAssemblyLine."Unit Cost" <> 0 then
                if (SalesShipmentLine."VAT %") = 0 then
                    ExentAmount += PostedAssemblyLine."Unit Cost" * PostedAssemblyLine.Quantity
                else begin
                    VATAmount += (PostedAssemblyLine."Unit Cost" * PostedAssemblyLine.Quantity) * SalesShipmentLine."VAT %" / 100;
                    NetAmount += (PostedAssemblyLine."Unit Cost" * PostedAssemblyLine.Quantity);
                end;
        until PostedAssemblyLine.Next() = 0;
        */
        IsHandled := true
    end;

    [EventSubscriber(ObjectType::Codeunit, 35004507, AddKeySalesInvoiceHeader_Json, '', false, false)]
    local procedure AddKeySalesInvoiceHeader_Json(var JsonAPIObjectTitulo: JsonObject; SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        if SalesInvoiceHeader."FJH.Has Watermark" then
            JsonAPIObjectTitulo.add('marca_agua_pagado', 'SI')
        else
            JsonAPIObjectTitulo.add('marca_agua_pagado', 'NO');

    end;

    [EventSubscriber(ObjectType::Codeunit, 35004507, AddKeySalesCrMemoHeader_Json, '', false, false)]
    local procedure AddKeySalesCrMemoHeader_Json(var JsonAPIObjectTitulo: JsonObject; SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        if SalesCrMemoHeader."FJH.Has Watermark" then
            JsonAPIObjectTitulo.add('marca_agua_pagado', 'SI')
        else
            JsonAPIObjectTitulo.add('marca_agua_pagado', 'NO');
    end;

    local procedure UnmdItem(UnitCode: Code[10]): Code[4];
    begin
        case StrLen(UnitCode) of
            0:
                exit('Unid');
            1 .. 4:
                exit(UnitCode);
            5 .. 10:
                exit(Copystr(UnitCode, 1, 4));
        end;
    end;
}