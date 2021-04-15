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
    public class EmpSubjectService : IService<EmpSubject>
    {
        private EmpSubjectRepository EmpSubjectRepository;

        public EmpSubjectService()
        {
            EmpSubjectRepository = new EmpSubjectRepository();
        }
        public bool Add(EmpSubject entity)
        {
            return EmpSubjectRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpSubject> entities)
        {
            return EmpSubjectRepository.AddRange(entities);
        }

        public IEnumerable<EmpSubject> Filter(Expression<Func<EmpSubject, bool>> filter, Func<IQueryable<EmpSubject>, IOrderedQueryable<EmpSubject>> orderBy = null, string[] Children = null)
        {
            return EmpSubjectRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpSubject, bool>> filter, Func<IQueryable<EmpSubject>, IOrderedQueryable<EmpSubject>> orderBy = null)
        {
            return EmpSubjectRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpSubject Get(long id)
        {
            return EmpSubjectRepository.Get(id);
        }

        public IEnumerable<EmpSubject> GetAll()
        {
            return EmpSubjectRepository.GetAll();
        }

        public IEnumerable<EmpSubject> GetByPage(int pageno, int pagesize)
        {
            return EmpSubjectRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpSubjectRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpSubjectRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpSubjectRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpSubject entity = new EmpSubject();
            entity = EmpSubjectRepository.SingleOrDefault(e=>e.SubjectID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpSubjectRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpSubject> entities = new List<EmpSubject>();
            entities = EmpSubjectRepository.Filter(x => ids.Contains(Convert.ToInt64(x.SubjectID))).ToList();

            return EmpSubjectRepository.RemoveRange(entities);
        }

        public EmpSubject SingleOrDefault(Expression<Func<EmpSubject, bool>> filter)
        {
            return EmpSubjectRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpSubject entity)
        { 
            return EmpSubjectRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpSubject> entities)
        {
            return EmpSubjectRepository.AddRange(entities);
        }
        public bool Remove(string SubjectName)
        {
            EmpSubject entity = new EmpSubject();
            entity = EmpSubjectRepository.SingleOrDefault(e => e.SubjectName == SubjectName);
            return EmpSubjectRepository.Remove(entity);
        }

        public int GetBranchId(string SubjectName)
        {

            int branchID = EmpSubjectRepository.SingleOrDefault(e => e.SubjectName == SubjectName).SubjectID;
            return branchID;
        }

   
    }
}
