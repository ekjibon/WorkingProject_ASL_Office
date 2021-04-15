using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveCategory")]
    [ClassName("Leave Category")]
    public class LeaveCategory:Entity
    {
        [Key]
        public int Id { get; set; }
        public string CategoryName { get; set; }
    }
}
