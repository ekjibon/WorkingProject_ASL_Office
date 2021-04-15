using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Invoice;
using OEMS.Repository.Repositories.Invoice;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Invoice
{
    public class BillingHeadConfigDetailsService : IService<BillingHeadConfigDetails>
    {
        BillingHeadConfigDetailsRepository BillingHeadConfigDetailsRepository; 
        public BillingHeadConfigDetailsService() 
        {
            BillingHeadConfigDetailsRepository = new BillingHeadConfigDetailsRepository();
        }

        public bool Add(BillingHeadConfigDetails entity)
        {
            return BillingHeadConfigDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<BillingHeadConfigDetails> entities)
        {
            return BillingHeadConfigDetailsRepository.AddRange(entities);
        }

        public bool Update(BillingHeadConfigDetails entity)
        {
            return BillingHeadConfigDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<BillingHeadConfigDetails> entities)
        {
            return BillingHeadConfigDetailsRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            BillingHeadConfigDetails entity = new BillingHeadConfigDetails();
            entity = BillingHeadConfigDetailsRepository.SingleOrDefault(e => e.Id == id);
            return BillingHeadConfigDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<BillingHeadConfigDetails> entities = new List<BillingHeadConfigDetails>();
            entities = BillingHeadConfigDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return BillingHeadConfigDetailsRepository.RemoveRange(entities);
        }

        public BillingHeadConfigDetails Get(long id)
        {
            return BillingHeadConfigDetailsRepository.Get(id);
        }

        public BillingHeadConfigDetails SingleOrDefault(Expression<Func<BillingHeadConfigDetails, bool>> filter)
        {
            return BillingHeadConfigDetailsRepository.SingleOrDefault(filter);
        }


        public IEnumerable<BillingHeadConfigDetails> GetAll()
        {
            return BillingHeadConfigDetailsRepository.GetAll();
        }

        public IEnumerable<BillingHeadConfigDetails> Filter(Expression<Func<BillingHeadConfigDetails, bool>> filter, Func<IQueryable<BillingHeadConfigDetails>, IOrderedQueryable<BillingHeadConfigDetails>> orderBy = null, string[] Children = null)
        {
            return BillingHeadConfigDetailsRepository.Filter(filter, orderBy);
        }

        public IEnumerable<BillingHeadConfigDetails> GetByPage(int pageno, int pagesize)
        {
            return BillingHeadConfigDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return BillingHeadConfigDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return BillingHeadConfigDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return BillingHeadConfigDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<BillingHeadConfigDetails, bool>> filter, Func<IQueryable<BillingHeadConfigDetails>, IOrderedQueryable<BillingHeadConfigDetails>> orderBy = null)
        {
            return BillingHeadConfigDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
