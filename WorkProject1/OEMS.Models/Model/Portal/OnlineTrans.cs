using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Portal
{
    [Table("Fees_OnlineTrans")]
    [ClassName("Online Transection")]
    public class OnlineTrans : Entity
    {
        [Key]
        public int Id { get; set; }
        public int TillMonth { get; set; }
        public int TillYear { get; set; }
        public int StudentID { get; set; }
        public string InvoiceNumber { get; set; }
        public string HeadDetails { get; set; }
        public string PayMode { get; set; }
        public string ChaqueNumber { get; set; }
        public decimal Amount { get; set; }
        public decimal bKashCharge { get; set; }

    }
}
