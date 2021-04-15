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
   public class LeaveRoutingConfigService: IService<LeaveRoutingConfig>
    {
        LeaveRoutingConfigRepository LeaveRoutingConfigRepository;
        public LeaveRoutingConfigService() 
        {
            LeaveRoutingConfigRepository = new LeaveRoutingConfigRepository();
        }

        public bool Add(LeaveRoutingConfig entity)
        {
            return LeaveRoutingConfigRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveRoutingConfig> entities)
        {
            return LeaveRoutingConfigRepository.AddRange(entities);
        }

        public bool Update(LeaveRoutingConfig entity)
        {
            return LeaveRoutingConfigRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveRoutingConfig> entities)
        {
            return LeaveRoutingConfigRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveRoutingConfig entity = new LeaveRoutingConfig();
            entity = LeaveRoutingConfigRepository.SingleOrDefault(e => e.RoutingId == id);
            return LeaveRoutingConfigRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveRoutingConfig> entities = new List<LeaveRoutingConfig>();
            entities = LeaveRoutingConfigRepository.Filter(x => ids.Contains(Convert.ToInt64(x.RoutingId))).ToList();

            return LeaveRoutingConfigRepository.RemoveRange(entities);
        }

        public LeaveRoutingConfig Get(long id)
        {
            return LeaveRoutingConfigRepository.Get(id);
        }

        public LeaveRoutingConfig SingleOrDefault(Expression<Func<LeaveRoutingConfig, bool>> filter)
        {
            return LeaveRoutingConfigRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveRoutingConfig> GetAll()
        {
            return LeaveRoutingConfigRepository.GetAll();
        }

        public IEnumerable<LeaveRoutingConfig> Filter(Expression<Func<LeaveRoutingConfig, bool>> filter, Func<IQueryable<LeaveRoutingConfig>, IOrderedQueryable<LeaveRoutingConfig>> orderBy = null, string[] Children = null)
        {
            return LeaveRoutingConfigRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveRoutingConfig> GetByPage(int pageno, int pagesize)
        {
            return LeaveRoutingConfigRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return LeaveRoutingConfigRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return LeaveRoutingConfigRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return LeaveRoutingConfigRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveRoutingConfig, bool>> filter, Func<IQueryable<LeaveRoutingConfig>, IOrderedQueryable<LeaveRoutingConfig>> orderBy = null)
        {
            return LeaveRoutingConfigRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
