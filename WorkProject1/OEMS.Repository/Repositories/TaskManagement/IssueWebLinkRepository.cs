using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Repository.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UI.Admin.Models.Task;

namespace OEMS.Repository.Repositories
{
    public class IssueWebLinkRepository : BaseRepository<IssueWebLink>,  IDisposable
    {
        public static ModelDbContext _context = new ModelDbContext();
       
        public IssueWebLinkRepository() : base(_context = new ModelDbContext())
        {
           // Context = _context;
        }
        
        //~RoleRepository()
        //{
        //    _context.Dispose();
        //}
        //public RoleRepository(Entities _context) : base(_context)
        //{

        //}


        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).

                    _context.Dispose();
                   // _context = null;
                }

                // TODO: free unmanaged resources (unmanaged objects) and override a finalizer below.
                // TODO: set large fields to null.

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        ~IssueWebLinkRepository()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
        }

        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }
        #endregion
    }
}
