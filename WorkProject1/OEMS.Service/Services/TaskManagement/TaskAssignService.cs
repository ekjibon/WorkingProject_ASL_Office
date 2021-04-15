using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;
using UI.Admin.Models.Task;

namespace OEMS.Service.Services
{
    public class TaskAssignService : IService<TaskAssign>
    {
        private TaskAssignRepository taskAssignRepository;

        public TaskAssignService()
        {
            taskAssignRepository = new TaskAssignRepository();
        }
        public bool Add(TaskAssign entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  taskAssignRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TaskAssign> entities)
        {
            return taskAssignRepository.AddRange(entities);
        }

        public bool Update(TaskAssign entity)
        {
            return taskAssignRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TaskAssign> entities)
        {
            return taskAssignRepository.AddRange(entities);
        }

        public IEnumerable<TaskAssign> Filter(Expression<Func<TaskAssign, bool>> filter, Func<IQueryable<TaskAssign>, IOrderedQueryable<TaskAssign>> orderBy = null, string[] Children = null)
        {
            return taskAssignRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TaskAssign, bool>> filter, Func<IQueryable<TaskAssign>, IOrderedQueryable<TaskAssign>> orderBy = null)
        {
            return taskAssignRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TaskAssign Get(long id)
        {
            return taskAssignRepository.Get(id);
        }

        public IEnumerable<TaskAssign> GetAll()
        {
            return taskAssignRepository.GetAll();
        }

        public IEnumerable<TaskAssign> GetByPage(int pageno, int pagesize)
        {
            return taskAssignRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return taskAssignRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return taskAssignRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return taskAssignRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TaskAssign entity = new TaskAssign();
            entity = taskAssignRepository.SingleOrDefault(e=>e.Id==id);
            return taskAssignRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TaskAssign> entities = new List<TaskAssign>();
            entities = taskAssignRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return taskAssignRepository.RemoveRange(entities);
        }

        public TaskAssign SingleOrDefault(Expression<Func<TaskAssign, bool>> filter)
        {
            return taskAssignRepository.SingleOrDefault(filter);
        }
        
    }
}
