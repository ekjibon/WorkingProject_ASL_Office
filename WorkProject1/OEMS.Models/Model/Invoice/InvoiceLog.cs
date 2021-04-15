using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_InvoiceLog")]
    [ClassName("Invoice Log")]
    public class InvoiceLog : Entity
    {
        [Key]
        public int Id { get; set; }
        public string InvoiceNo { get; set; }
        public int? ClientId { get; set; }
        public decimal? CollectionAmount { get; set; }
        public string LogType { get; set; } //  CollectionRollback
        public string LogStatus { get; set; } // CollectionRollback
        public string Description { get; set; }
        public DateTime LogDate { get; set; }
        public string UserId { get; set; }// ASP Net User Id



    }
}
