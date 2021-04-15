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
    [Table("Common_District")]
    [ClassName("District")]
    public class District
    {
        [Key]
        public int DistrictId { get; set; } 
        [Required]        
        public string DistrictName { get; set; }    
        [JsonIgnore]
        public ICollection<PoliceStation> PoliceStation { get; set; }
    }
}
