using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Clubs")]
    [ClassName("Emp Clubs")]
    public  class EmpClubs : Entity
    {
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int ClubId { get; set; }
        public int ClubConfigId { get; set; }
        public int DayId { get; set; }
        public int AssignDutyId { get; set; }
        public int NumberOfClass { get; set; }
    }
}
