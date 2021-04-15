using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_MeetingConfig")]
    [ClassName("Emp Meeting Config")]
    public  class EmpMeetingConfig : Entity
    {
        [Key]
        public int ConfigId { get; set; }
        [Required]
        public string EmpCategoryId { get; set; } //From CommonDropdown Config
        
        [Required]  
        public int FirstEmpId { get; set; }
        [Required]
        public int SecondEmpId { get; set; }
      
        public DateTime? StartTime { get; set; }
      
        public DateTime? EndTime { get; set; }

        public int BranchId { get; set; }
        public int ClassId { get; set; }

        public int? DayId { get; set; }


    }
}
