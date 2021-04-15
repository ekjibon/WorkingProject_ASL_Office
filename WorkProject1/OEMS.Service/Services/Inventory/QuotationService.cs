using OEMS.Models;
using OEMS.Models.Model.Inventory;
using OEMS.Repository.Repositories.Inventory;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Inventory
{
    
    public class QuotationService : IService<Quotation>
    {
        private QuotationRepositry quotationRepositry;

        public QuotationService()
        {
            quotationRepositry = new QuotationRepositry();
        }
        public bool Add(Quotation entity)
        {
            return quotationRepositry.Add(entity);
        }

        public bool AddRange(IEnumerable<Quotation> entities)
        {
            return quotationRepositry.AddRange(entities);
        }

        public IEnumerable<Quotation> Filter(Expression<Func<Quotation, bool>> filter, Func<IQueryable<Quotation>, IOrderedQueryable<Quotation>> orderBy = null, string[] Children = null)
        {
            return quotationRepositry.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Quotation, bool>> filter, Func<IQueryable<Quotation>, IOrderedQueryable<Quotation>> orderBy = null)
        {
            return quotationRepositry.Filter(pageno, pagesize, filter, orderBy);
        }
        public CommonResponse getDataSetResponseBySp(string SpName)
        {
            return quotationRepositry.getDatasetResponseBySp(SpName);
        }
        public Quotation Get(long id)
        {
            return quotationRepositry.Get(id);
        }

        public IEnumerable<Quotation> GetAll()
        {
            return quotationRepositry.GetAll();
        }

        public IEnumerable<Quotation> GetByPage(int pageno, int pagesize)
        {
            return quotationRepositry.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return quotationRepositry.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return quotationRepositry.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return quotationRepositry.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Quotation entity = new Quotation();
            entity = quotationRepositry.SingleOrDefault(e => e.QuotationId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return quotationRepositry.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Quotation> entities = new List<Quotation>();
            entities = quotationRepositry.Filter(x => ids.Contains(Convert.ToInt64(x.QuotationId))).ToList();

            return quotationRepositry.RemoveRange(entities);
        }

        public Quotation SingleOrDefault(Expression<Func<Quotation, bool>> filter)
        {
            return quotationRepositry.SingleOrDefault(filter);
        }

        public bool Update(Quotation entity)
        {
            return quotationRepositry.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Quotation> entities)
        {
            return quotationRepositry.AddRange(entities);
        }


    }
}
