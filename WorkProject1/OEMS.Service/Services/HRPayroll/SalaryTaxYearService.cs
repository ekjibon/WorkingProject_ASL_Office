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
    public class SalaryTaxYearService : IService<SalaryTaxYear>
    {
        SalaryTaxYearRepository salaryTaxYearRepository;
        public SalaryTaxYearService()
        {
            salaryTaxYearRepository = new SalaryTaxYearRepository();
        }

        public bool Add(SalaryTaxYear entity)
        {
            return salaryTaxYearRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryTaxYear> entities)
        {
            return salaryTaxYearRepository.AddRange(entities);
        }

        public bool Update(SalaryTaxYear entity)
        {
            return salaryTaxYearRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryTaxYear> entities)
        {
            return salaryTaxYearRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryTaxYear entity = new SalaryTaxYear();
            entity = salaryTaxYearRepository.SingleOrDefault(e => e.Id == id);
            return salaryTaxYearRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryTaxYear> entities = new List<SalaryTaxYear>();
            entities = salaryTaxYearRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryTaxYearRepository.RemoveRange(entities);
        }

        public SalaryTaxYear Get(long id)
        {
            return salaryTaxYearRepository.Get(id);
        }

        public SalaryTaxYear SingleOrDefault(Expression<Func<SalaryTaxYear, bool>> filter)
        {
            return salaryTaxYearRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryTaxYear> GetAll()
        {
            return salaryTaxYearRepository.GetAll();
        }

        public IEnumerable<SalaryTaxYear> Filter(Expression<Func<SalaryTaxYear, bool>> filter, Func<IQueryable<SalaryTaxYear>, IOrderedQueryable<SalaryTaxYear>> orderBy = null, string[] Children = null)
        {
            return salaryTaxYearRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryTaxYear> GetByPage(int pageno, int pagesize)
        {
            return salaryTaxYearRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryTaxYearRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryTaxYearRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryTaxYearRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryTaxYear, bool>> filter, Func<IQueryable<SalaryTaxYear>, IOrderedQueryable<SalaryTaxYear>> orderBy = null)
        {
            return salaryTaxYearRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
