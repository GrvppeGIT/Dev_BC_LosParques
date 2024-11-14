xmlport 50101 "FJH Banco CL Payment Export"
{
    Caption = 'Banco CL Payment Export';
    Direction = Export;
    FormatEvaluate = Legacy;
    Format = FixedText;
    TextEncoding = UTF8;
    UseRequestPage = false;
    //TableSeparator = '<NewLine>';
    TableSeparator = '<None>';
    //RecordSeparator = '<NewLine>';
    RecordSeparator = '<None>';

    schema
    {
        textelement(Root)
        {
            tableelement(Header; Integer)
            {
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(TipoRegistro01)
                {
                    Width = 2;
                }
                textelement(RutEmpresaNum)
                {
                    Width = 10;
                }
                textelement(RutEmpresaDV)
                {
                    Width = 1;
                }
                textelement(MontoTotalPago)
                {
                    Width = 13;
                }
                textelement(CantidadDePagos)
                {
                    Width = 10;
                }
                textelement(CantidadDeDocumentos)
                {
                    Width = 10;
                }
                textelement(Filler01)
                {
                    Width = 564;
                }
                textelement(CR01)
                {
                    Width = 1;
                }
                textelement(LF01)
                {
                    Width = 1;
                }

            }
            tableelement(paymentexportdata; "Payment Export Data")
            {
                UseTemporary = true;
                textelement(TipodeRegistro02)
                {
                    Width = 2;
                }
                textelement(RutBeneficiarioNum)
                {
                    Width = 10;
                }
                textelement(RutBeneficiarioDV)
                {
                    Width = 1;
                }
                textelement(NombreBeneficiario)
                {
                    Width = 60;
                }
                textelement(DireccionBeneficiario)
                {
                    Width = 35;
                }
                textelement(ComunaBeneficiario)
                {
                    Width = 15;
                }
                textelement(CiudadBeneficiario)
                {
                    Width = 15;
                }
                textelement(CodActEconomica)
                {
                    Width = 2;
                }
                textelement(MontoPago)
                {
                    Width = 13;
                }
                textelement(FechaDePago)
                {
                    Width = 8;
                }
                textelement(MedioDePago)
                {
                    Width = 2;
                }
                textelement(CodBanco)
                {
                    Width = 3;
                }
                textelement(OficinaDestino)
                {
                    Width = 3;
                }
                textelement(NumeroCuenta)
                {
                    Width = 22;
                }
                textelement(DescripcionPago)
                {
                    Width = 120;
                }
                textelement(ValeVistaAcumulado)
                {
                    Width = 1;
                }
                textelement(CampoLibre1)
                {
                    Width = 20;
                }
                textelement(CampoLibre2)
                {
                    Width = 20;
                }
                textelement(CampoLibre3)
                {
                    Width = 30;
                }
                textelement(RutContactoNum)
                {
                    Width = 10;
                }
                textelement(RutContactoDV)
                {
                    Width = 1;
                }
                textelement(NombreContacto)
                {
                    Width = 60;
                }
                textelement(CanaldeAviso)
                {
                    Width = 1;
                }
                textelement(CodigoArea)
                {
                    Width = 4;
                }
                textelement(NumeroFono)
                {
                    Width = 10;
                }
                textelement(CorreoE1)   //Casilla de Correo Electrónico 2
                {
                    Width = 60;
                }
                textelement(CorreoE2)  //Casilla de Correo Electrónico 2
                {
                    Width = 60;
                }
                textelement(NumeroMensaje)  //Número de Aviso
                {
                    Width = 4;
                }
                textelement(Filler02)
                {
                    Width = 18;
                }
                textelement(CR02)
                {
                    Width = 1;
                }
                textelement(LF02)
                {
                    Width = 1;
                }

                tableelement(CreditTransferEntry; "Credit Transfer Entry")
                {
                    UseTemporary = true;
                    SourceTableView = sorting("Credit Transfer Register No.", "Entry No.");
                    textelement(TipoRegistro03)
                    {
                        Width = 2;
                    }
                    textelement(TipoDocumento)
                    {
                        Width = 3;
                    }
                    textelement(NumeroDocumento)
                    {
                        Width = 10;
                    }
                    textelement(NumeroCuota)
                    {
                        Width = 3;
                    }
                    textelement(MontoDocumento)
                    {
                        Width = 13;
                    }
                    textelement(MontoPago03)
                    {
                        Width = 13;
                    }
                    textelement(FechaDocumento)
                    {
                        Width = 8;
                    }
                    textelement(DescripcionDocumento)
                    {
                        Width = 120;
                    }
                    textelement(CampoLibre21)
                    {
                        Width = 20;
                    }
                    textelement(CampoLibre22)
                    {
                        Width = 20;
                    }
                    textelement(CampoLibre23)
                    {
                        Width = 30;
                    }
                    textelement(Filler03)
                    {
                        Width = 368;
                    }
                    textelement(CR03)
                    {
                        Width = 1;
                    }
                    textelement(LF03)
                    {
                        Width = 1;
                    }
                    tableelement(Record04; Integer)
                    {
                        SourceTableView = SORTING(Number) WHERE(Number = CONST(1));

                        textelement(TipoRegistro04)
                        {
                            Width = 2;
                        }
                        textelement(NumeroDeAviso04)
                        {
                            Width = 4;
                        }
                        textelement(GlosadeAviso)
                        {
                            Width = 320;
                        }
                        textelement(CorrelativoRegistro)
                        {
                            Width = 5;
                        }
                        textelement(filler41)
                        {
                            Width = 279;
                        }
                        textelement(CR04)
                        {
                            Width = 1;
                        }
                        textelement(LF04)
                        {
                            Width = 1;
                        }
                        trigger OnAfterGetRecord()
                        var
                            CLE: Record "Cust. Ledger Entry";
                            chr13: Char;
                            chr10: Char;
                        begin
                            chr13 := 13;
                            chr10 := 10;
                            CR04 := FORMAT(chr13);
                            LF04 := FORMAT(chr10);
                            TipoRegistro04 := '04';
                            //RutEmpresaNum4 := RutEmpresaNum;
                            //RutEmpresaDV4 := RutEmpresaDV;
                            //CodigoConvenio04 := CodigoConvenio;
                            //NumeroNomina04 := NumeroNomina;
                            NumeroDeAviso04 := NumeroMensaje;
                            MsgNumber4 += 1;
                            //CorrelativoRegistro := FORMAT(MsgNumber4);
                            //CorrelativoRegistro := '000' + CorrelativoRegistro;
                            //CorrelativoRegistro := CopyStr(CorrelativoRegistro, StrLen(CorrelativoRegistro) - 2, 3);
                            CorrelativoRegistro := FillWith0(FORMAT(MsgNumber4), 3);

                            GlosadeAviso := paymentexportdata."Message to Recipient 1";
                            //Glosa1 := CreditTransferEntry."Message to Recipient";
                            //Monto1 := FORMAT(CreditTransferEntry."Transfer Amount" * 100, 0, 9);
                            //Monto1 := '0000000000000' + Monto1;
                            //Monto1 := CopyStr(Monto1, StrLen(Monto1) - 12, 13);
                        end;
                    }
                    trigger OnPreXmlItem()
                    var
                        GJL: record "Gen. Journal Line";
                        VLE: record "Vendor Ledger Entry";
                        RegCount: integer;
                    begin
                        RegCount := 0;
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
                                    AddVLE(VLE);
                            end else begin
                                if GJL."Applies-to ID" <> '' then begin
                                    VLE.SetRange("Applies-to ID", GJL."Applies-to ID");
                                    if VLE.FindFirst() then
                                        repeat
                                            AddVLE(VLE);
                                        until VLE.Next() = 0;
                                end;
                            end;
                        end;
                        if Not CreditTransferEntry.FindFirst() then begin
                            CreditTransferEntry.Init();
                            CreditTransferEntry."Entry No." := 1;
                            CreditTransferEntry."Message to Recipient" := 'Pago a Cuenta';
                            CreditTransferEntry."Transfer Amount" := GJL.Amount;
                            CreditTransferEntry."Transfer Date" := WorkDate();
                            CreditTransferEntry."Recipient Bank Account No." := CopyStr(GJL."Document No.", Strlen(GJL."Document No.") - 5, 6);
                            //CreditTransferEntry."Transaction ID" := 'FE';
                            CreditTransferEntry."Transaction ID" := '30';
                            CreditTransferEntry.Insert();
                        end;
                        RegCount := CreditTransferEntry.Count();
                        MsgNumber4 := 0;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        chr13: Char;
                        chr10: Char;
                        GJL: record "Gen. Journal Line";
                        VLE: record "Vendor Ledger Entry";
                        RegCount: integer;
                    begin
                        //Registro 03
                        chr13 := 13;
                        chr10 := 10;
                        CR03 := FORMAT(chr13);
                        LF03 := FORMAT(chr10);
                        TipoRegistro03 := '03';
                        //RutEmpresaNum3 := RutEmpresaNum;
                        //RutEmpresaDV3 := RutEmpresaDV;
                        //CodigoConvenio03 := CodigoConvenio;
                        //NumeroNomina03 := NumeroNomina;
                        //NumeroMensaje03 := NumeroMensaje;
                        //MarcaTipoAviso := 'EMA';
                        //DestinoAviso := paymentexportdata."Recipient Email Address";
                        //GlosaMensaje := paymentexportdata."Message to Recipient 1";
                        RegCount := 1;
                        GJL.Reset();
                        GJL.SetRange("Journal Template Name", paymentexportdata."General Journal Template");
                        GJL.SetRange("Journal Batch Name", paymentexportdata."General Journal Batch Name");
                        GJL.SetRange("Line No.", paymentexportdata."General Journal Line No.");
                        if GJL.FindFirst() then begin
                            if GJL."Applies-to ID" <> '' then begin
                                VLE.Reset();
                                VLE.SetRange("Applies-to ID", GJL."Applies-to ID");
                                if VLE.FindFirst() then
                                    RegCount := VLE.Count();
                            end;
                        end;
                        //TotalRegs04 := '000' + Format(RegCount);
                        //TotalRegs04 := CopyStr(TotalRegs04, StrLen(TotalRegs04) - 2, 3);
                        TipoDocumento := CreditTransferEntry."Transaction ID";
                        NumeroDocumento := FillWith0(CreditTransferEntry."Recipient Bank Account No.", 10);
                        NumeroCuota := '001';
                        //MontoDocumento := FORMAT(CreditTransferEntry."Transfer Amount" * 100, 0, 9);
                        //MontoDocumento := '0000000000000' + MontoDocumento;
                        //MontoDocumento := CopyStr(MontoDocumento, StrLen(MontoDocumento) - 12, 13);
                        MontoDocumento := FillWith0(FORMAT(CreditTransferEntry."Transfer Amount" * 100, 0, 9), 13);
                        MontoPago03 := MontoDocumento;
                        FechaDocumento := FORMAT(CreditTransferEntry."Transfer Date", 0, '<Day,2><Month,2><Year4>');
                        DescripcionDocumento := CreditTransferEntry."Message to Recipient";
                    end;
                }
                trigger OnAfterGetRecord()
                var
                    chr13: Char;
                    chr10: Char;
                begin
                    //Registro 02
                    chr13 := 13;
                    chr10 := 10;
                    CR02 := FORMAT(chr13);
                    LF02 := FORMAT(chr10);
                    MsgNumber += 1;
                    TipodeRegistro02 := '02';
                    RutBeneficiarioNum := FillWith0(CopyStr(paymentexportdata."FJH Recipient RUT", 1, StrPos(paymentexportdata."FJH Recipient RUT", '-') - 1), 10);
                    RutBeneficiarioDV := CopyStr(paymentexportdata."FJH Recipient RUT", StrPos(paymentexportdata."FJH Recipient RUT", '-') + 1, 1);
                    NombreBeneficiario := paymentexportdata."Recipient Name";
                    DireccionBeneficiario := paymentexportdata."Recipient Address";
                    ComunaBeneficiario := paymentexportdata."Recipient County";
                    CiudadBeneficiario := paymentexportdata."Recipient City";
                    if (paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Branch Cash Voucher") or
                       (paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Company Cash Voucher") then
                        CodActEconomica := paymentexportdata."FJH Economic Activity"
                    else
                        CodActEconomica := '  ';
                    MontoPago := FillWith0(Format((round(paymentexportdata.Amount * 100, 1, '<')), 0, 9), 13);
                    //Fecha de Pago:  ya viene establecido
                    if (paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Checking Account") or
                       (paymentexportdata."FJH Payment Mode" = paymentexportdata."FJH Payment Mode"::"Savings Account") then begin
                        CodBanco := FillWith0(paymentexportdata."FJH Recipient Bank No.", 3);
                        NumeroCuenta := paymentexportdata."Recipient Bank Acc. No.";
                    end else begin
                        CodBanco := '   ';
                        NumeroCuenta := '                      ';
                    end;

                    case paymentexportdata."FJH Payment Mode" of
                        paymentexportdata."FJH Payment Mode"::"Savings Account":
                            begin
                                if CodBanco = '001' then
                                    MedioDePago := '06'
                                else
                                    MedioDePago := '08';
                            end;
                        paymentexportdata."FJH Payment Mode"::"Branch Cash Voucher":
                            MedioDePago := '02';
                        paymentexportdata."FJH Payment Mode"::"Company Cash Voucher":
                            MedioDePago := '04';
                        else begin
                            if CodBanco = '001' then
                                MedioDePago := '01'
                            else
                                MedioDePago := '07';
                        end;
                    end;

                    if MedioDePago = '04' then
                        OficinaDestino := paymentexportdata."FJH Destination Branch"
                    else
                        OficinaDestino := '   ';

                    DescripcionPago := paymentexportdata."Message to Recipient 1";
                    ValeVistaAcumulado := 'N';
                    RutContactoNum := RutBeneficiarioNum;
                    RutContactoDV := RutBeneficiarioDV;
                    NombreContacto := NombreBeneficiario;
                    CanaldeAviso := '1';
                    //CodigoArea := '0000';
                    //NumeroFono := '0000000000';
                    CorreoE1 := paymentexportdata."Recipient Email Address";
                    CorreoE2 := paymentexportdata."Recipient Email Address";
                    NumeroMensaje := format(MsgNumber);
                    NumeroMensaje := '0000' + NumeroMensaje;
                    NumeroMensaje := CopyStr(NumeroMensaje, StrLen(NumeroMensaje) - 3, 4);
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
        MsgNumber: integer;
        MsgNumber4: integer;
        LblPayment: Label 'Payment for %1 %2';

    local procedure InitData()
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        FJHFillExportBuffer: Codeunit "FJH CT-Fill Export Buffer";
        CompanyInfo: record "Company Information";
        SetupLoc: record "FJH.Setup Localization";
        chr13: Char;
        chr10: Char;
    begin
        MsgNumber := 0;
        //SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        FJHFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        //NoOfTransfers := Format(PaymentExportData.Count, 10);
        //MessageID := PaymentExportData."Message ID";
        //CreatedDateTime := Format(CurrentDateTime, 19, 9);

        if not PaymentExportData.FindSet() then
            Error(NoDataToExportErr);

        CompanyInfo.Reset();
        CompanyInfo.Get();
        SetupLoc.Reset();
        SetupLoc.Get();

        //NumeroNomina := CopyStr(paymentexportdata."Message ID", StrLen(paymentexportdata."Message ID") - 4, 5);
        //NombreNomina := StrSubstNo('%1.TXT', CopyStr(paymentexportdata."Message ID", 1, 21));

        TipoRegistro01 := '01';
        //RutEmpresa := DelChr(SetupLoc."VAT Reg. No. Legal Rep", '=', '.-,;:');
        RutEmpresaNum := CopyStr(CompanyInfo."VAT Registration No.", 1, StrPos(CompanyInfo."VAT Registration No.", '-') - 1);
        RutEmpresaNum := '0000000000' + RutEmpresaNum;
        RutEmpresaNum := CopyStr(RutEmpresaNum, StrLen(RutEmpresaNum) - 9, 10);
        RutEmpresaDV := CopyStr(CompanyInfo."VAT Registration No.", StrPos(CompanyInfo."VAT Registration No.", '-') + 1, 1);
        //CodigoConvenio := paymentexportdata."FJH Agreement No.";
        paymentexportdata.TestField("Currency Code", 'CLP');
        //CodigodeMoneda := '01';
        FechadePago := FORMAT(paymentexportdata."Transfer Date", 0, '<Day,2><Month,2><Year4>');
        PaymentExportData.CalcSums(Amount);
        MontoTotalPago := Format((round(paymentexportdata.Amount * 100, 1, '<')), 0, 9);
        MontoTotalPago := '0000000000000' + MontoTotalPago;
        MontoTotalPago := CopyStr(MontoTotalPago, StrLen(MontoTotalPago) - 12, 13);
        CantidadDePagos := FORMAT(paymentexportdata.Count(), 0, 9);
        CantidadDePagos := '0000000000' + CantidadDePagos;
        CantidadDePagos := CopyStr(CantidadDePagos, StrLen(CantidadDePagos) - 9, 10);
        CantidadDeDocumentos := CantidadDePagos;
        //TipoEndoso := 'N';
        //TipoDePago := '0201';  //PAGO A PROVEEDORES
        chr13 := 13;
        chr10 := 10;
        CR01 := FORMAT(chr13);
        LF01 := FORMAT(chr10);

        //TipoServicio := '      5003'; // 5003 = Pago a Proveedores
        //MedioRespaldo := 'CAT_CSH_CONTRACT_ACCOUNT'; //Por defecto debe ser CAT_CSH_CONTRACT_ACCOUNT.
        //NroMedioResp := paymentexportdata."Sender Bank Account No.";
        //Glosa := 'PAGO A PROVEEDORES';
    end;

    local procedure AddVLE(VLE: record "Vendor Ledger Entry")
    var
        EntryNo: integer;
        DocumentType: record "FJH.Document Type Code";
    begin
        CreditTransferEntry.Reset();
        if CreditTransferEntry.FindLast() then
            EntryNo := CreditTransferEntry."Entry No."
        else
            EntryNo := 0;

        EntryNo += 1;
        CreditTransferEntry.Init();
        CreditTransferEntry."Entry No." := EntryNo;
        CreditTransferEntry."Applies-to Entry No." := VLE."Entry No.";
        if VLE."External Document No." <> '' then begin
            CreditTransferEntry."Message to Recipient" := StrSubstNo(LblPayment, VLE."Document Type", VLE."External Document No.");
            CreditTransferEntry."Recipient Bank Account No." := VLE."External Document No.";
        end else begin
            CreditTransferEntry."Message to Recipient" := StrSubstNo(LblPayment, VLE."Document Type", VLE."Document No.");
            CreditTransferEntry."Recipient Bank Account No." := VLE."Document No.";
        end;
        CreditTransferEntry."Transfer Amount" := -VLE."Amount to Apply";
        CreditTransferEntry."Transfer Date" := VLE."Document Date";
        CreditTransferEntry."Message to Recipient" := VLE.Description;
        DocumentType.Reset();
        if DocumentType.Get(VLE."FJH.Document Type Code") then begin
            CreditTransferEntry."Transaction ID" := DocumentType."CITI Code";
        end;

        if CreditTransferEntry."Transaction ID" = '' then begin
            if VLE.Amount > 0 then
                CreditTransferEntry."Transaction ID" := '60'
            else
                CreditTransferEntry."Transaction ID" := '30';
        end;

        /*
        //Determinado por el cliente: 30..34|55..56 -> FE // 35|38|39|41 -> BH
        if (CreditTransferEntry."Transaction ID" = '35') or (CreditTransferEntry."Transaction ID" = '38') or
            (CreditTransferEntry."Transaction ID" = '39') or (CreditTransferEntry."Transaction ID" = '41') then
            CreditTransferEntry."Transaction ID" := 'BH'
        else
            CreditTransferEntry."Transaction ID" := 'FE';
        */
        CreditTransferEntry.Insert();
    end;

    local procedure FillWith0(inputText: Text; length: Integer) outputText: Text
    var
        f: integer;
    begin
        outputText := '';
        for f := 1 to length do
            outputText += '0';
        outputText := CopyStr(outputText + inputText, StrLen(outputText + inputText) - (length - 1), length);
        exit(outputText);
    end;

}

