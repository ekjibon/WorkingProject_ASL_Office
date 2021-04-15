using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_Reward")]
    [ClassName("Reward")]
    public class Reward : Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public decimal RewardAmount { get; set; }
    }
}
