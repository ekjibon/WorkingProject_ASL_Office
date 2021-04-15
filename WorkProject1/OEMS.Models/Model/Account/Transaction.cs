using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_Transaction")]
    [ClassName("Transaction")]
    public class Transaction: Entity
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public int FiscalYearId { get; set; }
        [Required]
        public int AccBranchId { get; set; }
        [Required]
        [MinLength(4)]
        [MaxLength(12)]
        public string TransNo { get; set; }
        public int TransType { get; set; } // 1= Recive ,2=Payment, 3= Contra, 4=Journal
        public int PayMode { get; set; }// 1 = Cash 2 = Cheque 3 = OnCredit/Receivables

        public DateTime Date { get; set; }
        public DateTime ApproveDate { get; set; }
        public string ApproveBy { get; set; }
        public bool IsApproved { get; set; }

        public string PayTo { get; set; }
        public string RecivedBy { get; set; }
        public string ChequeNo { get; set; }
        public DateTime? ChequeDate { get; set; }
        public string Description { get; set; }
        public int? InvoiceTransType { get; set; } // 1= Publish ,2=Clear, 3= Collection
        public int? CollectionMasterId { get; set; }
        //[NotMapped]
        public bool IsReject { get; set; }

        public decimal DrTotal { get; set; }
        public decimal CrTotal { get; set; }

        [NotMapped]
        public int? LedgerId { get; set; }

        public Transaction()
        {
            DrTotal = 0;
            CrTotal = 0;
        }
    }
}
