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
    public class EmployeeExamBoardService : IService<EmployeeExamBoard>
    {
        private EmployeeExamBoardRepository EmployeeExamBoardRepository;

        public EmployeeExamBoardService()
        {
            EmployeeExamBoardRepository = new EmployeeExamBoardRepository();
        }
        public bool Add(EmployeeExamBoard entity)
        {
            return EmployeeExamBoardRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmployeeExamBoard> entities)
        {
            return EmployeeExamBoardRepository.AddRange(entities);
        }

        public IEnumerable<EmployeeExamBoard> Filter(Expression<Func<EmployeeExamBoard, bool>> filter, Func<IQueryable<EmployeeExamBoard>, IOrderedQueryable<EmployeeExamBoard>> orderBy = null, string[] Children = null)
        {
            return EmployeeExamBoardRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmployeeExamBoard, bool>> filter, Func<IQueryable<EmployeeExamBoard>, IOrderedQueryable<EmployeeExamBoard>> orderBy = null)
        {
            return EmployeeExamBoardRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmployeeExamBoard Get(long id)
        {
            return EmployeeExamBoardRepository.Get(id);
        }

        public IEnumerable<EmployeeExamBoard> GetAll()
        {
            return EmployeeExamBoardRepository.GetAll();
        }

        public IEnumerable<EmployeeExamBoard> GetByPage(int pageno, int pagesize)
        {
            return EmployeeExamBoardRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmployeeExamBoardRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmployeeExamBoardRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmployeeExamBoardRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmployeeExamBoard entity = new EmployeeExamBoard();
            entity = EmployeeExamBoardRepository.SingleOrDefault(e=>e.EmployeeExamBoard_ID==id);
            //entity.IsDeleted = true;
            //entity.SetDate();
            return EmployeeExamBoardRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmployeeExamBoard> entities = new List<EmployeeExamBoard>();
            entities = EmployeeExamBoardRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmployeeExamBoard_ID))).ToList();

            return EmployeeExamBoardRepository.RemoveRange(entities);
        }

        public EmployeeExamBoard SingleOrDefault(Expression<Func<EmployeeExamBoard, bool>> filter)
        {
            return EmployeeExamBoardRepository.SingleOrDefault(filter);
        }

        public bool Update(EmployeeExamBoard entity)
        { 
            return EmployeeExamBoardRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmployeeExamBoard> entities)
        {
            return EmployeeExamBoardRepository.AddRange(entities);
        }
        public bool Remove(string ShiftName)
        {
            EmployeeExamBoard entity = new EmployeeExamBoard();
            entity = EmployeeExamBoardRepository.SingleOrDefault(e => e.EmployeeExamBoard_Name == ShiftName);
            return EmployeeExamBoardRepository.Remove(entity);
        }

        public int GetBranchId(string ShiftName)
        {

            int branchID = EmployeeExamBoardRepository.SingleOrDefault(e => e.EmployeeExamBoard_Name == ShiftName).EmployeeExamBoard_ID;
            return branchID;
        }

   
    }
}
