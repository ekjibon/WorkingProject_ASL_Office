using OEMS.Models;
using OEMS.Models.Model.TaskManagement;
using OEMS.Repository.Repositories.TaskManagement;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services
{
    public class TasksStatusService : IService<TasksStatus>
    {
        private TasksStatusRepository tasksStatusRepository;

        public TasksStatusService()
        {
            tasksStatusRepository = new TasksStatusRepository();
        }
        public bool Add(TasksStatus entity)
        {
            return tasksStatusRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TasksStatus> entities)
        {
            return tasksStatusRepository.AddRange(entities);
        }

        public bool Update(TasksStatus entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return tasksStatusRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TasksStatus> entities)
        {
            return tasksStatusRepository.AddRange(entities);
        }

        public IEnumerable<TasksStatus> Filter(Expression<Func<TasksStatus, bool>> filter, Func<IQueryable<TasksStatus>, IOrderedQueryable<TasksStatus>> orderBy = null, string[] Children = null)
        {
            return tasksStatusRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TasksStatus, bool>> filter, Func<IQueryable<TasksStatus>, IOrderedQueryable<TasksStatus>> orderBy = null)
        {
            return tasksStatusRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public TasksStatus Get(long id)
        {
            return tasksStatusRepository.Get(id);
        }

        public IEnumerable<TasksStatus> GetAll()
        {
            return tasksStatusRepository.GetAll();
        }

        public IEnumerable<TasksStatus> GetByPage(int pageno, int pagesize)
        {
            return tasksStatusRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return tasksStatusRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return tasksStatusRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return tasksStatusRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TasksStatus entity = new TasksStatus();
            entity = tasksStatusRepository.SingleOrDefault(e => e.Id == id);
            return tasksStatusRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TasksStatus> entities = new List<TasksStatus>();
            entities = tasksStatusRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return tasksStatusRepository.RemoveRange(entities);
        }

        public TasksStatus SingleOrDefault(Expression<Func<TasksStatus, bool>> filter)
        {
            return tasksStatusRepository.SingleOrDefault(filter);
        }



    }
}
