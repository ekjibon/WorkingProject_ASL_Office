using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.TaskManagement
{
    [Table("Task_Issue")]
    [ClassName("Issue")]
    public class Issue : Entity
    {
        [Key]
        public int Id { get; set; }
        public int? ProjectId { get; set; }  //Fk
        public int? IssueTypeId { get; set; }  //Fk    
        public int? SprintId { get; set; }  //Fk
        public int? AssigneeId { get; set; }  //Fk  
        public int? ReporterId { get; set; } //Fk
        public int? ClientId { get; set; }  //Fk 
        public string Title { get; set; }
        public string Description { get; set; }
        public string Priority { get; set; } // By Default Medium
        public string AlertRule { get; set; }
        public DateTime? DueDate { get; set; }
        public int? ParentId { get; set; }
        public int? StatusId { get; set; }
        public DateTime? StartDate { get; set; } // Inprogress then Insert Date
        public DateTime? EndDate { get; set; } // Done then Insert Date
        // New Field Added by Arifur at 09-12-2020
        public int EstimatedTime { get; set; } // value = 1,2,12,20
        public string   EstimatedType { get; set; } // Min,Hour,Day

        [NotMapped]
        public string IssueDueDate { get; set; }

    }
}
