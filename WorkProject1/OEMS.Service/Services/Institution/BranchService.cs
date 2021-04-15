using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;


namespace OEMS.Service.Services
{
    public class BranchService : IService<Branch> 
    {
        private BranchRepository branchRepository;

        public BranchService()
        {
            branchRepository = new BranchRepository();
        }
        public bool Add(Branch entity)
        {            
            return  branchRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Branch> entities)
        {
            return branchRepository.AddRange(entities);
        }

        public IEnumerable<Branch> Filter(Expression<Func<Branch, bool>> filter, Func<IQueryable<Branch>, IOrderedQueryable<Branch>> orderBy = null, string[] Children = null)
        {
            return branchRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Branch, bool>> filter, Func<IQueryable<Branch>, IOrderedQueryable<Branch>> orderBy = null)
        {
            return branchRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Branch Get(long id)
        {
            return branchRepository.Get(id);
        }

        public IEnumerable<Branch> GetAll()
        {
            return branchRepository.GetAll();
        }

        public IEnumerable<Branch> GetByPage(int pageno, int pagesize)
        {
            return branchRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return branchRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return branchRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return branchRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Branch entity = new Branch();
            entity = branchRepository.SingleOrDefault(e=>e.BranchId==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return branchRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Branch> entities = new List<Branch>();
            entities = branchRepository.Filter(x => ids.Contains(Convert.ToInt64(x.BranchId))).ToList();

            return branchRepository.RemoveRange(entities);
        }

        public Branch SingleOrDefault(Expression<Func<Branch, bool>> filter)
        {
            return branchRepository.SingleOrDefault(filter);
        }

        public bool Update(Branch entity)
        { 
            return branchRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Branch> entities)
        {
            return branchRepository.AddRange(entities);
        }
        public bool Remove(string branchName)
        {
            Branch entity = new Branch();
            entity = branchRepository.SingleOrDefault(e => e.BranchName == branchName);
            return branchRepository.Remove(entity);
        }

        public int GetBranchId(string branchName)
        {

            int branchID = branchRepository.SingleOrDefault(e => e.BranchName == branchName).BranchId;
            return branchID;
        }

    }
}
