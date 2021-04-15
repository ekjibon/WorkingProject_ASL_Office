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
    public class SalaryHeadWiseConfigService : IService<SalaryHeadWiseConfig>
    {
        SalaryHeadWiseConfigRepository salaryHeadWiseConfigRepository; 
        public SalaryHeadWiseConfigService()
        {
            salaryHeadWiseConfigRepository = new SalaryHeadWiseConfigRepository();
        }

        public bool Add(SalaryHeadWiseConfig entity)
        {
            return salaryHeadWiseConfigRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryHeadWiseConfig> entities)
        {
            return salaryHeadWiseConfigRepository.AddRange(entities);
        }

        public bool Update(SalaryHeadWiseConfig entity)
        {
            return salaryHeadWiseConfigRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryHeadWiseConfig> entities)
        {
            return salaryHeadWiseConfigRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryHeadWiseConfig entity = new SalaryHeadWiseConfig();
            entity = salaryHeadWiseConfigRepository.SingleOrDefault(e => e.Id == id);
            return salaryHeadWiseConfigRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryHeadWiseConfig> entities = new List<SalaryHeadWiseConfig>();
            entities = salaryHeadWiseConfigRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryHeadWiseConfigRepository.RemoveRange(entities);
        }

        public SalaryHeadWiseConfig Get(long id)
        {
            return salaryHeadWiseConfigRepository.Get(id);
        }

        public SalaryHeadWiseConfig SingleOrDefault(Expression<Func<SalaryHeadWiseConfig, bool>> filter)
        {
            return salaryHeadWiseConfigRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryHeadWiseConfig> GetAll()
        {
            return salaryHeadWiseConfigRepository.GetAll();
        }

        public IEnumerable<SalaryHeadWiseConfig> Filter(Expression<Func<SalaryHeadWiseConfig, bool>> filter, Func<IQueryable<SalaryHeadWiseConfig>, IOrderedQueryable<SalaryHeadWiseConfig>> orderBy = null, string[] Children = null)
        {
            return salaryHeadWiseConfigRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryHeadWiseConfig> GetByPage(int pageno, int pagesize)
        {
            return salaryHeadWiseConfigRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryHeadWiseConfigRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryHeadWiseConfigRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryHeadWiseConfigRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryHeadWiseConfig, bool>> filter, Func<IQueryable<SalaryHeadWiseConfig>, IOrderedQueryable<SalaryHeadWiseConfig>> orderBy = null)
        {
            return salaryHeadWiseConfigRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
