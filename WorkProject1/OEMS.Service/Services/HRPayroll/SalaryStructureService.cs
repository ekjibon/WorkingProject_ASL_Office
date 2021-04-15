using OEMS.Models;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Repository.Repositories.HRPayroll;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.HRPayroll
{
   public class SalaryStructureService: IService<SalaryStructure>
    {
        SalaryStructureRepository salaryStructureRepository;
        public SalaryStructureService()
        {
            salaryStructureRepository = new SalaryStructureRepository();
        }

        public bool Add(SalaryStructure entity)
        {
            return salaryStructureRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryStructure> entities)
        {
            return salaryStructureRepository.AddRange(entities);
        }

        public bool Update(SalaryStructure entity)
        {
            return salaryStructureRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryStructure> entities)
        {
            return salaryStructureRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryStructure entity = new SalaryStructure();
            entity = salaryStructureRepository.SingleOrDefault(e => e.Id == id);
            return salaryStructureRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryStructure> entities = new List<SalaryStructure>();
            entities = salaryStructureRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryStructureRepository.RemoveRange(entities);
        }

        public SalaryStructure Get(long id)
        {
            return salaryStructureRepository.Get(id);
        }

        public SalaryStructure SingleOrDefault(Expression<Func<SalaryStructure, bool>> filter)
        {
            return salaryStructureRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryStructure> GetAll()
        {
            return salaryStructureRepository.GetAll();
        }

        public IEnumerable<SalaryStructure> Filter(Expression<Func<SalaryStructure, bool>> filter, Func<IQueryable<SalaryStructure>, IOrderedQueryable<SalaryStructure>> orderBy = null, string[] Children = null)
        {
            return salaryStructureRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryStructure> GetByPage(int pageno, int pagesize)
        {
            return salaryStructureRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryStructureRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryStructureRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryStructureRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryStructure, bool>> filter, Func<IQueryable<SalaryStructure>, IOrderedQueryable<SalaryStructure>> orderBy = null)
        {
            return salaryStructureRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
    
}
