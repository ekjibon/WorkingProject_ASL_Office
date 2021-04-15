using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Inventory;
using OEMS.Repository.Repositories;
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
  
    public class AssetPurchaseOrderDetailsService : IService<AssetPurchaseOrderDetails>
    {
        private AssetPurchseOrderDetailsRepository assetPurchseOrderDetailsRepository;

        public AssetPurchaseOrderDetailsService()
        {
            assetPurchseOrderDetailsRepository = new AssetPurchseOrderDetailsRepository();
        }
        public bool Add(AssetPurchaseOrderDetails entity)
        {
            return assetPurchseOrderDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetPurchaseOrderDetails> entities)
        {
            return assetPurchseOrderDetailsRepository.AddRange(entities);
        }

        public IEnumerable<AssetPurchaseOrderDetails> Filter(Expression<Func<AssetPurchaseOrderDetails, bool>> filter, Func<IQueryable<AssetPurchaseOrderDetails>, IOrderedQueryable<AssetPurchaseOrderDetails>> orderBy = null, string[] Children = null)
        {
            return assetPurchseOrderDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetPurchaseOrderDetails, bool>> filter, Func<IQueryable<AssetPurchaseOrderDetails>, IOrderedQueryable<AssetPurchaseOrderDetails>> orderBy = null)
        {
            return assetPurchseOrderDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetPurchaseOrderDetails Get(long id)
        {
            return assetPurchseOrderDetailsRepository.Get(id);
        }

        public IEnumerable<AssetPurchaseOrderDetails> GetAll()
        {
            return assetPurchseOrderDetailsRepository.GetAll();
        }

        public IEnumerable<AssetPurchaseOrderDetails> GetByPage(int pageno, int pagesize)
        {
            return assetPurchseOrderDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetPurchseOrderDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetPurchseOrderDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetPurchseOrderDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetPurchaseOrderDetails entity = new AssetPurchaseOrderDetails();
            entity = assetPurchseOrderDetailsRepository.SingleOrDefault(e => e.POId == id);
            //entity.IsDeleted = true;
            //entity.Status = "D";
            //entity.SetDate();
            return assetPurchseOrderDetailsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetPurchaseOrderDetails> entities = new List<AssetPurchaseOrderDetails>();
            entities = assetPurchseOrderDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.POId))).ToList();

            return assetPurchseOrderDetailsRepository.RemoveRange(entities);
        }

        public AssetPurchaseOrderDetails SingleOrDefault(Expression<Func<AssetPurchaseOrderDetails, bool>> filter)
        {
            return assetPurchseOrderDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetPurchaseOrderDetails entity)
        {
            return assetPurchseOrderDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetPurchaseOrderDetails> entities)
        {
            return assetPurchseOrderDetailsRepository.AddRange(entities);
        }
  

        public List<DropDownConfig> SearchPurchaseOrder(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 8 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
    }
}
