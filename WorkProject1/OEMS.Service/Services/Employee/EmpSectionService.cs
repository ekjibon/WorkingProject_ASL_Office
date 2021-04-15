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
    public class EmpSectionService : IService<EmpSection>
    {
        private EmpSectionRepository EmpSectionRepository;

        public EmpSectionService()
        {
            EmpSectionRepository = new EmpSectionRepository();
        }
        public bool Add(EmpSection entity)
        {
            return EmpSectionRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpSection> entities)
        {
            return EmpSectionRepository.AddRange(entities);
        }

        public IEnumerable<EmpSection> Filter(Expression<Func<EmpSection, bool>> filter, Func<IQueryable<EmpSection>, IOrderedQueryable<EmpSection>> orderBy = null, string[] Children = null)
        {
            return EmpSectionRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpSection, bool>> filter, Func<IQueryable<EmpSection>, IOrderedQueryable<EmpSection>> orderBy = null)
        {
            return EmpSectionRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpSection Get(long id)
        {
            return EmpSectionRepository.Get(id);
        }

        public IEnumerable<EmpSection> GetAll()
        {
            return EmpSectionRepository.GetAll();
        }

        public IEnumerable<EmpSection> GetByPage(int pageno, int pagesize)
        {
            return EmpSectionRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpSectionRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpSectionRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpSectionRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpSection entity = new EmpSection();
            entity = EmpSectionRepository.SingleOrDefault(e=>e.SectionID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpSectionRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpSection> entities = new List<EmpSection>();
            entities = EmpSectionRepository.Filter(x => ids.Contains(Convert.ToInt64(x.SectionID))).ToList();

            return EmpSectionRepository.RemoveRange(entities);
        }

        public EmpSection SingleOrDefault(Expression<Func<EmpSection, bool>> filter)
        {
            return EmpSectionRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpSection entity)
        { 
            return EmpSectionRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpSection> entities)
        {
            return EmpSectionRepository.AddRange(entities);
        }
        public bool Remove(string SectionName)
        {
            EmpSection entity = new EmpSection();
            entity = EmpSectionRepository.SingleOrDefault(e => e.SectionName == SectionName);
            return EmpSectionRepository.Remove(entity);
        }

        public int GetBranchId(string SectionnName)
        {

            int branchID = EmpSectionRepository.SingleOrDefault(e => e.SectionName == SectionnName).SectionID;
            return branchID;
        }

   
    }
}
