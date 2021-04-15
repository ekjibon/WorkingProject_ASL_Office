using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;

namespace OEMS.Service.Services.Account
{
    public class TransactionService : IService<Transaction>
    {
        private TransactionRepository TransactionRepository;

        public TransactionService()
        {
            TransactionRepository = new TransactionRepository();
        }        
        public bool Add(Transaction entity)
        {        
          return  TransactionRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Transaction> entities)
        {
            return TransactionRepository.AddRange(entities);
        }

        public IEnumerable<Transaction> Filter(Expression<Func<Transaction, bool>> filter, Func<IQueryable<Transaction>, IOrderedQueryable<Transaction>> orderBy = null, string[] Children = null)
        {
            return TransactionRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Transaction, bool>> filter, Func<IQueryable<Transaction>, IOrderedQueryable<Transaction>> orderBy = null)
        {
            return TransactionRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Transaction Get(long id)
        {
            return TransactionRepository.Get(id);
        }

        public IEnumerable<Transaction> GetAll()
        {
            return TransactionRepository.GetAll();
        }      
        public IEnumerable<Transaction> GetByPage(int pageno, int pagesize)
        {
            return TransactionRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return TransactionRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return TransactionRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return TransactionRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Transaction entity = new Transaction();
            entity = TransactionRepository.SingleOrDefault(e=>e.Id==id);
            return TransactionRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Transaction> entities = new List<Transaction>();
            entities = TransactionRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return TransactionRepository.RemoveRange(entities);
        }

        public Transaction SingleOrDefault(Expression<Func<Transaction, bool>> filter)
        {
            return TransactionRepository.SingleOrDefault(filter);
        }
      
        public bool Update(Transaction entity)
        { 
            return TransactionRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Transaction> entities)
        {
            return TransactionRepository.UpdateRange(entities);
        }
       

    }
}
