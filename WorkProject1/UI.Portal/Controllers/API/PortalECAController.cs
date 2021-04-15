using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Club;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using UI.Portal.Models;

namespace UI.Portal.Controllers.API
{
    public class PortalECAController : ApiController
    {
        [Route("PortalECA/GetECAListByStuID/")]
        [HttpGet]
        public IHttpActionResult GetECAListByStuID()
        {
            CommonResponse cr = new CommonResponse();
            long stuId = Convert.ToInt64(User.Identity.GetUserStudentId());

            DataTable dt;
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetECAStuClubList", new object[] { 2, DBNull.Value, DBNull.Value, DBNull.Value, stuId }); //need SP
            cr.results = dt;
            return Json(cr);

        }
        [Route("PortalECA/GetECAChangingHistory/")]
        [HttpGet]
        public IHttpActionResult GetECAChangingHistory()
        {
            CommonResponse cr = new CommonResponse();
            long stuId = Convert.ToInt64(User.Identity.GetUserStudentId());

            DataTable dt;
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetECAStuClubList", new object[] {3,DBNull.Value, DBNull.Value, DBNull.Value,stuId}); //need SP
            cr.results = dt;
            return Json(cr);

        } 

        [Route("PortalECA/AddECA/")]
        [HttpPost]
        public IHttpActionResult AddECA(StudentClubs StuClub)
        {
            CommonResponse cr = new CommonResponse();
            StudentClubs aStudentClub = new StudentClubs();
            long StuId = Convert.ToInt64(User.Identity.GetUserStudentId());
            var stuClub = DataAccess.Instance.StudentClubsService.Filter(e => e.StudentId == StuId);
            //int seatCapacity = DataAccess.Instance.ClubConfigService.Filter(e => e.ClubId == StuClub.ClubId).FirstOrDefault().SeatCapacity;
            try
            {
                if (stuClub.Count() == 2)
                {
                    throw new Exception("You can apply only Twice.");
                }
                if (StuClub.ChoiceTypeId==1)
                {
                    if (stuClub.Any(e => e.ChoiceTypeId == StuClub.ChoiceTypeId || e.ClubId==StuClub.ClubId))
                    {
                        throw new Exception("Please Second Choice Apply or Check Your Club Already Exist.");
                    }
                }
                else
                {
                    if (stuClub.Any(e => e.ChoiceTypeId == StuClub.ChoiceTypeId || e.ClubId == StuClub.ClubId))
                    {
                       throw new Exception("You can only Twice Apply or your Club Already Exist.");
                    }
                }

                int dayid = DataAccess.Instance.ClubConfigService.Filter(e => e.ClubId == StuClub.ClubId && e.IsDeleted==false&& e.Status=="A").FirstOrDefault().DayId;
            
                aStudentClub.ClubId = StuClub.ClubId;
                aStudentClub.TermId = StuClub.TermId;
                 aStudentClub.ChoiceTypeId = StuClub.ChoiceTypeId;
                aStudentClub.DayId = dayid;
                 aStudentClub.StudentId = StuId;
                aStudentClub.NewClubId = 0;
                aStudentClub.Status = "Pending";
                aStudentClub.AddBy = User.Identity.Name;
                aStudentClub.AddDate = DateTime.Now;
                aStudentClub.IsDeleted = false;
                aStudentClub.SetDate();

                var res = DataAccess.Instance.StudentClubsService.Add(aStudentClub);
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                cr.results = res;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
                //throw new Exception();"Club Did not Configure Yet"
            }
        }


        [Route("PortalECA/GetECAClubList/")]
        [HttpGet]
        public IHttpActionResult GetECAClubList()
        {
            CommonResponse res = new CommonResponse();
            long StuId = Convert.ToInt64(User.Identity.GetUserStudentId());
            var studentd = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == StuId).FirstOrDefault();
            List<DataColumn> ECAClubs = new List<DataColumn>();
            var result = DataAccess.Instance.CommonServices.GetBySp("GetAllClubConfigList");

            //var list =  result.AsEnumerable().Where(x => x.Field<int>("ClassId") == studentd.ClassId).ToList();
            //res.results = list.
            res.results = from d in result.AsEnumerable() where d.Field<int>("ClassId") == studentd.ClassId
                        select new
                        {
                            ClubId = d.Field<int>("ClubId"),
                            ClubName = d.Field<string>("ClubName"),
                            TermId = d.Field<int>("TermId")
                           
                        };
          

            //res.results = result.Columns.Cast<DataColumn>().Where(c => c.ColumnName == "ClassId").Where(c => Convert.ToInt32(result.Rows[0][c]) == studentd.ClassId).ToList();

            res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
         
        }


        [Route("PortalECA/GetDaywiseClubList/{DayId}")]
        [HttpGet]
        public IHttpActionResult GetDaywiseClubList(int DayId)
        {
            CommonResponse cr = new CommonResponse();

            var ClubConfigList = DataAccess.Instance.ClubConfigService.Filter(e => e.DayId == DayId && e.Status == "A").ToList();
            var ECAClubList = DataAccess.Instance.ECAClubService.GetAll();
            List<ECAClub> clubList = new List<ECAClub>();
            foreach (var item in ECAClubList)
            {
                if (ClubConfigList.Any(e=>e.ClubId== item.ClubId))
                {
                    clubList.Add(item);
                }
            }
            cr.results = clubList;
            return Json(cr);

        }
        [Route("PortalECA/GetCategorywiseClubList/{CategoryName}")]
        [HttpGet]
        public IHttpActionResult GetCategorywiseClubList(string CategoryName)
        {
            CommonResponse cr = new CommonResponse();
            var ECAClubList = DataAccess.Instance.ECAClubService.Filter(e=>e.CategoryName== CategoryName && e.IsDeleted==false&&e.Status=="A").ToList();
            cr.results = ECAClubList;
            return Json(cr);

        }



        [Route("PortalECA/GetDaywiseClubListByStudentID/")]
        [HttpGet]
        public IHttpActionResult GetDaywiseClubListByStudentID()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
              
                long stuId = Convert.ToInt64(User.Identity.GetUserStudentId());
                var student = DataAccess.Instance.StudentBasicInfo.Filter(s => s.StudentIID == stuId).FirstOrDefault();
                int DayId = DataAccess.Instance.StudentClubsService.Filter(e => e.StudentId == stuId && e.Status == "Approved").FirstOrDefault().DayId;
                var result = DataAccess.Instance.CommonServices.GetBySp("GetAllClubConfigList");
                cr.results = result.AsEnumerable().Where(e => e.Field<int>("ClassId") == student.ClassId && e.Field<int>("DayId") == DayId).Select(s => new { ClubId = s.Field<int>("ClubId"), ClubName = s.Field<string>("ClubName"), DayId = s.Field<int>("DayId") }).ToList();
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);

        }



        [Route("PortalECA/ChangeECAClub/")]
        [HttpPost]
        public IHttpActionResult ChangeECAClub(StudentClubsHistory stuClubHis)
        {
            CommonResponse cr = new CommonResponse();
            StudentClubsHistory entity = new StudentClubsHistory();
           
          
            try
            {
                long stuId = Convert.ToInt64(User.Identity.GetUserStudentId());

                var stuClubs = DataAccess.Instance.StudentClubsService.Filter(e => e.StudentId == stuId && e.Status== "Approved").FirstOrDefault();
                if (stuClubs.ClubId == stuClubHis.ToClubId || stuClubs.NewClubId == stuClubHis.ToClubId)
                {
                    throw new Exception("Data is Exist!");
                }
                entity.FromClubId = stuClubs.ClubId;
                entity.ToClubId = stuClubHis.ToClubId;
                entity.StudentId = stuId;
                entity.Reason = stuClubHis.Reason;
                entity.ChangingDate = DateTime.Now;
                entity.SetDate();
                entity.AddBy = User.Identity.Name;
                entity.AddDate = DateTime.Now;
                entity.IsDeleted = false;
                entity.Status = "Pending";
                var res = DataAccess.Instance.StudentClubsHistoryService.Add(entity);
                if (res)
                {
                    stuClubs.NewClubId = stuClubHis.ToClubId;
                    stuClubs.Status = "Pending";
                    var result = DataAccess.Instance.StudentClubsService.Update(stuClubs);
                }
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
               
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }
            return Json(cr);

           
        }
        [Route("PortalECA/GetTermList")]
        [HttpGet]
        public IHttpActionResult GetTermList()
        {
            CommonResponse cr = new CommonResponse();
            
            try
            {
                long studId = Convert.ToInt64(User.Identity.GetUserStudentId());
                var sb = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == studId).FirstOrDefault();
                var TermList = DataAccess.Instance.TermService.Filter(e=>e.ClassId == sb.ClassId && e.IsDeleted==false&&e.Status=="A");
                if (TermList.Any())
                {
                    cr.results = TermList;
                    
                }
            }
            catch (Exception ex)
            {

                throw;
            }
            return Json(cr);
        }
    }
}
