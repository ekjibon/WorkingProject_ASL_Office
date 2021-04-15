using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_TransactionDetail")]
    [ClassName("Transaction Detail")]
    public class TransactionDetail
    {
        [Key]
        public int Id { get; set; }
        public int TransactionId { get; set; }
        public int LedgerId { get; set; }
        public decimal DrAmount { get; set; }
        public decimal CrAmount { get; set; }
        public decimal CurrentAmount { get; set; }
        public decimal OpeningAmount { get; set; }
        public int? DC { get; set; }

    }
}
