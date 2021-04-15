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
    public class TaskActivityLogService : IService<TaskActivityLog>
    {
        private TaskActivityLogRepository taskActivityLogRepository;

        public TaskActivityLogService()
        {
            taskActivityLogRepository = new TaskActivityLogRepository();
        }
        public bool Add(TaskActivityLog entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  taskActivityLogRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TaskActivityLog> entities)
        {
            return taskActivityLogRepository.AddRange(entities);
        }

        public bool Update(TaskActivityLog entity)
        {
            return taskActivityLogRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TaskActivityLog> entities)
        {
            return taskActivityLogRepository.AddRange(entities);
        }

        public IEnumerable<TaskActivityLog> Filter(Expression<Func<TaskActivityLog, bool>> filter, Func<IQueryable<TaskActivityLog>, IOrderedQueryable<TaskActivityLog>> orderBy = null, string[] Children = null)
        {
            return taskActivityLogRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TaskActivityLog, bool>> filter, Func<IQueryable<TaskActivityLog>, IOrderedQueryable<TaskActivityLog>> orderBy = null)
        {
            return taskActivityLogRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TaskActivityLog Get(long id)
        {
            return taskActivityLogRepository.Get(id);
        }

        public IEnumerable<TaskActivityLog> GetAll()
        {
            return taskActivityLogRepository.GetAll();
        }

        public IEnumerable<TaskActivityLog> GetByPage(int pageno, int pagesize)
        {
            return taskActivityLogRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return taskActivityLogRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return taskActivityLogRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return taskActivityLogRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TaskActivityLog entity = new TaskActivityLog();
            entity = taskActivityLogRepository.SingleOrDefault(e=>e.Id==id);
            return taskActivityLogRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TaskActivityLog> entities = new List<TaskActivityLog>();
            entities = taskActivityLogRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return taskActivityLogRepository.RemoveRange(entities);
        }

        public TaskActivityLog SingleOrDefault(Expression<Func<TaskActivityLog, bool>> filter)
        {
            return taskActivityLogRepository.SingleOrDefault(filter);
        }

        
        
    }
}
