using OEMS.Models;
using OEMS.Models.Model.Employee;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Repository.Repositories.Employee;
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
   public class LeaveQuotaService: IService<LeaveQuota>
    {
        LeaveQuotaRepository leaveQuotaRepository;
        public LeaveQuotaService()
        {
            leaveQuotaRepository = new LeaveQuotaRepository();
        }

        public bool Add(LeaveQuota entity)
        {
            return leaveQuotaRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveQuota> entities)
        {
            return leaveQuotaRepository.AddRange(entities);
        }

        public bool Update(LeaveQuota entity)
        {
            return leaveQuotaRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveQuota> entities)
        {
            return leaveQuotaRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveQuota entity = new LeaveQuota();
            entity = leaveQuotaRepository.SingleOrDefault(e => e.LeaveQuotaId == id);
            return leaveQuotaRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveQuota> entities = new List<LeaveQuota>();
            entities = leaveQuotaRepository.Filter(x => ids.Contains(Convert.ToInt64(x.LeaveQuotaId))).ToList();

            return leaveQuotaRepository.RemoveRange(entities);
        }

        public LeaveQuota Get(long id)
        {
            return leaveQuotaRepository.Get(id);
        }

        public LeaveQuota SingleOrDefault(Expression<Func<LeaveQuota, bool>> filter)
        {
            return leaveQuotaRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveQuota> GetAll()
        {
            return leaveQuotaRepository.GetAll();
        }

        public IEnumerable<LeaveQuota> Filter(Expression<Func<LeaveQuota, bool>> filter, Func<IQueryable<LeaveQuota>, IOrderedQueryable<LeaveQuota>> orderBy = null, string[] Children = null)
        {
            return leaveQuotaRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveQuota> GetByPage(int pageno, int pagesize)
        {
            return leaveQuotaRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return leaveQuotaRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return leaveQuotaRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return leaveQuotaRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveQuota, bool>> filter, Func<IQueryable<LeaveQuota>, IOrderedQueryable<LeaveQuota>> orderBy = null)
        {
            return leaveQuotaRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
