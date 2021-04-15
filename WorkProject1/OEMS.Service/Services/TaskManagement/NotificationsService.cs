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
    public class NotificationsService : IService<Notifications>
    {
        private NotificationsRepository notificationsRepository;

        public NotificationsService()
        {
            notificationsRepository = new NotificationsRepository();
        }
        public bool Add(Notifications entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  notificationsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Notifications> entities)
        {
            return notificationsRepository.AddRange(entities);
        }

        public bool Update(Notifications entity)
        {
            return notificationsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Notifications> entities)
        {
            return notificationsRepository.AddRange(entities);
        }

        public IEnumerable<Notifications> Filter(Expression<Func<Notifications, bool>> filter, Func<IQueryable<Notifications>, IOrderedQueryable<Notifications>> orderBy = null, string[] Children = null)
        {
            return notificationsRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Notifications, bool>> filter, Func<IQueryable<Notifications>, IOrderedQueryable<Notifications>> orderBy = null)
        {
            return notificationsRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Notifications Get(long id)
        {
            return notificationsRepository.Get(id);
        }

        public IEnumerable<Notifications> GetAll()
        {
            return notificationsRepository.GetAll();
        }

        public IEnumerable<Notifications> GetByPage(int pageno, int pagesize)
        {
            return notificationsRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return notificationsRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return notificationsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return notificationsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Notifications entity = new Notifications();
            entity = notificationsRepository.SingleOrDefault(e=>e.Id==id);
            return notificationsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Notifications> entities = new List<Notifications>();
            entities = notificationsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return notificationsRepository.RemoveRange(entities);
        }

        public Notifications SingleOrDefault(Expression<Func<Notifications, bool>> filter)
        {
            return notificationsRepository.SingleOrDefault(filter);
        }

        
       

    }
}
