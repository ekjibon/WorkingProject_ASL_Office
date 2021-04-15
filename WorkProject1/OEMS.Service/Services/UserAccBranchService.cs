using OEMS.Models;
using OEMS.Models.Model.Account;
using OEMS.Service.Interface;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services
{
    public class UserAccBranchService : IService<UserAccBranch>
    {
        private UserAccBranchRepository userAccBranchRepository;

        public UserAccBranchService()
        {
            userAccBranchRepository = new UserAccBranchRepository();
        }
        public bool Add(UserAccBranch entity)
        {
            // entity.Id =   ( Convert.ToInt32( usersRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
            return userAccBranchRepository.Add(entity);
        }
        public bool AddRange(IEnumerable<UserAccBranch> entities)
        {
            return userAccBranchRepository.AddRange(entities);
        }

        public IEnumerable<UserAccBranch> Filter(Expression<Func<UserAccBranch, bool>> filter, Func<IQueryable<UserAccBranch>, IOrderedQueryable<UserAccBranch>> orderBy = null, string[] Children = null)
        {
            return userAccBranchRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<UserAccBranch, bool>> filter, Func<IQueryable<UserAccBranch>, IOrderedQueryable<UserAccBranch>> orderBy = null)
        {
            return userAccBranchRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public UserAccBranch Get(long id)
        {
            return userAccBranchRepository.Get(id);
        }

        public IEnumerable<UserAccBranch> GetAll()
        {
            return userAccBranchRepository.GetAll();
        }

        public IEnumerable<UserAccBranch> GetByPage(int pageno, int pagesize)
        {
            return userAccBranchRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return userAccBranchRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return userAccBranchRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return userAccBranchRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            UserAccBranch entity = new UserAccBranch();
            entity = userAccBranchRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return userAccBranchRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<UserAccBranch> entities = new List<UserAccBranch>();
            entities = userAccBranchRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return userAccBranchRepository.RemoveRange(entities);
        }

        public UserAccBranch SingleOrDefault(Expression<Func<UserAccBranch, bool>> filter)
        {
            return userAccBranchRepository.SingleOrDefault(filter);
        }

        public bool Update(UserAccBranch entity)
        {
            return userAccBranchRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<UserAccBranch> entities)
        {
            return userAccBranchRepository.AddRange(entities);
        }
        public bool Remove(int Id)
        {
            UserAccBranch entity = new UserAccBranch();
            entity = userAccBranchRepository.SingleOrDefault(e => e.Id == Id);
            return userAccBranchRepository.Remove(entity);
        }

        public int GetId(string userId)
        {

            int id = userAccBranchRepository.SingleOrDefault(e => e.UserId == userId).Id;
            return id;
        }
    }
}
