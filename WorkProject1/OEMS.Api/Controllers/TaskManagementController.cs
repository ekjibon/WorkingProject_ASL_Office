using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Inventory;
using OEMS.Models.Model.TaskManagement;
using OEMS.Models.ViewModel;
using OEMS.Models.ViewModel.SetUp;
using OEMS.Models.ViewModel.TaskManagement;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using UI.Admin.Models.Task;

namespace OEMS.Api.Controllers
{
    public class TaskManagementController : ApiController
    {
        #region Project
        [Route("TaskManagement/GetAllProject/")]
        [HttpGet]
        public IHttpActionResult GetAllProject()
        {
            CommonResponse cr = new CommonResponse();
            try
            {               
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllProject",1);
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/GetAllActiveProject/")]
        [HttpGet]
        public IHttpActionResult GetAllActiveProject()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllProject", 2);
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddProject")]
        [HttpPost]
        public IHttpActionResult AddProject(Project project)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.ProjectService.Filter(e=>e.IsDeleted==false).ToList();
                if (list.Any(p=>p.ProjectName==project.ProjectName))
                {
                    return BadRequest("Project Name Already Exists");
                }

                if (project.Date == null)
                {
                    project.ExpireDate = DateTime.Now;
                }
                else
                {
                    project.ExpireDate = Convert.ToDateTime(project.Date);
                }
               
                project.AddDate = DateTime.Now;
                project.AddBy = User.Identity.Name;
                project.IsDeleted = false;
                project.Status = "A";
                project.SetDate();
                var response = DataAccess.Instance.ProjectService.Add(project);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.SAVED : Constant.SAVED_ERROR;
                cr.ttype = response ? "success" : "error";
                cr.results = response;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("TaskManagement/UpdateProject")]
        [HttpPut]
        public IHttpActionResult UpdateProject(Project project)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.ProjectService.Filter(e => e.Id != project.Id).ToList();
                if (list.Any(p=>p.ProjectName==project.ProjectName))
                {
                    return BadRequest("Project Already Exists");
                }
                 Project _project = new Project();
                _project = DataAccess.Instance.ProjectService.Filter(e => e.Id == project.Id).FirstOrDefault();
                if (_project != null)
                {
                    _project.ProjectName = project.ProjectName;
                    if (project.Date != null)
                    {
                        _project.ExpireDate = Convert.ToDateTime(project.Date);
                    }
                    _project.CategoryId = project.CategoryId;
                    _project.DepartmentId = project.DepartmentId;             
                    _project.Status = project.Status;
                    _project.IsSupport = project.IsSupport;
                    _project.UpdateBy = User.Identity.Name;
                    _project.UpdateDate = DateTime.Now;
                    _project.SetDate();

                    var response = DataAccess.Instance.ProjectService.Update(_project);

                    cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = response ? "success" : "error";
                    cr.results = response;
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("TaskManagement/DeleteProject/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteProject(int id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (DataAccess.Instance.CommonServices.IsExist("[dbo].[Task_Sprint]", $"ProjectId = {id} AND IsDeleted = 0"))
                {
                    return BadRequest("Sprint Exists for this Project");
                }
                Project project = new Project();
                project = DataAccess.Instance.ProjectService.Get(id);
                project.UpdateBy = User.Identity.Name;
                project.IsDeleted = true;
                project.SetDate();
                var response = DataAccess.Instance.ProjectService.Update(project);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("TaskManagement/GetAllProjectCategory/")]
        [HttpGet]
        public IHttpActionResult GetAllProjectCategory()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.ProjectCategoryService.Filter(c => c.IsDeleted == false).OrderByDescending(o=> o.Id).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("TaskManagement/AddProjectCategory")]
        [HttpPost]
        public IHttpActionResult AddProjectCategory(ProjectCategory projectCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.ProjectCategoryService.Filter(e => e.IsDeleted == false).ToList();
                if (list.Any(p => p.CategoryName == projectCategory.CategoryName))
                {
                    return BadRequest("Category Name Already Exists");
                }

                projectCategory.AddDate = DateTime.Now;
                projectCategory.AddBy = User.Identity.Name;
                projectCategory.IsDeleted = false;
                projectCategory.Status = "A";
                projectCategory.SetDate();
                var response = DataAccess.Instance.ProjectCategoryService.Add(projectCategory);

                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.SAVED : Constant.SAVED_ERROR;
                cr.ttype = response ? "success" : "error";
                cr.results = response;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("TaskManagement/UpdateProjectCategory")]
        [HttpPut]
        public IHttpActionResult UpdateProjectCategory(ProjectCategory projectCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.ProjectCategoryService.Filter(e => e.Id != projectCategory.Id).ToList();
                if (list.Any(p => p.CategoryName == projectCategory.CategoryName))
                {
                    return BadRequest("Project Category Already Exists");
                }
                ProjectCategory _projectCategory = new ProjectCategory();

                _projectCategory = DataAccess.Instance.ProjectCategoryService.Filter(e => e.Id == projectCategory.Id).FirstOrDefault();
                if (_projectCategory != null)
                {
                    _projectCategory.CategoryName = projectCategory.CategoryName;
                    _projectCategory.Description = projectCategory.Description;

                    _projectCategory.UpdateBy = User.Identity.Name;
                    _projectCategory.UpdateDate = DateTime.Now;
                    _projectCategory.SetDate();

                    var response = DataAccess.Instance.ProjectCategoryService.Update(_projectCategory);

                    cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = response ? "success" : "error";
                    cr.results = response;
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("TaskManagement/DeleteProjectCategory/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteProjectCategory(int id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (DataAccess.Instance.CommonServices.IsExist("[dbo].[Task_Project]", $"CategoryId = {id} AND IsDeleted = 0"))
                {
                    return BadRequest("Project Exists for this Category");
                }
                
                ProjectCategory projectCategory = new ProjectCategory();
                projectCategory = DataAccess.Instance.ProjectCategoryService.Get(id);
                projectCategory.UpdateBy = User.Identity.Name;
                projectCategory.IsDeleted = true;
                projectCategory.SetDate();
                var response = DataAccess.Instance.ProjectCategoryService.Update(projectCategory);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        //[HttpGet]
        //public IHttpActionResult LoadUserList(int DeptId)
        //{
        //    if (User.IsInRole("Admin"))
        //    {
        //        var DeveloperList = db.Users.ToList();
        //        var results = Json(DeveloperList, JsonRequestBehavior.AllowGet);
        //        return results;
        //    }
        //    else
        //    {
        //        var DeveloperList = db.Users.Where(u => u.DepartmentId == DeptId).ToList();
        //        var results = Json(DeveloperList, JsonRequestBehavior.AllowGet);
        //        return results;
        //    }

        //}
        //[HttpGet]
        //public IHttpActionResult LoadUserListForTaskAdd()
        //{
        //    ApplicationUser user = db.Users.Where(u => u.UserName == User.Identity.Name).FirstOrDefault();
        //    List<ApplicationUser> UserList = new List<ApplicationUser>();

        //    if (User.IsInRole("Admin"))
        //    {
        //        var UserList2 = db.Users.Select(e => new { e.UserName, e.FullName, e.Id, e.DepartmentId }).ToList();
        //        return Json(UserList2, JsonRequestBehavior.AllowGet);

        //    }
        //    else if (User.IsInRole("Manager"))
        //    {

        //        var DeveloperList = db.Users.Where(u => u.DepartmentId == user.DepartmentId).Select(e => new { e.Id, e.FullName, e.UserName, e.DepartmentId }).ToList();
        //        return Json(DeveloperList, JsonRequestBehavior.AllowGet);
        //    }
        //    else
        //    {
        //        UserList.Add(user);
        //        return Json(UserList, JsonRequestBehavior.AllowGet);

        //    }


        //}
        //[HttpGet]
        //public IHttpActionResult LoadAllUserList()
        //{
        //    var user = db.Users.Where(u => u.UserName == User.Identity.Name).Select(e => new { e.Id, e.FullName, e.UserName, e.DepartmentId }).FirstOrDefault();
        //    var DeveloperList1 = db.Users.Where(e => e.DepartmentId == user.DepartmentId && e.LockoutEnabled == false).Select(e => new { e.Id, e.FullName, e.UserName, e.DepartmentId }).ToList();
        //    //List<ApplicationUser> UserList = new List<ApplicationUser>().Select(e => new { e.Id, e.FullName, e.UserName, e.DepartmentId });

        //    if (User.IsInRole("Admin"))
        //    {
        //        var DeveloperList = db.Users.Select(e => new { e.Id, e.FullName, e.UserName, e.DepartmentId }).ToList();
        //        return Json(DeveloperList, JsonRequestBehavior.AllowGet); ;
        //    }
        //    return Json(DeveloperList1, JsonRequestBehavior.AllowGet);

        #endregion

        #region Sprint
        [Route("TaskManagement/GetAllSprint/")]
        [HttpGet]
        public IHttpActionResult GetAllSprint()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<Sprint> sprintList = DataAccess.Instance.SprintService.Filter(c => c.IsDeleted == false ).ToList();
                List<Project> projectList = DataAccess.Instance.ProjectService.Filter(c => c.IsDeleted == false).ToList();
              var list = (from s in sprintList join p in projectList on s.ProjectId equals p.Id where s.IsDeleted == false && p.IsDeleted == false
                            select new { s.Id ,s.SprintTitle,s.StartDate,s.EndDate,s.IsStart,s.Completed,s.IsDeleted,s.PersonId,s.Status,s.ProjectId,s.Goal,s.AddDate,s.AddBy,p.ProjectName }).OrderByDescending(a => a.Id).ToList();
                cr.results = list;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = list.Count > 0 ? $"{list.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("TaskManagement/GetSprintByProjectId/{projectId}")]
        [HttpGet]
        public IHttpActionResult GetSprintByProjectId(int projectId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.SprintService.Filter(c => c.IsDeleted == false && c.ProjectId == projectId && c.Status == "A").ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddSprint")]
        [HttpPost]
        public IHttpActionResult AddSprint(Sprint sprint)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.SprintService.Filter(e=>e.IsDeleted==false && e.ProjectId==sprint.ProjectId).ToList();
                
                if (list.Any(e=>e.SprintTitle==sprint.SprintTitle))
                {
                    return BadRequest("Sprint Title Already Exists.");
                }

                sprint.StartDate = Convert.ToDateTime(sprint.SprintStartDate);
                sprint.EndDate = Convert.ToDateTime(sprint.SprintEndDate);

                var projectExpDate = DataAccess.Instance.ProjectService.Filter(a => a.Id == sprint.ProjectId).Select(r => r.ExpireDate).FirstOrDefault();
                if (sprint.StartDate > projectExpDate)
                {
                    return BadRequest("Start Date not Valid for Project Expire Date");
                }
                if(sprint.SprintEndDate != null)
                {
                    if (sprint.EndDate > projectExpDate || sprint.EndDate < sprint.StartDate)
                    {
                        return BadRequest("End Date not Valid for Project Expire Date");
                    }
                }
                else
                {
                    sprint.EndDate = sprint.StartDate; ///EndDate not null
                }
               

                sprint.IsStart = false;
                sprint.Status = "A";       
                sprint.AddDate = DateTime.Now;
                sprint.AddBy = User.Identity.Name;
                sprint.IsDeleted = false;
                sprint.SetDate();
                var response = DataAccess.Instance.SprintService.Add(sprint);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.SAVED : Constant.SAVED_ERROR;
                cr.ttype = response ? "success" : "error";
                cr.results = response;

                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("TaskManagement/UpdateSprint")]
        [HttpPut]
        public IHttpActionResult UpdateSprint(Sprint sprint)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.SprintService.Filter(s=>s.Id != sprint.Id && s.ProjectId==sprint.ProjectId).ToList();
                if (list.Any(s=>s.SprintTitle == sprint.SprintTitle && s.Id != sprint.Id))
                {
                    return BadRequest("Sprint Title Already Exists.");
                }
                Sprint _sprint = new Sprint();
                _sprint = DataAccess.Instance.SprintService.Filter(e => e.Id == sprint.Id).FirstOrDefault();
                if (_sprint != null)
                {
                    _sprint.StartDate = Convert.ToDateTime(sprint.SprintStartDate);
                    _sprint.EndDate = Convert.ToDateTime(sprint.SprintEndDate);

                    var projectExpDate = DataAccess.Instance.ProjectService.Filter(a => a.Id == sprint.ProjectId).Select(r => r.ExpireDate).FirstOrDefault();
                    if (sprint.StartDate > projectExpDate)
                    {
                        return BadRequest("Start Date not Valid for Project Expire Date");
                    }
                    if (sprint.SprintEndDate != null)
                    {
                        if (_sprint.EndDate > projectExpDate || _sprint.EndDate < _sprint.StartDate)
                        {
                            return BadRequest("End Date not Valid for Project Expire Date");
                        }
                    }
                    else
                    {
                        sprint.EndDate = sprint.StartDate; ///EndDate not null
                    }

                    _sprint.SprintTitle = sprint.SprintTitle;                    
                    _sprint.Goal = sprint.Goal;
                    _sprint.Completed = sprint.Completed;
                    _sprint.UpdateBy = User.Identity.Name;
                    _sprint.UpdateDate = DateTime.Now;
                    _sprint.SetDate();

                    var response = DataAccess.Instance.SprintService.Update(_sprint);

                    cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = response ? "success" : "error";
                    cr.results = response;
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("TaskManagement/DeleteSprint/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteSprint(int id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (DataAccess.Instance.CommonServices.IsExist("dbo.Task_Issue", $"SprintId = {id} AND IsDeleted = 0"))
                {
                    return BadRequest("Issue Exists this Sprint");
                }
                Sprint sprint = new Sprint();
                sprint = DataAccess.Instance.SprintService.Get(id);
                sprint.UpdateBy = User.Identity.Name;
                sprint.IsDeleted = true;
                sprint.SetDate();
                var response = DataAccess.Instance.SprintService.Update(sprint);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("TaskManagement/StartSprint/{id}")]
        [HttpDelete]
        public IHttpActionResult StartSprint(int id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {               
                Sprint sprint = new Sprint();
                sprint = DataAccess.Instance.SprintService.Filter(e=>e.IsDeleted== false && e.Id == id).FirstOrDefault();
                sprint.UpdateBy = User.Identity.Name;
                sprint.IsStart = true;
                sprint.SetDate();
                var response = DataAccess.Instance.SprintService.Update(sprint);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [Route("TaskManagement/CompleteSprint/{id}")]
        [HttpDelete]
        public IHttpActionResult CompleteSprint(int id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var issueList = DataAccess.Instance.IssueService.Filter(e => e.IsDeleted == false && e.SprintId == id && e.StatusId != 6).Count();
                if(issueList > 0)
                {
                    return BadRequest(issueList + " Issue are not Complete");
                }
                Sprint sprint = new Sprint();
                sprint = DataAccess.Instance.SprintService.Filter(e => e.IsDeleted == false && e.Id == id).FirstOrDefault();
                sprint.UpdateBy = User.Identity.Name;
                sprint.Completed =1;
                sprint.SetDate();
                var response = DataAccess.Instance.SprintService.Update(sprint);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        #endregion

        #region MyTask
        [Route("TaskManagement/GetAllMyTask/")]
        [HttpGet]
        public IHttpActionResult GetAllMyTask()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.ProjectService.Filter(c => c.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddMyTask")]
        [HttpPost]
        public IHttpActionResult AddMyTask(TaskInfo myTask)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                myTask.DueDate = Convert.ToDateTime(myTask.TaskDueDate);
                myTask.AddDate = DateTime.Now;
                myTask.AddBy = User.Identity.Name;
                myTask.IsDeleted = false;
                myTask.StartDate = DateTime.Now;
                myTask.SetDate();

                var response = DataAccess.Instance.TaskInfoService.Add(myTask);

                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.SAVED : Constant.SAVED_ERROR;
                cr.ttype = response ? "success" : "error";
                cr.results = response;

                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        #endregion

        #region TasksStatus

        [Route("TaskManagement/GetAllTasksStatus/")]
        [HttpGet]
        public IHttpActionResult GetAllTasksStatus()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.TasksStatusService.Filter(c => c.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddTasksStatus")]
        [HttpPost]
        public IHttpActionResult AddTasksStatus(TasksStatus tasksStatus)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (tasksStatus != null)
                {
                    List<TasksStatus> tasksStatuslist = DataAccess.Instance.TasksStatusService.Filter(a => a.StatusName == tasksStatus.StatusName && a.IsDeleted == false && a.ColorCode == tasksStatus.ColorCode).ToList();

                    if (tasksStatuslist.Count > 0)
                    {
                        throw new Exception("Tasks Status Already Exist.");
                    }


                    tasksStatus.IsDeleted = false;
                    tasksStatus.AddBy = User.Identity.Name;
                    tasksStatus.AddDate = DateTime.Now;
                    tasksStatus.UpdateBy = User.Identity.Name;
                    tasksStatus.UpdateDate = DateTime.Now;
                    tasksStatus.SetDate();
                    var res = DataAccess.Instance.TasksStatusService.Add(tasksStatus);
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
        [Route("TaskManagement/UpdateTasksStatus")]
        [HttpPut]
        public IHttpActionResult UpdateInvoiceService(TasksStatus tasksStatus)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (tasksStatus != null)
                {
                    List<TasksStatus> tasksStatuslist = DataAccess.Instance.TasksStatusService.Filter(a => a.StatusName == tasksStatus.StatusName && a.IsDeleted == false && a.ColorCode == tasksStatus.ColorCode).ToList();

                    if (tasksStatuslist.Count > 0)
                    {
                        throw new Exception("Tasks Status Already Exist.");
                    }
                    TasksStatus data = DataAccess.Instance.TasksStatusService.Filter(p => p.Id == tasksStatus.Id).FirstOrDefault();
                    data.StatusName = tasksStatus.StatusName;
                    data.ColorCode = tasksStatus.ColorCode;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.TasksStatusService.Update(data);
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
        [Route("TaskManagement/DeleteTasksStatus/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteTasksStatus(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                TasksStatus tasksStatus = new TasksStatus();
                tasksStatus = DataAccess.Instance.TasksStatusService.Get(id);
                tasksStatus.UpdateBy = User.Identity.Name;
                tasksStatus.IsDeleted = true;
                tasksStatus.SetDate();

                var resp = DataAccess.Instance.TasksStatusService.Update(tasksStatus);
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

        #region IssueType

        [Route("TaskManagement/GetAllIssueType/")]
        [HttpGet]
        public IHttpActionResult GetAllIssueType()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.IssueTypeService.Filter(c => c.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddIssueType")]
        [HttpPost]
        public IHttpActionResult AddIssueType(IssueType issueType)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueType != null)
                {
                    List<IssueType> issueTypelist = DataAccess.Instance.IssueTypeService.Filter(a => a.IssueTypeName == issueType.IssueTypeName && a.IsDeleted == false).ToList();

                    if (issueTypelist.Count > 0)
                    {
                        throw new Exception("Tasks Status Already Exist.");
                    }


                    issueType.IsDeleted = false;
                    issueType.AddBy = User.Identity.Name;
                    issueType.AddDate = DateTime.Now;
                    issueType.UpdateBy = User.Identity.Name;
                    issueType.UpdateDate = DateTime.Now;
                    issueType.SetDate();
                    var res = DataAccess.Instance.IssueTypeService.Add(issueType);
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
        [Route("TaskManagement/UpdateIssueType")]
        [HttpPut]
        public IHttpActionResult UpdateIssueType(IssueType issueType)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueType != null)
                {
                    List<IssueType> issueTypelist = DataAccess.Instance.IssueTypeService.Filter(a => a.IssueTypeName == issueType.IssueTypeName && a.IsDeleted == false).ToList();

                    if (issueTypelist.Count > 0)
                    {
                        throw new Exception("Issue Type Already Exist.");
                    }
                    IssueType data = DataAccess.Instance.IssueTypeService.Filter(p => p.Id == issueType.Id).FirstOrDefault();
                    data.IssueTypeName = issueType.IssueTypeName;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.IssueTypeService.Update(data);
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
        [Route("TaskManagement/DeleteIssueType/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteIssueType(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                IssueType issueType = new IssueType();
                issueType = DataAccess.Instance.IssueTypeService.Get(id);
                issueType.UpdateBy = User.Identity.Name;
                issueType.IsDeleted = true;
                issueType.SetDate();

                var resp = DataAccess.Instance.IssueTypeService.Update(issueType);
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

        #region Issue

        [Route("TaskManagement/GetIssueListByFilter/")]
        [HttpPost]
        public IHttpActionResult GetIssueListByFilter(IssueFilterVM issue)   
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<IssueVM> list = new List<IssueVM>();
                List<SubIssueDetails> issueList = new List<SubIssueDetails>();
                List<SubIssueDetails> subIssueList = new List<SubIssueDetails>();
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@Priority", issue.Priority));
                param.Add(new SqlParameter("@IssueTypeId", issue.IssueTypeId));
                param.Add(new SqlParameter("@ProjectId", issue.ProjectId));
                param.Add(new SqlParameter("@ClientId", issue.ClientId));
                param.Add(new SqlParameter("@ReporteId", issue.ReporteId));
                param.Add(new SqlParameter("@SprintId", issue.SprintId));
                param.Add(new SqlParameter("@StatusId", issue.StatusId));
                param.Add(new SqlParameter("@AssigneeId", issue.AssigneeId));
                param.Add(new SqlParameter("@AddBy", issue.AddBy));
                param.Add(new SqlParameter("@UserId", DBNull.Value));
                if (issue.DueDate == null || issue.DueDate == "undefined")
                {
                    param.Add(new SqlParameter("@Date", DBNull.Value));
                }
                else
                {
                    param.Add(new SqlParameter("@Date", Convert.ToDateTime(issue.DueDate)));
                }
                param.Add(new SqlParameter("@PageNo", issue.pageno));
                param.Add(new SqlParameter("@PageSize", issue.pageSize));

                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllIssuesFilter", param.ToArray());

                issueList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[0]).ToList();
                subIssueList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[1]).ToList();
                var webLinkList = CommonRepository.ConvertDataTable<IssueWebLink>(res.Tables[2]).ToList();
                var historyList = CommonRepository.ConvertDataTable<IssueHistoryVM>(res.Tables[3]).ToList();
                var attachmentList = CommonRepository.ConvertDataTable<IssueAttachmentVM>(res.Tables[4]).ToList();
                var commentList = CommonRepository.ConvertDataTable<CommentsVM>(res.Tables[5]).ToList();

                foreach (var item in issueList)
                {
                    list.Add(new IssueVM() {
                        Id = item.Id,
                        Title = item.Title,
                        Description = item.Description,
                        ParentId = item.ParentId,
                        ProjectName = item.ProjectName,
                        ClientFullName = item.ClientFullName,
                        IssueTypeName = item.IssueTypeName,
                        ReporterUserId =  item.ReporterUserId,
                        ReporterName = item.ReporterName,
                        AssigneeName = item.AssigneeName,
                        StatusName = item.StatusName,
                        StatusId = item.StatusId,
                        AssigneeId = item.AssigneeId,
                        AssigneeUserId = item.AssigneeUserId,
                        ReporterId = item.ReporterId,
                        Priority = item.Priority,
                        ProjectId = item.ProjectId,
                        ClientId = item.ClientId,
                        SprintTitle = item.SprintTitle,
                        SprintId = item.SprintId,
                        DueDate = item.DueDate,
                        DepartmentId = item.DepartmentId,
                        SubIssueDetailsList = subIssueList.Where(s => s.ParentId == item.Id).ToList(),
                        HistoryList = historyList.Where(s => s.IssueId == item.Id).ToList(),
                        IssueAttachmentList = attachmentList.Where(s => s.IssueId == item.Id).ToList(),
                        CommentsList = commentList.Where(s => s.IssueId == item.Id).ToList(),
                        WeblinksList = webLinkList.Where(w=>w.IssueId== item.Id).ToList()
                    });
                   
                }


                if (list.Count >0)
                {
                    cr.results = list ;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("TaskManagement/GetIssueListByEmpIdWithFilter/")]
        [HttpPost]
        public IHttpActionResult GetIssueListByEmpIdWithFilter(IssueFilterVM issue)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                int empId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                List<IssueVM> list = new List<IssueVM>();
                List<SubIssueDetails> issueList = new List<SubIssueDetails>();
                List<SubIssueDetails> subIssueList = new List<SubIssueDetails>();
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 7));
                param.Add(new SqlParameter("@Priority", issue.Priority));
                param.Add(new SqlParameter("@IssueTypeId", issue.IssueTypeId));
                param.Add(new SqlParameter("@ProjectId", issue.ProjectId));
                param.Add(new SqlParameter("@ClientId", issue.ClientId));
                param.Add(new SqlParameter("@ReporteId", DBNull.Value));
                param.Add(new SqlParameter("@SprintId", issue.SprintId));
                param.Add(new SqlParameter("@StatusId", issue.StatusId));
                param.Add(new SqlParameter("@AssigneeId", empId));
                param.Add(new SqlParameter("@AddBy", issue.AddBy));
                param.Add(new SqlParameter("@UserId", DBNull.Value));
                if (issue.DueDate == null || issue.DueDate == "undefined")
                {
                    param.Add(new SqlParameter("@Date", DBNull.Value));
                }
                else
                {
                    param.Add(new SqlParameter("@Date", Convert.ToDateTime(issue.DueDate)));
                }
                param.Add(new SqlParameter("@PageNo", issue.pageno));
                param.Add(new SqlParameter("@PageSize", issue.pageSize));

                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllIssuesFilter", param.ToArray());

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
                    cr.results = list;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("TaskManagement/GetIssueListForBoardWithFilter/")]
        [HttpPost]
        public IHttpActionResult GetIssueListForBoardWithFilter(IssueFilterVM issue)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<IssueVM> list = new List<IssueVM>();
                List<SubIssueDetails> issueList = new List<SubIssueDetails>();
                List<SubIssueDetails> subIssueList = new List<SubIssueDetails>();
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 6));
                param.Add(new SqlParameter("@Priority", issue.Priority));
                param.Add(new SqlParameter("@IssueTypeId", issue.IssueTypeId));
                param.Add(new SqlParameter("@ProjectId", issue.ProjectId));
                param.Add(new SqlParameter("@ClientId", issue.ClientId));
                param.Add(new SqlParameter("@ReporteId", issue.ReporteId));
                param.Add(new SqlParameter("@SprintId", issue.SprintId));
                param.Add(new SqlParameter("@StatusId", issue.StatusId));
                param.Add(new SqlParameter("@AssigneeId", issue.AssigneeId));
                param.Add(new SqlParameter("@AddBy", issue.AddBy));
                param.Add(new SqlParameter("@UserId", DBNull.Value));
                if(issue.DueDate == null || issue.DueDate == "undefined")
                {
                    param.Add(new SqlParameter("@Date", DBNull.Value ));
                }
                else
                {
                    param.Add(new SqlParameter("@Date", Convert.ToDateTime(issue.DueDate) ));
                }
                param.Add(new SqlParameter("@PageNo", DBNull.Value));
                param.Add(new SqlParameter("@PageSize", DBNull.Value));

                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllIssuesFilter", param.ToArray());

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
                        AssigneeUserId = item.AssigneeUserId,
                        ReporterId = item.ReporterId,
                        Priority = item.Priority,
                        ProjectId = item.ProjectId,
                        ClientId = item.ClientId,
                        SprintTitle = item.SprintTitle,
                        SprintId = item.SprintId,
                        IssueTypeId = item.IssueTypeId,
                        DueDate = item.DueDate,
                        DepartmentId = item.DepartmentId,
                        SubIssueDetailsList = subIssueList.Where(s => s.ParentId == item.Id).ToList(),
                        HistoryList = historyList.Where(s => s.IssueId == item.Id).ToList(),
                        IssueAttachmentList = attachmentList.Where(s => s.IssueId == item.Id).ToList(),
                        CommentsList = commentList.Where(s => s.IssueId == item.Id).ToList(),
                        WeblinksList = webLinkList.Where(w => w.IssueId == item.Id).ToList()
                    });

                }


                if (list.Count > 0)
                {
                    cr.results = list;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("TaskManagement/GetIssueList/")]
        [HttpGet]
        public IHttpActionResult GetIssueList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dt = new DataTable();
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 3));
                param.Add(new SqlParameter("@Priority", DBNull.Value));
                param.Add(new SqlParameter("@IssueTypeId", DBNull.Value));
                param.Add(new SqlParameter("@ProjectId", DBNull.Value));
                param.Add(new SqlParameter("@ClientId", DBNull.Value));
                param.Add(new SqlParameter("@ReporteId", DBNull.Value));
                param.Add(new SqlParameter("@SprintId", DBNull.Value));
                param.Add(new SqlParameter("@StatusId", DBNull.Value));
                param.Add(new SqlParameter("@AssigneeId", DBNull.Value));
                param.Add(new SqlParameter("@AddBy", DBNull.Value));
                param.Add(new SqlParameter("@UserId", DBNull.Value));
                param.Add(new SqlParameter("@Date", DBNull.Value));
                param.Add(new SqlParameter("@PageNo", DBNull.Value));
                param.Add(new SqlParameter("@PageSize", DBNull.Value));

                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllIssuesFilter", param.ToArray());

                var projectList = CommonRepository.ConvertDataTable<ProjectVM>(res.Tables[0]).ToList();
                var SprintList = CommonRepository.ConvertDataTable<SprintVM>(res.Tables[1]).ToList();
                var sprintList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[2]).ToList();
                var backlogList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[3]).ToList();
                List<SprintListVM> list = new List<SprintListVM>();
                foreach (var item in projectList)
                {
                    SprintListVM _obj = new SprintListVM();
                    _obj.ProjectId = item.Id;
                    _obj.ProjectName = item.ProjectName;
                    _obj.ProjectWiseSprintList = SprintList.Where(e => e.ProjectId == item.Id).ToList();
                    list.Add(_obj);
                }

                foreach (var item in list)
                {
                    foreach (var sprint in item.ProjectWiseSprintList)
                    {
                        sprint.SprintList = sprintList.Where(e => e.SprintId == sprint.Id).ToList();

                    }
                }

                //foreach (var item in projectSprintList)
                //{
                //    list.Add(new SprintListVM() {
                //        Id = item.Id,
                //        ProjectSprint = item.ProjectSprint,
                //        IsStart =  item.IsStart,
                //        Completed = item.Completed,
                //        TodoPersent = item.TodoPersent,
                //        InProPersent = item.InProPersent,
                //        QAPersent = item.QAPersent,
                //        DonePersent = item.DonePersent,
                //        SprintList = sprintList.Where(e => e.SprintId == item.Id).ToList()
                //    });
                //}

                cr.results = new { ProjectWiseList = list, BacklogList = backlogList };
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddIssue/")]
        [HttpPost]
        public IHttpActionResult AddIssue(Issue issue)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issue != null)
                {
                    List<Issue> issuelist = DataAccess.Instance.IssueService.Filter(a => a.Title == issue.Title && a.IsDeleted == false).ToList();

                    if (issuelist.Count > 0)
                    {
                        throw new Exception("Title Already Exist.");
                    }

                    if(issue.IssueTypeId == null)
                    {
                        issue.IssueTypeId = 2;
                    }

                    if (issue.IssueDueDate == null)
                    {
                        issue.DueDate = DateTime.Now;
                    }
                    else
                    {
                        issue.DueDate = Convert.ToDateTime(issue.IssueDueDate);
                    }

                    issue.IsDeleted = false;
                    issue.AddBy = User.Identity.Name;
                    issue.AddDate = DateTime.Now;
                    issue.ReporterId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                    if(issue.SprintId > 0)
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
                        AddIssueHistory(issue.Id, "CreateIssue", $"created the Issue", 0, 0,0,0);
                        int assigneeId = Convert.ToInt32(issue.AssigneeId);
                        CommunicationService.PushNotification(assigneeId, 1, issue.Id + " - " + issue.Title + "- Assigned to you.", "Issue", 0, 0, 0);
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
        

        [Route("TaskManagement/UpdateIssue/")]
        [HttpPut]
        public IHttpActionResult UpdateIssue(Issue issue)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (issue != null)
                {
                    List<Issue> issuelist = DataAccess.Instance.IssueService.Filter(a => a.Id != issue.Id && a.Title == issue.Title && a.IsDeleted == false).ToList();

                    if (issuelist.Count > 0)
                    {
                        throw new Exception("Title Already Exist.");
                    }

                    Issue data = DataAccess.Instance.IssueService.Filter(p => p.Id == issue.Id).FirstOrDefault();
                    data.Title = issue.Title;
                    data.Description = issue.Description;
                    data.ProjectId = issue.ProjectId;
                    data.ReporterId = issue.ReporterId;
                    data.AssigneeId = issue.AssigneeId;
                    data.ClientId = issue.ClientId;
                    data.IssueTypeId = issue.IssueTypeId;
                    data.SprintId = issue.SprintId;
                    data.Priority = issue.Priority;
                    data.StatusId = issue.StatusId;
                    //data.DueDate = Convert.ToDateTime(issue.IssueDueDate);
                    //data.EndDate = Convert.ToDateTime(issue.IssueDueDate);
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.IssueService.Update(data);
                    if (res)
                    {
                        AddIssueHistory(data.Id, "UpdateIssue", $"updated the Issue ", 0,0,0,0);
                    }
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
                else
                {
                    return BadRequest();
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }    
        [Route("TaskManagement/DeleteIssue/{id}")]
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
                    AddIssueHistory(id, "DeleteIssue", $"deleted the Issue ", 0, 0,0,0);
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

        [Route("TaskManagement/UpdateIssueSprint/{issueId}/{sprintId}")]
        [HttpGet]
        public IHttpActionResult UpdateIssueSprint(int issueId,int sprintId )
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId>0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId && e.IsDeleted == false).FirstOrDefault();
                    
                    if (_issue!=null)
                    {
                        int preSprint = Convert.ToInt32(_issue.SprintId);

                        var oldSprint = DataAccess.Instance.SprintService.Filter(e => e.Id == preSprint).Select( a => a.SprintTitle).FirstOrDefault();
                        var newSprint = DataAccess.Instance.SprintService.Filter(e => e.Id == sprintId).Select(a => a.SprintTitle).FirstOrDefault();

                        if (_issue.SprintId == 0 || _issue.SprintId == null)
                        {
                            _issue.StatusId = 3; // TO DO
                        }
                        if (_issue.ProjectId == 0 || _issue.ProjectId==null)
                        {
                            _issue.ProjectId = DataAccess.Instance.SprintService.Filter(e => e.Id == sprintId).FirstOrDefault().ProjectId;
                        }
                        _issue.SprintId = sprintId;                     
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            AddIssueHistory(issueId,"Sprint",$"updated the Sprint from "+ oldSprint + " to "+ newSprint, 0, sprintId, preSprint, sprintId);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("TaskManagement/UpdateIssueDescription/")]
        [HttpPut]
        public IHttpActionResult UpdateIssueDescription(IssueDueDate issueDueDate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueDueDate.IssueId > 0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueDueDate.IssueId && e.IsDeleted == false).FirstOrDefault();
                    if (_issue != null)
                    {
                        string descrip = _issue.Description;
                        _issue.Description = issueDueDate.Description;                        
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            AddIssueHistory(issueDueDate.IssueId, "Description", $"updated the Description", 0,0,0,0);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                return BadRequest(cr.message);
            }
            return Json(cr);
        }
        [Route("TaskManagement/CreateSubIssue/{issueId}/{title}")]
        [HttpGet]
        public IHttpActionResult CreateSubIssue(int issueId, string title)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId > 0 )
                {
                    Issue issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId).FirstOrDefault();
                    Issue _issue = new Issue();
                    
                    _issue.ProjectId = issue.ProjectId;
                    _issue.ClientId = issue.ClientId;
                    _issue.SprintId = issue.SprintId;
                    _issue.AssigneeId = issue.AssigneeId;
                    _issue.IssueTypeId = issue.IssueTypeId;
                    _issue.StatusId = 3;
                    _issue.ReporterId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);                    
                    _issue.Priority = "Medium";
                    _issue.ParentId = issueId;
                    _issue.Title = title;                
                    _issue.AddBy = User.Identity.Name;
                    _issue.AddDate = DateTime.Now;
                    _issue.SetDate();
                    var res = DataAccess.Instance.IssueService.Add(_issue);
                    if (res)
                    {
                        AddIssueHistory(issueId, "SubIssue",$"created the Sub Issue", issueId, 0 ,0, issueId);
                    }
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }
                else
                {
                    return NotFound();
                }


            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/UpdateIssuePriority/{issueId}/{priority}")]
        [HttpGet]
        public IHttpActionResult UpdateIssuePriority(int issueId, string priority)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId > 0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId && e.IsDeleted == false).FirstOrDefault();
                    if (_issue != null)
                    {
                        string prio = _issue.Priority;
                       _issue.Priority = priority;
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            AddIssueHistory(issueId, "UpdatePriority",$"update the Priority from "+ prio+" to "+ priority, 0, 0,0,0);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("TaskManagement/UpdateIssueStatus/{issueId}/{statusId}")]
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
                        if (statusId==4) // In Progress
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
                            AddIssueHistory(issueId, "Status", $"updated the Status from "+ oldStatus + " to " + newStatus, 0, statusId, preSprint, statusId);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/UpdateIssueDueDate/")]
        [HttpPut]
        public IHttpActionResult UpdateIssueDueDate(IssueDueDate issueDueDate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueDueDate.IssueId > 0)
                {
                                
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueDueDate.IssueId && e.IsDeleted == false).FirstOrDefault();

                    var sprintEndDate = DataAccess.Instance.SprintService.Filter(a => a.Id == _issue.SprintId).Select(e => e.EndDate).FirstOrDefault();
                    var dueDate = Convert.ToDateTime(issueDueDate.DueDate);
                    if(dueDate > sprintEndDate)
                    {
                        return BadRequest("Due Date not Valid for Sprint End Date");
                    }

                    if (_issue != null)
                    {
                        var prio = _issue.DueDate;
                        _issue.DueDate = dueDate;
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            AddIssueHistory(issueDueDate.IssueId, "Update DueDate", $"update the Issue DueDate from " + prio + " to " + issueDueDate.DueDate, 0, 0, 0, 0);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                return BadRequest(cr.message);
            }
            return Json(cr);
        }

        [Route("TaskManagement/IssueAssign/{issueId}/{empId}")]
        [HttpGet]
        public IHttpActionResult IssueAssign(int issueId, int empId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId > 0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId && e.IsDeleted == false).FirstOrDefault();
                    if (_issue != null)
                    {
                        int assignId = Convert.ToInt32(_issue.AssigneeId);
                        _issue.AssigneeId = empId;
              
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {                            
                            AddIssueHistory(issueId, "Assign", $"changed the Assignee ", 0, empId, assignId, empId);
                            CommunicationService.PushNotification(empId, 1, _issue.Id + " - " + _issue.Title + "- Assigned to you." + " Assigned to you.", "Issue", 0, 0, 0);                            
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [AllowAnonymous]
        [Route("TaskManagement/AddIssueAttachment")]
        [HttpPost]
        public IHttpActionResult AddIssueAttachment()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                string value = HttpContext.Current.Request.Form["issueAttachment"] ?? "";
                int issueID = JsonConvert.DeserializeObject<int>(value);
                var file = HttpContext.Current.Request.Files["attachment"] != null ? new HttpPostedFileWrapper(HttpContext.Current.Request.Files["attachment"]) : null;
                IssueAttachment attach = new IssueAttachment();
                attach.IssueId = issueID;
                if (file!=null)
                {
                    var filePath = $"~/content/issue/{issueID}_IssueAtt_{file.FileName}";
                    attach.ImageUrl = filePath.Trim('~'); ;
                    attach.FileType = Path.GetExtension(file.FileName);
                    attach.FileName = file.FileName;
                    APIUitility.ToPath(file, System.Web.Hosting.HostingEnvironment.MapPath(filePath));
                }
                var res = DataAccess.Instance.IssueAttachmentService.Add(attach);
                if (res)
                {
                   
                    AddIssueHistory(issueID, "Attachment", $"Added an Attachment ", 0, 0, 0, 0);
                }
                return Json(cr);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
        }
        [AllowAnonymous]
        [Route("TaskManagement/AddMultipleAttachment/{issueId}/{empId}")]
        [HttpPost]
        public IHttpActionResult AddMultipleAttachment(int issueId, int empId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                bool res = false;
                int numberOfData = 0;
                var imgs = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files : null;
                if (imgs.Count > 0 && issueId > 0)
                {
                    //int a = imgs.Count;
                    for (int i = 0; i < imgs.Count; i++)
                    {
                        var file = HttpContext.Current.Request.Files.Count > 0 ? new HttpPostedFileWrapper(HttpContext.Current.Request.Files[i]) : null;
                        IssueAttachment attach = new IssueAttachment();
                        attach.IssueId = issueId;
                        var filePath = $"~/content/issue/{issueId}_IssueAtt_{file.FileName}";
                        attach.ImageUrl = filePath.Trim('~'); ;
                        attach.FileType = Path.GetExtension(file.FileName);
                        attach.FileName = file.FileName;
                        APIUitility.ToPath(file, System.Web.Hosting.HostingEnvironment.MapPath(filePath));
                        res = DataAccess.Instance.IssueAttachmentService.Add(attach);
                        numberOfData += 1;
                    }
                }                
                cr.message = "Total  " + numberOfData + "  Row Inserted Successfully.";
                if (res)
                {                    
                    IssueHistory _issueHistory = new IssueHistory();
                    _issueHistory.IssueId = issueId;
                    _issueHistory.Type = "Attachment";
                    _issueHistory.Description = $"Added an Attachment ";
                    _issueHistory.ParentId = 0;
                    _issueHistory.SprinttId = 0;
                    _issueHistory.PreviousId = 0;
                    _issueHistory.PresentId = 0;
                    _issueHistory.UserId = DataAccess.Instance.Users.Filter(e => e.EmpId == empId).FirstOrDefault().Id;
                    _issueHistory.ModifyDate = DateTime.Now;
                    var History_res = DataAccess.Instance.IssueHistoryService.Add(_issueHistory);
                }
                return Json(cr);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("TaskManagement/DeleteIssueAttachment/{issueId}/{attachId}")]
        [HttpDelete]
        public IHttpActionResult DeleteIssueAttachment(int issueId,int attachId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {    
                var res = DataAccess.Instance.IssueAttachmentService.Remove(attachId);
                if (res)
                {
                    AddIssueHistory(issueId, "Attachment", $"removed the Attachment ", 0, 0, 0, 0);
                }
                return Json(cr);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("TaskManagement/UpdateIssueTitle/{issueId}/{title}")]
        [HttpGet]
        public IHttpActionResult UpdateIssueTitle(int issueId, string title)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId > 0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId && e.IsDeleted == false).FirstOrDefault();
                    if (_issue != null)
                    {                      
                        _issue.Title = title;
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            AddIssueHistory(issueId, "Status", $"updated the Title", 0,0, _issue.Id, issueId);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
                        cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    }
                    else
                    {
                        return BadRequest("Issue Not Found");
                    }
                }
                else
                {
                    Issue _issue = new Issue();
                    _issue.Title = title;
                    _issue.StatusId = 2;
                    _issue.ReporterId = DataAccess.Instance.Users.GetUserEmpId(User.Identity.Name);
                    _issue.Priority = "Medium";
                    _issue.AddBy = User.Identity.Name;
                    _issue.AddDate = DateTime.Now;
                    _issue.SetDate();
                    _issue.IsDeleted = false;
                    _issue.IssueTypeId = 2;
                    _issue.ClientId = 0;
                    var res = DataAccess.Instance.IssueService.Add(_issue);
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("TaskManagement/UpdateIssueReporter/{issueId}/{reporterId}")]
        [HttpGet]
        public IHttpActionResult UpdateIssueReporter(int issueId, int reporterId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issueId > 0)
                {
                    Issue _issue = DataAccess.Instance.IssueService.Filter(e => e.Id == issueId && e.IsDeleted == false).FirstOrDefault();
                    if (_issue != null)
                    {
                        int preReporter = Convert.ToInt32(_issue.ReporterId);
                        _issue.ReporterId = reporterId;
                        _issue.UpdateBy = User.Identity.Name;
                        _issue.UpdateDate = DateTime.Now;
                        var res = DataAccess.Instance.IssueService.Update(_issue);
                        if (res)
                        {
                            AddIssueHistory(issueId, "Reporter", $"updated the Reporter", 0, 0, preReporter, reporterId);
                        }
                        cr.httpStatusCode = HttpStatusCode.OK;
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
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        #endregion

        #region Sub-Issue

        [Route("TaskManagement/AddSubIssue/{issueId}")]
        [HttpPost]
        public IHttpActionResult AddSubIssue(Issue issue , int issueId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (issue != null)
                {
                    List<Issue> issuelist = DataAccess.Instance.IssueService.Filter(a => a.Id != issue.Id && a.Title == issue.Title && a.IsDeleted == false).ToList();

                    if (issuelist.Count > 0)
                    {
                        throw new Exception("Title Already Exist.");
                    }

                    Issue data = new Issue();
                    data.Title = issue.Title;
                    data.Description = issue.Description;
                    data.ProjectId = issue.ProjectId;
                    data.ClientId = issue.ClientId;
                    data.IssueTypeId = issue.IssueTypeId;
                    data.AssigneeId = issue.AssigneeId;
                    data.SprintId = issue.SprintId;
                    data.Priority = issue.Priority;
                    data.ParentId = issue.ParentId;

                    data.IsDeleted = false;
                    data.AddBy = User.Identity.Name;
                    data.AddDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.IssueService.Add(data);
                    if (res)
                    {
                        AddIssueHistory(issueId, "AddSubIssue", $"Added By Sub Issue {User.Identity.Name}", 0, 0,0,0);
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


        [Route("TaskManagement/GetIssueDetails/{Id}")]
        [HttpGet]
        public IHttpActionResult GetIssueDetails(int Id)   //Flowing --[Route("Inventory/GetQuotationList/")]
        {
            CommonResponse cr = new CommonResponse();

            try
            {

                IssueDetailsVM issueDetailsVMList = new IssueDetailsVM();
                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("GetIssueList", new object[] { 2, Id });
                issueDetailsVMList = CommonRepository.ConvertDataTable<IssueDetailsVM>(res.Tables[0]).FirstOrDefault();
                issueDetailsVMList.SubIssueList = CommonRepository.ConvertDataTable<Issue>(res.Tables[1]);
                issueDetailsVMList.CommentsList = CommonRepository.ConvertDataTable<CommentsVM>(res.Tables[2]);
                issueDetailsVMList.IssueAttachmentList = CommonRepository.ConvertDataTable<IssueAttachment>(res.Tables[3]);
                issueDetailsVMList.IssueWebLinksList = CommonRepository.ConvertDataTable<IssueWebLink>(res.Tables[4]);
                issueDetailsVMList.IssueHistoryList = CommonRepository.ConvertDataTable<IssueHistory>(res.Tables[5]);

                if (issueDetailsVMList != null)
                {
                    cr.results = issueDetailsVMList;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        #endregion

        #region Comments

        [Route("TaskManagement/GetAllComments/")]
        [HttpGet]
        public IHttpActionResult GetAllComments()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommentsService.GetAll().ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddComments")]
        [HttpPost]
        public IHttpActionResult AddComments(Comments comments)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (comments != null)
                {
                    int assigneeId = Convert.ToInt32( DataAccess.Instance.IssueService.Filter(e => e.Id == comments.IssueId).FirstOrDefault().AssigneeId);
                  
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
        [Route("TaskManagement/UpdateComments")]
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
                    data.IssueId = comments.IssueId;
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



        [Route("TaskManagement/DeleteComments/{id}")]
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

        #region  IssueHistory  

        //[Route("TaskManagement/GetAllIssueHistory/{issueId}")]
        //[HttpGet]
        //public IHttpActionResult GetAllIssueHistory(int issueId)
        //{
        //    CommonResponse cr = new CommonResponse();
        //    try
        //    {
        //        var dt = DataAccess.Instance.IssueHistoryService.GetAll().OrderByDescending(o => o.HistoryId).ToList();
        //        cr.results = dt;
        //        cr.httpStatusCode = HttpStatusCode.OK;
        //        cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
        //    }
        //    catch (Exception ex)
        //    {
        //        cr.httpStatusCode = HttpStatusCode.BadRequest;
        //        cr.message = ex.Message.ToString();
        //    }
        //    return Json(cr);
        //}


        [Route("TaskManagement/GetAllIssueHistory/{issueId}")]
        [HttpGet]
        public IHttpActionResult GetAllIssueHistory(int issueId= 1003)
        {
            CommonResponse cr = new CommonResponse();

            try
            {

                IssueHistory issueHistory = new IssueHistory();
                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("SP_GetIssueHistory", new object[] {issueId });
 
                if (issueHistory != null)
                {
                    cr.results = issueHistory;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        #endregion

        #region IssueWebLink
        [Route("TaskManagement/GetAllIssueWebLink/")]
        [HttpGet]
        public IHttpActionResult GetAllIssueWebLink()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.IssueWebLinkService.GetAll().OrderByDescending(o => o.Id).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("TaskManagement/AddIssueWebLink")]
        [HttpPost]
        public IHttpActionResult AddIssueWebLink(IssueWebLink issueWebLink)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                
                var response = DataAccess.Instance.IssueWebLinkService.Add(issueWebLink);

                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.SAVED : Constant.SAVED_ERROR;
                cr.ttype = response ? "success" : "error";
                cr.results = response;

                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("TaskManagement/UpdateIssueWebLink")]
        [HttpPut]
        public IHttpActionResult UpdateIssueWebLink(IssueWebLink issueWebLink)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                IssueWebLink _issueWebLink = new IssueWebLink();
                _issueWebLink = DataAccess.Instance.IssueWebLinkService.Filter(e => e.Id == issueWebLink.Id).FirstOrDefault();

                if (_issueWebLink != null)
                {
                    _issueWebLink.IssueId = issueWebLink.IssueId;
                    _issueWebLink.Url = issueWebLink.Url;
                    _issueWebLink.Description = issueWebLink.Description;


                    var response = DataAccess.Instance.IssueWebLinkService.Update(_issueWebLink);

                    cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = response ? "success" : "error";
                    cr.results = response;
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("TaskManagement/DeleteIssueWebLink/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteIssueWebLink(int id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
             

                var response = DataAccess.Instance.IssueWebLinkService.Remove(id);
                cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = response ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }




        #endregion

        #region TasksStatus 

        [Route("TaskManagement/GetAllStatus/")]
        [HttpGet]
        public IHttpActionResult GetAllStatus()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.TasksStatusService.Filter(c => c.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        #endregion
        #region Board List
        [AllowAnonymous]
        [Route("TaskManagement/GetBoardIssueList/{statusId}")]
        [HttpPost]
        public IHttpActionResult GetBoardIssueList(IssueFilterVM issue,int statusId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                issue.StatusId = statusId;
                var whereclause = CommunicationService.GetWhereClause(issue);
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@Where", whereclause));
                param.Add(new SqlParameter("@pageno", issue.pageno));
                param.Add(new SqlParameter("@pageSize", issue.pageSize));

                var res = DataAccess.Instance.CommonServices.GetDatasetBySp("GetIssueBoardList", param.ToArray());
                var IssueList = CommonRepository.ConvertDataTable<SubIssueDetails>(res.Tables[0]).ToList();

                if (IssueList != null)
                {
                    cr.results = IssueList;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion

        [Route("TaskManagement/GetDepertmentWiseEmpList")]
        [HttpGet]
        public IHttpActionResult GetDepertmentWiseEmpList()
        {
            CommonResponse cr = new CommonResponse();

            try
            {
                DataTable dt = new DataTable();
                if (User.IsInRole("Admin"))
                {

                    SqlParameter param = new SqlParameter("@UserId", DBNull.Value);
                    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpDepartment", param);
                }
                else
                {
                    var userId = DataAccess.Instance.Users.GetUserUserId(User.Identity.Name);
                    SqlParameter param = new SqlParameter("@UserId", userId);
                    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpDepartment", param);
                }
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        public void AddIssueHistory(int issueId, string type,string description, int? parentId, int? sprinttId, int? PreviousId, int? PresentId)
        {
            IssueHistory _issueHistory = new IssueHistory();
            _issueHistory.IssueId = issueId;
            _issueHistory.Type = type;
            _issueHistory.Description = description;
            _issueHistory.ParentId = parentId;
            _issueHistory.SprinttId = sprinttId;
            _issueHistory.PreviousId = PreviousId;
            _issueHistory.PresentId = PresentId;
            _issueHistory.UserId = DataAccess.Instance.Users.GetUserUserId(User.Identity.Name);
            _issueHistory.ModifyDate = DateTime.Now;
            var res = DataAccess.Instance.IssueHistoryService.Add(_issueHistory);
            
        }

    }
}
