using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Employee;

namespace OEMS.Service.Services
{
    public class EmployeeExamGroupService : IService<EmployeeExamGroup>
    {
        private EmployeeExamGroupRepository EmployeeExamGroupRepository;

        public EmployeeExamGroupService()
        {
            EmployeeExamGroupRepository = new EmployeeExamGroupRepository();
        }
        public bool Add(EmployeeExamGroup entity)
        {
            return EmployeeExamGroupRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmployeeExamGroup> entities)
        {
            return EmployeeExamGroupRepository.AddRange(entities);
        }

        public IEnumerable<EmployeeExamGroup> Filter(Expression<Func<EmployeeExamGroup, bool>> filter, Func<IQueryable<EmployeeExamGroup>, IOrderedQueryable<EmployeeExamGroup>> orderBy = null, string[] Children = null)
        {
            return EmployeeExamGroupRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmployeeExamGroup, bool>> filter, Func<IQueryable<EmployeeExamGroup>, IOrderedQueryable<EmployeeExamGroup>> orderBy = null)
        {
            return EmployeeExamGroupRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmployeeExamGroup Get(long id)
        {
            return EmployeeExamGroupRepository.Get(id);
        }

        public IEnumerable<EmployeeExamGroup> GetAll()
        {
            return EmployeeExamGroupRepository.GetAll();
        }

        public IEnumerable<EmployeeExamGroup> GetByPage(int pageno, int pagesize)
        {
            return EmployeeExamGroupRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmployeeExamGroupRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmployeeExamGroupRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmployeeExamGroupRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmployeeExamGroup entity = new EmployeeExamGroup();
            entity = EmployeeExamGroupRepository.SingleOrDefault(e=>e.EmployeeExamGroup_ID==id);
            //entity.IsDeleted = true;
            //entity.SetDate();
            return EmployeeExamGroupRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmployeeExamGroup> entities = new List<EmployeeExamGroup>();
            entities = EmployeeExamGroupRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmployeeExamGroup_ID))).ToList();

            return EmployeeExamGroupRepository.RemoveRange(entities);
        }

        public EmployeeExamGroup SingleOrDefault(Expression<Func<EmployeeExamGroup, bool>> filter)
        {
            return EmployeeExamGroupRepository.SingleOrDefault(filter);
        }

        public bool Update(EmployeeExamGroup entity)
        { 
            return EmployeeExamGroupRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmployeeExamGroup> entities)
        {
            return EmployeeExamGroupRepository.AddRange(entities);
        }
        public bool Remove(string SectionName)
        {
            EmployeeExamGroup entity = new EmployeeExamGroup();
            entity = EmployeeExamGroupRepository.SingleOrDefault(e => e.EmployeeExamGroup_Name == SectionName);
            return EmployeeExamGroupRepository.Remove(entity);
        }

        public int GetBranchId(string SectionnName)
        {

            int branchID = EmployeeExamGroupRepository.SingleOrDefault(e => e.EmployeeExamGroup_Name == SectionnName).EmployeeExamGroup_ID;
            return branchID;
        }

   
    }
}
