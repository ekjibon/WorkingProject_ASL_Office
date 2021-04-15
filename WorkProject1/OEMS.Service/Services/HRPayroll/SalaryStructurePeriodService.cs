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
   public class SalaryStructurePeriodService : IService <SalaryStructurePeriod>
    {
        SalaryStructurePeriodRepository salaryStructurePeriodRepository;
        public SalaryStructurePeriodService()
        {
            salaryStructurePeriodRepository = new SalaryStructurePeriodRepository();
        }

        public bool Add(SalaryStructurePeriod entity)
        {
            return salaryStructurePeriodRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryStructurePeriod> entities)
        {
            return salaryStructurePeriodRepository.AddRange(entities);
        }

        public bool Update(SalaryStructurePeriod entity)
        {
            return salaryStructurePeriodRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryStructurePeriod> entities)
        {
            return salaryStructurePeriodRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryStructurePeriod entity = new SalaryStructurePeriod();
            entity = salaryStructurePeriodRepository.SingleOrDefault(e => e.Id == id);
            return salaryStructurePeriodRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryStructurePeriod> entities = new List<SalaryStructurePeriod>();
            entities = salaryStructurePeriodRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryStructurePeriodRepository.RemoveRange(entities);
        }

        public SalaryStructurePeriod Get(long id)
        {
            return salaryStructurePeriodRepository.Get(id);
        }

        public SalaryStructurePeriod SingleOrDefault(Expression<Func<SalaryStructurePeriod, bool>> filter)
        {
            return salaryStructurePeriodRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryStructurePeriod> GetAll()
        {
            return salaryStructurePeriodRepository.GetAll();
        }

        public IEnumerable<SalaryStructurePeriod> Filter(Expression<Func<SalaryStructurePeriod, bool>> filter, Func<IQueryable<SalaryStructurePeriod>, IOrderedQueryable<SalaryStructurePeriod>> orderBy = null, string[] Children = null)
        {
            return salaryStructurePeriodRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryStructurePeriod> GetByPage(int pageno, int pagesize)
        {
            return salaryStructurePeriodRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryStructurePeriodRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryStructurePeriodRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryStructurePeriodRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryStructurePeriod, bool>> filter, Func<IQueryable<SalaryStructurePeriod>, IOrderedQueryable<SalaryStructurePeriod>> orderBy = null)
        {
            return salaryStructurePeriodRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
    
}
