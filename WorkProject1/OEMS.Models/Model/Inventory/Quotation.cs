using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Quotation")]
    [ClassName("Quotation")]
    public class Quotation : Entity
    {
        public Quotation()
        {
            QuoDetailsList = new List<QuotationDetails>();
            QutatinList = new List<Quotation>();
        }

        [Key]
        public int QuotationId { get; set; }
        public string QuotationCode { get; set; } // Automatice Generate 
        public int  SupplierId { get; set; }
       public DateTime DueDate { get; set; }
        public string Description { get; set; }
        [NotMapped]
        public string Date { get; set; }
        [NotMapped]
        public string SupplierName { get; set; }
        [NotMapped]
        public string AccountCode { get; set; }
        [NotMapped]
        public List<QuotationDetails> QuoDetailsList { get; set; }

        [NotMapped]
        public List<Quotation> QutatinList { get; set; }

    }
}
