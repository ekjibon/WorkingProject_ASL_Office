using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Modules")]
    [ClassName("Modules")]
    public class Modules : Entity
    {
        [Key]
        public int Id { get; set; }
        public string ModuleName { get; set; }
        public string ProductName { get; set; }
    }
}