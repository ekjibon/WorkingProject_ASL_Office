using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Sales")]
    [ClassName("Sales")]
    public class Sales : Entity

    {
        public Sales()
        {
            SalesDetails = new List<SalesDetails>();
        }

        [Key]
        public int SalesId { get; set; }
        public string CustomerName { get; set; }
        public string MobileNo { get; set; }       
        public decimal  SubTotal { get; set; }
        public decimal Discount { get; set; }
        public decimal Vat { get; set; }
        public decimal NetPayable { get; set; }

        [NotMapped]
        public List<SalesDetails> SalesDetails { get; set; }



    }
}
