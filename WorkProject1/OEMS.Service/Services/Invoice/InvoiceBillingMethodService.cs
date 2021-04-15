using OEMS.Models;
using OEMS.Models.Model.Inventory;
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
    
    public  class InvoiceBillingMethodService : IService<InvoiceBillingMethod>
    {
        private InvoiceBillingMethodRepository InvoiceBillingMethodRepository;

        public InvoiceBillingMethodService()
        {
            InvoiceBillingMethodRepository = new InvoiceBillingMethodRepository();
        }
        public bool Add(InvoiceBillingMethod entity)
        {
            return InvoiceBillingMethodRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoiceBillingMethod> entities)
        {
            return InvoiceBillingMethodRepository.AddRange(entities);
        }

        public IEnumerable<InvoiceBillingMethod> Filter(Expression<Func<InvoiceBillingMethod, bool>> filter, Func<IQueryable<InvoiceBillingMethod>, IOrderedQueryable<InvoiceBillingMethod>> orderBy = null, string[] Children = null)
        {
            return InvoiceBillingMethodRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoiceBillingMethod, bool>> filter, Func<IQueryable<InvoiceBillingMethod>, IOrderedQueryable<InvoiceBillingMethod>> orderBy = null)
        {
            return InvoiceBillingMethodRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public InvoiceBillingMethod Get(long id)
        {
            return InvoiceBillingMethodRepository.Get(id);
        }

        public IEnumerable<InvoiceBillingMethod> GetAll()
        {
            return InvoiceBillingMethodRepository.GetAll();
        }

        public IEnumerable<InvoiceBillingMethod> GetByPage(int pageno, int pagesize)
        {
            return InvoiceBillingMethodRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoiceBillingMethodRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoiceBillingMethodRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoiceBillingMethodRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            InvoiceBillingMethod entity = new InvoiceBillingMethod();
            entity = InvoiceBillingMethodRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return InvoiceBillingMethodRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoiceBillingMethod> entities = new List<InvoiceBillingMethod>();
            entities = InvoiceBillingMethodRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoiceBillingMethodRepository.RemoveRange(entities);
        }

        public InvoiceBillingMethod SingleOrDefault(Expression<Func<InvoiceBillingMethod, bool>> filter)
        {
            return InvoiceBillingMethodRepository.SingleOrDefault(filter);
        }

        public bool Update(InvoiceBillingMethod entity)
        {
            return InvoiceBillingMethodRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoiceBillingMethod> entities)
        {
            return InvoiceBillingMethodRepository.AddRange(entities);
        }
        
    }
}
