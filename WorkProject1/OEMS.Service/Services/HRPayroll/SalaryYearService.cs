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
    public class SalaryYearService : IService<SalaryYear>
    {
        SalaryYearRepository salaryYearRepository;
        public SalaryYearService()
        {
            salaryYearRepository = new SalaryYearRepository();
        }

        public bool Add(SalaryYear entity)
        {
            return salaryYearRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryYear> entities)
        {
            return salaryYearRepository.AddRange(entities);
        }

        public bool Update(SalaryYear entity)
        {
            return salaryYearRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryYear> entities)
        {
            return salaryYearRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryYear entity = new SalaryYear();
            entity = salaryYearRepository.SingleOrDefault(e => e.Id == id);
            return salaryYearRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryYear> entities = new List<SalaryYear>();
            entities = salaryYearRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryYearRepository.RemoveRange(entities);
        }

        public SalaryYear Get(long id)
        {
            return salaryYearRepository.Get(id);
        }

        public SalaryYear SingleOrDefault(Expression<Func<SalaryYear, bool>> filter)
        {
            return salaryYearRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryYear> GetAll()
        {
            return salaryYearRepository.GetAll();
        }

        public IEnumerable<SalaryYear> Filter(Expression<Func<SalaryYear, bool>> filter, Func<IQueryable<SalaryYear>, IOrderedQueryable<SalaryYear>> orderBy = null, string[] Children = null)
        {
            return salaryYearRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryYear> GetByPage(int pageno, int pagesize)
        {
            return salaryYearRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryYearRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryYearRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryYearRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryYear, bool>> filter, Func<IQueryable<SalaryYear>, IOrderedQueryable<SalaryYear>> orderBy = null)
        {
            return salaryYearRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
