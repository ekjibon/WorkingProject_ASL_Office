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

namespace OEMS.Service.Services
{
    public class PoliceStationService : IService<PoliceStation>
    {
        private PoliceStationRepository policeStationRepository;

        public PoliceStationService()
        {
            policeStationRepository = new PoliceStationRepository();
        }
        public bool Add(PoliceStation entity)
        {
        // entity.Id =   ( Convert.ToInt32( PoliceStationRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  policeStationRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<PoliceStation> entities)
        {
            return policeStationRepository.AddRange(entities);
        }

        public IEnumerable<PoliceStation> Filter(Expression<Func<PoliceStation, bool>> filter, Func<IQueryable<PoliceStation>, IOrderedQueryable<PoliceStation>> orderBy = null, string[] Children = null)
        {
            return policeStationRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<PoliceStation, bool>> filter, Func<IQueryable<PoliceStation>, IOrderedQueryable<PoliceStation>> orderBy = null)
        {
            return policeStationRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public PoliceStation Get(long id)
        {
            return policeStationRepository.Get(id);
        }

        public IEnumerable<PoliceStation> GetAll()
        {
            return policeStationRepository.GetAll();
        }

        public IEnumerable<PoliceStation> GetByPage(int pageno, int pagesize)
        {
            return policeStationRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return policeStationRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return policeStationRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return policeStationRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            PoliceStation entity = new PoliceStation();
            entity = policeStationRepository.SingleOrDefault(e=>e.PsId==id);
            return policeStationRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<PoliceStation> entities = new List<PoliceStation>();
            entities = policeStationRepository.Filter(x => ids.Contains(Convert.ToInt64(x.PsId))).ToList();

            return policeStationRepository.RemoveRange(entities);
        }

        public PoliceStation SingleOrDefault(Expression<Func<PoliceStation, bool>> filter)
        {
            return policeStationRepository.SingleOrDefault(filter);
        }

        public bool Update(PoliceStation entity)
        {
          PoliceStation _entity = policeStationRepository.SingleOrDefault(e => e.PsId == entity.PsId);
           _entity.PsName = entity.PsName;

            return policeStationRepository.Update(_entity);
        }

        public bool UpdateRange(IEnumerable<PoliceStation> entities)
        {
            return policeStationRepository.AddRange(entities);
        }
        

       

    }
}
