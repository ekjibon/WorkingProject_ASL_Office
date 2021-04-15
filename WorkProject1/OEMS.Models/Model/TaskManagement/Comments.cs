using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Comments")]
    [ClassName("Comments")]
    public class Comments
    {
        [Key]
        public int Id { get; set; }
        public int IssueId { get; set; } // Fk
        public int? ParentId { get; set; } // Fk
        public string Type { get; set; } //   Issue
        public string Description { get; set; }
        public int Like { get; set; }
        public int Dislike { get; set; }
        public string AddBy { get; set; }
        public DateTime AddDate { get; set; }

        [NotMapped]
        public string FullName { get; set; }
    }
}