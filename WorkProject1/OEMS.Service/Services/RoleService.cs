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
    public class RoleService : IService<AspNetRole>
    {
        private RoleRepository roleRepository;

        public RoleService()
        {
            roleRepository = new RoleRepository();
        }
        public bool Add(AspNetRole entity)
        {
        // entity.Id =   ( Convert.ToInt32( roleRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  roleRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AspNetRole> entities)
        {
            return roleRepository.AddRange(entities);
        }

        public IEnumerable<AspNetRole> Filter(Expression<Func<AspNetRole, bool>> filter, Func<IQueryable<AspNetRole>, IOrderedQueryable<AspNetRole>> orderBy = null, string[] Children = null)
        {
            return roleRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AspNetRole, bool>> filter, Func<IQueryable<AspNetRole>, IOrderedQueryable<AspNetRole>> orderBy = null)
        {
            return roleRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public AspNetRole Get(long id)
        {
            return roleRepository.Get(id);
        }

        public IEnumerable<AspNetRole> GetAll()
        {
            return roleRepository.GetAll();
        }

        public IEnumerable<AspNetRole> GetByPage(int pageno, int pagesize)
        {
            return roleRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return roleRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return roleRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return roleRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AspNetRole entity = new AspNetRole();
            entity = roleRepository.SingleOrDefault(e=>e.Id==id.ToString());
            return roleRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AspNetRole> entities = new List<AspNetRole>();
            entities = roleRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return roleRepository.RemoveRange(entities);
        }

        public AspNetRole SingleOrDefault(Expression<Func<AspNetRole, bool>> filter)
        {
            return roleRepository.SingleOrDefault(filter);
        }

        public bool Update(AspNetRole entity)
        {
            AspNetRole _entity = roleRepository.SingleOrDefault(e => e.Id == entity.Id);
            _entity.Name = entity.Name;

            return roleRepository.Update(_entity);
        }

        public bool UpdateRange(IEnumerable<AspNetRole> entities)
        {
            return roleRepository.AddRange(entities);
        }
        public bool Remove(string id)
        {
            AspNetRole entity = new AspNetRole();
            entity = roleRepository.SingleOrDefault(e => e.Id == id.ToString());
            return roleRepository.Remove(entity);
        }

        public string GetRolId(string RoleName)
        {
            string res = string.Empty;
            res = roleRepository.SingleOrDefault(e => e.Name == RoleName).Id;
            return res;
        }

       

    }
}
