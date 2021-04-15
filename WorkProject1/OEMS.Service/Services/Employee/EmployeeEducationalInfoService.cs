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
    public class EmployeeEducationalInfoService : IService<EmployeeEducationalInfo>
    {
        private EmployeeEducationalInfoRepository EmployeeEducationalInfoRepository;

        public EmployeeEducationalInfoService()
        {
            EmployeeEducationalInfoRepository = new EmployeeEducationalInfoRepository();
        }
        public bool Add(EmployeeEducationalInfo entity)
        {
            return EmployeeEducationalInfoRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmployeeEducationalInfo> entities)
        {
            return EmployeeEducationalInfoRepository.AddRange(entities);
        }

        public IEnumerable<EmployeeEducationalInfo> Filter(Expression<Func<EmployeeEducationalInfo, bool>> filter, Func<IQueryable<EmployeeEducationalInfo>, IOrderedQueryable<EmployeeEducationalInfo>> orderBy = null, string[] Children = null)
        {
            return EmployeeEducationalInfoRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmployeeEducationalInfo, bool>> filter, Func<IQueryable<EmployeeEducationalInfo>, IOrderedQueryable<EmployeeEducationalInfo>> orderBy = null)
        {
            return EmployeeEducationalInfoRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmployeeEducationalInfo Get(long id)
        {
            return EmployeeEducationalInfoRepository.Get(id);
        }

        public IEnumerable<EmployeeEducationalInfo> GetAll()
        {
            return EmployeeEducationalInfoRepository.GetAll();
        }

        public IEnumerable<EmployeeEducationalInfo> GetByPage(int pageno, int pagesize)
        {
            return EmployeeEducationalInfoRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmployeeEducationalInfoRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmployeeEducationalInfoRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmployeeEducationalInfoRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmployeeEducationalInfo entity = new EmployeeEducationalInfo();
            entity = EmployeeEducationalInfoRepository.SingleOrDefault(e=>e.EducationalInfo_ID==id);
            //entity.IsDeleted = true;
            //entity.SetDate();
            return EmployeeEducationalInfoRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmployeeEducationalInfo> entities = new List<EmployeeEducationalInfo>();
            entities = EmployeeEducationalInfoRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EducationalInfo_ID))).ToList();

            return EmployeeEducationalInfoRepository.RemoveRange(entities);
        }

        public EmployeeEducationalInfo SingleOrDefault(Expression<Func<EmployeeEducationalInfo, bool>> filter)
        {
            return EmployeeEducationalInfoRepository.SingleOrDefault(filter);
        }

        public bool Update(EmployeeEducationalInfo entity)
        { 
            return EmployeeEducationalInfoRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmployeeEducationalInfo> entities)
        {
            return EmployeeEducationalInfoRepository.AddRange(entities);
        }
        public bool Remove(string SubjectName)
        {
            EmployeeEducationalInfo entity = new EmployeeEducationalInfo();
            entity = EmployeeEducationalInfoRepository.SingleOrDefault(e => e.ExamInstituteName == SubjectName);
            return EmployeeEducationalInfoRepository.Remove(entity);
        }

        public int GetBranchId(string SubjectName)
        {

            int branchID = EmployeeEducationalInfoRepository.SingleOrDefault(e => e.ExamInstituteName == SubjectName).EducationalInfo_ID;
            return branchID;
        }

   
    }
}
