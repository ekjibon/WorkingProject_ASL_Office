using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_IssueHistory")]
    [ClassName("Task Issue History")]
    public class IssueHistory
    {
        [Key]
        public long HistoryId { get; set; }
        public string UserId { get; set; }
        public string Type { get; set; }// Function Type = SubTask,Assign,Priority,Attachment,Sprint,IssueStatus
        public string Description { get; set; }
        public int IssueId { get; set; }
        public int? ParentId { get; set; }
        public int? SprinttId { get; set; }
        public int? PreviousId { get; set; }
        public int? PresentId { get; set; }
        public DateTime ModifyDate { get; set; } = DateTime.Now;      

    }
}