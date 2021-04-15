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
    public class DistrictService : IService<District>
    {
        private DistrictRepository districtRepository;

        public DistrictService()
        {
            districtRepository = new DistrictRepository();
        }
        public bool Add(District entity)
        {
        // entity.Id =   ( Convert.ToInt32( DistrictRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  districtRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<District> entities)
        {
            return districtRepository.AddRange(entities);
        }

        public IEnumerable<District> Filter(Expression<Func<District, bool>> filter, Func<IQueryable<District>, IOrderedQueryable<District>> orderBy = null, string[] Children = null)
        {
            return districtRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<District, bool>> filter, Func<IQueryable<District>, IOrderedQueryable<District>> orderBy = null)
        {
            return districtRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public District Get(long id)
        {
            return districtRepository.Get(id);
        }

        public IEnumerable<District> GetAll()
        {
            return districtRepository.GetAll();
        }

        public IEnumerable<District> GetByPage(int pageno, int pagesize)
        {
            return districtRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return districtRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return districtRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return districtRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            District entity = new District();
            entity = districtRepository.SingleOrDefault(e=>e.DistrictId==id);
            return districtRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<District> entities = new List<District>();
            entities = districtRepository.Filter(x => ids.Contains(Convert.ToInt64(x.DistrictId))).ToList();

            return districtRepository.RemoveRange(entities);
        }

        public District SingleOrDefault(Expression<Func<District, bool>> filter)
        {
            return districtRepository.SingleOrDefault(filter);
        }

        public bool Update(District entity)
        {
          District _entity = districtRepository.SingleOrDefault(e => e.DistrictId == entity.DistrictId);
           _entity.DistrictName = entity.DistrictName;

            return districtRepository.Update(_entity);
        }

        public bool UpdateRange(IEnumerable<District> entities)
        {
            return districtRepository.AddRange(entities);
        }
        

       

    }
}
