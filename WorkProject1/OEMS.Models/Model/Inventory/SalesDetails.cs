using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_SalesDetails")]
    [ClassName("Sales Details")]
    public class SalesDetails : Entity
    {
        [Key]
        public int SalesDetailsId { get; set; }
        public int SalesId { get; set; }
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal  SubTotal { get; set; }
        public decimal Discount { get; set; }
        public decimal Vat { get; set; }
        public decimal NetPayable { get; set; }
      

    }
}
