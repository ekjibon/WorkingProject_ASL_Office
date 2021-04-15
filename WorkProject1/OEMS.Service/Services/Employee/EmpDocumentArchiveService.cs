using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories.Employee;

namespace OEMS.Service.Services
{
    public class EmpDocumentArchiveService : IService<EmpDocumentArchive>
    {
        private EmpDocumentArchiveRepository empDocumentArchiveRepository;

        public EmpDocumentArchiveService()
        {
            empDocumentArchiveRepository = new EmpDocumentArchiveRepository();
        }
        public bool Add(EmpDocumentArchive entity)
        {
            return empDocumentArchiveRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpDocumentArchive> entities)
        {
            return empDocumentArchiveRepository.AddRange(entities);
        }

        public IEnumerable<EmpDocumentArchive> Filter(Expression<Func<EmpDocumentArchive, bool>> filter, Func<IQueryable<EmpDocumentArchive>, IOrderedQueryable<EmpDocumentArchive>> orderBy = null, string[] Children = null)
        {
            return empDocumentArchiveRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpDocumentArchive, bool>> filter, Func<IQueryable<EmpDocumentArchive>, IOrderedQueryable<EmpDocumentArchive>> orderBy = null)
        {
            return empDocumentArchiveRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpDocumentArchive Get(long id)
        {
            return empDocumentArchiveRepository.Get(id);
        }

        public IEnumerable<EmpDocumentArchive> GetAll()
        {
            return empDocumentArchiveRepository.GetAll();
        }

        public IEnumerable<EmpDocumentArchive> GetByPage(int pageno, int pagesize)
        {
            return empDocumentArchiveRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empDocumentArchiveRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empDocumentArchiveRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empDocumentArchiveRepository.getResponseBySpWithParam(SpName, parameterValues);
        }
        public bool Remove(long id)
        {
            EmpDocumentArchive entity = new EmpDocumentArchive();
            entity = empDocumentArchiveRepository.SingleOrDefault(e=>e.EmpDocumentID==id);
          
            return empDocumentArchiveRepository.Remove(entity);
        }
        public bool RemoveRange(List<long> ids)
        {
            List<EmpDocumentArchive> entities = new List<EmpDocumentArchive>();
            entities = empDocumentArchiveRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpDocumentID))).ToList();

            return empDocumentArchiveRepository.RemoveRange(entities);
        }
        public EmpDocumentArchive SingleOrDefault(Expression<Func<EmpDocumentArchive, bool>> filter)
        {
            return empDocumentArchiveRepository.SingleOrDefault(filter);
        }
        public bool Update(EmpDocumentArchive entity)
        { 
            return empDocumentArchiveRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpDocumentArchive> entities)
        {
            return empDocumentArchiveRepository.AddRange(entities);
        }
        public bool Remove(string ShiftName)
        {
            EmpDocumentArchive entity = new EmpDocumentArchive();
            entity = empDocumentArchiveRepository.SingleOrDefault(e => e.DocumentName == ShiftName);
            return empDocumentArchiveRepository.Remove(entity);
        }

        public int GetBranchId(string NomineeName)
        {

            int branchID = empDocumentArchiveRepository.SingleOrDefault(e => e.DocumentName== NomineeName).EmpDocumentID;
            return branchID;
        }

   
    }
}
