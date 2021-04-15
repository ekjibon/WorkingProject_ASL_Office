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
   public class LeaveRoutingConfigDetailsService: IService<LeaveRoutingConfigDetails>
    {
        LeaveRoutingConfigDetailsRepository LeaveRoutingConfigDetailsRepository;
        public LeaveRoutingConfigDetailsService() 
        {
            LeaveRoutingConfigDetailsRepository = new LeaveRoutingConfigDetailsRepository();
        }

        public bool Add(LeaveRoutingConfigDetails entity)
        {
            return LeaveRoutingConfigDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveRoutingConfigDetails> entities)
        {
            return LeaveRoutingConfigDetailsRepository.AddRange(entities);
        }

        public bool Update(LeaveRoutingConfigDetails entity)
        {
            return LeaveRoutingConfigDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveRoutingConfigDetails> entities)
        {
            return LeaveRoutingConfigDetailsRepository.UpdateRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveRoutingConfigDetails entity = new LeaveRoutingConfigDetails();
            entity = LeaveRoutingConfigDetailsRepository.SingleOrDefault(e => e.RoutingId == id);
            return LeaveRoutingConfigDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveRoutingConfigDetails> entities = new List<LeaveRoutingConfigDetails>();
            entities = LeaveRoutingConfigDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.RoutingId))).ToList();

            return LeaveRoutingConfigDetailsRepository.RemoveRange(entities);
        }

        public LeaveRoutingConfigDetails Get(long id)
        {
            return LeaveRoutingConfigDetailsRepository.Get(id);
        }

        public LeaveRoutingConfigDetails SingleOrDefault(Expression<Func<LeaveRoutingConfigDetails, bool>> filter)
        {
            return LeaveRoutingConfigDetailsRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveRoutingConfigDetails> GetAll()
        {
            return LeaveRoutingConfigDetailsRepository.GetAll();
        }

        public IEnumerable<LeaveRoutingConfigDetails> Filter(Expression<Func<LeaveRoutingConfigDetails, bool>> filter, Func<IQueryable<LeaveRoutingConfigDetails>, IOrderedQueryable<LeaveRoutingConfigDetails>> orderBy = null, string[] Children = null)
        {
            return LeaveRoutingConfigDetailsRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveRoutingConfigDetails> GetByPage(int pageno, int pagesize)
        {
            return LeaveRoutingConfigDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return LeaveRoutingConfigDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return LeaveRoutingConfigDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return LeaveRoutingConfigDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveRoutingConfigDetails, bool>> filter, Func<IQueryable<LeaveRoutingConfigDetails>, IOrderedQueryable<LeaveRoutingConfigDetails>> orderBy = null)
        {
            return LeaveRoutingConfigDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
