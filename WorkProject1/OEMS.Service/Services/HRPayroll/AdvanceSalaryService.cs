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
    public class AdvanceSalaryService : IService<AdvanceSalary>
    {
        AdvanceSalaryRepository advanceSalaryRepository;
        public AdvanceSalaryService()
        {
            advanceSalaryRepository = new AdvanceSalaryRepository();
        }

        public bool Add(AdvanceSalary entity)
        {
            return advanceSalaryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AdvanceSalary> entities)
        {
            return advanceSalaryRepository.AddRange(entities);
        }

        public bool Update(AdvanceSalary entity)
        {
            return advanceSalaryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AdvanceSalary> entities)
        {
            return advanceSalaryRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            AdvanceSalary entity = new AdvanceSalary();
            entity = advanceSalaryRepository.SingleOrDefault(e => e.Id == id);
            return advanceSalaryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AdvanceSalary> entities = new List<AdvanceSalary>();
            entities = advanceSalaryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return advanceSalaryRepository.RemoveRange(entities);
        }

        public AdvanceSalary Get(long id)
        {
            return advanceSalaryRepository.Get(id);
        }

        public AdvanceSalary SingleOrDefault(Expression<Func<AdvanceSalary, bool>> filter)
        {
            return advanceSalaryRepository.SingleOrDefault(filter);
        }


        public IEnumerable<AdvanceSalary> GetAll()
        {
            return advanceSalaryRepository.GetAll();
        }

        public IEnumerable<AdvanceSalary> Filter(Expression<Func<AdvanceSalary, bool>> filter, Func<IQueryable<AdvanceSalary>, IOrderedQueryable<AdvanceSalary>> orderBy = null, string[] Children = null)
        {
            return advanceSalaryRepository.Filter(filter, orderBy);
        }

        public IEnumerable<AdvanceSalary> GetByPage(int pageno, int pagesize)
        {
            return advanceSalaryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return advanceSalaryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return advanceSalaryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return advanceSalaryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AdvanceSalary, bool>> filter, Func<IQueryable<AdvanceSalary>, IOrderedQueryable<AdvanceSalary>> orderBy = null)
        {
            return advanceSalaryRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
