pageextension 50101 "PDR Vendor Ledger Entries" extends "Vendor Ledger Entries"
{


    layout
    {

        addafter("Global Dimension 2 Code")
        {
            field(PDRVendorPostingGroup; PDRVendorPostingGroup)
            {
                Caption = 'Vendor Posting Group';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                TableRelation = "Vendor Posting Group";
                trigger OnValidate()
                var

                begin
                    rec."Vendor Posting Group" := PDRVendorPostingGroup;
                    rec.Modify();
                end;
            }
        }

    }
    var

        PDRVendorPostingGroup: Code[20];



    trigger OnAfterGetRecord()
    var

    begin
        PDRVendorPostingGroup := rec."Vendor Posting Group";
    end;
}
