using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.TaskManagement
{
    [Table("Task_ProjectCategory")]
    [ClassName("Project Category")]
    public class ProjectCategory : Entity
    {
        [Key]
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
    }
}
