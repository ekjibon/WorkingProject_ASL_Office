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
    
    public  class InvoiceBillingHeadService : IService<InvoiceBillingHead>
    {
        private InvoiceBillingHeadRepository InvoiceBillingHeadRepository;

        public InvoiceBillingHeadService()
        {
            InvoiceBillingHeadRepository = new InvoiceBillingHeadRepository();
        }
        public bool Add(InvoiceBillingHead entity)
        {
            return InvoiceBillingHeadRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoiceBillingHead> entities)
        {
            return InvoiceBillingHeadRepository.AddRange(entities);
        }

        public IEnumerable<InvoiceBillingHead> Filter(Expression<Func<InvoiceBillingHead, bool>> filter, Func<IQueryable<InvoiceBillingHead>, IOrderedQueryable<InvoiceBillingHead>> orderBy = null, string[] Children = null)
        {
            return InvoiceBillingHeadRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoiceBillingHead, bool>> filter, Func<IQueryable<InvoiceBillingHead>, IOrderedQueryable<InvoiceBillingHead>> orderBy = null)
        {
            return InvoiceBillingHeadRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public InvoiceBillingHead Get(long id)
        {
            return InvoiceBillingHeadRepository.Get(id);
        }

        public IEnumerable<InvoiceBillingHead> GetAll()
        {
            return InvoiceBillingHeadRepository.GetAll();
        }

        public IEnumerable<InvoiceBillingHead> GetByPage(int pageno, int pagesize)
        {
            return InvoiceBillingHeadRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoiceBillingHeadRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoiceBillingHeadRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoiceBillingHeadRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            InvoiceBillingHead entity = new InvoiceBillingHead();
            entity = InvoiceBillingHeadRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return InvoiceBillingHeadRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoiceBillingHead> entities = new List<InvoiceBillingHead>();
            entities = InvoiceBillingHeadRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoiceBillingHeadRepository.RemoveRange(entities);
        }

        public InvoiceBillingHead SingleOrDefault(Expression<Func<InvoiceBillingHead, bool>> filter)
        {
            return InvoiceBillingHeadRepository.SingleOrDefault(filter);
        }

        public bool Update(InvoiceBillingHead entity)
        {
            return InvoiceBillingHeadRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoiceBillingHead> entities)
        {
            return InvoiceBillingHeadRepository.AddRange(entities);
        }
        
    }
}
