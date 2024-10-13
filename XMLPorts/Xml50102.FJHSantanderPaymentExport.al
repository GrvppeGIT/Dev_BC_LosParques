xmlport 50102 "FJH Santander Payment Export"
{
    Caption = 'Santander Payment Export';
    Direction = Export;
    FormatEvaluate = Legacy;
    Format = FixedText;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '<NewLine>';

    schema
    {
        textelement(Root)
        {
            tableelement(paymentexportdata; "Payment Export Data")
            {
                UseTemporary = true;
                textelement(RutBeneficiario)
                {
                    Width = 11;
                }
                textelement(NombreBenefic)
                {
                    Width = 40;
                }
                textelement(DireccionBeneficiario)
                {
                    Width = 40;
                }
                textelement(ComunaBeneficiario)
                {
                    Width = 15;
                }
                textelement(CiudadBeneficiario)
                {
                    Width = 15;
                }
                textelement(ModalidadDePago)
                {
                    Width = 2;
                }
                textelement(CodSucursalEntrega)
                {
                    Width = 4;
                }
                textelement(CtaAbonoBeneficiario)
                {
                    Width = 18;
                }
                textelement(CodBancoDestino)
                {
                    Width = 4;
                }
                textelement(RutQuienRetiraVV)
                {
                    Width = 11;
                }
                textelement(NombreQuienRetiraVV)
                {
                    Width = 40;
                }
                textelement(NumeroFactura1)
                {
                    Width = 12;
                }
                textelement(SignoFactura1)
                {
                    Width = 1;
                }
                textelement(MontoFactura1)
                {
                    Width = 11;
                }
                textelement(NumeroFactura2)
                {
                    Width = 12;
                }
                textelement(SignoFactura2)
                {
                    Width = 1;
                }
                textelement(MontoFactura2)
                {
                    Width = 11;
                }
                textelement(NumeroFactura3)
                {
                    Width = 12;
                }
                textelement(SignoFactura3)
                {
                    Width = 1;
                }
                textelement(MontoFactura3)
                {
                    Width = 11;
                }
                textelement(NumeroFactura4)
                {
                    Width = 12;
                }
                textelement(SignoFactura4)
                {
                    Width = 1;
                }
                textelement(MontoFactura4)
                {
                    Width = 11;
                }
                textelement(NumeroFactura5)
                {
                    Width = 12;
                }
                textelement(SignoFactura5)
                {
                    Width = 1;
                }
                textelement(MontoFactura5)
                {
                    Width = 11;
                }
                textelement(NumeroFactura6)
                {
                    Width = 12;
                }
                textelement(SignoFactura6)
                {
                    Width = 1;
                }
                textelement(MontoFactura6)
                {
                    Width = 11;
                }
                textelement(NumeroFactura7)
                {
                    Width = 12;
                }
                textelement(SignoFactura7)
                {
                    Width = 1;
                }
                textelement(MontoFactura7)
                {
                    Width = 11;
                }
                textelement(NumeroFactura8)
                {
                    Width = 12;
                }
                textelement(SignoFactura8)
                {
                    Width = 1;
                }
                textelement(MontoFactura8)
                {
                    Width = 11;
                }
                textelement(NumeroFactura9)
                {
                    Width = 12;
                }
                textelement(SignoFactura9)
                {
                    Width = 1;
                }
                textelement(MontoFactura9)
                {
                    Width = 11;
                }
                textelement(NumeroFactura10)
                {
                    Width = 12;
                }
                textelement(SignoFactura10)
                {
                    Width = 1;
                }
                textelement(MontoFactura10)
                {
                    Width = 11;
                }
                textelement(NumeroFactura11)
                {
                    Width = 12;
                }
                textelement(SignoFactura11)
                {
                    Width = 1;
                }
                textelement(MontoFactura11)
                {
                    Width = 11;
                }
                textelement(MontoTotalAbono)
                {
                    Width = 13;
                }
                textelement(MailBeneficiario)
                {
                    Width = 60;
                }
                textelement(GlosaMail)
                {
                    Width = 200;
                }
                trigger OnAfterGetRecord()
                var
                    Vendor: record Vendor;
                    GJL: record "Gen. Journal Line";
                    VLE: record "Vendor Ledger Entry";
                    CreditTransferEntry: Record "Credit Transfer Entry" temporary;
                    RemainingAmount: decimal;
                    FieldIndex: integer;
                begin
                    RutBeneficiario := PadLeft(Delchr(paymentexportdata."FJH Recipient RUT", '=', '.-,;:'), 11, '0');
                    //NombreBenefic := paymentexportdata."Recipient Name";
                    NombreBenefic := paymentexportdata."FJH Vendor Address";
                    //DireccionBeneficiario := paymentexportdata."Recipient Address";
                    DireccionBeneficiario := paymentexportdata."FJH Vendor Address";
                    //ComunaBeneficiario := paymentexportdata."Recipient County";
                    ComunaBeneficiario := paymentexportdata."FJH Vendor Address 2";
                    //CiudadBeneficiario := paymentexportdata."Recipient City";
                    CiudadBeneficiario := paymentexportdata."FJH Vendor City";
                    //ModalidadDePago := '02';  //ABONO EN CUENTA
                    case paymentexportdata."FJH Payment Mode" of
                        paymentexportdata."FJH Payment Mode"::"Savings Account":
                            ModalidadDePago := '04';
                        paymentexportdata."FJH Payment Mode"::"Branch Cash Voucher":
                            ModalidadDePago := '01';
                        paymentexportdata."FJH Payment Mode"::"Company Cash Voucher":
                            //Error(CompanyCashVoucherNotAllowedErr);
                            ModalidadDePago := '14';
                        else
                            ModalidadDePago := '03';
                    end;
                    if paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Branch Cash Voucher" then
                        CodSucursalEntrega := PadLeft(paymentexportdata."FJH Destination Branch", 4, '0')
                    else
                        CodSucursalEntrega := '0000';
                    CtaAbonoBeneficiario := PadLeft(paymentexportdata."Recipient Bank Acc. No.", 18, '0');
                    CodBancoDestino := PadLeft(paymentexportdata."FJH Recipient Bank No.", 4, '0');
                    if paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Branch Cash Voucher" then
                        RutQuienRetiraVV := paymentexportdata."FJH Recipient RUT"
                    else
                        RutQuienRetiraVV := '';
                    if paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Branch Cash Voucher" then
                        NombreQuienRetiraVV := paymentexportdata."Recipient Name"
                    else
                        NombreQuienRetiraVV := '';
                    NumeroFactura1 := '000000000000';
                    SignoFactura1 := '+';
                    MontoFactura1 := '00000000000';
                    NumeroFactura2 := NumeroFactura1;
                    SignoFactura2 := SignoFactura1;
                    MontoFactura2 := MontoFactura1;
                    NumeroFactura3 := NumeroFactura1;
                    SignoFactura3 := SignoFactura1;
                    MontoFactura3 := MontoFactura1;
                    NumeroFactura4 := NumeroFactura1;
                    SignoFactura4 := SignoFactura1;
                    MontoFactura4 := MontoFactura1;
                    NumeroFactura5 := NumeroFactura1;
                    SignoFactura5 := SignoFactura1;
                    MontoFactura5 := MontoFactura1;
                    NumeroFactura6 := NumeroFactura1;
                    SignoFactura6 := SignoFactura1;
                    MontoFactura6 := MontoFactura1;
                    NumeroFactura7 := NumeroFactura1;
                    SignoFactura7 := SignoFactura1;
                    MontoFactura7 := MontoFactura1;
                    NumeroFactura8 := NumeroFactura1;
                    SignoFactura8 := SignoFactura1;
                    MontoFactura8 := MontoFactura1;
                    NumeroFactura9 := NumeroFactura1;
                    SignoFactura9 := SignoFactura1;
                    MontoFactura9 := MontoFactura1;
                    NumeroFactura10 := NumeroFactura1;
                    SignoFactura10 := SignoFactura1;
                    MontoFactura10 := MontoFactura1;
                    NumeroFactura11 := NumeroFactura1;
                    SignoFactura11 := SignoFactura1;
                    MontoFactura11 := MontoFactura1;

                    MontoTotalAbono := PadLeft(Format((round(paymentexportdata.Amount * 100, 1, '<')), 0, 9), 13, '0');
                    MailBeneficiario := paymentexportdata."Recipient Email Address";
                    GlosaMail := paymentexportdata."Message to Recipient 1";

                    //Buscar las facturas aplicadas.
                    RemainingAmount := 0;
                    CreditTransferEntry.Reset();
                    CreditTransferEntry.DeleteAll();
                    GJL.Reset();
                    GJL.SetRange("Journal Template Name", paymentexportdata."General Journal Template");
                    GJL.SetRange("Journal Batch Name", paymentexportdata."General Journal Batch Name");
                    GJL.SetRange("Line No.", paymentexportdata."General Journal Line No.");
                    if GJL.FindFirst() then begin
                        VLE.Reset();
                        VLE.SetRange("Vendor No.", GJL."Account No.");
                        //VLE.SetRange(Open, true);
                        if GJL."Applies-to Doc. No." <> '' then begin
                            VLE.SetRange("Document Type", GJL."Applies-to Doc. Type");
                            VLE.SetRange("Document No.", GJL."Applies-to Doc. No.");
                            If VLE.FindFirst() then
                                AddVLE(VLE, CreditTransferEntry);
                        end else begin
                            if GJL."Applies-to ID" <> '' then begin
                                VLE.SetRange("Applies-to ID", GJL."Applies-to ID");
                                if VLE.FindFirst() then
                                    repeat
                                        AddVLE(VLE, CreditTransferEntry);
                                    until VLE.Next() = 0;
                            end;
                        end;
                    end;
                    FieldIndex := 0;
                    if CreditTransferEntry.FindSet() then
                        repeat
                            FieldIndex += 1;
                            if FieldIndex = 1 then begin
                                NumeroFactura1 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura1 := '-'
                                else
                                    SignoFactura1 := '+';
                                MontoFactura1 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 2 then begin
                                NumeroFactura2 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura2 := '-'
                                else
                                    SignoFactura2 := '+';
                                MontoFactura2 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 3 then begin
                                NumeroFactura3 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura3 := '-'
                                else
                                    SignoFactura3 := '+';
                                MontoFactura3 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 4 then begin
                                NumeroFactura4 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura4 := '-'
                                else
                                    SignoFactura4 := '+';
                                MontoFactura4 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 5 then begin
                                NumeroFactura5 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura5 := '-'
                                else
                                    SignoFactura5 := '+';
                                MontoFactura5 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 6 then begin
                                NumeroFactura6 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura6 := '-'
                                else
                                    SignoFactura6 := '+';
                                MontoFactura6 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 7 then begin
                                NumeroFactura7 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura7 := '-'
                                else
                                    SignoFactura7 := '+';
                                MontoFactura7 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 8 then begin
                                NumeroFactura8 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura8 := '-'
                                else
                                    SignoFactura8 := '+';
                                MontoFactura8 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 9 then begin
                                NumeroFactura9 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura9 := '-'
                                else
                                    SignoFactura9 := '+';
                                MontoFactura9 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex = 10 then begin
                                NumeroFactura10 := CreditTransferEntry."Message to Recipient";
                                if CreditTransferEntry."Transfer Amount" < 0 then
                                    SignoFactura10 := '-'
                                else
                                    SignoFactura10 := '+';
                                MontoFactura10 := PadLeft(Format((round(CreditTransferEntry."Transfer Amount" * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                            if FieldIndex > 10 then begin
                                NumeroFactura11 := '000099999999';
                                RemainingAmount += CreditTransferEntry."Transfer Amount";
                                if RemainingAmount < 0 then
                                    SignoFactura11 := '-'
                                else
                                    SignoFactura11 := '+';
                                MontoFactura11 := PadLeft(Format((round(RemainingAmount * 100, 1, '<')), 0, 9), 11, '0');
                            end;
                        until CreditTransferEntry.Next() = 0;

                    /*
                    EmailBeneficiario := paymentexportdata."Recipient Email Address";
                    MetododePago := 'CAT_CSH_TRANSFER';
                    CodigoBancoAbono := COPYSTR(paymentexportdata."FJH Recipient Bank No.", 1, 3);
                    TipodeCuentaAbono := 'CAT_CSH_CCTE';
                    NumerodeCuentaAbono := paymentexportdata."Recipient Bank Acc. No.";
                    MontodelPago := Format((round(paymentexportdata.Amount, 1, '<')), 15, 9);
                    MedioRespaldoPago := 'CAT_CSH_CCTE';
                    NodeCuentaCargo := NroMedioResp;
                    If CodigoBancoAbono = '039' then
                        CodigodeSucursal := '001'
                    else
                        CodigodeSucursal := '   ';
                    GlosadelPago := paymentexportdata."Message to Recipient 1";
                    */
                end;
            }
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'Document1';
                UseTemporary = true;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        InitData();
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.', Comment = '%1=Field;%2=Value;%3=Value';
        CompanyCashVoucherNotAllowedErr: Label 'Company Cash Voucher not Allowed';

    local procedure InitData()
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        FJHFillExportBuffer: Codeunit "FJH CT-Fill Export Buffer";
        CompanyInfo: record "Company Information";
        SetupLoc: record "FJH.Setup Localization";
    begin
        //SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        FJHFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        //NoOfTransfers := Format(PaymentExportData.Count, 10);
        //MessageID := PaymentExportData."Message ID";
        //CreatedDateTime := Format(CurrentDateTime, 19, 9);
        PaymentExportData.CalcSums(Amount);
        //SumaRegistros := Format((round(paymentexportdata.Amount, 1, '<')), 15, 9);

        if not PaymentExportData.FindSet() then
            Error(NoDataToExportErr);

        CompanyInfo.Reset();
        CompanyInfo.Get();
        SetupLoc.Reset();
        SetupLoc.Get();

        //RutEmpresa := fillNumeric(DelChr(CompanyInfo."VAT Registration No.", '=', '.-,;:'), '0', 11);
        //TipoServicio := '      5003'; // 5003 = Pago a Proveedores
        //MedioRespaldo := 'CAT_CSH_CONTRACT_ACCOUNT'; //Por defecto debe ser CAT_CSH_CONTRACT_ACCOUNT.
        //NroMedioResp := paymentexportdata."Sender Bank Account No.";
        //Glosa := 'PAGO A PROVEEDORES';
    end;

    local procedure fillNumeric(initString: text; fillchar: text[1]; positions: integer) result: Text
    var
        i: integer;
    begin
        for i := 1 to positions do
            initString := fillchar + initString;
        result := Copystr(initString, strlen(initString) + 1);
    end;

    local procedure AddVLE(VLE: record "Vendor Ledger Entry"; var CTE: record "Credit Transfer Entry")
    var
        EntryNo: integer;
    begin
        CTE.Reset();
        if CTE.FindLast() then
            EntryNo := CTE."Entry No."
        else
            EntryNo := 0;

        EntryNo += 1;
        CTE.Init();
        CTE."Entry No." := EntryNo;
        if VLE."External Document No." <> '' then
            CTE."Message to Recipient" := PadLeft(DELCHR(VLE."External Document No.", '=', DELCHR(VLE."External Document No.", '=', '1234567890')), 12, '0')
        else
            CTE."Message to Recipient" := PadLeft(DELCHR(VLE."Document No.", '=', DELCHR(VLE."Document No.", '=', '1234567890')), 12, '0');
        CTE."Transfer Amount" := -VLE."Amount to Apply";
        CTE.Insert();
    end;

    local procedure PadLeft(InputString: text; Lenght: integer; FillChar: Text[1]) OutputString: text
    var
        f: integer;
    begin
        for f := 1 to Lenght do
            InputString := FillChar + InputString;
        OutputString := CopyStr(InputString, StrLen(InputString) - Lenght + 1);
        Exit(OutputString);
    end;

}

