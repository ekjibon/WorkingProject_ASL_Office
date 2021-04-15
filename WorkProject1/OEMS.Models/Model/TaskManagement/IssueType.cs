using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.TaskManagement
{
    [Table("Task_IssueType")]
    [ClassName("Issue Type")]
    public class IssueType : Entity
    {
        [Key]
        public int Id { get; set; }
        public string IssueTypeName { get; set; } // Stroy,Bug,New Development
    }
}
