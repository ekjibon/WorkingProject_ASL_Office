using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.TaskManagement
{
    [Table("Task_Status")]
    [ClassName("TasksStatus")]
    public class TasksStatus : Entity
    {
        [Key]
        public int Id { get; set; }
        public string StatusName { get; set; }
        public string ColorCode { get; set; }
    }
}
