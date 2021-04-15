using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    public class InventoryVController : BaseController
    {
        // GET: Inventory
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.Inventory;
            return View();
        }
        #region Setup 
        public ActionResult ProductCategory()
        {
            return View();
        }
        public ActionResult ProductSubCategory()
        {
            return View();
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult UnitSetup()
        {
            return View();
        }

        public ActionResult ServiceSetup()
        {
            return View();
        }

        public ActionResult Supplier()
        {
            return View();
        }

        public ActionResult Customer()
        {
            return View();
        }

        public ActionResult ProductList()
        {
            return View();
        }
        #endregion
        #region Inventory Fixed Assest Setup 
        public ActionResult AssetCategory()
        {
            return View();
        }
        public ActionResult AssestSubCategory()
        {
            return View();
        }
        public ActionResult AssestUnitSetup()
        {
            return View();
        }
  
        #endregion

        public ActionResult AssetList()
        {
            return View();
        }

        public ActionResult AddExistingAsset()
        {
            return View();
        }

        public ActionResult RequisitionEntry()
        {
            return View();
        }

        public ActionResult RequisitionList()
        {
            return View();
        }

        
        public ActionResult QuotationEntry()
        {
            return View();
        }

        public ActionResult QuotationList()
        {
            return View();
        }

        public ActionResult PurchaseOrderEntry()
        {
            return View();
        }

        public ActionResult PurchaseOrderList()
        {
            return View();
        }
        public ActionResult PurchaseOrderReceive()
        {
            return View();
        }
        public ActionResult SalesEntry()
        {
            return View();
        }
        public ActionResult Distribution()
        {
            return View();
        }
        public ActionResult AssetDisposal()
        {
            return View();
        }
        public ActionResult AssetTagging()
        {
            return View();
        }
        public ActionResult Report()
        {
            return View();
        }



    }
}