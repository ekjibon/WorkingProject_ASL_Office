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
   public class SalaryHeadService: IService<SalaryHead>
    {
        SalaryHeadRepository salaryHeadRepository;
        public SalaryHeadService() 
        {
            salaryHeadRepository = new SalaryHeadRepository();
        }

        public bool Add(SalaryHead entity)
        {
            return salaryHeadRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryHead> entities)
        {
            return salaryHeadRepository.AddRange(entities);
        }

        public bool Update(SalaryHead entity)
        {
            return salaryHeadRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryHead> entities)
        {
            return salaryHeadRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryHead entity = new SalaryHead();
            entity = salaryHeadRepository.SingleOrDefault(e => e.Id == id);
            return salaryHeadRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryHead> entities = new List<SalaryHead>();
            entities = salaryHeadRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryHeadRepository.RemoveRange(entities);
        }

        public SalaryHead Get(long id)
        {
            return salaryHeadRepository.Get(id);
        }

        public SalaryHead SingleOrDefault(Expression<Func<SalaryHead, bool>> filter)
        {
            return salaryHeadRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryHead> GetAll()
        {
            return salaryHeadRepository.GetAll();
        }

        public IEnumerable<SalaryHead> Filter(Expression<Func<SalaryHead, bool>> filter, Func<IQueryable<SalaryHead>, IOrderedQueryable<SalaryHead>> orderBy = null, string[] Children = null)
        {
            return salaryHeadRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryHead> GetByPage(int pageno, int pagesize)
        {
            return salaryHeadRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryHeadRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryHeadRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryHeadRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryHead, bool>> filter, Func<IQueryable<SalaryHead>, IOrderedQueryable<SalaryHead>> orderBy = null)
        {
            return salaryHeadRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
