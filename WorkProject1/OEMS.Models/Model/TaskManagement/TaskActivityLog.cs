using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_TaskActivityLog")]
    [ClassName("Task Activity Log")]
    public class TaskActivityLog
    {
        [Key]
        public long Id { get; set; }
        public string UserId { get; set; }
        public string Type { get; set; }//ticket=1, task=2, task assign=3 // bug=6
        public string Description { get; set; }
        public int RefId { get; set; }
        public DateTime LogDate { get; set; } = DateTime.Now;
        public int? StatusId { get; set; }

    }
}