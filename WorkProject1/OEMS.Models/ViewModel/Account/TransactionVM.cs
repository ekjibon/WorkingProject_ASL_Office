using System;
using System.Collections.Generic;

namespace OEMS.Models.ViewModel.Account
{
    public class TransactionVM
    {
        public int Id { get; set; }
        public int FiscalYearId { get; set; }
        public int AccBranchId { get; set; }
        public string TransNo { get; set; }
        public int TransType { get; set; } // 1= Recive ,2=Payment, 3= Contra, 4=Journal
        public string Date { get; set; }
        public decimal DrTotal { get; set; }
        public decimal CrTotal { get; set; }
        public string Remarks { get; set; }
        public bool IsReject { get; set; }
        public string IP { get; set; }
        public int PayMode { get; set; }// 1 = Cash 2 = Cheque 3 = OnCredit
        public string ApproveDate { get; set; }
        public string ApproveBy { get; set; }
        public bool IsApproved { get; set; }
        public string PayTo { get; set; }
        public string RecivedBy { get; set; }
        public string ChequeNo { get; set; }
        public string ChequeDate { get; set; }
        public List<TransactionDetailVM> TransactionDetail { get; set; }
       
       
        public TransactionVM()
        {
            DrTotal = 0;
            CrTotal = 0;
        }
    }
    public class TransactionDetailVM
    {
        public int RowNo { get; set; }
        public int Id { get; set; }
        public int TransactionId { get; set; }
        public int LedgerId { get; set; }
        public string Date { get; set; }
        public decimal DrAmount { get; set; }
        public decimal CrAmount { get; set; }
        public decimal CurrentAmount { get; set; }
        public decimal OpeningAmount { get; set; }
        public int DC { get; set; }
        public string LedgerName { get; set; }

        static int nrOfInstances = 0;
        TransactionDetailVM()
        {
            TransactionDetailVM.nrOfInstances++;
            RowNo = TransactionDetailVM.nrOfInstances;
            
        }
        public List<lsCostCenterVM> lsCostCenter { get; set; }
    }
   
    public class lsCostCenterVM
    {
        public int? RowNo { get; set; }
        public int? Id { get; set; }
        public int? TransactionId { get; set; }
        public int? LedgerId { get; set; }
        public int? CostCenterId { get; set; }
        public decimal? Amount { get; set; }
        public string LedgerName { get; set; }
        public string CostCenterName { get; set; }

    }
}
