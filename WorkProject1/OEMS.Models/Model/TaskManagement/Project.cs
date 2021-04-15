using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Project")]
    [ClassName("Project")]
    public class Project:Entity
    {
        [Key]
        public int Id { get; set; }
        public string ProjectName { get; set; }
        public DateTime ExpireDate { get; set; }
        public bool IsSupport { get; set; }
        public int CategoryId { get; set; } // Fk
        public int DepartmentId { get; set; } // Fk

        [NotMapped]
        public string Date { get; set; }
    }
}