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
    public class EmpDepartmentService : IService<EmpDepartment>
    {
        private EmpDepartmentRepository empDepartmentRepository;

        public EmpDepartmentService()
        {
            empDepartmentRepository = new EmpDepartmentRepository();
        }
        public bool Add(EmpDepartment entity)
        {
            return empDepartmentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpDepartment> entities)
        {
            return empDepartmentRepository.AddRange(entities);
        }

        public IEnumerable<EmpDepartment> Filter(Expression<Func<EmpDepartment, bool>> filter, Func<IQueryable<EmpDepartment>, IOrderedQueryable<EmpDepartment>> orderBy = null, string[] Children = null)
        {
            return empDepartmentRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpDepartment, bool>> filter, Func<IQueryable<EmpDepartment>, IOrderedQueryable<EmpDepartment>> orderBy = null)
        {
            return empDepartmentRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpDepartment Get(long id)
        {
            return empDepartmentRepository.Get(id);
        }

        public IEnumerable<EmpDepartment> GetAll()
        {
            return empDepartmentRepository.GetAll();
        }

        public IEnumerable<EmpDepartment> GetByPage(int pageno, int pagesize)
        {
            return empDepartmentRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empDepartmentRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empDepartmentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empDepartmentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpDepartment entity = new EmpDepartment();
            entity = empDepartmentRepository.SingleOrDefault(e=>e.DepartmentID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return empDepartmentRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpDepartment> entities = new List<EmpDepartment>();
            entities = empDepartmentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.DepartmentID))).ToList();

            return empDepartmentRepository.RemoveRange(entities);
        }

        public EmpDepartment SingleOrDefault(Expression<Func<EmpDepartment, bool>> filter)
        {
            return empDepartmentRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpDepartment entity)
        { 
            return empDepartmentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpDepartment> entities)
        {
            return empDepartmentRepository.AddRange(entities);
        }
        public bool Remove(string DepartmentName)
        {
            EmpDepartment entity = new EmpDepartment();
            entity = empDepartmentRepository.SingleOrDefault(e => e.DepartmentName == DepartmentName);
            return empDepartmentRepository.Remove(entity);
        }

        public int GetBranchId(string DepartmentName)
        {

            int branchID = empDepartmentRepository.SingleOrDefault(e => e.DepartmentName == DepartmentName).DepartmentID;
            return branchID;
        }
        

      
      

       

       
    }
}
