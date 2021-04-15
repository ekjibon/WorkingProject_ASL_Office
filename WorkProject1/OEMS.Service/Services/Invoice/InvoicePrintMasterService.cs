using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Inventory;
using OEMS.Models.Model.Invoice;
using OEMS.Repository.Repositories;
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
    
    public  class InvoicePrintMasterService : IService<InvoicePrintMaster>
    {
        private InvoicePrintMasterRepository InvoicePrintMasterRepository;
        private CommonRepository commonRepository;

        public InvoicePrintMasterService()
        {
            InvoicePrintMasterRepository = new InvoicePrintMasterRepository();
            commonRepository = new CommonRepository();
        }
        public bool Add(InvoicePrintMaster entity)
        {
            return InvoicePrintMasterRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoicePrintMaster> entities)
        {
            return InvoicePrintMasterRepository.AddRange(entities);
        }

        public IEnumerable<InvoicePrintMaster> Filter(Expression<Func<InvoicePrintMaster, bool>> filter, Func<IQueryable<InvoicePrintMaster>, IOrderedQueryable<InvoicePrintMaster>> orderBy = null, string[] Children = null)
        {
            return InvoicePrintMasterRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoicePrintMaster, bool>> filter, Func<IQueryable<InvoicePrintMaster>, IOrderedQueryable<InvoicePrintMaster>> orderBy = null)
        {
            return InvoicePrintMasterRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public InvoicePrintMaster Get(long id)
        {
            return InvoicePrintMasterRepository.Get(id);
        }

        public IEnumerable<InvoicePrintMaster> GetAll()
        {
            return InvoicePrintMasterRepository.GetAll();
        }

        public IEnumerable<InvoicePrintMaster> GetByPage(int pageno, int pagesize)
        {
            return InvoicePrintMasterRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoicePrintMasterRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoicePrintMasterRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoicePrintMasterRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            InvoicePrintMaster entity = new InvoicePrintMaster();
            entity = InvoicePrintMasterRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return InvoicePrintMasterRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoicePrintMaster> entities = new List<InvoicePrintMaster>();
            entities = InvoicePrintMasterRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoicePrintMasterRepository.RemoveRange(entities);
        }

        public InvoicePrintMaster SingleOrDefault(Expression<Func<InvoicePrintMaster, bool>> filter)
        {
            return InvoicePrintMasterRepository.SingleOrDefault(filter);
        }

        public bool Update(InvoicePrintMaster entity)
        {
            return InvoicePrintMasterRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoicePrintMaster> entities)
        {
            return InvoicePrintMasterRepository.AddRange(entities);
        }
        public bool Remove(string InvoiceNo)
        {
            InvoicePrintMaster entity = new InvoicePrintMaster();
            entity = InvoicePrintMasterRepository.SingleOrDefault(e => e.InvoiceNo == InvoiceNo);
            return InvoicePrintMasterRepository.Remove(entity);
        }
        public List<DropDownConfig> SearchInvoice(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 19 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

    }
}
