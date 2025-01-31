codeunit 50120 PDRElectronicBillTecnoback
{
    trigger OnRun()
    begin

    end;

    var
        FJHElectBillFunctions: Codeunit "FJH.Elect. Bill. Functions";

    [EventSubscriber(ObjectType::Codeunit, 35004507, SalesShipmentDetail_Json, '', false, false)]
    local procedure CU414_OnBeforeModifySalesDoc(SalesShipmentLine: Record "Sales Shipment Line"; var JsonAPIArray: JsonArray; var I: Integer; var IsHandled: Boolean)
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
                    JsonAPIObjectDetalle.add('PrcItem', FORMAT(PostedAssemblyLine."Unit Cost", 0, '<Integer>'));
                    JsonAPIObjectDetalle.add('MontoItem', FORMAT(PostedAssemblyLine."Unit Cost" * PostedAssemblyLine.Quantity, 0, '<Integer>'));
                    JsonAPIObjectDetalle.add('NroLinDet', FORMAT(I));
                    I += 1;
                    JsonAPIArray.add(JsonAPIObjectDetalle);
                end

            until PostedAssemblyLine.Next() = 0;
        IsHandled := true

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