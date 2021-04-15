using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Distribution")]
    [ClassName("Distribution")]
    public class Distribution:Entity
    {
        [Key]
        public int DistributionId { get; set; }
        public int ProductId { get; set; }
        public decimal Qty { get; set; }
        public int EmployeeId { get; set; }
    }
}
