namespace FJH.API.LPCustom;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Projects.Project.Job;

tableextension 50104 "FHJ G/L Entry Extension" extends "G/L Entry"
{
    fields
    {
        field(50101; "FJH.Job Task No."; Code[20])
        {
            Caption = 'Project Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
    }
}
