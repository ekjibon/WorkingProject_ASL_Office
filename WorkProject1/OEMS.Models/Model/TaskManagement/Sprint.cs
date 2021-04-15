using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Sprint")]
    [ClassName("Sprint")]
    public class Sprint: Entity
    {
        [Key]
        public int Id { get; set; }
        public int ProjectId { get; set; } // Fk
        public string SprintTitle { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int Completed {  get; set; }
        public string Goal { get; set; }
        public string PersonId { get; set; } // 1,2,3,4,5
        public bool IsStart { get; set; }
        public bool IsSupport { get; set; }
        [NotMapped]
        public string SprintStartDate { get; set; }
        [NotMapped]
        public string SprintEndDate { get; set; }
    }
}