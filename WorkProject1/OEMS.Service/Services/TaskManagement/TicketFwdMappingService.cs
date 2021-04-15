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
    public class TicketFwdMappingService : IService<TicketFwdMapping>
    {
        private TicketFwdMappingRepository ticketFwdMappingRepository;

        public TicketFwdMappingService()
        {
            ticketFwdMappingRepository = new TicketFwdMappingRepository();
        }
        public bool Add(TicketFwdMapping entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  ticketFwdMappingRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TicketFwdMapping> entities)
        {
            return ticketFwdMappingRepository.AddRange(entities);
        }

        public bool Update(TicketFwdMapping entity)
        {
            return ticketFwdMappingRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TicketFwdMapping> entities)
        {
            return ticketFwdMappingRepository.AddRange(entities);
        }

        public IEnumerable<TicketFwdMapping> Filter(Expression<Func<TicketFwdMapping, bool>> filter, Func<IQueryable<TicketFwdMapping>, IOrderedQueryable<TicketFwdMapping>> orderBy = null, string[] Children = null)
        {
            return ticketFwdMappingRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TicketFwdMapping, bool>> filter, Func<IQueryable<TicketFwdMapping>, IOrderedQueryable<TicketFwdMapping>> orderBy = null)
        {
            return ticketFwdMappingRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TicketFwdMapping Get(long id)
        {
            return ticketFwdMappingRepository.Get(id);
        }

        public IEnumerable<TicketFwdMapping> GetAll()
        {
            return ticketFwdMappingRepository.GetAll();
        }

        public IEnumerable<TicketFwdMapping> GetByPage(int pageno, int pagesize)
        {
            return ticketFwdMappingRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ticketFwdMappingRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ticketFwdMappingRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ticketFwdMappingRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TicketFwdMapping entity = new TicketFwdMapping();
            entity = ticketFwdMappingRepository.SingleOrDefault(e=>e.Id==id);
            return ticketFwdMappingRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TicketFwdMapping> entities = new List<TicketFwdMapping>();
            entities = ticketFwdMappingRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return ticketFwdMappingRepository.RemoveRange(entities);
        }

        public TicketFwdMapping SingleOrDefault(Expression<Func<TicketFwdMapping, bool>> filter)
        {
            return ticketFwdMappingRepository.SingleOrDefault(filter);
        }

        

    }
}
