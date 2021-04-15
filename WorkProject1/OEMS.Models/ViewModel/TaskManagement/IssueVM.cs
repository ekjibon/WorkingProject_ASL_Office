using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UI.Admin.Models.Task;

namespace OEMS.Models.ViewModel.TaskManagement
{

    public class IssueVM
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
        public string IssueDueDate { get; set; }
        public DateTime DueDate { get; set; }

        public string WeblinkDescription { get; set; }
        public int AssigneeId { get; set; }  //Fk   //EmpId
        public int ReporterId { get; set; } //Fk //EmpId
        public int StatusId { get; set; }
        public int ProjectId { get; set; } //Fk
        public int ClientId { get; set; }
        public int SprintId { get; set; }
        public int DepartmentId { get; set; }
        public int? IssueTypeId { get; set; }
        public int IsOverDue { get; set; }
        public List<SubIssueDetails> SubIssueDetailsList = new List<SubIssueDetails>();
        public List<IssueWebLink> WeblinksList = new List<IssueWebLink>();
        public List<IssueHistoryVM> HistoryList = new List<IssueHistoryVM>();
        public List<CommentsVM> CommentsList = new List<CommentsVM>();
        public List<IssueAttachmentVM> IssueAttachmentList = new List<IssueAttachmentVM>();
    }

    public class SubIssueDetails
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ProjectName { get; set; }
        public string ClientFullName { get; set; }
        public string IssueTypeName { get; set; }
        public int ParentId { get; set; }
        public string SprintTitle { get; set; }
        public string ReporterName { get; set; }
        public string AssigneeName { get; set; }
        public string Status { get; set; }
        public string Priority { get; set; }
        public string Weblink { get; set; }
        public string WeblinkDescription { get; set; }
        public string StatusName { get; set; }
        public string ReporterUserId { get; set; }
        public int AssigneeId { get; set; }  //Fk   //EmpId
        public int ReporterId { get; set; } //Fk //EmpId
        public int StatusId { get; set; }
        public int ProjectId { get; set; } //Fk
        public int ClientId { get; set; }
        public string AssigneeUserId { get; set; }
        public int SprintId { get; set; }
        public DateTime DueDate { get; set; }
        public int DepartmentId { get; set; }
        public int IssueTypeId { get; set; }
        public int TotalBackLog { get; set; }
        public int TotalToDo { get; set; }
        public int TotalInPro { get; set; }
        public int TotalQARev { get; set; }
        public int TotalDone { get; set; }
        public int IsOverDue { get; set; }
    }

    public class CommentsVM
    {
        public int Id { get; set; }
        public int IssueId { get; set; } 
        public int? ParentId { get; set; }
        public string Type { get; set; } 
        public string Description { get; set; }
        public string AddBy { get; set; }
        public DateTime AddDate { get; set; }
        public string FullName { get; set; }
        public string UserId { get; set; }
        public int EmpId { get; set; }

    }

    public class IssueHistoryVM
    {
        public long HistoryId { get; set; }
        public int IssueId { get; set; } 
        public int? ParentId { get; set; }
        public string UserId { get; set; }
        public string FullName { get; set; }
        public string Type { get; set; }            
        public string Description { get; set; }
        public string SprintTitle { get; set; }
    }
    public class IssueAttachmentVM
    {
        public int AttachmentId { get; set; }
        public int IssueId { get; set; }
        public int? ParentId { get; set; }
        public string FileName { get; set; }
        public string Type { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }

    }

    public class ProjectVM
    {
        public int Id { get; set; }
        public string ProjectName { get; set; }
        public bool IsStart { get; set; }
        public string PersonId { get; set; } // 1,2,3,4,5
        public int Completed { get; set; } // 1 =  Complete Sprint
        public decimal TodoPersent { get; set; }
        public decimal InProPersent { get; set; }
        public decimal QAPersent { get; set; }
        public decimal DonePersent { get; set; }

    }

    public class SprintVM
    {
        public int Id { get; set; }
        public int ProjectId { get; set; }
        public string SprintTitle { get; set; }
        public bool IsStart { get; set; }
        public string PersonId { get; set; } // 1,2,3,4,5
        public int Completed { get; set; } // 1 =  Complete Sprint
        public decimal TodoPersent { get; set; }
        public decimal InProPersent { get; set; }
        public decimal QAPersent { get; set; }
        public decimal DonePersent { get; set; }
        public List<SubIssueDetails> SprintList = new List<SubIssueDetails>();
    }

    public class SprintListVM
    {
        public int Id { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public bool IsStart { get; set; }
        public string PersonId { get; set; } // 1,2,3,4,5
        public int Completed { get; set; } // 1 =  Complete Sprint
         public decimal TodoPersent { get; set; }
        public decimal InProPersent { get; set; }
        public decimal QAPersent { get; set; }
        public decimal DonePersent { get; set; }
        public List<SprintVM> ProjectWiseSprintList { get; set; }
    }

    public class IssueDueDate
    {
        public int IssueId { get; set; }
        public string DueDate { get; set; }
        public string Description { get; set; }
    }

}
