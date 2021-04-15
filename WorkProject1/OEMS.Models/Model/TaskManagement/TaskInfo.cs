using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_TaskInfo")]
    [ClassName("Task Info")]
    public class TaskInfo: Entity
    {
        [Key]
        public int Id { get; set; }
        public int TicketId { get; set; } // Fk
        public int ProjectId { get; set; } // Fk
        public int SprintId { get; set; } // Fk
        public string TaskName { get; set; }
        public string Description { get; set; }
        public string Comments { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime DueDate { get; set; }
        public int WorkingHour { get; set; }
        public bool IsClosed { get; set; }
        public int ClientId { get; set; }
        public int Priority { get; set; }

        [NotMapped]
        public string TaskDueDate { get; set; }
    }
}