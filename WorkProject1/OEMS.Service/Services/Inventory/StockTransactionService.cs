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
    
    public class StockTransactionService : IService<StockTransaction>
    {
        private StockTransactionRepository stockTransactionRepository;

        public StockTransactionService()
        {
            stockTransactionRepository = new StockTransactionRepository();
        }
        public bool Add(StockTransaction entity)
        {
            return stockTransactionRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<StockTransaction> entities)
        {
            return stockTransactionRepository.AddRange(entities);
        }

        public IEnumerable<StockTransaction> Filter(Expression<Func<StockTransaction, bool>> filter, Func<IQueryable<StockTransaction>, IOrderedQueryable<StockTransaction>> orderBy = null, string[] Children = null)
        {
            return stockTransactionRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<StockTransaction, bool>> filter, Func<IQueryable<StockTransaction>, IOrderedQueryable<StockTransaction>> orderBy = null)
        {
            return stockTransactionRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public StockTransaction Get(long id)
        {
            return stockTransactionRepository.Get(id);
        }

        public IEnumerable<StockTransaction> GetAll()
        {
            return stockTransactionRepository.GetAll();
        }

        public IEnumerable<StockTransaction> GetByPage(int pageno, int pagesize)
        {
            return stockTransactionRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return stockTransactionRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return stockTransactionRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return stockTransactionRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            StockTransaction entity = new StockTransaction();
            entity = stockTransactionRepository.SingleOrDefault(e => e.TransactionId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return stockTransactionRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<StockTransaction> entities = new List<StockTransaction>();
            entities = stockTransactionRepository.Filter(x => ids.Contains(Convert.ToInt64(x.TransactionId))).ToList();

            return stockTransactionRepository.RemoveRange(entities);
        }

        public StockTransaction SingleOrDefault(Expression<Func<StockTransaction, bool>> filter)
        {
            return stockTransactionRepository.SingleOrDefault(filter);
        }

        public bool Update(StockTransaction entity)
        {
            return stockTransactionRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<StockTransaction> entities)
        {
            return stockTransactionRepository.AddRange(entities);
        }


    }
}
