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
   public class EmpLeaveQuotaService : IService<EmpLeaveQuota>
    {
        EmpLeaveQuotaRepository empLeaveQuotaRepository;
        public EmpLeaveQuotaService()
        {
            empLeaveQuotaRepository = new EmpLeaveQuotaRepository();
        }

        public bool Add(EmpLeaveQuota entity)
        {
            return empLeaveQuotaRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpLeaveQuota> entities)
        {
            return empLeaveQuotaRepository.AddRange(entities);
        }

        public bool Update(EmpLeaveQuota entity)
        {
            return empLeaveQuotaRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpLeaveQuota> entities)
        {
            return empLeaveQuotaRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            EmpLeaveQuota entity = new EmpLeaveQuota();
            entity = empLeaveQuotaRepository.SingleOrDefault(e => e.EmpLeaveQuotaId == id);
            return empLeaveQuotaRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpLeaveQuota> entities = new List<EmpLeaveQuota>();
            entities = empLeaveQuotaRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpLeaveQuotaId))).ToList();

            return empLeaveQuotaRepository.RemoveRange(entities);
        }

        public EmpLeaveQuota Get(long id)
        {
            return empLeaveQuotaRepository.Get(id);
        }

        public EmpLeaveQuota SingleOrDefault(Expression<Func<EmpLeaveQuota, bool>> filter)
        {
            return empLeaveQuotaRepository.SingleOrDefault(filter);
        }


        public IEnumerable<EmpLeaveQuota> GetAll()
        {
            return empLeaveQuotaRepository.GetAll();
        }

        public IEnumerable<EmpLeaveQuota> Filter(Expression<Func<EmpLeaveQuota, bool>> filter, Func<IQueryable<EmpLeaveQuota>, IOrderedQueryable<EmpLeaveQuota>> orderBy = null, string[] Children = null)
        {
            return empLeaveQuotaRepository.Filter(filter, orderBy);
        }

        public IEnumerable<EmpLeaveQuota> GetByPage(int pageno, int pagesize)
        {
            return empLeaveQuotaRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empLeaveQuotaRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empLeaveQuotaRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empLeaveQuotaRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpLeaveQuota, bool>> filter, Func<IQueryable<EmpLeaveQuota>, IOrderedQueryable<EmpLeaveQuota>> orderBy = null)
        {
            return empLeaveQuotaRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
