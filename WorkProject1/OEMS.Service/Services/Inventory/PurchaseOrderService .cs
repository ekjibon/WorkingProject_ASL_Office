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
  
    public class PurchaseOrderService : IService<PurchaseOrder>
    {
        private PurchaseOrderRepository purchaseOrderRepository;

        public PurchaseOrderService()
        {
            purchaseOrderRepository = new PurchaseOrderRepository();
        }
        public bool Add(PurchaseOrder entity)
        {
            return purchaseOrderRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<PurchaseOrder> entities)
        {
            return purchaseOrderRepository.AddRange(entities);
        }

        public IEnumerable<PurchaseOrder> Filter(Expression<Func<PurchaseOrder, bool>> filter, Func<IQueryable<PurchaseOrder>, IOrderedQueryable<PurchaseOrder>> orderBy = null, string[] Children = null)
        {
            return purchaseOrderRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<PurchaseOrder, bool>> filter, Func<IQueryable<PurchaseOrder>, IOrderedQueryable<PurchaseOrder>> orderBy = null)
        {
            return purchaseOrderRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public PurchaseOrder Get(long id)
        {
            return purchaseOrderRepository.Get(id);
        }

        public IEnumerable<PurchaseOrder> GetAll()
        {
            return purchaseOrderRepository.GetAll();
        }

        public IEnumerable<PurchaseOrder> GetByPage(int pageno, int pagesize)
        {
            return purchaseOrderRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return purchaseOrderRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return purchaseOrderRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return purchaseOrderRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            PurchaseOrder entity = new PurchaseOrder();
            entity = purchaseOrderRepository.SingleOrDefault(e => e.POId == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            entity.SetDate();
            return purchaseOrderRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<PurchaseOrder> entities = new List<PurchaseOrder>();
            entities = purchaseOrderRepository.Filter(x => ids.Contains(Convert.ToInt64(x.POId))).ToList();

            return purchaseOrderRepository.RemoveRange(entities);
        }

        public PurchaseOrder SingleOrDefault(Expression<Func<PurchaseOrder, bool>> filter)
        {
            return purchaseOrderRepository.SingleOrDefault(filter);
        }

        public bool Update(PurchaseOrder entity)
        {
            return purchaseOrderRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<PurchaseOrder> entities)
        {
            return purchaseOrderRepository.AddRange(entities);
        }
  

        public List<DropDownConfig> SearchPurchaseOrder(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 8 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
    }
}
