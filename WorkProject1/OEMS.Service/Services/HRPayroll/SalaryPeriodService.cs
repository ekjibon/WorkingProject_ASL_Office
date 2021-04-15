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
    public class SalaryPeriodService : IService<SalaryPeriod>
    {
        SalaryPeriodRepository salaryPeriodRepository;
        public SalaryPeriodService()
        {
            salaryPeriodRepository = new SalaryPeriodRepository();
        }

        public bool Add(SalaryPeriod entity)
        {
            return salaryPeriodRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryPeriod> entities)
        {
            return salaryPeriodRepository.AddRange(entities);
        }

        public bool Update(SalaryPeriod entity)
        {
            return salaryPeriodRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryPeriod> entities)
        {
            return salaryPeriodRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryPeriod entity = new SalaryPeriod();
            entity = salaryPeriodRepository.SingleOrDefault(e => e.Id == id);
            return salaryPeriodRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryPeriod> entities = new List<SalaryPeriod>();
            entities = salaryPeriodRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryPeriodRepository.RemoveRange(entities);
        }

        public SalaryPeriod Get(long id)
        {
            return salaryPeriodRepository.Get(id);
        }

        public SalaryPeriod SingleOrDefault(Expression<Func<SalaryPeriod, bool>> filter)
        {
            return salaryPeriodRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryPeriod> GetAll()
        {
            return salaryPeriodRepository.GetAll();
        }

        public IEnumerable<SalaryPeriod> Filter(Expression<Func<SalaryPeriod, bool>> filter, Func<IQueryable<SalaryPeriod>, IOrderedQueryable<SalaryPeriod>> orderBy = null, string[] Children = null)
        {
            return salaryPeriodRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryPeriod> GetByPage(int pageno, int pagesize)
        {
            return salaryPeriodRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryPeriodRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryPeriodRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryPeriodRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryPeriod, bool>> filter, Func<IQueryable<SalaryPeriod>, IOrderedQueryable<SalaryPeriod>> orderBy = null)
        {
            return salaryPeriodRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
