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
    public class InvoiceCollectionMasterService : IService<InvoiceCollectionMaster>
    {
        InvoiceCollectionMasterRepository InvoiceCollectionMasterRepository; 
        public InvoiceCollectionMasterService() 
        {
            InvoiceCollectionMasterRepository = new InvoiceCollectionMasterRepository();
        }

        public bool Add(InvoiceCollectionMaster entity)
        {
            return InvoiceCollectionMasterRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoiceCollectionMaster> entities)
        {
            return InvoiceCollectionMasterRepository.AddRange(entities);
        }

        public bool Update(InvoiceCollectionMaster entity)
        {
            return InvoiceCollectionMasterRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoiceCollectionMaster> entities)
        {
            return InvoiceCollectionMasterRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            InvoiceCollectionMaster entity = new InvoiceCollectionMaster();
            entity = InvoiceCollectionMasterRepository.SingleOrDefault(e => e.Id == id);
            return InvoiceCollectionMasterRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoiceCollectionMaster> entities = new List<InvoiceCollectionMaster>();
            entities = InvoiceCollectionMasterRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoiceCollectionMasterRepository.RemoveRange(entities);
        }

        public InvoiceCollectionMaster Get(long id)
        {
            return InvoiceCollectionMasterRepository.Get(id);
        }

        public InvoiceCollectionMaster SingleOrDefault(Expression<Func<InvoiceCollectionMaster, bool>> filter)
        {
            return InvoiceCollectionMasterRepository.SingleOrDefault(filter);
        }


        public IEnumerable<InvoiceCollectionMaster> GetAll()
        {
            return InvoiceCollectionMasterRepository.GetAll();
        }

        public IEnumerable<InvoiceCollectionMaster> Filter(Expression<Func<InvoiceCollectionMaster, bool>> filter, Func<IQueryable<InvoiceCollectionMaster>, IOrderedQueryable<InvoiceCollectionMaster>> orderBy = null, string[] Children = null)
        {
            return InvoiceCollectionMasterRepository.Filter(filter, orderBy);
        }

        public IEnumerable<InvoiceCollectionMaster> GetByPage(int pageno, int pagesize)
        {
            return InvoiceCollectionMasterRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoiceCollectionMasterRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoiceCollectionMasterRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoiceCollectionMasterRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoiceCollectionMaster, bool>> filter, Func<IQueryable<InvoiceCollectionMaster>, IOrderedQueryable<InvoiceCollectionMaster>> orderBy = null)
        {
            return InvoiceCollectionMasterRepository.Filter(pageno, pagesize, filter, orderBy);
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
