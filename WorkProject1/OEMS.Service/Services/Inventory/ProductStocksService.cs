
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
    
    public  class ProductStocksService : IService<ProductStocks>
    {
        private ProductStocksRepository productStocksRepository;

        public ProductStocksService()
        {
            productStocksRepository = new ProductStocksRepository();
        }
        public bool Add(ProductStocks entity)
        {
            return productStocksRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ProductStocks> entities)
        {
            return productStocksRepository.AddRange(entities);
        }

        public IEnumerable<ProductStocks> Filter(Expression<Func<ProductStocks, bool>> filter, Func<IQueryable<ProductStocks>, IOrderedQueryable<ProductStocks>> orderBy = null, string[] Children = null)
        {
            return productStocksRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ProductStocks, bool>> filter, Func<IQueryable<ProductStocks>, IOrderedQueryable<ProductStocks>> orderBy = null)
        {
            return productStocksRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public ProductStocks Get(long id)
        {
            return productStocksRepository.Get(id);
        }

        public IEnumerable<ProductStocks> GetAll()
        {
            return productStocksRepository.GetAll();
        }

        public IEnumerable<ProductStocks> GetByPage(int pageno, int pagesize)
        {
            return productStocksRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return productStocksRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return productStocksRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return productStocksRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ProductStocks entity = new ProductStocks();
            entity = productStocksRepository.SingleOrDefault(e => e.StockId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return productStocksRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ProductStocks> entities = new List<ProductStocks>();
            entities = productStocksRepository.Filter(x => ids.Contains(Convert.ToInt64(x.StockId))).ToList();

            return productStocksRepository.RemoveRange(entities);
        }

        public ProductStocks SingleOrDefault(Expression<Func<ProductStocks, bool>> filter)
        {
            return productStocksRepository.SingleOrDefault(filter);
        }

        public bool Update(ProductStocks entity)
        {
            return productStocksRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ProductStocks> entities)
        {
            return productStocksRepository.AddRange(entities);
        }
   

    }
}
