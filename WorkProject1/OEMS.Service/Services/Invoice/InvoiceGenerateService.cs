using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Invoice;
using OEMS.Repository.Repositories;
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
    public class InvoiceGenerateService : IService<InvoiceGenerate>
    {
        InvoiceGenerateRepository InvoiceGenerateRepository; 
        public InvoiceGenerateService() 
        {
            InvoiceGenerateRepository = new InvoiceGenerateRepository();
        }

        public bool Add(InvoiceGenerate entity)
        {
            return InvoiceGenerateRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<InvoiceGenerate> entities)
        {
            return InvoiceGenerateRepository.AddRange(entities);
        }

        public bool Update(InvoiceGenerate entity)
        {
            return InvoiceGenerateRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<InvoiceGenerate> entities)
        {
            return InvoiceGenerateRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            InvoiceGenerate entity = new InvoiceGenerate();
            entity = InvoiceGenerateRepository.SingleOrDefault(e => e.Id == id);
            return InvoiceGenerateRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<InvoiceGenerate> entities = new List<InvoiceGenerate>();
            entities = InvoiceGenerateRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return InvoiceGenerateRepository.RemoveRange(entities);
        }

        public InvoiceGenerate Get(long id)
        {
            return InvoiceGenerateRepository.Get(id);
        }

        public InvoiceGenerate SingleOrDefault(Expression<Func<InvoiceGenerate, bool>> filter)
        {
            return InvoiceGenerateRepository.SingleOrDefault(filter);
        }


        public IEnumerable<InvoiceGenerate> GetAll()
        {
            return InvoiceGenerateRepository.GetAll();
        }

        public IEnumerable<InvoiceGenerate> Filter(Expression<Func<InvoiceGenerate, bool>> filter, Func<IQueryable<InvoiceGenerate>, IOrderedQueryable<InvoiceGenerate>> orderBy = null, string[] Children = null)
        {
            return InvoiceGenerateRepository.Filter(filter, orderBy);
        }

        public IEnumerable<InvoiceGenerate> GetByPage(int pageno, int pagesize)
        {
            return InvoiceGenerateRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return InvoiceGenerateRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return InvoiceGenerateRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return InvoiceGenerateRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<InvoiceGenerate, bool>> filter, Func<IQueryable<InvoiceGenerate>, IOrderedQueryable<InvoiceGenerate>> orderBy = null)
        {
            return InvoiceGenerateRepository.Filter(pageno, pagesize, filter, orderBy);
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
        public List<DropDownConfig> SearchInvoiceNo(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 17 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
    }
}
