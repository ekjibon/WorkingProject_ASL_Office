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
    public class SalaryHoldService : IService<SalaryHold>
    {
        SalaryHoldRepository salaryHoldRepository;
        public SalaryHoldService()
        {
            salaryHoldRepository = new SalaryHoldRepository();
        }

        public bool Add(SalaryHold entity)
        {
            return salaryHoldRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryHold> entities)
        {
            return salaryHoldRepository.AddRange(entities);
        }

        public bool Update(SalaryHold entity)
        {
            return salaryHoldRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryHold> entities)
        {
            return salaryHoldRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryHold entity = new SalaryHold();
            entity = salaryHoldRepository.SingleOrDefault(e => e.Id == id);
            return salaryHoldRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryHold> entities = new List<SalaryHold>();
            entities = salaryHoldRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryHoldRepository.RemoveRange(entities);
        }

        public SalaryHold Get(long id)
        {
            return salaryHoldRepository.Get(id);
        }

        public SalaryHold SingleOrDefault(Expression<Func<SalaryHold, bool>> filter)
        {
            return salaryHoldRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryHold> GetAll()
        {
            return salaryHoldRepository.GetAll();
        }

        public IEnumerable<SalaryHold> Filter(Expression<Func<SalaryHold, bool>> filter, Func<IQueryable<SalaryHold>, IOrderedQueryable<SalaryHold>> orderBy = null, string[] Children = null)
        {
            return salaryHoldRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryHold> GetByPage(int pageno, int pagesize)
        {
            return salaryHoldRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryHoldRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryHoldRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryHoldRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryHold, bool>> filter, Func<IQueryable<SalaryHold>, IOrderedQueryable<SalaryHold>> orderBy = null)
        {
            return salaryHoldRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
