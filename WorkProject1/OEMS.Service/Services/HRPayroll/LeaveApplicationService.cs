using OEMS.Models;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Repository.Repositories.HRPayroll;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.HRPayroll
{
    public class LeaveApplicationService:IService<LeaveApplication>
    {
        LeaveApplicationRepository leaveApplicationRepository;
        public LeaveApplicationService()
        {
            leaveApplicationRepository = new LeaveApplicationRepository();
        }

        public bool Add(LeaveApplication entity)
        {
            return leaveApplicationRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveApplication> entities)
        {
            return leaveApplicationRepository.AddRange(entities);
        }

        public bool Update(LeaveApplication entity)
        {
            return leaveApplicationRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveApplication> entities)
        {
            return leaveApplicationRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveApplication entity = new LeaveApplication();
            entity = leaveApplicationRepository.SingleOrDefault(e => e.Id == id);
            return leaveApplicationRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveApplication> entities = new List<LeaveApplication>();
            entities = leaveApplicationRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return leaveApplicationRepository.RemoveRange(entities);
        }

        public LeaveApplication Get(long id)
        {
            return leaveApplicationRepository.Get(id);
        }

        public LeaveApplication SingleOrDefault(Expression<Func<LeaveApplication, bool>> filter)
        {
            return leaveApplicationRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveApplication> GetAll()
        {
            return leaveApplicationRepository.GetAll();
        }

        public IEnumerable<LeaveApplication> Filter(Expression<Func<LeaveApplication, bool>> filter, Func<IQueryable<LeaveApplication>, IOrderedQueryable<LeaveApplication>> orderBy = null, string[] Children = null)
        {
            return leaveApplicationRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveApplication> GetByPage(int pageno, int pagesize)
        {
            return leaveApplicationRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return leaveApplicationRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return leaveApplicationRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return leaveApplicationRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveApplication, bool>> filter, Func<IQueryable<LeaveApplication>, IOrderedQueryable<LeaveApplication>> orderBy = null)
        {
            return leaveApplicationRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
