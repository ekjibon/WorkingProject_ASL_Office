using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Portal
{
    [Table("Fees_pay2feeTransection")]
    [ClassName("Pay2Fee Transection")]
    public class Pay2FeeTransection : Entity
    {
        [Key]
        public int Id { get; set; }
        public int TillMonth { get; set; }
        public int TillYear { get; set; }
        public int StudentID { get; set; }
        public string InvoiceNumber { get; set; }
        public decimal Amount { get; set; }

    }
}
