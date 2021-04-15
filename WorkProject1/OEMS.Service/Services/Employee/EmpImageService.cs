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
    public class EmpImageService : IService<EmpImage>
    {
        private EmpImageRepository EmpImageRepository;

        public EmpImageService()
        {
            EmpImageRepository = new EmpImageRepository();
        }
        public bool Add(EmpImage entity)
        {
            return EmpImageRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpImage> entities)
        {
            return EmpImageRepository.AddRange(entities);
        }

       

        public EmpImage Get(long id)
        {
            return EmpImageRepository.Get(id);
        }

        public IEnumerable<EmpImage> GetAll()
        {
            return EmpImageRepository.GetAll();
        }

       
        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpImageRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpImageRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpImage entity = new EmpImage();
            entity = EmpImageRepository.SingleOrDefault(e=>e.EmpID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpImageRepository.Update(entity);
        }

      
        public EmpImage SingleOrDefault(Expression<Func<EmpImage, bool>> filter)
        {
            return EmpImageRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpImage entity)
        { 
            return EmpImageRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpImage> entities)
        {
            return EmpImageRepository.AddRange(entities);
        }
        public bool Remove(string ImageName)
        {
            EmpImage entity = new EmpImage();
            entity = EmpImageRepository.SingleOrDefault(e => e.ImageName == ImageName);
            return EmpImageRepository.Remove(entity);
        }

        public int GetBranchId(string ImageName)
        {

            int ImageId = EmpImageRepository.SingleOrDefault(e => e.ImageName == ImageName).ImageId;
            return ImageId;
        }

        public bool RemoveRange(List<long> ids)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<EmpImage> Filter(Expression<Func<EmpImage, bool>> filter, Func<IQueryable<EmpImage>, IOrderedQueryable<EmpImage>> orderBy = null, string[] Children = null)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<EmpImage> GetByPage(int pageno, int pagesize)
        {
            throw new NotImplementedException();
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            throw new NotImplementedException();
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpImage, bool>> filter, Func<IQueryable<EmpImage>, IOrderedQueryable<EmpImage>> orderBy = null)
        {
            throw new NotImplementedException();
        }
    }
}
