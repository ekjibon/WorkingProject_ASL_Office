using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Tickets")]
    [ClassName("Tickets")]
    public class Tickets: Entity
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public int ProjectId { get; set; }
        public int CategoryId { get; set; }
        public int ModuleId { get; set; }
        public string Description { get; set; }
        public int Priority { get; set; }
        public int DepartmentId { get; set; }    
        public DateTime ClosedDate { get; set; }
        public int ClientId { get; set; }
        public string Url { get; set; }

    }
}