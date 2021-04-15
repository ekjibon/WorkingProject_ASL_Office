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
   public class LeaveRoutingHistoryService: IService<LeaveRoutingHistory>
    {
        LeaveRoutingHistoryRepository LeaveRoutingHistoryRepository;
        public LeaveRoutingHistoryService() 
        {
            LeaveRoutingHistoryRepository = new LeaveRoutingHistoryRepository();
        }

        public bool Add(LeaveRoutingHistory entity)
        {
            return LeaveRoutingHistoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveRoutingHistory> entities)
        {
            return LeaveRoutingHistoryRepository.AddRange(entities);
        }

        public bool Update(LeaveRoutingHistory entity)
        {
            return LeaveRoutingHistoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveRoutingHistory> entities)
        {
            return LeaveRoutingHistoryRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveRoutingHistory entity = new LeaveRoutingHistory();
            entity = LeaveRoutingHistoryRepository.SingleOrDefault(e => e.LeaveHistoryId == id);
            return LeaveRoutingHistoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveRoutingHistory> entities = new List<LeaveRoutingHistory>();
            entities = LeaveRoutingHistoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.LeaveHistoryId))).ToList();

            return LeaveRoutingHistoryRepository.RemoveRange(entities);
        }

        public LeaveRoutingHistory Get(long id)
        {
            return LeaveRoutingHistoryRepository.Get(id);
        }

        public LeaveRoutingHistory SingleOrDefault(Expression<Func<LeaveRoutingHistory, bool>> filter)
        {
            return LeaveRoutingHistoryRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveRoutingHistory> GetAll()
        {
            return LeaveRoutingHistoryRepository.GetAll();
        }

        public IEnumerable<LeaveRoutingHistory> Filter(Expression<Func<LeaveRoutingHistory, bool>> filter, Func<IQueryable<LeaveRoutingHistory>, IOrderedQueryable<LeaveRoutingHistory>> orderBy = null, string[] Children = null)
        {
            return LeaveRoutingHistoryRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveRoutingHistory> GetByPage(int pageno, int pagesize)
        {
            return LeaveRoutingHistoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return LeaveRoutingHistoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return LeaveRoutingHistoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return LeaveRoutingHistoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveRoutingHistory, bool>> filter, Func<IQueryable<LeaveRoutingHistory>, IOrderedQueryable<LeaveRoutingHistory>> orderBy = null)
        {
            return LeaveRoutingHistoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
