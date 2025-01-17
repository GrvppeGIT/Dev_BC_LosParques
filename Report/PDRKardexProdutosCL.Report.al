report 50100 "PDR.Kardex Produtos CL"
{
    //35001036 "FJH.Kardex Produtos."

    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/PDRKardexProdutosCL.rdl';
    Caption = 'Kardex Produtos.';
    ApplicationArea = all;
    Permissions =
        tabledata Customer = R,
        tabledata Item = R,
        tabledata "Item Ledger Entry" = R,
        tabledata "Value Entry" = R,
        tabledata Vendor = R;

    dataset
    {
        dataitem("Item"; Item)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(FORMAT_Today_0_4_; FORMAT(Today, 0, 4))
            {
            }
            column(Period_from_______FORMAT_StartDate______to______FORMAT_EndDate_; 'Periodo : ' + FORMAT(StartDate) + ' to: ' + FORMAT(EndDate))
            {
            }
            column(CurrencyDesc; 104)
            {
            }
            column(KardexCaption; KardexCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item_No_; "No.")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                CalcFields = "Cost Amount (Actual)";
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Location Code", "Posting Date")
                                    ORDER(Ascending);
                column(Item_Description___Item__Description_2_; Item.Description + Item."Description 2")
                {
                }
                column(Unit_of_Measure_; Item."Base Unit of Measure")
                {
                }
                column(TransactionTypeLbl; TransactionTypeLbl)
                {
                }
                column(ReferenceNoLbl; ReferenceNoLbl)
                {
                }
                column(ReferenceNo; ReferenceNo)
                {
                }
                column(GuiaLbl; GuiaLbl)
                {
                }
                column(GuiaNo; GuiaNo)
                {
                }
                column(TransactionDateLbl; TransactionDateLbl)
                {
                }
                column(TransactionDate; Format("Posting Date", 10, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(SpecificCostLbl; SpecificCostLbl)
                {
                }
                column(UnitaryTransactionLbl; UnitaryTransactionLbl)
                {
                }
                column(Lot_No_; "Lot No.")
                {
                }
                column(Lot_NoLbl; FieldCaption("Lot No."))
                {
                }
                column(Item__No__; Item."No.")
                {
                }
                column(Text50003_____FORMAT___StartDate__; Text50003 + FORMAT(StartDate))
                {
                }
                column(FirstBalance; FirstBalance)
                {
                }
                column(FirstCostAmount; FirstCostAmount)
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(Location_Code; "Location Code")
                {
                }
                column(Location_Name; LocationName)
                {
                }
                column(Item_Ledger_Entry__Entry_Type_; "Entry Type")
                {
                }
                column(FirstBalance_Control1000000006; FirstBalance)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UnitCost; UnitCost)
                {
                }
                column(FirstCostAmount_Control1000000025; FirstCostAmount)
                {
                }

                column(FirstBalance_Control1000000019; FirstBalance)
                {
                }
                column(Item_Ledger_Entry__Entry_Type__Control1000000021; "Entry Type")
                {
                }
                column(DocumentNo_Control1000000022; DocumentNo)
                {
                }
                column(Item_Ledger_Entry__Posting_Date__Control1000000023; "Posting Date")
                {
                }
                column(FirstCostAmount_Control1000000026; FirstCostAmount)
                {
                }
                column(Continues____; 'Continues...')
                {
                }
                column(FirstBalance_Control1000000016; FirstBalance)
                {
                }
                column(NegativeAmount; NegativeAmount)
                {
                }
                column(PositiveAmount; PositiveAmount)
                {
                }
                column(FirstCostAmount_Control1000000008; FirstCostAmount)
                {
                }
                column(QtyCaptionLbl; QtyCaptionLbl)
                {
                }
                column(QtyCaptionAcumLbl; QtyCaptionAcumLbl)
                {
                }
                column(InventoryCaption; InventoryCaptionLbl)
                {
                }
                column(Description_Caption; Description_CaptionLbl)
                {
                }
                column(Item__Caption; Item__CaptionLbl)
                {
                }
                column(QtyCaption; QtyCaptionLbl)
                {
                }

                column(Entry_TypeCaption; Entry_TypeCaptionLbl)
                {
                }
                column(Document_No_Caption; Document_No_CaptionLbl)
                {
                }
                column(DateCaption; DateCaptionLbl)
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(AmountCaption_Control1102200021; AmountCaption_Control1102200021Lbl)
                {
                }
                column(AmountCaption_Control1102200022; AmountCaption_Control1102200022Lbl)
                {
                }
                column(Total_Caption; Total_CaptionLbl)
                {
                }
                column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Item_Ledger_Entry_Item_No_; "Item No.")
                {
                }
                column(InitialDate_; InitialDate)
                {
                }
                column(FinalDate_; FinalDate)
                {
                }

                column(UnitCostLbl; UnitCostLbl)
                {
                }
                column(ExtCostLbl; ExtCostLbl)
                {
                }
                column(TotalCost; TotalCost)
                {
                }

                column(Total_Cus_Caption; Total_Cus_CaptionLbl)
                {
                }
                column(Total_Quant_Caption; Total_Quant_CaptionLbl)
                {
                }
                column(InitialBalanceLbl; InitialBalanceLbl)
                {
                }
                column(LocationLbl; LocationLbl)
                {
                }
                column(InventoryIDLbl; InventoryIDLbl)
                {
                }
                column(Total_LocationLbl; Total_LocationLbl)
                {
                }
                column(Total_InventoryIDLbl; Total_InventoryIDLbl)
                {
                }
                column(TotalCostinit; TotalCostinit)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    CLEAR(ReferenceNo);
                    Clear(GuiaNo);
                    if Location.get("Location Code") then
                        LocationName := Location.Name
                    else
                        LocationName := '';
                    GuiaNo := "Document No.";
                    DocumentNo := "Document No.";
                    IF "Entry Type" = "Entry Type"::Purchase THEN begin
                        ReferenceNo := "External Document No.";
                        IF ("Entry Type" = "Entry Type"::Purchase) THEN
                            IF "External Document No." <> '' THEN
                                ReferenceNo := "External Document No."
                            else
                                ReferenceNo := "Document No.";
                    END else
                        IF ("Entry Type" = "Entry Type"::Sale) THEN begin
                            IF "External Document No." <> '' THEN
                                ReferenceNo := "External Document No."
                            else
                                ReferenceNo := "Document No.";
                        END else
                            IF ("Entry Type" = "Entry Type"::Output) THEN
                                ReferenceNo := "Document No."
                            else
                                IF ("Entry Type" = "Entry Type"::Consumption) THEN
                                    ReferenceNo := "Document No."
                                else
                                    IF ("Entry Type" = "Entry Type"::"Positive Adjmt.") THEN
                                        ReferenceNo := "Document No."
                                    else
                                        IF ("Entry Type" = "Entry Type"::Transfer) THEN
                                            ReferenceNo := "Document No."
                                        else
                                            ReferenceNo := "Document No.";
                    ReferenceNo := DelChr(ReferenceNo, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ-');
                    GuiaNo := DelChr(GuiaNo, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ-');
                    PositiveQuantity := Quantity;

                    IF Quantity > 0 THEN begin
                        NegativeQuantity := 0;
                        NegativeAmount := 0;
                        PositiveQuantity := Quantity;
                        PositiveAmount := ROUND(CostAmountCurrency, 0.01); //MtsBr8.05
                        UnitCost := ROUND(CostAmountCurrency / Quantity, 0.01); //MtsBr8.05
                        LastCostOut := 0;
                        FirstBalance += PositiveQuantity;
                        FirstCostAmount += PositiveAmount;
                        IF FirstBalance <> 0 THEN                                          //MtsBr8.04
                            TotalCost := ROUND(FirstCostAmount / FirstBalance, 0.01)
                        else                                                               //MtsBr8.04
                            TotalCost := ROUND(FirstCostAmount, 0.01);               //MtsBr8.04
                    end;
                    IF Quantity < 0 THEN begin
                        PositiveQuantity := 0;
                        PositiveAmount := 0;
                        NegativeQuantity := ABS(Quantity);
                        NegativeAmount := ABS(ROUND(CostAmountCurrency, 0.01)); //MtsBr8.05
                        UnitCost := 0;
                        LastCostOut := ROUND(ABS(CostAmountCurrency / Quantity), 0.000001);//MtsBr8.03 //MtsBr8.05

                        FirstBalance -= NegativeQuantity;
                        FirstCostAmount -= NegativeAmount;
                        IF FirstBalance <> 0 THEN                                          //MtsBr8.02
                            TotalCost := ROUND(FirstCostAmount / FirstBalance, 0.01) //MtsBr8.02
                        else                                                               //MtsBr8.02
                            TotalCost := ROUND(FirstCostAmount, 0.01);               //MtsBr8.02
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                    if (LocationCodeFilter <> '') then
                        SETFILTER("Location Code", LocationCodeFilter);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CLEAR(InitialDate);
                CLEAR(FinalDate);
                CLEAR(TotalCostinit);
                CLEAR(FirstBalance);
                CLEAR(FirstCostAmount);
                CLEAR(TotalCost);
                ItemBalance.GET("No.");
                ItemBalance.SETFILTER("Date Filter", '..%1', CALCDATE('-1D', StartDate));
                ItemBalance.CALCFIELDS("Inventory");
                InitialDate := ItemBalance."Inventory";
                FinalDate := CalcFirstCostAmount("No.", StartDate);
                IF InitialDate <> 0 THEN
                    TotalCostinit := ROUND(FinalDate / InitialDate, 0.01);
                FirstBalance := InitialDate;
                FirstCostAmount := FinalDate;
                TotalCost := TotalCostinit;
            end;

            trigger OnPreDataItem()
            begin
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("<Control3>")
                {
                    Caption = 'Options';
                    field(StartDateField; StartDate)
                    {
                        Caption = 'Initial Date';
                        ToolTip = 'Initial Date';
                    }
                    field(EndDateField; EndDate)
                    {
                        Caption = 'End Date';
                        ToolTip = 'End Date';
                    }
                    field(LocationCodeField; LocationCodeFilter)
                    {
                        Caption = 'Location Filter';
                        TableRelation = Location where("Use As In-Transit" = const(false));
                        ToolTip = 'End Date';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        //Test
        StartDate := 20240101D;
        EndDate := 20241231D;
    end;

    trigger OnPreReport()
    begin
        IF ((StartDate = 0D) OR (EndDate = 0D)) THEN //or (LocationCodeFilter = '')
            ERROR(InformErr);
    end;

    var
        ItemBalance: Record Item;
        Location: Record Location;
        DocumentNo: Code[20];

        LocationCodeFilter: Code[20];

        LocationName: Text[100];

        EndDate: Date;
        StartDate: Date;
        CostAmountCurrency: Decimal;
        FinalDate: Decimal;
        FirstBalance: Decimal;
        FirstCostAmount: Decimal;
        InitialDate: Decimal;
        LastCostOut: Decimal;
        NegativeAmount: Decimal;
        NegativeQuantity: Decimal;
        PositiveAmount: Decimal;
        PositiveQuantity: Decimal;
        TotalCost: Decimal;

        TotalCostinit: Decimal;
        UnitCost: Decimal;
        AmountCaption_Control1102200021Lbl: Label 'Amount';
        AmountCaption_Control1102200022Lbl: Label 'Amount';
        AmountCaptionLbl: Label 'Amount';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        UnitCostLbl: Label 'Costo. Unitario';
        ExtCostLbl: Label 'Costo Ext.';
        DateCaptionLbl: Label 'Date';
        Description_CaptionLbl: Label 'Description:';
        Document_No_CaptionLbl: Label 'Document No.';
        Entry_TypeCaptionLbl: Label 'Entry Type';

        InventoryCaptionLbl: Label 'Inventory';
        Item__CaptionLbl: Label 'Item :';

        KardexCaptionLbl: Label 'Kardex';


        QtyCaptionAcumLbl: Label 'Cantidad Unid. Almac.';
        QtyCaptionLbl: Label 'Cantidad';
        InformErr: Label 'Please inform the period and Location';
        Text50003: Label 'Initial Inventory in ';
        Total_CaptionLbl: Label 'Total:';
        Total_Cus_CaptionLbl: Label 'Total Custo';
        Total_Quant_CaptionLbl: Label 'Total Quantidade';


        Total_InventoryIDLbl: Label 'Total Item :', Comment = 'ESM=Total Producto :';
        Total_LocationLbl: Label 'Total Location :', Comment = 'ESM=Total Almacen :';
        InventoryIDLbl: Label 'Item :', Comment = 'ESM=Producto :';
        LocationLbl: Label 'Location :', Comment = 'ESM=Almacen:';
        InitialBalanceLbl: Label 'Initial Balance :', Comment = 'ESM=SaldoInicial:';

        TransactionTypeLbl: Label 'Transaction Type', Comment = 'ESM=Tipo Transacción';
        ReferenceNoLbl: Label 'ReferenceNo No.', Comment = 'ESM=Número Referencia';
        GuiaLbl: Label 'Guia No.', Comment = 'ESM=Nº Guia';
        TransactionDateLbl: Label 'Transaction Date', Comment = 'ESM=Fecha de Transacción';

        SpecificCostLbl: Label 'Specific Cost', Comment = 'ESM=Costo Especifico';
        UnitaryTransactionLbl: Label 'Unitary Transaction', Comment = 'ESM=Transacción Unitaria';
        GuiaNo: Code[35];
        ReferenceNo: Code[35];

    procedure CalcFirstCostAmount("Item No.2": Code[20]; StartDate2: Date) FirstCost: Decimal
    var
        ValueEntry: Record 5802;
    begin
        ValueEntry.Reset();
        ValueEntry.SETCURRENTKEY("Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type", "Variance Type", "Item Charge No.", "Location Code", "Variant Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Source Type", "Source No."); //MtsBr8.05
        ValueEntry.SETRANGE("Item No.", "Item No.2");
        ValueEntry.SETFILTER("Posting Date", '..%1', CALCDATE('<-1D>', StartDate2));
        ValueEntry.CALCSUMS("Cost Amount (Actual)");
        ValueEntry.CALCSUMS("Cost Amount (Expected)"); //MtsBr8.05

        //MtsBr8.05 - START
        IF ValueEntry."Cost Amount (Actual)" <> 0 THEN
            CostAmountCurrency := ValueEntry."Cost Amount (Actual)"
        else
            CostAmountCurrency := ValueEntry."Cost Amount (Expected)";
        //MtsBr8.05 - END
        FirstCost := CostAmountCurrency;
    end;

    procedure CalcLineCostILE(EntryNo: Integer; ItemNo: Code[20]) Value: Decimal
    var
        lvValueEntry: Record 5802;
        ValueAmount: Decimal;
        ValueExpected: Decimal;
    begin
        //MtsBr8.05 - START

        lvValueEntry.Reset();
        lvValueEntry.SETCURRENTKEY("Item No.", "Expected Cost", "Posting Date", "Location Code", "Variant Code");
        lvValueEntry.SETRANGE("Item Ledger Entry No.", EntryNo);
        lvValueEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
        lvValueEntry.SETRANGE("Item No.", ItemNo);
        IF lvValueEntry.FindSet() THEN begin
            CLEAR(ValueAmount);
            CLEAR(ValueExpected);
            REPEAT
                ValueAmount += lvValueEntry."Cost Amount (Actual)"
            UNTIL lvValueEntry.NEXT() = 0;
        end;

        Value := ValueAmount

        //MtsBr8.05 - END
    end;
}
