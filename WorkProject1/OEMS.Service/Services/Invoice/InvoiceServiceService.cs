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
    
    public  class InvoiceServiceService : IService<InvoiceService>
    {
        private InvoiceServiceRepository InvoiceServiceRepository;

        public InvoiceServiceService()
        {
            InvoiceServiceRepository = new InvoiceServiceRepository();
        }
        public bool Add(InvoiceService entity)
        {
            return InvoiceServiceRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoiceService> entities)
        {
            return InvoiceServiceRepository.AddRange(entities);
        }

        public IEnumerable<InvoiceService> Filter(Expression<Func<InvoiceService, bool>> filter, Func<IQueryable<InvoiceService>, IOrderedQueryable<InvoiceService>> orderBy = null, string[] Children = null)
        {
            return InvoiceServiceRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoiceService, bool>> filter, Func<IQueryable<InvoiceService>, IOrderedQueryable<InvoiceService>> orderBy = null)
        {
            return InvoiceServiceRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public InvoiceService Get(long id)
        {
            return InvoiceServiceRepository.Get(id);
        }

        public IEnumerable<InvoiceService> GetAll()
        {
            return InvoiceServiceRepository.GetAll();
        }

        public IEnumerable<InvoiceService> GetByPage(int pageno, int pagesize)
        {
            return InvoiceServiceRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoiceServiceRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoiceServiceRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoiceServiceRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            InvoiceService entity = new InvoiceService();
            entity = InvoiceServiceRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return InvoiceServiceRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoiceService> entities = new List<InvoiceService>();
            entities = InvoiceServiceRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoiceServiceRepository.RemoveRange(entities);
        }

        public InvoiceService SingleOrDefault(Expression<Func<InvoiceService, bool>> filter)
        {
            return InvoiceServiceRepository.SingleOrDefault(filter);
        }

        public bool Update(InvoiceService entity)
        {
            return InvoiceServiceRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoiceService> entities)
        {
            return InvoiceServiceRepository.AddRange(entities);
        }
        public bool Remove(string categoryName)
        {
            InvoiceService entity = new InvoiceService();
            entity = InvoiceServiceRepository.SingleOrDefault(e => e.ServiceName == categoryName);
            return InvoiceServiceRepository.Remove(entity);
        }


    }
}
