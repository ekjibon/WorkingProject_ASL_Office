using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_ServiceSetup")]
    [ClassName("Service Setup")]
    public class ServiceSetup : Entity
    {
        [Key]
        public int ServiceSetupId { get; set; }
        public string ServiceName { get; set; }
        public string ServiceCode { get; set; } 
    }
}
