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
   public  class QuotationDetailsService : IService<QuotationDetails>
    {
        private QuotationDetailsRepository quotationDetailsRepository;

        public QuotationDetailsService()
        {
            quotationDetailsRepository = new QuotationDetailsRepository();
        }
        public bool Add(QuotationDetails entity)
        {
            return quotationDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<QuotationDetails> entities)
        {
            return quotationDetailsRepository.AddRange(entities);
        }

        public IEnumerable<QuotationDetails> Filter(Expression<Func<QuotationDetails, bool>> filter, Func<IQueryable<QuotationDetails>, IOrderedQueryable<QuotationDetails>> orderBy = null, string[] Children = null)
        {
            return quotationDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<QuotationDetails, bool>> filter, Func<IQueryable<QuotationDetails>, IOrderedQueryable<QuotationDetails>> orderBy = null)
        {
            return quotationDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public QuotationDetails Get(long id)
        {
            return quotationDetailsRepository.Get(id);
        }

        public IEnumerable<QuotationDetails> GetAll()
        {
            return quotationDetailsRepository.GetAll();
        }

        public IEnumerable<QuotationDetails> GetByPage(int pageno, int pagesize)
        {
            return quotationDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return quotationDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return quotationDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return quotationDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            QuotationDetails entity = new QuotationDetails();
            entity = quotationDetailsRepository.SingleOrDefault(e => e.QuotationDetailsId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return quotationDetailsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<QuotationDetails> entities = new List<QuotationDetails>();
            entities = quotationDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.QuotationDetailsId))).ToList();

            return quotationDetailsRepository.RemoveRange(entities);
        }

        public QuotationDetails SingleOrDefault(Expression<Func<QuotationDetails, bool>> filter)
        {
            return quotationDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(QuotationDetails entity)
        {
            return quotationDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<QuotationDetails> entities)
        {
            return quotationDetailsRepository.AddRange(entities);
        }


    }
}
