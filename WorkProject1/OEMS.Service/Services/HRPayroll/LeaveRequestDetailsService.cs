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
   public class LeaveRequestDetailsService: IService<LeaveRequestDetails>
    {
        LeaveRequestDetailsRepository LeaveRequestDetailsRepository;
        public LeaveRequestDetailsService() 
        {
            LeaveRequestDetailsRepository = new LeaveRequestDetailsRepository();
        }

        public bool Add(LeaveRequestDetails entity)
        {
            return LeaveRequestDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveRequestDetails> entities)
        {
            return LeaveRequestDetailsRepository.AddRange(entities);
        }

        public bool Update(LeaveRequestDetails entity)
        {
            return LeaveRequestDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveRequestDetails> entities)
        {
            return LeaveRequestDetailsRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveRequestDetails entity = new LeaveRequestDetails();
            entity = LeaveRequestDetailsRepository.SingleOrDefault(e => e.Id == id);
            return LeaveRequestDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveRequestDetails> entities = new List<LeaveRequestDetails>();
            entities = LeaveRequestDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return LeaveRequestDetailsRepository.RemoveRange(entities);
        }

        public LeaveRequestDetails Get(long id)
        {
            return LeaveRequestDetailsRepository.Get(id);
        }

        public LeaveRequestDetails SingleOrDefault(Expression<Func<LeaveRequestDetails, bool>> filter)
        {
            return LeaveRequestDetailsRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveRequestDetails> GetAll()
        {
            return LeaveRequestDetailsRepository.GetAll();
        }

        public IEnumerable<LeaveRequestDetails> Filter(Expression<Func<LeaveRequestDetails, bool>> filter, Func<IQueryable<LeaveRequestDetails>, IOrderedQueryable<LeaveRequestDetails>> orderBy = null, string[] Children = null)
        {
            return LeaveRequestDetailsRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveRequestDetails> GetByPage(int pageno, int pagesize)
        {
            return LeaveRequestDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return LeaveRequestDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return LeaveRequestDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return LeaveRequestDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveRequestDetails, bool>> filter, Func<IQueryable<LeaveRequestDetails>, IOrderedQueryable<LeaveRequestDetails>> orderBy = null)
        {
            return LeaveRequestDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
