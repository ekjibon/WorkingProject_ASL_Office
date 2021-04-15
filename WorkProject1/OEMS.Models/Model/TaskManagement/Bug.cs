using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Bug")]
    [ClassName("Bug")]
    public class Bug : Entity
    {
        [Key]
        public int Id { get; set; }
        public int ModuleId { get; set; }  // Fk
        public int TestSiteId { get; set; } // Fk
        public int ProjectId { get; set; } // Fk
        public string Code { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Comments { get; set; }
        public string DeveloperFeedback { get; set; }
        public string  TesterFeedback { get; set; }

    }
}