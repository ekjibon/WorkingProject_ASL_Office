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
    public class EmpDesignationtService : IService<EmpDesignation>
    {
        private EmpDesignationRepository EmpDesignationRepository;

        public EmpDesignationtService()
        {
            EmpDesignationRepository = new EmpDesignationRepository();
        }
        public bool Add(EmpDesignation entity)
        {
            return EmpDesignationRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpDesignation> entities)
        {
            return EmpDesignationRepository.AddRange(entities);
        }

        public IEnumerable<EmpDesignation> Filter(Expression<Func<EmpDesignation, bool>> filter, Func<IQueryable<EmpDesignation>, IOrderedQueryable<EmpDesignation>> orderBy = null, string[] Children = null)
        {
            return EmpDesignationRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpDesignation, bool>> filter, Func<IQueryable<EmpDesignation>, IOrderedQueryable<EmpDesignation>> orderBy = null)
        {
            return EmpDesignationRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpDesignation Get(long id)
        {
            return EmpDesignationRepository.Get(id);
        }

        public IEnumerable<EmpDesignation> GetAll()
        {
            return EmpDesignationRepository.GetAll();
        }

        public IEnumerable<EmpDesignation> GetByPage(int pageno, int pagesize)
        {
            return EmpDesignationRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpDesignationRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpDesignationRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpDesignationRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpDesignation entity = new EmpDesignation();
            entity = EmpDesignationRepository.SingleOrDefault(e=>e.DesignationID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpDesignationRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpDesignation> entities = new List<EmpDesignation>();
            entities = EmpDesignationRepository.Filter(x => ids.Contains(Convert.ToInt64(x.DesignationID))).ToList();

            return EmpDesignationRepository.RemoveRange(entities);
        }

        public EmpDesignation SingleOrDefault(Expression<Func<EmpDesignation, bool>> filter)
        {
            return EmpDesignationRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpDesignation entity)
        { 
            return EmpDesignationRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpDesignation> entities)
        {
            return EmpDesignationRepository.AddRange(entities);
        }
        public bool Remove(string DesignationName)
        {
            EmpDesignation entity = new EmpDesignation();
            entity = EmpDesignationRepository.SingleOrDefault(e => e.DesignationName == DesignationName);
            return EmpDesignationRepository.Remove(entity);
        }

        public int GetBranchId(string DesignationName)
        {

            int branchID = EmpDesignationRepository.SingleOrDefault(e => e.DesignationName == DesignationName).DesignationID;
            return branchID;
        }

   
    }
}
