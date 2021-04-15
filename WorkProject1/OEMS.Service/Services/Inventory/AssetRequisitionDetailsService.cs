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
    
   public  class AssetRequisitionDetailsService : IService<AssetRequisitionDetails>
    {
        private AssetRequisitionDetailsRepository assetRequisitionDetailsRepository;

        public AssetRequisitionDetailsService()
        {
            assetRequisitionDetailsRepository = new AssetRequisitionDetailsRepository();
        }
        public bool Add(AssetRequisitionDetails entity)
        {
            return assetRequisitionDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetRequisitionDetails> entities)
        {
            return assetRequisitionDetailsRepository.AddRange(entities);
        }

        public IEnumerable<AssetRequisitionDetails> Filter(Expression<Func<AssetRequisitionDetails, bool>> filter, Func<IQueryable<AssetRequisitionDetails>, IOrderedQueryable<AssetRequisitionDetails>> orderBy = null, string[] Children = null)
        {
            return assetRequisitionDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetRequisitionDetails, bool>> filter, Func<IQueryable<AssetRequisitionDetails>, IOrderedQueryable<AssetRequisitionDetails>> orderBy = null)
        {
            return assetRequisitionDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetRequisitionDetails Get(long id)
        {
            return assetRequisitionDetailsRepository.Get(id);
        }

        public IEnumerable<AssetRequisitionDetails> GetAll()
        {
            return assetRequisitionDetailsRepository.GetAll();
        }

        public IEnumerable<AssetRequisitionDetails> GetByPage(int pageno, int pagesize)
        {
            return assetRequisitionDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetRequisitionDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetRequisitionDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetRequisitionDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetRequisitionDetails entity = new AssetRequisitionDetails();
            entity = assetRequisitionDetailsRepository.SingleOrDefault(e => e.ReqDetailsId == id);
            //entity.IsDeleted = true;
            //entity.SetDate();
            return assetRequisitionDetailsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetRequisitionDetails> entities = new List<AssetRequisitionDetails>();
            entities = assetRequisitionDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ReqDetailsId))).ToList();

            return assetRequisitionDetailsRepository.RemoveRange(entities);
        }

        public AssetRequisitionDetails SingleOrDefault(Expression<Func<AssetRequisitionDetails, bool>> filter)
        {
            return assetRequisitionDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetRequisitionDetails entity)
        {
            return assetRequisitionDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetRequisitionDetails> entities)
        {
            return assetRequisitionDetailsRepository.AddRange(entities);
        }


    }
}
