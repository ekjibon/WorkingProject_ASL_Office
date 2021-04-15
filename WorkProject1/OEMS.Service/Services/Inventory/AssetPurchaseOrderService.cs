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
  
    public class AssetPurchaseOrderService : IService<AssetPurchaseOrder>
    {
        private AssetPurchaseOrderRepository assetPurchaseOrderRepository;

        public AssetPurchaseOrderService()
        {
            assetPurchaseOrderRepository = new AssetPurchaseOrderRepository();
        }
        public bool Add(AssetPurchaseOrder entity)
        {
            return assetPurchaseOrderRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetPurchaseOrder> entities)
        {
            return assetPurchaseOrderRepository.AddRange(entities);
        }

        public IEnumerable<AssetPurchaseOrder> Filter(Expression<Func<AssetPurchaseOrder, bool>> filter, Func<IQueryable<AssetPurchaseOrder>, IOrderedQueryable<AssetPurchaseOrder>> orderBy = null, string[] Children = null)
        {
            return assetPurchaseOrderRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetPurchaseOrder, bool>> filter, Func<IQueryable<AssetPurchaseOrder>, IOrderedQueryable<AssetPurchaseOrder>> orderBy = null)
        {
            return assetPurchaseOrderRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetPurchaseOrder Get(long id)
        {
            return assetPurchaseOrderRepository.Get(id);
        }

        public IEnumerable<AssetPurchaseOrder> GetAll()
        {
            return assetPurchaseOrderRepository.GetAll();
        }

        public IEnumerable<AssetPurchaseOrder> GetByPage(int pageno, int pagesize)
        {
            return assetPurchaseOrderRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetPurchaseOrderRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetPurchaseOrderRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetPurchaseOrderRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetPurchaseOrder entity = new AssetPurchaseOrder();
            entity = assetPurchaseOrderRepository.SingleOrDefault(e => e.POId == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            entity.SetDate();
            return assetPurchaseOrderRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetPurchaseOrder> entities = new List<AssetPurchaseOrder>();
            entities = assetPurchaseOrderRepository.Filter(x => ids.Contains(Convert.ToInt64(x.POId))).ToList();

            return assetPurchaseOrderRepository.RemoveRange(entities);
        }

        public AssetPurchaseOrder SingleOrDefault(Expression<Func<AssetPurchaseOrder, bool>> filter)
        {
            return assetPurchaseOrderRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetPurchaseOrder entity)
        {
            return assetPurchaseOrderRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetPurchaseOrder> entities)
        {
            return assetPurchaseOrderRepository.AddRange(entities);
        }
  

        public List<DropDownConfig> SearchPurchaseOrder(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 8 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
    }
}
