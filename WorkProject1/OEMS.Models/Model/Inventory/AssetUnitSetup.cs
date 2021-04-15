using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetUnitSetup")]
    [ClassName("Asset Unit Setup")]
    public class AssetUnitSetup : Entity
    {
        [Key]
        public int UnitSetupId { get; set; }
        public string UnitName { get; set; }
        public string UnitCode { get; set; }
    }
}
