using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [Table("Common_PoliceStation")]
    [ClassName("Police Station")]
    public class PoliceStation
    {
        [Key]
        public int PsId { get; set; }
        [ForeignKey("District")]
        public int DistrictId { get; set; }
        [Required]
        public string PsName { get; set; }
        public virtual District District { get; set; }

        
    }
}
