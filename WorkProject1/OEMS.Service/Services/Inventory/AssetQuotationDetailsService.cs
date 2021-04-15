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
   public  class AssetQuotationDetailsService : IService<AssetQuotationDetails>
    {
        private AssetQuotationDetailsRepository assetQuotationDetailsRepository;

        public AssetQuotationDetailsService()
        {
            assetQuotationDetailsRepository = new AssetQuotationDetailsRepository();
        }
        public bool Add(AssetQuotationDetails entity)
        {
            return assetQuotationDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetQuotationDetails> entities)
        {
            return assetQuotationDetailsRepository.AddRange(entities);
        }

        public IEnumerable<AssetQuotationDetails> Filter(Expression<Func<AssetQuotationDetails, bool>> filter, Func<IQueryable<AssetQuotationDetails>, IOrderedQueryable<AssetQuotationDetails>> orderBy = null, string[] Children = null)
        {
            return assetQuotationDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetQuotationDetails, bool>> filter, Func<IQueryable<AssetQuotationDetails>, IOrderedQueryable<AssetQuotationDetails>> orderBy = null)
        {
            return assetQuotationDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetQuotationDetails Get(long id)
        {
            return assetQuotationDetailsRepository.Get(id);
        }

        public IEnumerable<AssetQuotationDetails> GetAll()
        {
            return assetQuotationDetailsRepository.GetAll();
        }

        public IEnumerable<AssetQuotationDetails> GetByPage(int pageno, int pagesize)
        {
            return assetQuotationDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetQuotationDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetQuotationDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetQuotationDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetQuotationDetails entity = new AssetQuotationDetails();
            entity = assetQuotationDetailsRepository.SingleOrDefault(e => e.QuotationDetailsId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return assetQuotationDetailsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetQuotationDetails> entities = new List<AssetQuotationDetails>();
            entities = assetQuotationDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.QuotationDetailsId))).ToList();

            return assetQuotationDetailsRepository.RemoveRange(entities);
        }

        public AssetQuotationDetails SingleOrDefault(Expression<Func<AssetQuotationDetails, bool>> filter)
        {
            return assetQuotationDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetQuotationDetails entity)
        {
            return assetQuotationDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetQuotationDetails> entities)
        {
            return assetQuotationDetailsRepository.AddRange(entities);
        }


    }
}
