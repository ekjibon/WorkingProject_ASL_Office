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
    public class BillingProcessService : IService<BillingProcess>
    {
        BillingProcessRepository BillingProcessRepository; 
        public BillingProcessService() 
        {
            BillingProcessRepository = new BillingProcessRepository();
        }

        public bool Add(BillingProcess entity)
        {
            return BillingProcessRepository.Add(entity);
        }

        public DataTable GetBySpWithParam(string SpName, params object[] parameterValues)
        {
            return this.BillingProcessRepository.GetBySpWithParam(SpName, parameterValues);
        }

        public bool AddRange(IEnumerable<BillingProcess> entities)
        {
            return BillingProcessRepository.AddRange(entities);
        }

        public bool Update(BillingProcess entity)
        {
            return BillingProcessRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<BillingProcess> entities)
        {
            return BillingProcessRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            BillingProcess entity = new BillingProcess();
            entity = BillingProcessRepository.SingleOrDefault(e => e.Id == id);
            return BillingProcessRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<BillingProcess> entities = new List<BillingProcess>();
            entities = BillingProcessRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return BillingProcessRepository.RemoveRange(entities);
        }

        public BillingProcess Get(long id)
        {
            return BillingProcessRepository.Get(id);
        }

        public BillingProcess SingleOrDefault(Expression<Func<BillingProcess, bool>> filter)
        {
            return BillingProcessRepository.SingleOrDefault(filter);
        }


        public IEnumerable<BillingProcess> GetAll()
        {
            return BillingProcessRepository.GetAll();
        }

        public IEnumerable<BillingProcess> Filter(Expression<Func<BillingProcess, bool>> filter, Func<IQueryable<BillingProcess>, IOrderedQueryable<BillingProcess>> orderBy = null, string[] Children = null)
        {
            return BillingProcessRepository.Filter(filter, orderBy);
        }

        public IEnumerable<BillingProcess> GetByPage(int pageno, int pagesize)
        {
            return BillingProcessRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return BillingProcessRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return BillingProcessRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return BillingProcessRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<BillingProcess, bool>> filter, Func<IQueryable<BillingProcess>, IOrderedQueryable<BillingProcess>> orderBy = null)
        {
            return BillingProcessRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
