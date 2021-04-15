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
    
    public class SalaryPayDetailsService : IService<SalaryPayDetails>
    {
        SalaryPayDetailsRepository salaryPayDetailsRepository;
        public SalaryPayDetailsService()
        {
            salaryPayDetailsRepository = new SalaryPayDetailsRepository();
        }

        public bool Add(SalaryPayDetails entity)
        {
            return salaryPayDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryPayDetails> entities)
        {
            return salaryPayDetailsRepository.AddRange(entities);
        }

        public bool Update(SalaryPayDetails entity)
        {
            return salaryPayDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryPayDetails> entities)
        {
            return salaryPayDetailsRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryPayDetails entity = new SalaryPayDetails();
            entity = salaryPayDetailsRepository.SingleOrDefault(e => e.Id == id);
            return salaryPayDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryPayDetails> entities = new List<SalaryPayDetails>();
            entities = salaryPayDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryPayDetailsRepository.RemoveRange(entities);
        }

        public SalaryPayDetails Get(long id)
        {
            return salaryPayDetailsRepository.Get(id);
        }

        public SalaryPayDetails SingleOrDefault(Expression<Func<SalaryPayDetails, bool>> filter)
        {
            return salaryPayDetailsRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryPayDetails> GetAll()
        {
            return salaryPayDetailsRepository.GetAll();
        }

        public IEnumerable<SalaryPayDetails> Filter(Expression<Func<SalaryPayDetails, bool>> filter, Func<IQueryable<SalaryPayDetails>, IOrderedQueryable<SalaryPayDetails>> orderBy = null, string[] Children = null)
        {
            return salaryPayDetailsRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryPayDetails> GetByPage(int pageno, int pagesize)
        {
            return salaryPayDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryPayDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryPayDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryPayDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryPayDetails, bool>> filter, Func<IQueryable<SalaryPayDetails>, IOrderedQueryable<SalaryPayDetails>> orderBy = null)
        {
            return salaryPayDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
