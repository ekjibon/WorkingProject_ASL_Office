using OEMS.Models;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories.Employee;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Employee
{
    public  class EmpMeetingConfigService :IService<EmpMeetingConfig>
    {
        private EmpMeetingConfigRepository EmpMeetingConfigRepository;

        public EmpMeetingConfigService()
        {
            EmpMeetingConfigRepository = new EmpMeetingConfigRepository();
        }
        public bool Add(EmpMeetingConfig entity)
        {
            return EmpMeetingConfigRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpMeetingConfig> entities)
        {
            return EmpMeetingConfigRepository.AddRange(entities);
        }

        public IEnumerable<EmpMeetingConfig> Filter(Expression<Func<EmpMeetingConfig, bool>> filter, Func<IQueryable<EmpMeetingConfig>, IOrderedQueryable<EmpMeetingConfig>> orderBy = null, string[] Children = null)
        {
            return EmpMeetingConfigRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpMeetingConfig, bool>> filter, Func<IQueryable<EmpMeetingConfig>, IOrderedQueryable<EmpMeetingConfig>> orderBy = null)
        {
            return EmpMeetingConfigRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpMeetingConfig Get(long id)
        {
            return EmpMeetingConfigRepository.Get(id);
        }

        public IEnumerable<EmpMeetingConfig> GetAll()
        {
            return EmpMeetingConfigRepository.GetAll();
        }

        public IEnumerable<EmpMeetingConfig> GetByPage(int pageno, int pagesize)
        {
            return EmpMeetingConfigRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpMeetingConfigRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpMeetingConfigRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpMeetingConfigRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

    

        public bool RemoveRange(List<long> ids)
        {
            List<EmpMeetingConfig> entities = new List<EmpMeetingConfig>();
            entities = EmpMeetingConfigRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ConfigId))).ToList();

            return EmpMeetingConfigRepository.RemoveRange(entities);
        }

        public EmpMeetingConfig SingleOrDefault(Expression<Func<EmpMeetingConfig, bool>> filter)
        {
            return EmpMeetingConfigRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpMeetingConfig entity)
        {
            return EmpMeetingConfigRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpMeetingConfig> entities)
        {
            return EmpMeetingConfigRepository.AddRange(entities);
        }
        public bool Remove(long Id)
        {
            EmpMeetingConfig entity = new EmpMeetingConfig();
            entity = EmpMeetingConfigRepository.SingleOrDefault(e => e.ConfigId == Id);
            return EmpMeetingConfigRepository.Remove(entity);
        }


    }
}
