using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Club
{
    [Table("Ins_ECAClub")]
    [ClassName("ECA Club")]
    public class ECAClub : Entity
    {
        [Key]
        public int ClubId { get; set; }
        public string ClubName { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
    }
}
