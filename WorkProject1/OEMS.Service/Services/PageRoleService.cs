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
using System.Data;

namespace OEMS.Service.Services
{
    public class PageRoleService : IService<AspNetPagesRole>
    {
        private PageRoleRepository pageRoleRepository;
        private CommonRepository commonRepository =  new CommonRepository();

        public PageRoleService()
        {
            pageRoleRepository = new PageRoleRepository();
        }
        public bool Add(AspNetPagesRole entity)
        {
        // entity.Id =   ( Convert.ToInt32( PageRoleRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  pageRoleRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AspNetPagesRole> entities)
        {
            return pageRoleRepository.AddRange(entities);
        }

        public IEnumerable<AspNetPagesRole> Filter(Expression<Func<AspNetPagesRole, bool>> filter, Func<IQueryable<AspNetPagesRole>, IOrderedQueryable<AspNetPagesRole>> orderBy = null, string[] Children=null)
        {
            return pageRoleRepository.Filter(filter,orderBy,Children);
        }
        public IEnumerable<AspNetPage> GetByUserId(string UserId, int ModuleId)
        {
            List<AspNetPage> listrole = new List<AspNetPage>();
            DataTable dt = commonRepository.GetBySpWithParam("GetPageBuUserId", new object[] { UserId, ModuleId });
            listrole = CommonRepository.ConvertDataTable<AspNetPage>(dt);           
            return listrole;
        }
        public IEnumerable<AspNetPage> GetModuleByUserId(string UserId)
        {
            List<AspNetPage> listrole = new List<AspNetPage>();
            DataTable dt = commonRepository.GetBySpWithParam("GetModuleByUserId", new object[] { UserId });
            listrole = CommonRepository.ConvertDataTable<AspNetPage>(dt);
            return listrole;
        }
        public IEnumerable<AspNetPage> GetByUserId(string UserId)
        {
            List<AspNetPage> listrole = new List<AspNetPage>();
          DataTable dt =   commonRepository.GetBySpWithParam("GetPageBuUserId", new object[] { UserId });

            listrole = CommonRepository.ConvertDataTable<AspNetPage>(dt);
            //foreach (DataRow row in dt.Rows)
            //{
            //    listrole.Add(new AspNetPage
            //    {
            //        PageID = Convert.ToInt32(row[0].ToString()),
            //        ParentID = Convert.ToInt32(row[1].ToString()),
            //        IsParent = Convert.ToBoolean(row[2].ToString()),
            //        NameOption_En = row[3].ToString(),
            //        Controller = row[4]==null? string.Empty : row[4].ToString(),
            //        Action = row[5] == null ? string.Empty : row[5].ToString(),
            //        Area = row[6] == null ? string.Empty : row[6].ToString(),
            //        IconClass = row[7] == null ? string.Empty : row[7].ToString(),
            //        ActiveLi = row[8] == null ? string.Empty : row[8].ToString(),
            //        Status = row[9] == null ? string.Empty : row[9].ToString(),
            //        Displayorder = Convert.ToInt32(row[10].ToString())
            //    });
            //}
            return listrole;
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AspNetPagesRole, bool>> filter, Func<IQueryable<AspNetPagesRole>, IOrderedQueryable<AspNetPagesRole>> orderBy = null)
        {
            return pageRoleRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public AspNetPagesRole Get(long id)
        {
            return pageRoleRepository.Get(id);
        }

        public IEnumerable<AspNetPagesRole> GetAll()
        {
            return pageRoleRepository.GetAll();
        }

        public IEnumerable<AspNetPagesRole> GetByPage(int pageno, int pagesize)
        {
            return pageRoleRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return pageRoleRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return pageRoleRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return pageRoleRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AspNetPagesRole entity = new AspNetPagesRole();
            entity = pageRoleRepository.SingleOrDefault(e=>e.PageRoleId==id);
            return pageRoleRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AspNetPagesRole> entities = new List<AspNetPagesRole>();
           // entities = pageRoleRepository.Filter(x => ids.Contains(Convert.ToInt64(x.PageID))).ToList();
            return pageRoleRepository.RemoveRange(entities);
        }
        public bool RemoveRange(string RoleId)
        {
            List<AspNetPagesRole> entities = new List<AspNetPagesRole>();
            entities = pageRoleRepository.Filter(x =>x.RoleId==RoleId).ToList();
            if (entities.Count() == 0)
                return false;
            return pageRoleRepository.RemoveRange(entities);
        }
        public AspNetPagesRole SingleOrDefault(Expression<Func<AspNetPagesRole, bool>> filter)
        {
            return pageRoleRepository.SingleOrDefault(filter);
        }

        public bool Update(AspNetPagesRole entity)
        {
            //AspNetPagesRole _entity = PageRoleRepository.SingleOrDefault(e => e.Id == entity.Id);
            //_entity.Name = entity.Name;
            return pageRoleRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AspNetPagesRole> entities)
        {
            return pageRoleRepository.AddRange(entities);
        }
        

    }
}
