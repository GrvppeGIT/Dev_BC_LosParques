namespace FJH.ElectronicPayments;

using Microsoft.Bank.DirectDebit;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.HumanResources.Employee;
using Microsoft.Bank.Payment;
using System.Utilities;
using System.IO;

codeunit 50101 "FJH Payments Subscriptions"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEPA CT-Check Line", OnBeforeCheckBank, '', false, false)]
    local procedure OnBeforeCheckBank(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean);
    var
        BankAccount: record "Bank Account";
    begin
        IsHandled := true;
        if BankAccount.Get(GenJournalLine."Bal. Account No.") then begin
            if BankAccount."Bank Account No." = '' then
                AddFieldEmptyError(GenJournalLine, BankAccount.TableCaption(), BankAccount.FieldCaption("Bank Account No."), GenJournalLine."Bal. Account No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEPA CT-Check Line", OnBeforeCheckCustVendEmpl, '', false, false)]
    local procedure OnBeforeCheckCustVendEmpl(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean);
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        Employee: Record Employee;
    begin
        IsHandled := true;

        if GenJournalLine."Account No." = '' then begin
            GenJournalLine.InsertPaymentFileError(MustBeVendorEmployeeOrCustomerErr);
            exit;
        end;
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Customer:
                begin
                    Customer.Get(GenJournalLine."Account No.");
                    if Customer.Name = '' then
                        AddFieldEmptyError(GenJournalLine, Customer.TableCaption(), Customer.FieldCaption(Name), GenJournalLine."Account No.");
                    if GenJournalLine."Recipient Bank Account" <> '' then begin
                        CustomerBankAccount.Get(Customer."No.", GenJournalLine."Recipient Bank Account");
                        if CustomerBankAccount."Bank Account No." = '' then
                            AddFieldEmptyError(
                              GenJournalLine, CustomerBankAccount.TableCaption(), CustomerBankAccount.FieldCaption("Bank Account No."), GenJournalLine."Recipient Bank Account");
                    end;
                end;
            GenJournalLine."Account Type"::Vendor:
                begin
                    Vendor.Get(GenJournalLine."Account No.");
                    if Vendor.Name = '' then
                        AddFieldEmptyError(GenJournalLine, Vendor.TableCaption(), Vendor.FieldCaption(Name), GenJournalLine."Account No.");
                    if GenJournalLine."Recipient Bank Account" <> '' then begin
                        VendorBankAccount.Get(Vendor."No.", GenJournalLine."Recipient Bank Account");
                        if (VendorBankAccount."FJH Payment Mode" = VendorBankAccount."FJH Payment Mode"::"Checking Account") or
                           (VendorBankAccount."FJH Payment Mode" = VendorBankAccount."FJH Payment Mode"::"Savings Account") then begin
                            if VendorBankAccount."Bank Account No." = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("Bank Account No."), GenJournalLine."Recipient Bank Account");
                            if VendorBankAccount."Transit No." = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("Transit No."), GenJournalLine."Recipient Bank Account");
                            if VendorBankAccount."Bank Branch No." = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("Bank Branch No."), GenJournalLine."Recipient Bank Account");
                        end;

                        if VendorBankAccount."FJH Payment Mode" = VendorBankAccount."FJH Payment Mode"::"Branch Cash Voucher" then begin
                            if VendorBankAccount."FJH Economic Activity" = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("FJH Economic Activity"), GenJournalLine."Recipient Bank Account");
                            if VendorBankAccount."FJH Destination Branch" = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("FJH Destination Branch"), GenJournalLine."Recipient Bank Account");
                        end;

                        if VendorBankAccount."FJH Payment Mode" = VendorBankAccount."FJH Payment Mode"::"Company Cash Voucher" then begin
                            if VendorBankAccount."FJH Economic Activity" = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("FJH Economic Activity"), GenJournalLine."Recipient Bank Account");
                            if VendorBankAccount."FJH Destination Branch" = '' then
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FieldCaption("FJH Destination Branch"), GenJournalLine."Recipient Bank Account");
                        end;
                    end;
                end;
            GenJournalLine."Account Type"::Employee:
                begin
                    Employee.Get(GenJournalLine."Account No.");
                    if Employee.FullName() = '' then
                        AddFieldEmptyError(GenJournalLine, Employee.TableCaption(), Employee.FieldCaption("First Name"), GenJournalLine."Account No.");
                    if GenJournalLine."Recipient Bank Account" <> '' then
                        if Employee."Bank Account No." = '' then
                            AddFieldEmptyError(
                              GenJournalLine, Employee.TableCaption(), Employee.FieldCaption("Bank Account No."), GenJournalLine."Recipient Bank Account");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Export Data", OnAfterSetVendorAsRecipient, '', false, false)]
    local procedure OnAfterSetVendorAsRecipient(var PaymentExportData: Record "Payment Export Data"; var Vendor: Record Vendor; var VendorBankAccount: Record "Vendor Bank Account");
    begin
        PaymentExportData."FJH Recipient RUT" := Vendor."VAT Registration No.";
        PaymentExportData."FJH Recipient Bank No." := VendorBankAccount."Transit No.";
        PaymentExportData."FJH Destination Branch" := VendorBankAccount."FJH Destination Branch";
        PaymentExportData."FJH Economic Activity" := VendorBankAccount."FJH Economic Activity";
        PaymentExportData."FJH Payment Mode" := VendorBankAccount."FJH Payment Mode";
        if PaymentExportData."FJH Payment Mode" = PaymentExportData."FJH Payment Mode"::"Branch Cash Voucher" then begin
            PaymentExportData."Recipient Name" := VendorBankAccount.Name;
            PaymentExportData."Recipient Address" := VendorBankAccount.Address;
            PaymentExportData."Recipient County" := VendorBankAccount."Address 2";
            PaymentExportData."Recipient City" := VendorBankAccount.City;
            PaymentExportData."FJH Recipient RUT" := VendorBankAccount."FJH CV Withdrawer VAT No.";
            PaymentExportData."FJH Vendor Name" := Vendor.Name;
            PaymentExportData."FJH Vendor Address" := Vendor.Address;
            PaymentExportData."FJH Vendor Address 2" := Vendor."Address 2";
            PaymentExportData."FJH Vendor City" := Vendor.City;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEPA CT-Export File", OnBeforeBLOBExport, '', false, false)]
    local procedure OnBeforeBLOBExport(var TempBlob: Codeunit "Temp Blob"; CreditTransferRegister: Record "Credit Transfer Register"; UseComonDialog: Boolean; var FieldCreated: Boolean; var IsHandled: Boolean);
    var
        FileManagement: Codeunit "File Management";
    begin
        IsHandled := true;
        FieldCreated :=
            FileManagement.BLOBExport(TempBlob, StrSubstNo('%1.TXT', CreditTransferRegister.Identifier), UseComonDialog) <> '';
    end;

    local procedure AddFieldEmptyError(var GenJnlLine: Record "Gen. Journal Line"; TableCaption2: Text; FieldCaption: Text; KeyValue: Text)
    var
        ErrorText: Text;
    begin
        if KeyValue = '' then
            ErrorText := StrSubstNo(FieldBlankErr, FieldCaption)
        else
            ErrorText := StrSubstNo(FieldKeyBlankErr, TableCaption2, KeyValue, FieldCaption);
        GenJnlLine.InsertPaymentFileError(ErrorText);
    end;

    var
        FieldBlankErr: Label 'The %1 field must be filled.', Comment = '%1= field name. Example: The Name field must be filled.';
        FieldKeyBlankErr: Label '%1 %2 must have a value in %3.', Comment = '%1=table name, %2=key field value, %3=field name. Example: Customer 10000 must have a value in Name.';
        MustBeVendorEmployeeOrCustomerErr: Label 'The account must be a vendor, customer or employee account.';

}
