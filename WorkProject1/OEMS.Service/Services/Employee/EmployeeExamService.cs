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
    public class EmployeeExamService : IService<EmployeeExam>
    {
        private EmployeeExamRepository EmployeeExamRepository;

        public EmployeeExamService()
        {
            EmployeeExamRepository = new EmployeeExamRepository();
        }
        public bool Add(EmployeeExam entity)
        {
            return EmployeeExamRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmployeeExam> entities)
        {
            return EmployeeExamRepository.AddRange(entities);
        }

        public IEnumerable<EmployeeExam> Filter(Expression<Func<EmployeeExam, bool>> filter, Func<IQueryable<EmployeeExam>, IOrderedQueryable<EmployeeExam>> orderBy = null, string[] Children = null)
        {
            return EmployeeExamRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmployeeExam, bool>> filter, Func<IQueryable<EmployeeExam>, IOrderedQueryable<EmployeeExam>> orderBy = null)
        {
            return EmployeeExamRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmployeeExam Get(long id)
        {
            return EmployeeExamRepository.Get(id);
        }

        public IEnumerable<EmployeeExam> GetAll()
        {
            return EmployeeExamRepository.GetAll();
        }

        public IEnumerable<EmployeeExam> GetByPage(int pageno, int pagesize)
        {
            return EmployeeExamRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmployeeExamRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmployeeExamRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmployeeExamRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmployeeExam entity = new EmployeeExam();
            entity = EmployeeExamRepository.SingleOrDefault(e=>e.EmployeeExam_ID==id);
            //entity.IsDeleted = true;
            //entity.SetDate();
            return EmployeeExamRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmployeeExam> entities = new List<EmployeeExam>();
            entities = EmployeeExamRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmployeeExam_ID))).ToList();

            return EmployeeExamRepository.RemoveRange(entities);
        }

        public EmployeeExam SingleOrDefault(Expression<Func<EmployeeExam, bool>> filter)
        {
            return EmployeeExamRepository.SingleOrDefault(filter);
        }

        public bool Update(EmployeeExam entity)
        { 
            return EmployeeExamRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmployeeExam> entities)
        {
            return EmployeeExamRepository.AddRange(entities);
        }
        public bool Remove(string ShiftName)
        {
            EmployeeExam entity = new EmployeeExam();
            entity = EmployeeExamRepository.SingleOrDefault(e => e.EmployeeExam_Name == ShiftName);
            return EmployeeExamRepository.Remove(entity);
        }

        public int GetBranchId(string ShiftName)
        {

            int branchID = EmployeeExamRepository.SingleOrDefault(e => e.EmployeeExam_Name == ShiftName).EmployeeExam_ID;
            return branchID;
        }

   
    }
}
