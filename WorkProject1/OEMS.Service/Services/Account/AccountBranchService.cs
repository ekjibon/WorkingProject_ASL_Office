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
    public class AccountBranchService : IService<AccountBranchs>
    {
        private AccountBranchRepository AcBranchRepository;

        public AccountBranchService()
        {
            AcBranchRepository = new AccountBranchRepository();
        }        
        public bool Add(AccountBranchs entity)
        {        
          return AcBranchRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AccountBranchs> entities)
        {
            return AcBranchRepository.AddRange(entities);
        }

        public IEnumerable<AccountBranchs> Filter(Expression<Func<AccountBranchs, bool>> filter, Func<IQueryable<AccountBranchs>, IOrderedQueryable<AccountBranchs>> orderBy = null, string[] Children = null)
        {
            return AcBranchRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AccountBranchs, bool>> filter, Func<IQueryable<AccountBranchs>, IOrderedQueryable<AccountBranchs>> orderBy = null)
        {
            return AcBranchRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public AccountBranchs Get(long id)
        {
            return AcBranchRepository.Get(id);
        }

        public IEnumerable<AccountBranchs> GetAll()
        {
            return AcBranchRepository.GetAll();
        }      
        public IEnumerable<AccountBranchs> GetByPage(int pageno, int pagesize)
        {
            return AcBranchRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AcBranchRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AcBranchRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AcBranchRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AccountBranchs entity = new AccountBranchs();
            entity = AcBranchRepository.SingleOrDefault(a=>a.BranchId==id);
            return AcBranchRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AccountBranchs> entities = new List<AccountBranchs>();
            entities = AcBranchRepository.Filter(x => ids.Contains(Convert.ToInt64(x.BranchId))).ToList();

            return AcBranchRepository.RemoveRange(entities);
        }

        public AccountBranchs SingleOrDefault(Expression<Func<AccountBranchs, bool>> filter)
        {
            return AcBranchRepository.SingleOrDefault(filter);
        }
        
        public bool Update(AccountBranchs entity)
        { 
            return AcBranchRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AccountBranchs> entities)
        {
            return AcBranchRepository.UpdateRange(entities);
        }
       

    }
}
