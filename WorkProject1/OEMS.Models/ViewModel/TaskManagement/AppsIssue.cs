using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.TaskManagement
{
    public class AppsIssue
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int ParentId { get; set; }
        public string ProjectName { get; set; }
        public string ClientFullName { get; set; }
        public string IssueTypeName { get; set; }
        public string SprintTitle { get; set; }
        public string ReporterName { get; set; }
        public string AssigneeName { get; set; }
        public string StatusName { get; set; }
        public string Priority { get; set; }
        public string Weblink { get; set; }
        public string ReporterUserId { get; set; }
        public string AssigneeUserId { get; set; }

        public string WeblinkDescription { get; set; }
        public int AssigneeId { get; set; }  //Fk   //EmpId
        public int ReporterId { get; set; } //Fk //EmpId
        public int StatusId { get; set; }
        public int ProjectId { get; set; } //Fk
        public int ClientId { get; set; }
        public int SprintId { get; set; }
        public DateTime DueDate { get; set; }
    }
}
