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
    public class UsersService : IService<AspNetUser>
    {
        private UsersRepository usersRepository;

        public UsersService()
        {
            usersRepository = new UsersRepository();
        }
        public bool Add(AspNetUser entity)
        {
        // entity.Id =   ( Convert.ToInt32( usersRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  usersRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AspNetUser> entities)
        {
            return usersRepository.AddRange(entities);
        }

        public IEnumerable<AspNetUser> Filter(Expression<Func<AspNetUser, bool>> filter, Func<IQueryable<AspNetUser>, IOrderedQueryable<AspNetUser>> orderBy = null, string[] Children=null)
        {
            return usersRepository.Filter(filter,orderBy,Children);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AspNetUser, bool>> filter, Func<IQueryable<AspNetUser>, IOrderedQueryable<AspNetUser>> orderBy = null)
        {
            return usersRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public AspNetUser Get(long id)
        {
            return usersRepository.Get(id);
        }

        public IEnumerable<AspNetUser> GetAll()
        {
            return usersRepository.GetAll();
        }

        public IEnumerable<AspNetUser> GetByPage(int pageno, int pagesize)
        {
            return usersRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return usersRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return usersRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return usersRepository.getResponseBySpWithParam(SpName, parameterValues);
        }
        public int GetUserEmpId(string UserName)
        {
            int emp = Convert.ToInt32(usersRepository.SingleOrDefault(u => u.UserName == UserName).EmpId);
            return emp;
        }
        public bool Remove(long id)
        {
            return false;
            //AspNetUser entity = new AspNetUser();
            //entity = usersRepository.SingleOrDefault(e=>e.Id==id);
            //return usersRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AspNetUser> entities = new List<AspNetUser>();
           // entities = usersRepository.Filter(x => ids.Contains(Convert.ToInt64(x.PageID))).ToList();
            return usersRepository.RemoveRange(entities);
        }
        public bool RemoveRange(string RoleId)
        {
           
                return false;
           // return usersRepository.RemoveRange(entities);
        }
        public string GetUserUserId(string UserName)
        {
            return usersRepository.SingleOrDefault(u => u.UserName == UserName).Id;
        }

        public AspNetUser SingleOrDefault(Expression<Func<AspNetUser, bool>> filter)
        {
            return usersRepository.SingleOrDefault(filter);
        }

        public bool Update(AspNetUser entity)
        {
            //AspNetUser _entity = usersRepository.SingleOrDefault(e => e.Id == entity.Id);
            //_entity.Name = entity.Name;
            return usersRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AspNetUser> entities)
        {
            return usersRepository.AddRange(entities);
        }

        public CommonResponse GetUsetList(int pageno, int pagesize,string searchtext)
        {
            return usersRepository.GetUsetList(pageno, pagesize,searchtext);
        }
    }
}
