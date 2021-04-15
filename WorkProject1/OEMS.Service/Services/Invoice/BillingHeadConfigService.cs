using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Invoice;
using OEMS.Repository.Repositories.Invoice;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Invoice
{
    public class BillingHeadConfigService : IService<BillingHeadConfig>
    {
        BillingHeadConfigRepository BillingHeadConfigRepository; 
        public BillingHeadConfigService() 
        {
            BillingHeadConfigRepository = new BillingHeadConfigRepository();
        }

        public bool Add(BillingHeadConfig entity)
        {
            return BillingHeadConfigRepository.Add(entity);
        }


        public bool AddRange(IEnumerable<BillingHeadConfig> entities)
        {
            return BillingHeadConfigRepository.AddRange(entities);
        }

        public bool Update(BillingHeadConfig entity)
        {
            return BillingHeadConfigRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<BillingHeadConfig> entities)
        {
            return BillingHeadConfigRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            BillingHeadConfig entity = new BillingHeadConfig();
            entity = BillingHeadConfigRepository.SingleOrDefault(e => e.Id == id);
            return BillingHeadConfigRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<BillingHeadConfig> entities = new List<BillingHeadConfig>();
            entities = BillingHeadConfigRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return BillingHeadConfigRepository.RemoveRange(entities);
        }

        public BillingHeadConfig Get(long id)
        {
            return BillingHeadConfigRepository.Get(id);
        }

        public BillingHeadConfig SingleOrDefault(Expression<Func<BillingHeadConfig, bool>> filter)
        {
            return BillingHeadConfigRepository.SingleOrDefault(filter);
        }
        public DataTable GetBySpWithParam(string SpName, params object[] parameterValues)
        {
            return this.BillingHeadConfigRepository.GetBySpWithParam(SpName, parameterValues);
        }

        public IEnumerable<BillingHeadConfig> GetAll()
        {
            return BillingHeadConfigRepository.GetAll();
        }

        public IEnumerable<BillingHeadConfig> Filter(Expression<Func<BillingHeadConfig, bool>> filter, Func<IQueryable<BillingHeadConfig>, IOrderedQueryable<BillingHeadConfig>> orderBy = null, string[] Children = null)
        {
            return BillingHeadConfigRepository.Filter(filter, orderBy);
        }

        public IEnumerable<BillingHeadConfig> GetByPage(int pageno, int pagesize)
        {
            return BillingHeadConfigRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return BillingHeadConfigRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return BillingHeadConfigRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return BillingHeadConfigRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<BillingHeadConfig, bool>> filter, Func<IQueryable<BillingHeadConfig>, IOrderedQueryable<BillingHeadConfig>> orderBy = null)
        {
            return BillingHeadConfigRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
