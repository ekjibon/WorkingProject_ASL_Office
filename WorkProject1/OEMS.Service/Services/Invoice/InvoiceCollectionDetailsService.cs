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
    public class InvoiceCollectionDetailsService : IService<InvoiceCollectionDetails>
    {
        InvoiceCollectionDetailsRepository InvoiceCollectionDetailsRepository; 
        public InvoiceCollectionDetailsService() 
        {
            InvoiceCollectionDetailsRepository = new InvoiceCollectionDetailsRepository();
        }

        public bool Add(InvoiceCollectionDetails entity)
        {
            return InvoiceCollectionDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoiceCollectionDetails> entities)
        {
            return InvoiceCollectionDetailsRepository.AddRange(entities);
        }

        public bool Update(InvoiceCollectionDetails entity)
        {
            return InvoiceCollectionDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoiceCollectionDetails> entities)
        {
            return InvoiceCollectionDetailsRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            InvoiceCollectionDetails entity = new InvoiceCollectionDetails();
            entity = InvoiceCollectionDetailsRepository.SingleOrDefault(e => e.Id == id);
            return InvoiceCollectionDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoiceCollectionDetails> entities = new List<InvoiceCollectionDetails>();
            entities = InvoiceCollectionDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoiceCollectionDetailsRepository.RemoveRange(entities);
        }

        public InvoiceCollectionDetails Get(long id)
        {
            return InvoiceCollectionDetailsRepository.Get(id);
        }

        public InvoiceCollectionDetails SingleOrDefault(Expression<Func<InvoiceCollectionDetails, bool>> filter)
        {
            return InvoiceCollectionDetailsRepository.SingleOrDefault(filter);
        }


        public IEnumerable<InvoiceCollectionDetails> GetAll()
        {
            return InvoiceCollectionDetailsRepository.GetAll();
        }

        public IEnumerable<InvoiceCollectionDetails> Filter(Expression<Func<InvoiceCollectionDetails, bool>> filter, Func<IQueryable<InvoiceCollectionDetails>, IOrderedQueryable<InvoiceCollectionDetails>> orderBy = null, string[] Children = null)
        {
            return InvoiceCollectionDetailsRepository.Filter(filter, orderBy);
        }

        public IEnumerable<InvoiceCollectionDetails> GetByPage(int pageno, int pagesize)
        {
            return InvoiceCollectionDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoiceCollectionDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoiceCollectionDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoiceCollectionDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoiceCollectionDetails, bool>> filter, Func<IQueryable<InvoiceCollectionDetails>, IOrderedQueryable<InvoiceCollectionDetails>> orderBy = null)
        {
            return InvoiceCollectionDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }
        public string InvoiceNo(String SrtName)
        {
            string squotNo = "";
            int lastId = 0;
            lastId = (GetAll().ToList().Count != 0) ?GetAll().Last().Id : 0;
            lastId = lastId + 1;
            squotNo = SrtName + lastId.ToString("D4");
            return squotNo;
        }
    }
}
