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
    public class ClassTeacherService : IService<ClassTeacher>
    {
        private ClassTeacherRepository ClassTeacherRepository;

        public ClassTeacherService()
        {
            ClassTeacherRepository = new ClassTeacherRepository();
        }
        public bool Add(ClassTeacher entity)
        {
            return ClassTeacherRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ClassTeacher> entities)
        {
            return ClassTeacherRepository.AddRange(entities);
        }

        public IEnumerable<ClassTeacher> Filter(Expression<Func<ClassTeacher, bool>> filter, Func<IQueryable<ClassTeacher>, IOrderedQueryable<ClassTeacher>> orderBy = null, string[] Children = null)
        {
            return ClassTeacherRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ClassTeacher, bool>> filter, Func<IQueryable<ClassTeacher>, IOrderedQueryable<ClassTeacher>> orderBy = null)
        {
            return ClassTeacherRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public ClassTeacher Get(long id)
        {
            return ClassTeacherRepository.Get(id);
        }

        public IEnumerable<ClassTeacher> GetAll()
        {
            return ClassTeacherRepository.GetAll();
        }

        public IEnumerable<ClassTeacher> GetByPage(int pageno, int pagesize)
        {
            return ClassTeacherRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ClassTeacherRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ClassTeacherRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ClassTeacherRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ClassTeacher entity = new ClassTeacher();
            entity = ClassTeacherRepository.SingleOrDefault(e=>e.ID==id);
            return ClassTeacherRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ClassTeacher> entities = new List<ClassTeacher>();
            entities = ClassTeacherRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ID))).ToList();

            return ClassTeacherRepository.RemoveRange(entities);
        }

        public ClassTeacher SingleOrDefault(Expression<Func<ClassTeacher, bool>> filter)
        {
            return ClassTeacherRepository.SingleOrDefault(filter);
        }

        public bool Update(ClassTeacher entity) 
        { 
            return ClassTeacherRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ClassTeacher> entities)
        {
            return ClassTeacherRepository.AddRange(entities);
        }
      
    }
}
