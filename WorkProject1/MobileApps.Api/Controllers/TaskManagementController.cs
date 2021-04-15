using Microsoft.AspNet.Identity;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.TaskManagement;
using OEMS.Models.ViewModel.TaskManagement;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using UI.Admin.Models.Task;

namespace MobileApps.Api.Controllers
{
    [Authorize]
    [RoutePrefix("api/TaskManagement")]
    public class TaskManagementController : ApiController
    {

        #region Issue
        [Route("IssueList")]
        [HttpPost]
        public IHttpActionResult GetIssueList(string Year, string Month, string Day = "TODAY")
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DateTime dateTime = DateTime.Now;
                switch (Day)
                {
                    case "TODAY":
                        dateTime = DateTime.Now;
                        break;
                    case "TOMORROW":
                        dateTime = DateTime.Now.AddDays(1);
                        break;
                    case "YESTERDAY":
                        dateTime = DateTime.Now.AddDays(-1);
                        break;
                    case "LAST7":
                        dateTime = DateTime.Now.AddDays(-7);
                        break;
                    default:
                        dateTime = Convert.ToDateTime(Day);
                        break;
                }
                int empId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                List<IssueVM> list = new List<IssueVM>();
                List<SubIssueDetails> issueList = new List<SubIssueDetails>();
                List<SubIssueDetails> subIssueList = new List<SubIssueDetails>();
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@Priority", DBNull.Value));
                param.Add(new SqlParameter("@IssueTypeId", DBNull.Value));
                param.Add(new SqlParameter("@ProjectId", DBNull.Value));
                param.Add(new SqlParameter("@ClientId", DBNull.Value));
                param.Add(new SqlParameter("@ReporteId", DBNull.Value));
                param.Add(new SqlParameter("@SprintId", DBNull.Value));
                param.Add(new SqlParameter("@StatusId", DBNull.Value));
                param.Add(new SqlParameter("@AssigneeId", empId));
                param.Add(new SqlParameter("@AddBy", DBNull.Value));
                param.Add(new SqlParameter("@UserId", DBNull.Value));
                param.Add(new SqlParameter("@Date", dateTime.ToString()));
                param.Add(new SqlParameter("@PageNo", DBNull.Value));
                param.Add(new SqlParameter("@PageSize", DBNull.Value));

                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("SPM_GetAllIssuesForMobile", param.ToArray());

                issueList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[0]).ToList();
                subIssueList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[1]).ToList();
                var webLinkList = CommonRepository.ConvertDataTable<IssueWebLink>(res.Tables[2]).ToList();
                var historyList = CommonRepository.ConvertDataTable<IssueHistoryVM>(res.Tables[3]).ToList();
                var attachmentList = CommonRepository.ConvertDataTable<IssueAttachmentVM>(res.Tables[4]).ToList();
                var commentList = CommonRepository.ConvertDataTable<CommentsVM>(res.Tables[5]).ToList();

                foreach (var item in issueList)
                {
                    list.Add(new IssueVM()
                    {
                        Id = item.Id,
                        Title = item.Title,
                        Description = item.Description,
                        ParentId = item.ParentId,
                        ProjectName = item.ProjectName,
                        ClientFullName = item.ClientFullName,
                        IssueTypeName = item.IssueTypeName,
                        ReporterUserId = item.ReporterUserId,
                        ReporterName = item.ReporterName,
                        AssigneeName = item.AssigneeName,
                        StatusName = item.StatusName,
                        StatusId = item.StatusId,
                        AssigneeId = item.AssigneeId,
                        ReporterId = item.ReporterId,
                        Priority = item.Priority,
                        ProjectId = item.ProjectId,
                        ClientId = item.ClientId,
                        SprintTitle = item.SprintTitle,
                        SprintId = item.SprintId,
                        AssigneeUserId = item.AssigneeUserId,
                        DepartmentId = item.DepartmentId,
                        DueDate = item.DueDate,
                        SubIssueDetailsList = subIssueList.Where(s => s.ParentId == item.Id).ToList(),
                        HistoryList = historyList.Where(s => s.IssueId == item.Id).ToList(),
                        IssueAttachmentList = attachmentList.Where(s => s.IssueId == item.Id).ToList(),
                        CommentsList = commentList.Where(s => s.IssueId == item.Id).ToList(),
                        WeblinksList = webLinkList.Where(w => w.IssueId == item.Id).ToList()
                    });

                }


                if (list.Count > 0)
                {
                    cr.results = list.OrderByDescending(e => e.Id);
                    cr.message = "Data Found";
                }
                else
                {
                    cr.results = list;
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("UpdateIssueStatus/{issueId}/{statusId}")]
        [HttpGet]
        public IHttpActionResult UpdateIssueStatus(int issueId, int statusId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId > 0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId && e.IsDeleted == false).FirstOrDefault();
                    var newStatus = DataAccess.Instance.TasksStatusService.Filter(e => e.Id == statusId).Select(a => a.StatusName).FirstOrDefault();
                    var oldStatus = DataAccess.Instance.TasksStatusService.Filter(e => e.Id == _issue.StatusId).Select(a => a.StatusName).FirstOrDefault();
                    if (_issue != null)
                    {
                        if ((_issue.StatusId == 2 || _issue.StatusId == 3) && statusId == 6)
                        {
                            return BadRequest("Issue can't be done without in progress or QA review.");
                        }

                        int preSprint = Convert.ToInt32(_issue.StatusId);
                        _issue.StatusId = statusId;
                        if (statusId == 4) // In Progress
                        {
                            _issue.StartDate = DateTime.Now;
                        }
                        else if (statusId == 6) // Done
                        {
                            _issue.EndDate = DateTime.Now;
                        }

                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            CommunicationService.AddIssueHistory(issueId, "Status", $"updated the Status from " + oldStatus + " to " + newStatus, 0, statusId, preSprint, statusId, User.Identity.GetUserId());
                        }
                        //cr.httpStatusCode = HttpStatusCode.OK;
                        cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    }
                    else
                    {
                        return BadRequest("Issue Not Found");
                    }
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {

                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("AddIssue/")]
        [HttpPost]
        public IHttpActionResult AddIssue(IssueVM issueVM)
        {
            Issue issue = new Issue();

            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueVM != null)
                {
                    List<Issue> issuelist = DataAccess.Instance.IssueService.Filter(a => a.Title == issueVM.Title && a.IsDeleted == false).ToList();

                    if (issuelist.Count > 0)
                    {
                        throw new Exception("Title Already Exist.");
                    }
                    if (issueVM.ProjectId < 1 || issueVM.IssueTypeId < 1 || issueVM.Title == "" || issueVM.Description == "")
                    {
                        throw new Exception("Need required field.");
                    }

                    if (issueVM.IssueTypeId == null)
                    {
                        issueVM.IssueTypeId = 2;
                    }

                    if (issueVM.IssueDueDate == null)
                    {
                        issueVM.DueDate = DateTime.Now;
                    }
                    else
                    {
                        issue.DueDate = Convert.ToDateTime(issueVM.IssueDueDate);
                    }
                    //Mandatory field
                    issue.ProjectId = issueVM.ProjectId;
                    issue.IssueTypeId = issueVM.IssueTypeId;
                    issue.Title = issueVM.Title;
                    issue.Description = issueVM.Description;
                    //Optional field
                    if (issueVM.AssigneeId < 1)
                    {
                        issue.AssigneeId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                    }
                    else
                    {
                        issue.AssigneeId = issueVM.AssigneeId;
                    }
                    issue.ClientId = issueVM.ClientId;
                    issue.SprintId = issueVM.SprintId;
                    issue.Priority = issueVM.Priority;

                    issue.IsDeleted = false;
                    issue.AddBy = User.Identity.Name;
                    issue.AddDate = DateTime.Now;
                    issue.ReporterId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                    if (issue.SprintId > 0)
                    {
                        issue.StatusId = 3;
                    }
                    else
                    {
                        issue.StatusId = 2;
                    }
                    issue.SetDate();
                    var res = DataAccess.Instance.IssueService.Add(issue);
                    if (res)
                    {
                        CommunicationService.AddIssueHistory(issue.Id, "CreateIssue", $"created the Issue", 0, 0, 0, 0, User.Identity.GetUserId());

                        if (issueVM.WeblinksList.Count > 0)
                        {
                            foreach (var webLink in issueVM.WeblinksList)
                            {
                                IssueWebLink issueWebLink = new IssueWebLink();
                                issueWebLink.IssueId = issue.Id;
                                issueWebLink.Url = webLink.Url;
                                issueWebLink.Description = webLink.Description;
                                var response = DataAccess.Instance.IssueWebLinkService.Add(issueWebLink);
                            }
                        }

                        int assigneeId = Convert.ToInt32(issue.AssigneeId);
                        CommunicationService.PushNotification(assigneeId, 1, issue.Id + " - " + issue.Title + "- Assigned to you.", "Issue", 0, 0, 0);

                    }
                    cr.results = issue.Id;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("DeleteIssue/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteIssue(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                Issue issue = new Issue();
                issue = DataAccess.Instance.IssueService.Get(id);
                var subissueList = DataAccess.Instance.IssueService.Filter(a => a.ParentId == issue.Id).ToList();
                if (subissueList.Count > 0)
                {
                    throw new Exception("Sub issue Already Exist.Issue cant be deleted");
                }
                issue.UpdateBy = User.Identity.Name;
                issue.IsDeleted = true;
                issue.SetDate();
                var resp = DataAccess.Instance.IssueService.Update(issue);
                if (resp)
                {
                    IssueHistory _issueHistory = new IssueHistory();
                    _issueHistory.IssueId = issue.Id;
                    _issueHistory.Type = "DeleteIssue";
                    _issueHistory.Description = $"deleted the Issue ";
                    _issueHistory.ParentId = issue.ParentId;
                    _issueHistory.SprinttId = issue.SprintId;
                    _issueHistory.PreviousId = 0;
                    _issueHistory.PresentId = 0;
                    _issueHistory.UserId = DataAccess.Instance.Users.GetUserUserId(User.Identity.Name);
                    _issueHistory.ModifyDate = DateTime.Now;
                    var res = DataAccess.Instance.IssueHistoryService.Add(_issueHistory);
                }
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        //Common Field for Task

        [Route("GetCommonItemForTask")]
        [HttpGet]
        public IHttpActionResult GetCommonItemForTask()
        {
            try
            {
                CommonResponse cr = new CommonResponse();
                var empId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("SPM_GetCommonItemForTask", empId);
                res.Tables[0].TableName = "IssueType";
                res.Tables[1].TableName = "Project";
                res.Tables[2].TableName = "Sprint";
                res.Tables[3].TableName = "Status";
                res.Tables[4].TableName = "Client";
                res.Tables[5].TableName = "Employee";
                cr.results = res;
                return Json(cr);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        #endregion


        #region Task_Comments

        [Route("AddComments")]
        [HttpPost]
        public IHttpActionResult AddComments(Comments comments)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (comments != null)
                {
                    int assigneeId = Convert.ToInt32(DataAccess.Instance.IssueService.Filter(e => e.Id == comments.IssueId).FirstOrDefault().AssigneeId);
                    comments.AddBy = User.Identity.Name;
                    comments.AddDate = DateTime.Now;
                    var res = DataAccess.Instance.CommentsService.Add(comments);
                    if (res)
                    {
                        CommunicationService.PushNotification(assigneeId, 1, comments.IssueId + " - " + comments.Description, "Issue Comments", 0, 0, 0);
                    }
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        [Route("UpdateComments")]
        [HttpPut]
        public IHttpActionResult UpdateComments(Comments comments)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (comments != null)
                {
                    Comments data = DataAccess.Instance.CommentsService.Filter(p => p.Id == comments.Id).FirstOrDefault();
                    data.Type = comments.Type;                    
                    data.Description = comments.Description;
                    data.Like = comments.Like;
                    data.Dislike = comments.Dislike;
                    var res = DataAccess.Instance.CommentsService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("DeleteComments/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteComments(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var resp = DataAccess.Instance.CommentsService.Remove(id);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion
    }
}
