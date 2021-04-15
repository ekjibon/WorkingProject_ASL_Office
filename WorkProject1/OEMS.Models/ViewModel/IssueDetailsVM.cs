using OEMS.Models.Model.TaskManagement;
using OEMS.Models.ViewModel.TaskManagement;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UI.Admin.Models.Task;

namespace OEMS.Models.ViewModel
{
    
    public class IssueDetailsVM
    {
        public int? Id { get; set; }
        public int? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int? IssueTypeId { get; set; }
        public string IssueTypeName { get; set; }
        //public int? BugAttachmentId { get; set; }   Multiple Attachment
        public int? SprintId { get; set; }
        public string SprintTitle { get; set; } 
        public int? AssigneeId { get; set; }
        public string AssigneeName { get; set; }
        public int? ReporterId { get; set; }
        public string ReporterName { get; set; }
        public int? ClientId { get; set; }
        public string ClientName { get; set; }
        public int? StatusId { get; set; }
        public string StatusName { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Priority { get; set; }
        public string AlertRule { get; set; }
        public DateTime? DueDate { get; set; }
        public int? ParentId { get; set; }
        public bool IsParent { get; set; }

        public List<IssueWebLink> IssueWebLinksList { get; set; }
        public List<CommentsVM> CommentsList { get; set; }
        public List<TaskActivityLog> TaskActivityLogsList { get; set; }
        public List<Issue> SubIssueList { get; set; }
        public List<IssueAttachment> IssueAttachmentList { get; set; }
        public List<IssueHistory> IssueHistoryList { get; set; }
    }
}
