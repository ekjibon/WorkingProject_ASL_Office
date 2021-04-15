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
   public class SalaryIncrementService: IService<SalaryIncrement>
    {
        SalaryIncrementRepository salaryIncrementRepository; 
        public SalaryIncrementService()
        {
            salaryIncrementRepository = new SalaryIncrementRepository(); 
        }

        public bool Add(SalaryIncrement entity)
        {
            return salaryIncrementRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryIncrement> entities)
        {
            return salaryIncrementRepository.AddRange(entities);
        }

        public bool Update(SalaryIncrement entity)
        {
            return salaryIncrementRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryIncrement> entities)
        {
            return salaryIncrementRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryIncrement entity = new SalaryIncrement();
            entity = salaryIncrementRepository.SingleOrDefault(e => e.Id == id);
            return salaryIncrementRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryIncrement> entities = new List<SalaryIncrement>();
            entities = salaryIncrementRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryIncrementRepository.RemoveRange(entities);
        }

        public SalaryIncrement Get(long id)
        {
            return salaryIncrementRepository.Get(id);
        }

        public SalaryIncrement SingleOrDefault(Expression<Func<SalaryIncrement, bool>> filter)
        {
            return salaryIncrementRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryIncrement> GetAll()
        {
            return salaryIncrementRepository.GetAll();
        }

        public IEnumerable<SalaryIncrement> Filter(Expression<Func<SalaryIncrement, bool>> filter, Func<IQueryable<SalaryIncrement>, IOrderedQueryable<SalaryIncrement>> orderBy = null, string[] Children = null)
        {
            return salaryIncrementRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryIncrement> GetByPage(int pageno, int pagesize)
        {
            return salaryIncrementRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryIncrementRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryIncrementRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryIncrementRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryIncrement, bool>> filter, Func<IQueryable<SalaryIncrement>, IOrderedQueryable<SalaryIncrement>> orderBy = null)
        {
            return salaryIncrementRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
