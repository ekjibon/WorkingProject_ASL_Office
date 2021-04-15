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
    
    public class SupplierService : IService<Supplier>
    {
        private SupplierRepository supplierRepository;
        private CommonRepository commonRepository = new CommonRepository();

        public SupplierService()
        {
            supplierRepository = new SupplierRepository();
        }
        public bool Add(Supplier entity)
        {
            return supplierRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Supplier> entities)
        {
            return supplierRepository.AddRange(entities);
        }

        public IEnumerable<Supplier> Filter(Expression<Func<Supplier, bool>> filter, Func<IQueryable<Supplier>, IOrderedQueryable<Supplier>> orderBy = null, string[] Children = null)
        {
            return supplierRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Supplier, bool>> filter, Func<IQueryable<Supplier>, IOrderedQueryable<Supplier>> orderBy = null)
        {
            return supplierRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Supplier Get(long id)
        {
            return supplierRepository.Get(id);
        }

        public IEnumerable<Supplier> GetAll()
        {
            return supplierRepository.GetAll();
        }

        public IEnumerable<Supplier> GetByPage(int pageno, int pagesize)
        {
            return supplierRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return supplierRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return supplierRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return supplierRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Supplier entity = new Supplier();
            entity = supplierRepository.SingleOrDefault(e => e.SupplierId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return supplierRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Supplier> entities = new List<Supplier>();
            entities = supplierRepository.Filter(x => ids.Contains(Convert.ToInt64(x.SupplierId))).ToList();

            return supplierRepository.RemoveRange(entities);
        }

        public Supplier SingleOrDefault(Expression<Func<Supplier, bool>> filter)
        {
            return supplierRepository.SingleOrDefault(filter);
        }

        public bool Update(Supplier entity)
        {
            return supplierRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Supplier> entities)
        {
            return supplierRepository.AddRange(entities);
        }
        public List<DropDownConfig> SearchLedger(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetTypeHeadForInventoryLedger", new object[] { SrchText, 1 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

    }
}
