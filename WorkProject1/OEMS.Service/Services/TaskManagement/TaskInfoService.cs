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
    public class TaskInfoService : IService<TaskInfo>
    {
        private TaskInfoRepository taskInfoRepository;

        public TaskInfoService()
        {
            taskInfoRepository = new TaskInfoRepository();
        }
        public bool Add(TaskInfo entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  taskInfoRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TaskInfo> entities)
        {
            return taskInfoRepository.AddRange(entities);
        }

        public bool Update(TaskInfo entity)
        {
            return taskInfoRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TaskInfo> entities)
        {
            return taskInfoRepository.AddRange(entities);
        }

        public IEnumerable<TaskInfo> Filter(Expression<Func<TaskInfo, bool>> filter, Func<IQueryable<TaskInfo>, IOrderedQueryable<TaskInfo>> orderBy = null, string[] Children = null)
        {
            return taskInfoRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TaskInfo, bool>> filter, Func<IQueryable<TaskInfo>, IOrderedQueryable<TaskInfo>> orderBy = null)
        {
            return taskInfoRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TaskInfo Get(long id)
        {
            return taskInfoRepository.Get(id);
        }

        public IEnumerable<TaskInfo> GetAll()
        {
            return taskInfoRepository.GetAll();
        }

        public IEnumerable<TaskInfo> GetByPage(int pageno, int pagesize)
        {
            return taskInfoRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return taskInfoRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return taskInfoRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return taskInfoRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TaskInfo entity = new TaskInfo();
            entity = taskInfoRepository.SingleOrDefault(e=>e.Id==id);
            return taskInfoRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TaskInfo> entities = new List<TaskInfo>();
            entities = taskInfoRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return taskInfoRepository.RemoveRange(entities);
        }

        public TaskInfo SingleOrDefault(Expression<Func<TaskInfo, bool>> filter)
        {
            return taskInfoRepository.SingleOrDefault(filter);
        }

        
       

    }
}
