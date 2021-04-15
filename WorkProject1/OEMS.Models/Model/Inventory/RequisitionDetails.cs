using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_RequisitionDetails")]
    [ClassName("Requisition Details")]
    public class RequisitionDetails
    {
        [Key]
        public int ReqDetailsId { get; set; }
        public int ReqId { get; set; } 
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        [NotMapped]
        public string ProductName { get; set; }
        [NotMapped]
        public string Unit { get; set; }
    }
}
