using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_Service")]
    [ClassName("InvoiceService")]
    public class InvoiceService : Entity
    {
        [Key]
        public int Id { get; set; }
        public string ServiceName { get; set; }
    }
}
