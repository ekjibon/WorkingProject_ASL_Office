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
    public class TicketsAttachmentService : IService<TicketsAttachment>
    {
        private TicketsAttachmentRepository ticketsAttachmentRepository;

        public TicketsAttachmentService()
        {
            ticketsAttachmentRepository = new TicketsAttachmentRepository();
        }
        public bool Add(TicketsAttachment entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  ticketsAttachmentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TicketsAttachment> entities)
        {
            return ticketsAttachmentRepository.AddRange(entities);
        }

        public bool Update(TicketsAttachment entity)
        {
            return ticketsAttachmentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TicketsAttachment> entities)
        {
            return ticketsAttachmentRepository.AddRange(entities);
        }

        public IEnumerable<TicketsAttachment> Filter(Expression<Func<TicketsAttachment, bool>> filter, Func<IQueryable<TicketsAttachment>, IOrderedQueryable<TicketsAttachment>> orderBy = null, string[] Children = null)
        {
            return ticketsAttachmentRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TicketsAttachment, bool>> filter, Func<IQueryable<TicketsAttachment>, IOrderedQueryable<TicketsAttachment>> orderBy = null)
        {
            return ticketsAttachmentRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TicketsAttachment Get(long id)
        {
            return ticketsAttachmentRepository.Get(id);
        }

        public IEnumerable<TicketsAttachment> GetAll()
        {
            return ticketsAttachmentRepository.GetAll();
        }

        public IEnumerable<TicketsAttachment> GetByPage(int pageno, int pagesize)
        {
            return ticketsAttachmentRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ticketsAttachmentRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ticketsAttachmentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ticketsAttachmentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TicketsAttachment entity = new TicketsAttachment();
            entity = ticketsAttachmentRepository.SingleOrDefault(e=>e.Id==id);
            return ticketsAttachmentRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TicketsAttachment> entities = new List<TicketsAttachment>();
            entities = ticketsAttachmentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return ticketsAttachmentRepository.RemoveRange(entities);
        }

        public TicketsAttachment SingleOrDefault(Expression<Func<TicketsAttachment, bool>> filter)
        {
            return ticketsAttachmentRepository.SingleOrDefault(filter);
        }

        
    }
}
