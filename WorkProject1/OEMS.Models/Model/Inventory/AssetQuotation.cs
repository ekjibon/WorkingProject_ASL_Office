using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetQuotation")]
    [ClassName("Asset Quotation")]
    public class AssetQuotation : Entity
    {
        public AssetQuotation()
        {
            QuoDetailsList = new List<AssetQuotationDetails>();
            QutatinList = new List<AssetQuotation>();
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
        public List<AssetQuotationDetails> QuoDetailsList { get; set; }

        [NotMapped]
        public List<AssetQuotation> QutatinList { get; set; }

    }
}
