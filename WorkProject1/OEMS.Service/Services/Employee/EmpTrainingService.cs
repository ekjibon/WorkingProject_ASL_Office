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
    public class EmpTrainingService : IService<EmpTraining>
    {
        private EmpTrainingRepository EmpTrainingRepository;

        public EmpTrainingService()
        {
            EmpTrainingRepository = new EmpTrainingRepository();
        }
        public bool Add(EmpTraining entity)
        {
            return EmpTrainingRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpTraining> entities)
        {
            return EmpTrainingRepository.AddRange(entities);
        }

        public IEnumerable<EmpTraining> Filter(Expression<Func<EmpTraining, bool>> filter, Func<IQueryable<EmpTraining>, IOrderedQueryable<EmpTraining>> orderBy = null, string[] Children = null)
        {
            return EmpTrainingRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpTraining, bool>> filter, Func<IQueryable<EmpTraining>, IOrderedQueryable<EmpTraining>> orderBy = null)
        {
            return EmpTrainingRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpTraining Get(long id)
        {
            return EmpTrainingRepository.Get(id);
        }

        public IEnumerable<EmpTraining> GetAll()
        {
            return EmpTrainingRepository.GetAll();
        }

        public IEnumerable<EmpTraining> GetByPage(int pageno, int pagesize)
        {
            return EmpTrainingRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpTrainingRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpTrainingRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpTrainingRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpTraining entity = new EmpTraining();
            entity = EmpTrainingRepository.SingleOrDefault(e=>e.EmpTrainingID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpTrainingRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpTraining> entities = new List<EmpTraining>();
            entities = EmpTrainingRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpTrainingID))).ToList();

            return EmpTrainingRepository.RemoveRange(entities);
        }

        public EmpTraining SingleOrDefault(Expression<Func<EmpTraining, bool>> filter)
        {
            return EmpTrainingRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpTraining entity)
        { 
            return EmpTrainingRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpTraining> entities)
        {
            return EmpTrainingRepository.AddRange(entities);
        }
        public bool Remove(string InstituteName)
        {
            EmpTraining entity = new EmpTraining();
            entity = EmpTrainingRepository.SingleOrDefault(e => e.InstituteName == InstituteName);
            return EmpTrainingRepository.Remove(entity);
        }

        public int GetBranchId(string InstituteName)
        {

            int branchID = EmpTrainingRepository.SingleOrDefault(e => e.InstituteName == InstituteName).EmpTrainingID;
            return branchID;
        }

   
    }
}
