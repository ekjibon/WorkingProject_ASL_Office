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
    
    public class AssetQuotationService : IService<AssetQuotation>
    {
        private AssetQuotationRepository assetquotationRepository;

        public AssetQuotationService()
        {
            assetquotationRepository = new AssetQuotationRepository();
        }
        public bool Add(AssetQuotation entity)
        {
            return assetquotationRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetQuotation> entities)
        {
            return assetquotationRepository.AddRange(entities);
        }

        public IEnumerable<AssetQuotation> Filter(Expression<Func<AssetQuotation, bool>> filter, Func<IQueryable<AssetQuotation>, IOrderedQueryable<AssetQuotation>> orderBy = null, string[] Children = null)
        {
            return assetquotationRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetQuotation, bool>> filter, Func<IQueryable<AssetQuotation>, IOrderedQueryable<AssetQuotation>> orderBy = null)
        {
            return assetquotationRepository.Filter(pageno, pagesize, filter, orderBy);
        }
        public CommonResponse getDataSetResponseBySp(string SpName)
        {
            return assetquotationRepository.getDatasetResponseBySp(SpName);
        }
        public AssetQuotation Get(long id)
        {
            return assetquotationRepository.Get(id);
        }

        public IEnumerable<AssetQuotation> GetAll()
        {
            return assetquotationRepository.GetAll();
        }

        public IEnumerable<AssetQuotation> GetByPage(int pageno, int pagesize)
        {
            return assetquotationRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetquotationRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetquotationRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetquotationRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetQuotation entity = new AssetQuotation();
            entity = assetquotationRepository.SingleOrDefault(e => e.QuotationId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return assetquotationRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetQuotation> entities = new List<AssetQuotation>();
            entities = assetquotationRepository.Filter(x => ids.Contains(Convert.ToInt64(x.QuotationId))).ToList();

            return assetquotationRepository.RemoveRange(entities);
        }

        public AssetQuotation SingleOrDefault(Expression<Func<AssetQuotation, bool>> filter)
        {
            return assetquotationRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetQuotation entity)
        {
            return assetquotationRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetQuotation> entities)
        {
            return assetquotationRepository.AddRange(entities);
        }


    }
}
