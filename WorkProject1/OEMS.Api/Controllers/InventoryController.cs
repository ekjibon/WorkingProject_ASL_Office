using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Inventory;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace OEMS.Api.Controllers
{
    public class InventoryController : ApiController
    {

        #region  Fixed Asset Setup
        [Route("Inventory/AddAssetCategory")]
        [HttpPost]
        public IHttpActionResult AddAssetCategory(AssetCategory assetCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetCategory != null)
                {
                    List<AssetCategory> assetCategorylist = DataAccess.Instance.AssetCategoryService.Filter(a => a.CategoryName == assetCategory.CategoryName && a.IsDeleted == false && a.Status == "A").ToList();

                    if (assetCategorylist.Count > 0)
                    {
                        throw new Exception("Asset Category Already Exist.");
                    }

                    assetCategory.Status = "A";
                    assetCategory.IsDeleted = false;
                    assetCategory.AddBy = User.Identity.Name;
                    assetCategory.AddDate = DateTime.Now;
                    assetCategory.UpdateBy = User.Identity.Name;
                    assetCategory.UpdateDate = DateTime.Now;
                    assetCategory.SetDate();
                    var res = DataAccess.Instance.AssetCategoryService.Add(assetCategory);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateAssetCategory")]
        [HttpPut]
        public IHttpActionResult UpdateAssetCategory(AssetCategory assetCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetCategory != null)
                {
                    List<AssetCategory> assetCategoryList = DataAccess.Instance.AssetCategoryService.Filter(a => a.CategoryName == assetCategory.CategoryName && a.AssetCateId != assetCategory.AssetCateId && a.IsDeleted == false && a.Status == "A").ToList();

                    if (assetCategoryList.Count>0)
                    {
                        throw new Exception("Asset Category Already Exist.");
                    }
                    AssetCategory data = DataAccess.Instance.AssetCategoryService.Filter(p => p.AssetCateId == assetCategory.AssetCateId).FirstOrDefault();
                    data.CategoryName = assetCategory.CategoryName;
                    data.CategoryCode = assetCategory.CategoryCode;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.AssetCategoryService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteAssetCategory")]
        [HttpPost]
        public IHttpActionResult DeleteAssetCategory(AssetCategory assetCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetCategory != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.FA_AssetSubCategory", "CategoryId", assetCategory.AssetCateId);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.AssetCategoryService.Remove(assetCategory.AssetCateId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetAssetCategorys")]
        [HttpGet]
        public IHttpActionResult GetAssetCategorys()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<AssetCategory> assetCategoryList = DataAccess.Instance.AssetCategoryService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (assetCategoryList.Count > 0)
                {
                    cr.results = assetCategoryList;
                    cr.message = assetCategoryList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }


        [Route("Inventory/AddAssetSubCategory")]
        [HttpPost]
        public IHttpActionResult AddAssetSubCategory(AssetSubCategory assetSubCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetSubCategory != null)
                {
                    List<AssetSubCategory> assetSubCategorylist = DataAccess.Instance.AssetSubCategoryService.Filter(p =>(p.SubCategoryName == assetSubCategory.SubCategoryName)&& p.IsDeleted == false && p.Status == "A").ToList();

                    if (assetSubCategorylist.Count>0)
                    {
                        throw new Exception("Asset Sub Category Already Exist.");
                    }

                    assetSubCategory.Status = "A";
                    assetSubCategory.IsDeleted = false;
                    assetSubCategory.AddBy = User.Identity.Name;
                    assetSubCategory.AddDate = DateTime.Now;
                    assetSubCategory.UpdateBy = User.Identity.Name;
                    assetSubCategory.UpdateDate = DateTime.Now;
                    assetSubCategory.SetDate();
                    var res = DataAccess.Instance.AssetSubCategoryService.Add(assetSubCategory);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateAssetSubCategory")]
        [HttpPut]
        public IHttpActionResult UpdateAssetSubCategory(AssetSubCategory assetSubCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetSubCategory != null)
                {
                    List<AssetSubCategory> assetSubCategoryList = DataAccess.Instance.AssetSubCategoryService.Filter(p => (p.SubCategoryName == assetSubCategory.SubCategoryName) && p.AssetSubCatId != assetSubCategory.AssetSubCatId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (assetSubCategoryList.Count>0)
                    {
                        throw new Exception("Asset Sub Category Already Exist.");
                    }
                    AssetSubCategory data = DataAccess.Instance.AssetSubCategoryService.Filter(p => p.AssetSubCatId == assetSubCategory.AssetSubCatId).FirstOrDefault();
                    data.SubCategoryName = assetSubCategory.SubCategoryName;
                    data.CategoryId = assetSubCategory.CategoryId;
                    data.UpdateDate = DateTime.Now;
                    data.UpdateBy = User.Identity.Name;
                    data.SetDate();
                    var res = DataAccess.Instance.AssetSubCategoryService.Update(assetSubCategory);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteAssetSubCategory")]
        [HttpPost]
        public IHttpActionResult DeleteAssetSubCategory(AssetSubCategory assetSubCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetSubCategory != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.FA_Asset", "AssetSubCateId", assetSubCategory.AssetSubCatId);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.AssetSubCategoryService.Remove(assetSubCategory.AssetSubCatId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }


                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetAssetSubCategorys")]
        [HttpGet]
        public IHttpActionResult GetAssetSubCategorys()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<AssetSubCategory> assetSubCategoryList = DataAccess.Instance.AssetSubCategoryService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                List<AssetSubCategory> list = new List<AssetSubCategory>();
                foreach (var item in assetSubCategoryList)
                {
                    AssetCategory data = DataAccess.Instance.AssetCategoryService.Filter(p => p.AssetCateId == item.CategoryId).FirstOrDefault();
                    item.CategoryName = data.CategoryName;
                    list.Add(item);
                }
                if (list.Count > 0)
                {
                    cr.results = list;
                    cr.message = assetSubCategoryList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/AddAssetUnitSetup")]
        [HttpPost]
        public IHttpActionResult AddAssetUnitSetup(AssetUnitSetup unitSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (unitSetup != null)
                {
                    List<AssetUnitSetup> UnitSetupList = DataAccess.Instance.AssetUnitSetupService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (UnitSetupList.Any(p => p.UnitName == unitSetup.UnitName || p.UnitCode == unitSetup.UnitCode))
                    {
                        throw new Exception("Unit Already Exist.");
                    }

                    unitSetup.Status = "A";
                    unitSetup.IsDeleted = false;
                    unitSetup.AddBy = User.Identity.Name;
                    unitSetup.AddDate = DateTime.Now;
                    unitSetup.UpdateBy = User.Identity.Name;
                    unitSetup.UpdateDate = DateTime.Now;
                    unitSetup.SetDate();
                    var res = DataAccess.Instance.AssetUnitSetupService.Add(unitSetup);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateAssetUnitSetup")]
        [HttpPut]
        public IHttpActionResult UpdateAssetUnitSetup(AssetUnitSetup unitSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (unitSetup != null)
                {
                    List<AssetUnitSetup> unitSetupList = DataAccess.Instance.AssetUnitSetupService.Filter(p => p.UnitSetupId != unitSetup.UnitSetupId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (unitSetupList.Any(p => p.UnitName == unitSetup.UnitName || p.UnitCode == unitSetup.UnitCode))
                    {
                        throw new Exception("Unit Setup Already Exist.");
                    }
                    AssetUnitSetup data = DataAccess.Instance.AssetUnitSetupService.Filter(p => p.UnitSetupId == unitSetup.UnitSetupId).FirstOrDefault();
                    data.UnitName = unitSetup.UnitName;
                    data.UnitCode = unitSetup.UnitCode;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.AssetUnitSetupService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteAssetUnitSetup")]
        [HttpPost]
        public IHttpActionResult DeleteAssetUnitSetup(AssetUnitSetup unitSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (unitSetup != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.FA_Asset", "UnitId", unitSetup.UnitSetupId);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.AssetUnitSetupService.Remove(unitSetup.UnitSetupId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;

                    }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetAssetUnitSetups")]
        [HttpGet]
        public IHttpActionResult GetAssetUnitSetups()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<AssetUnitSetup> assetUnitSetupList = DataAccess.Instance.AssetUnitSetupService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (assetUnitSetupList.Count > 0)
                {
                    cr.results = assetUnitSetupList;
                    cr.message = assetUnitSetupList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/AddAsset")]
        [HttpPost]
        public IHttpActionResult AddAsset(Asset asset)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (asset != null)
                {
                    asset.AddBy = User.Identity.Name;
                    var param = new object[] { asset.AssetId
                                               ,asset.AssetName
                                               ,asset.AssetCode
                                               ,asset.AssetSubCatId
                                               ,asset.UnitId                                               
                                               ,asset.AssetTypeId = 1
                                               ,asset.Description 
                                               ,asset.DeprcAmount                                             
                                               ,asset.Amount = 0
                                               ,asset.SellingPrice = 0
                                               ,asset.AccCode                                              
                                               ,asset.AddBy
                                               
                                             };
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("AddAsset", param);
                    cr.results = res;

                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Inventory/UpdateAsset")]
        [HttpPut]
        public IHttpActionResult UpdateAsset(Asset asset)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (asset != null)
                {
                    asset.UpdateBy = User.Identity.Name;
                    //var res = DataAccess.Instance.ProductService.Update(product);
                    var param = new object[] { asset.AssetId
                                               ,asset.AssetName
                                               ,asset.AssetCode
                                               ,asset.AssetSubCatId
                                               ,asset.UnitId
                                               ,asset.AssetTypeId = 1
                                               ,asset.Description
                                               ,asset.DeprcAmount                                          
                                               ,asset.SellingPrice =0
                                               ,asset.UpdateBy
                                             };
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateProduct", param);

                    cr.results = res;
                    cr.message = Constant.SAVED;

                }
                else
                {
                    cr.message = Constant.FAILED;
                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        [Route("Inventory/GetAssets")]
        [HttpGet]
        public IHttpActionResult GetAssets()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //Khaled
                var res = DataAccess.Instance.CommonServices.GetBySp("GetAssetList");
                cr.results = res;
                //if (cr.results > 0)
                //{
                //    cr.message = "Data Found";
                //}

                //else
                //{
                //    throw new Exception("No Data Found.");
                //}


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/DeleteAsset")]
        [HttpPost]
        public IHttpActionResult DeleteAsset(Asset asset)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (asset != null)
                {
                    //bool IsExist = false;
                    //List<string> tablelst = new List<string>() { "Inv_QuotationDetails", "Inv_PurchaseOrderDetails", "Inv_RequisitionDetails", "Inv_SalesDetails", "Inv_AssetDisposal", "Inv_Distribution" };
                    //foreach (var tablename in tablelst)
                    //{
                    //    IsExist = DataAccess.Instance.CommonServices.IsExist(tablename, "ProductId", product.ProductId);
                    //    if (IsExist)
                    //    {
                    //        throw new Exception(Constant.DATA_EXISTS);
                    ////    }
                    ////}
                    //if (!IsExist)
                    //{
                        var res = DataAccess.Instance.ProductService.Remove(asset.AssetId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    //}

                }
                else
                {
                    cr.message = Constant.INVAILD_DATA;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/SearchAsset/{srhtext}")]
        [HttpGet]
        public IHttpActionResult SearchAsset(string srhtext)
        {

            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.AssetService.Filter(e => e.AssetName.Contains(srhtext))
           .Select(e => new { Name = e.AssetName + " (" + e.AssetId + ")", Id = e.AssetId }).ToList();
            return Json(cr);

        }

        [Route("Inventory/GetAssetInfo/{AssetIdNo}/")] 
        [HttpGet]
        public IHttpActionResult GetAssetInfo(int AssetIdNo)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssetInfo", new object[] { AssetIdNo });
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
               
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);


        }

        [Route("Inventory/AddExAsset")]
        [HttpPost]
        public IHttpActionResult AddExAsset(AssetDetails exAsset)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (exAsset != null)
                {
                    exAsset.Status = "A";
                    exAsset.IsDeleted = false;
                    exAsset.IsExisting = true;
                    exAsset.AddBy = User.Identity.Name;
                    exAsset.AddDate = DateTime.Now;
                    exAsset.SetDate();
                    var res = DataAccess.Instance.AssetDetailsService.Add(exAsset);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion

        #region Setup
        [Route("Inventory/AddProductCategory")]
        [HttpPost]
        public IHttpActionResult AddProductCategory(ProductCategory productCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (productCategory!=null)
                {
                    List<ProductCategory> productCategoryList = DataAccess.Instance.ProductCategoryService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (productCategoryList.Any(p=>p.CategoryName==productCategory.CategoryName || p.CategoryCode == productCategory.CategoryCode))
                    {
                        throw new Exception("Product Category Already Exist.");
                    }

                    productCategory.Status = "A";
                    productCategory.IsDeleted = false;
                    productCategory.AddBy = User.Identity.Name;
                    productCategory.AddDate = DateTime.Now;
                    productCategory.UpdateBy = User.Identity.Name;
                    productCategory.UpdateDate = DateTime.Now;
                    productCategory.SetDate();
                    var res = DataAccess.Instance.ProductCategoryService.Add(productCategory);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateProductCategory")]
        [HttpPut]
        public IHttpActionResult UpdateProductCategory(ProductCategory productCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (productCategory != null)
                {
                    List<ProductCategory> productCategoryList = DataAccess.Instance.ProductCategoryService.Filter(p => p.ProductCateId != productCategory.ProductCateId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (productCategoryList.Any(p => p.CategoryName == productCategory.CategoryName || p.CategoryCode == productCategory.CategoryCode))
                    {
                        throw new Exception("Product Category Already Exist.");
                    }
                    ProductCategory data = DataAccess.Instance.ProductCategoryService.Filter(p => p.ProductCateId == productCategory.ProductCateId).FirstOrDefault();
                    data.CategoryName = productCategory.CategoryName;
                    data.CategoryCode = productCategory.CategoryCode;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.ProductCategoryService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteProductCategory")]
        [HttpPost]
        public IHttpActionResult DeleteProductCategory(ProductCategory productCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (productCategory != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_ProductSubCategory", "CategoryId", productCategory.ProductCateId);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.ProductCategoryService.Remove(productCategory.ProductCateId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }
                   
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetProductCategorys")]
        [HttpGet]
        public IHttpActionResult GetProductCategorys()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
               List<ProductCategory> productCategoryList = DataAccess.Instance.ProductCategoryService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (productCategoryList.Count>0)
                {
                    cr.results = productCategoryList;
                    cr.message = productCategoryList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/AddProductSubCategory")]
        [HttpPost]
        public IHttpActionResult AddProductSubCategory(ProductSubCategory productSubCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (productSubCategory != null)
                {
                    List<ProductSubCategory> productSubCategoryList = DataAccess.Instance.ProductSubCategoryService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (productSubCategoryList.Any(p => p.SubCategoryName == productSubCategory.SubCategoryName))
                    {
                        throw new Exception("Product Sub Category Already Exist.");
                    }

                    productSubCategory.Status = "A";
                    productSubCategory.IsDeleted = false;
                    productSubCategory.AddBy = User.Identity.Name;
                    productSubCategory.AddDate = DateTime.Now;
                    productSubCategory.UpdateBy = User.Identity.Name;
                    productSubCategory.UpdateDate = DateTime.Now;
                    productSubCategory.SetDate();
                    var res = DataAccess.Instance.ProductSubCategoryService.Add(productSubCategory);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateProductSubCategory")]
        [HttpPut]
        public IHttpActionResult UpdateProductSubCategory(ProductSubCategory productSubCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (productSubCategory != null)
                {
                    List<ProductSubCategory> productSubCategoryList = DataAccess.Instance.ProductSubCategoryService.Filter(p => p.ProductSubCatId != productSubCategory.ProductSubCatId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (productSubCategoryList.Any(p => p.SubCategoryName == productSubCategory.SubCategoryName))
                    {
                        throw new Exception("Product Category Already Exist.");
                    }
                    ProductSubCategory data = DataAccess.Instance.ProductSubCategoryService.Filter(p => p.ProductSubCatId == productSubCategory.ProductSubCatId).FirstOrDefault();
                    data.SubCategoryName = productSubCategory.SubCategoryName;
                    data.CategoryId = productSubCategory.CategoryId;
                    data.UpdateDate = DateTime.Now;
                    data.UpdateBy = User.Identity.Name;
                    data.SetDate();
                    var res = DataAccess.Instance.ProductSubCategoryService.Update(productSubCategory);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteProductSubCategory")]
        [HttpPost]
        public IHttpActionResult DeleteProductSubCategory(ProductSubCategory productSubCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (productSubCategory != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_Product", "ProductSubCateId", productSubCategory.ProductSubCatId);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.ProductSubCategoryService.Remove(productSubCategory.ProductSubCatId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }
                   

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetProductSubCategorys")]
        [HttpGet]
        public IHttpActionResult GetProductSubCategorys()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<ProductSubCategory> productSubCategoryList = DataAccess.Instance.ProductSubCategoryService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                List<ProductSubCategory> list = new List<ProductSubCategory>();
                foreach (var item in productSubCategoryList)
                {
                    ProductCategory data = DataAccess.Instance.ProductCategoryService.Filter(p => p.ProductCateId == item.CategoryId).FirstOrDefault();
                    item.CategoryName = data.CategoryName;
                    list.Add(item);
                }
                if (list.Count > 0)
                {
                    cr.results = list;
                    cr.message = productSubCategoryList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }


        


        [Route("Inventory/AddUnitSetup")]
        [HttpPost]
        public IHttpActionResult AddUnitSetup(UnitSetup unitSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (unitSetup != null)
                {
                    List<UnitSetup> UnitSetupList = DataAccess.Instance.UnitSetupService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (UnitSetupList.Any(p => p.UnitName == unitSetup.UnitName || p.UnitCode == unitSetup.UnitCode))
                    {
                        throw new Exception("Unit Already Exist.");
                    }

                    unitSetup.Status = "A";
                    unitSetup.IsDeleted = false;
                    unitSetup.AddBy = User.Identity.Name;
                    unitSetup.AddDate = DateTime.Now;
                    unitSetup.UpdateBy = User.Identity.Name;
                    unitSetup.UpdateDate = DateTime.Now;
                    unitSetup.SetDate();
                    var res = DataAccess.Instance.UnitSetupService.Add(unitSetup);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateUnitSetup")]
        [HttpPut]
        public IHttpActionResult UpdateUnitSetup(UnitSetup unitSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (unitSetup != null)
                {
                    List<UnitSetup> unitSetupList = DataAccess.Instance.UnitSetupService.Filter(p => p.UnitSetupId != unitSetup.UnitSetupId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (unitSetupList.Any(p => p.UnitName == unitSetup.UnitName || p.UnitCode == unitSetup.UnitCode))
                    {
                        throw new Exception("Unit Setup Already Exist.");
                    }
                    UnitSetup data = DataAccess.Instance.UnitSetupService.Filter(p => p.UnitSetupId == unitSetup.UnitSetupId).FirstOrDefault();
                    data.UnitName = unitSetup.UnitName;
                    data.UnitCode = unitSetup.UnitCode;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.UnitSetupService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteUnitSetup")]
        [HttpPost]
        public IHttpActionResult DeleteUnitSetup(UnitSetup unitSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (unitSetup != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_Product", "UnitId", unitSetup.UnitSetupId);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.UnitSetupService.Remove(unitSetup.UnitSetupId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;

                    }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetUnitSetups")]
        [HttpGet]
        public IHttpActionResult GetUnitSetups()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<UnitSetup> UnitSetupList = DataAccess.Instance.UnitSetupService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (UnitSetupList.Count > 0)
                {
                    cr.results = UnitSetupList;
                    cr.message = UnitSetupList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }


        [Route("Inventory/AddServiceSetup")]
        [HttpPost]
        public IHttpActionResult AddServiceSetup(ServiceSetup serviceSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (serviceSetup != null)
                {
                    List<ServiceSetup> ServiceSetupList = DataAccess.Instance.ServiceSetupService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (ServiceSetupList.Any(p => p.ServiceName == serviceSetup.ServiceName || p.ServiceCode == serviceSetup.ServiceCode))
                    {
                        throw new Exception("Service Already Exist.");
                    }

                    serviceSetup.Status = "A";
                    serviceSetup.IsDeleted = false;
                    serviceSetup.AddBy = User.Identity.Name;
                    serviceSetup.AddDate = DateTime.Now;
                    serviceSetup.UpdateBy = User.Identity.Name;
                    serviceSetup.UpdateDate = DateTime.Now;
                    serviceSetup.SetDate();
                    var res = DataAccess.Instance.ServiceSetupService.Add(serviceSetup);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateServiceSetup")]
        [HttpPut]
        public IHttpActionResult UpdateServiceSetup(ServiceSetup serviceSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (serviceSetup != null)
                {
                    List<ServiceSetup> serviceSetupList = DataAccess.Instance.ServiceSetupService.Filter(p => p.ServiceSetupId != serviceSetup.ServiceSetupId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (serviceSetupList.Any(p => p.ServiceName == serviceSetup.ServiceName || p.ServiceCode == serviceSetup.ServiceCode))
                    {
                        throw new Exception("Service Setup Already Exist.");
                    }
                    ServiceSetup data = DataAccess.Instance.ServiceSetupService.Filter(p => p.ServiceSetupId == serviceSetup.ServiceSetupId).FirstOrDefault();
                    data.ServiceName = serviceSetup.ServiceName;
                    data.ServiceCode = serviceSetup.ServiceCode;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.ServiceSetupService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteServiceSetup")]
        [HttpPost]
        public IHttpActionResult DeleteServiceSetup(ServiceSetup serviceSetup)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (serviceSetup != null)
                {
                    var res = DataAccess.Instance.ServiceSetupService.Remove(serviceSetup.ServiceSetupId);
                    cr.results = res;
                    cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetServiceSetups")]
        [HttpGet]
        public IHttpActionResult GetServiceSetups()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<ServiceSetup> ServiceSetupList = DataAccess.Instance.ServiceSetupService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (ServiceSetupList.Count > 0)
                {
                    cr.results = ServiceSetupList;
                    cr.message = ServiceSetupList.Count + " Data Found.";
                }
                
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/AddSupplier")]
        [HttpPost]
        public IHttpActionResult AddSupplier(Supplier supplier)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (supplier != null)
                {
                    List<Supplier> supplierList = DataAccess.Instance.SupplierService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (supplierList.Any(p => p.SupplierName == supplier.SupplierName || p.SupplierCode == supplier.SupplierCode || p.CompanyName == supplier.CompanyName))
                    {
                        throw new Exception("Supplier Already Exist.");
                    }

                    supplier.Status = "A";
                    supplier.IsDeleted = false;
                    supplier.AddBy = User.Identity.Name;
                    supplier.AddDate = DateTime.Now;
              
                    supplier.SetDate();
                    var res = DataAccess.Instance.SupplierService.Add(supplier);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateSupplier")]
        [HttpPut]
        public IHttpActionResult UpdateSupplier(Supplier supplier)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (supplier != null)
                {
                    List<Supplier> supplierList = DataAccess.Instance.SupplierService.Filter(p => p.SupplierId != supplier.SupplierId && p.IsDeleted == false && p.Status == "A").ToList();

                    if (supplierList.Any(p => p.SupplierName == supplier.SupplierName || p.SupplierCode == supplier.SupplierCode || p.CompanyName == supplier.CompanyName))
                    {
                        throw new Exception("Supplier Already Exist.");
                    }
                    Supplier data = DataAccess.Instance.SupplierService.Filter(p => p.SupplierId == supplier.SupplierId).FirstOrDefault();
                    data.SupplierName = supplier.SupplierName;
                    data.SupplierCode = supplier.SupplierCode;
                    data.BIN = supplier.BIN;

                    data.CompanyName = supplier.CompanyName;
                    data.ContactPersonName = supplier.ContactPersonName;
                    data.ConatactPersonMobileNo = supplier.ConatactPersonMobileNo;
                    data.Address = supplier.Address;
                    data.AccountCode = supplier.AccountCode;
                    data.Email = supplier.Email;

                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.SupplierService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteSupplier")]
        [HttpPost]
        public IHttpActionResult DeleteSupplier(Supplier supplier)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (supplier != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_Quotation", "SupplierId", supplier.SupplierId);
                    bool Exist2 = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_PurchaseOrder", "SupplierId", supplier.SupplierId);
                    if (Exist || Exist2)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.SupplierService.Remove(supplier.SupplierId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }
                   

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetSuppliers")]
        [HttpGet]
        public IHttpActionResult GetSuppliers()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<Supplier> SupplierList = DataAccess.Instance.SupplierService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (SupplierList.Count > 0)
                {
                    cr.results = SupplierList;
                    cr.message = SupplierList.Count + " Data Found.";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        //new 
        [Route("Inventory/AddCustomer")]
        [HttpPost]
        public IHttpActionResult AddCustomer(Customer customer)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (customer != null)
                {
                    List<Customer> customerList = DataAccess.Instance.CustomerService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();

                    if (customerList.Any(p => p.CustomerName == customer.CustomerName || p.CustomerCode == customer.CustomerCode || p.CompanyName == customer.CompanyName))
                    {
                        throw new Exception("Customer Already Exist.");
                    }

                    customer.Status = "A";
                    customer.IsDeleted = false;
                    customer.AddBy = User.Identity.Name;
                    customer.AddDate = DateTime.Now;
                    
                    customer.SetDate();
                    var res = DataAccess.Instance.CustomerService.Add(customer);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/UpdateCustomer")]
        [HttpPut]
        public IHttpActionResult UpdateCustomer(Customer customer)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (customer != null)
                {
                    //List<Customer> customerList = DataAccess.Instance.CustomerService.Filter(p => p.CustomerId != customer.CustomerId && p.IsDeleted == false && p.Status == "A").ToList();

                    //if (customerList.Any(p => p.CustomerName == customer.CustomerName || p.CustomerCode == customer.CustomerCode || p.CompanyName == customer.CompanyName))
                    //{
                    //    throw new Exception("Customer Already Exist.");
                    //}
                    Customer data = DataAccess.Instance.CustomerService.Filter(p => p.CustomerId == customer.CustomerId).FirstOrDefault();

                    data.CustomerName = customer.CustomerName;
                    data.CustomerCode = customer.CustomerCode;
                    data.BIN = customer.BIN;

                    data.CompanyName = customer.CompanyName;
                    data.ContactPersonName = customer.ContactPersonName;
                    data.ConatactPersonMobileNo = customer.ConatactPersonMobileNo;
                    data.Address = customer.Address;
                    data.AccountCode = customer.AccountCode;
                    data.Email = customer.Email;

                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.CustomerService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteCustomer")]
        [HttpPost]
        public IHttpActionResult DeleteCustomer(Customer customer)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (customer != null)
                {
                    //bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_Quotation", "CustomerId", customer.CustomerId);
                    //bool Exist2 = DataAccess.Instance.CommonServices.IsExist("dbo.Inv_PurchaseOrder", "CustomerId", customer.CustomerId);
                    //if (Exist || Exist2)
                    //{
                    //    throw new Exception(Constant.DATA_EXISTS);
                    //}
                    //else
                    //{
                    //    var res = DataAccess.Instance.CustomerService.Remove(customer.CustomerId);
                    //    cr.results = res;
                    //    cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    //}

                    var res = DataAccess.Instance.CustomerService.Remove(customer.CustomerId);
                    cr.results = res;
                    cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/GetCustomers")]
        [HttpGet]
        public IHttpActionResult GetCustomers()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<Customer> CustomerList = DataAccess.Instance.CustomerService.Filter(p => p.IsDeleted == false && p.Status == "A").ToList();
                if (CustomerList.Count > 0)
                {
                    cr.results = CustomerList;
                    cr.message = CustomerList.Count + " Data Found.";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }


        [Route("Inventory/SearchLedger/{srhtext}")]
        [HttpGet]
        public IHttpActionResult SearchLedger(string srhtext) //This method will Search Ledger by Name.
        {
            CommonResponse cr = new CommonResponse();
            //var results = DataAccess.Instance.LedgersService.SearchLedger(srhtext).Where(l => !LedgerIds.Contains(l.Id)).ToList();
            //if (results.Count > 0)
            //    cr.results = results;
            cr.results = DataAccess.Instance.SupplierService.SearchLedger(srhtext).ToList();

            return Json(cr);
        }

        #endregion

        #region Product
        [Route("Inventory/AddProduct")]
        [HttpPost]
        public IHttpActionResult AddProduct(Product product)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (product!=null)
                {
                    product.AddBy = User.Identity.Name;
                    var param = new object[] { product.ProductId
                                               ,product.ProductName
                                               ,product.ProductCode
                                               ,product.ProductSubCateId
                                               ,product.UnitId
                                               ,product.ReOrderLevel
                                               ,product.ProductTypeId
                                               ,product.Description
                                               ,product.OpeningBalance
                                               ,product.Amount
                                               ,product.SellingPrice                                               
                                               ,product.AddBy
                                               ,product.AccCode
                                             };
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("AddProduct",param);
                    cr.results = res.Columns.Count;
                    if (cr.results > 0)
                    {
                        cr.message = Constant.SAVED;
                    }
                    else
                    {
                        cr.message = Constant.SAVED_ERROR;
                    }
                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Inventory/UpdateProduct")]
        [HttpPut]
        public IHttpActionResult UpdateProduct(Product product)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (product != null)
                {
                    product.UpdateBy = User.Identity.Name;
                    //var res = DataAccess.Instance.ProductService.Update(product);
                    var param = new object[] { product.ProductId
                                               ,product.ProductName
                                               ,product.ProductCode
                                               ,product.ProductSubCateId
                                               ,product.UnitId
                                               ,product.ReOrderLevel
                                               ,product.ProductTypeId
                                               ,product.Description
                                               ,product.SellingPrice
                                               ,product.UpdateBy
                                             };
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateProduct", param);

                    cr.results = res.Columns.Count;
                    if (cr.results > 0)
                    {
                        cr.message = Constant.SAVED;

                    }
                    else
                    {
                        cr.message = Constant.SAVED_ERROR;
                    }

                }
                else
                {
                    cr.message = Constant.FAILED;
                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Inventory/GetProducts")]
        [HttpGet]
        public IHttpActionResult GetProducts()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //Khaled
                var res =  DataAccess.Instance.CommonServices.GetBySp("GetProductList");
                cr.results = res.Columns.Count;
                if (cr.results > 0)
                {
                    cr.message = "Data Found";
                }
                             
                else
                {
                        throw new Exception("No Data Found.");
                }
                
                
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/DeleteProduct")]
        [HttpPost]
        public IHttpActionResult DeleteProduct(Product product)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (product != null)
                {
                    bool IsExist = false;
                    List<string> tablelst = new List<string>() {"Inv_QuotationDetails","Inv_PurchaseOrderDetails","Inv_RequisitionDetails", "Inv_SalesDetails", "Inv_AssetDisposal", "Inv_Distribution" } ;
                    foreach (var tablename in tablelst)
                    {
                        IsExist = DataAccess.Instance.CommonServices.IsExist(tablename, "ProductId", product.ProductId);
                        if (IsExist)
                        {
                            throw new Exception(Constant.DATA_EXISTS);
                        }
                    }
                    if(!IsExist)
                    {
                        var res = DataAccess.Instance.ProductService.Remove(product.ProductId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }

                }
                else
                {
                    cr.message = Constant.INVAILD_DATA;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/SearchProduct/{Searchtxt}/")]
        [HttpGet]
        public IHttpActionResult SearchProduct(string Searchtxt)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.ProductService.SearchProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Inventory/SearchSellingProduct/{Searchtxt}/")]
        [HttpGet]
        public IHttpActionResult SearchSellingProduct(string Searchtxt)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.ProductService.SearchSellingProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Inventory/SearchDistributionProduct/{Searchtxt}/")]
        [HttpGet]
        public IHttpActionResult SearchDistributionProduct(string Searchtxt)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.ProductService.SearchDistributionProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Inventory/SearchFixedAssetProduct/{Searchtxt}/")]
        [HttpGet]
        public IHttpActionResult SearchFixedAssetProduct(string Searchtxt)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.ProductService.SearchFixedAssetProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Inventory/GetProductListById/{ProductId}/")]
        [HttpGet]
        public IHttpActionResult GetProductListById(int  ProductId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetProductListById", new object[] { ProductId });
                    
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        #endregion

        #region Requsition
        [Route("Inventory/RequisitionAdd/")]
        [HttpPost]
        public IHttpActionResult RequisitionAdd(Requisition requisition)
        {
            CommonResponse cr = new CommonResponse();
            try
            {             
                if (requisition != null)
                {
                    var res = true;
                    requisition.DueDate = Convert.ToDateTime(requisition.Date);
                    requisition.AddBy = User.Identity.Name;
                    List<SqlParameter> param = new List<SqlParameter>();

            

                    param.Add(new SqlParameter("DueDate",requisition.DueDate));
                    param.Add(new SqlParameter("Description", requisition.Description));
                    param.Add(new SqlParameter("AddBy", requisition.AddBy));



                    DataTable dtt = new DataTable();
                    dtt.Columns.Add("ProductId", typeof(int));
                    dtt.Columns.Add("Quantity", typeof(decimal));
               
                    foreach (var item in requisition.ReqDetailsList)
                    {
                        dtt.Rows.Add(item.ProductId, item.Quantity);
                    }

                    param.Add(Converter.ToSqlParameter("RequisitionDetails", dtt, "dbo.udtRequisitionDetails"));


                    var dt = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("AddRequisition", param.ToArray());
                
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.results = res;
                }
                else
                {
                    cr.message = "Data Not Found";
                }

                //cr.results = DataAccess.Instance.ProductService.SearchProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Inventory/GetRequisitionList/")]
        [HttpGet]
        public IHttpActionResult GetRequisitionList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                
                Requisition req = new Requisition();
                cr = DataAccess.Instance.RequisitionService.getDataSetResponseBySp("GetRequisitionList");
                req.requisition = CommonRepository.ConvertDataTable<Requisition>(cr.results.Tables[0]);
                req.ReqDetailsList = CommonRepository.ConvertDataTable<RequisitionDetails>(cr.results.Tables[1]);
                if (req.requisition.Count>0)
                {
                    cr.results = req;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.INVAILD_DATA;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/RequisitionUpdate/")]
        [HttpPut]
        public IHttpActionResult RequisitionUpdate(Requisition requisition)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                
                if (requisition!=null)
                {
                    Requisition data = DataAccess.Instance.RequisitionService.Filter(r => r.RequisitionId == requisition.RequisitionId).FirstOrDefault();
                    data.ApprovedBy = User.Identity.Name;
                    data.ApprovedComments = requisition.ApprovedComments;
                    data.IsApproved = true;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    var res = DataAccess.Instance.RequisitionService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }
                else
                {
                    cr.message = Constant.SAVED_ERROR;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/RequisitionDelete/")]
        [HttpPost]
        public IHttpActionResult RequisitionDelete(Requisition requisition)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (requisition != null)
                {
                   
                    var res = DataAccess.Instance.RequisitionService.Remove(requisition.RequisitionId);
                    cr.results = res;
                    cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                }
                else
                {
                    cr.message = Constant.FAILED;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }



        #endregion


        #region Quotation 
        [Route("Inventory/QuotationAdd/")]
        [HttpPost]
        public IHttpActionResult QuotationAdd(Quotation quotation)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
           
                if (quotation != null)
                {
                    var res = true;
                    quotation.AddBy = User.Identity.Name;
                    quotation.DueDate = Convert.ToDateTime(quotation.Date);
                    List<SqlParameter> param = new List<SqlParameter>();
                    param.Add(new SqlParameter("SupplierId", quotation.SupplierId));
                    param.Add(new SqlParameter("DueDate", quotation.DueDate));

                    param.Add(new SqlParameter("Description", quotation.Description));
                    param.Add(new SqlParameter("AddBy", quotation.AddBy));
                    DataTable dtt = new DataTable();
                    dtt.Columns.Add("ProductId", typeof(int));
                    dtt.Columns.Add("Quantity", typeof(decimal));
                    dtt.Columns.Add("Discount", typeof(decimal));
                    dtt.Columns.Add("UnitPrice", typeof(decimal));
              

                    foreach (var item in quotation.QuoDetailsList)
                    {
                        dtt.Rows.Add(item.ProductId, item.Quantity, item.Discount, item.UnitPrice);
                    }

                    param.Add(Converter.ToSqlParameter("QuotationDetails", dtt, "dbo.udtQuotationDetails"));


                    var dt = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("AddQuotation", param.ToArray());

                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.results = res;
                }
                else
                {
                    cr.message = "Data Not Found";
                }

                //cr.results = DataAccess.Instance.ProductService.SearchProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Inventory/GetQuotationList/")]
        [HttpGet]
        public IHttpActionResult GetQuotationList()
        {
            CommonResponse cr = new CommonResponse();
         
            try
            {

                Quotation qua = new Quotation();
                cr = DataAccess.Instance.QuotationService.getDataSetResponseBySp("GetQuotationList");
                qua.QutatinList = CommonRepository.ConvertDataTable<Quotation>(cr.results.Tables[0]);
                qua.QuoDetailsList = CommonRepository.ConvertDataTable<QuotationDetails>(cr.results.Tables[1]);
                if (qua.QutatinList.Count > 0)
                {
                    cr.results = qua;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.DATA_NOT_FOUND;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        [Route("Inventory/QuotationDelete/")]
        [HttpPost]
        public IHttpActionResult QuotationDelete(Quotation quotation)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (quotation != null)
                {

                    var res = DataAccess.Instance.QuotationService.Remove(quotation.QuotationId);
                    cr.results = res;
                    cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                }
                else
                {
                    cr.message = Constant.FAILED;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        #endregion

        #region PurchaseOrder 

        [Route("Inventory/AddPurchaseOrder")]
        [HttpPost]
        public IHttpActionResult AddPurchaseOrder(PurchaseOrder purchaseOrder)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (purchaseOrder != null)
                {
                    var res = true;
                    purchaseOrder.DueDate = Convert.ToDateTime(purchaseOrder.Date);
                    List<SqlParameter> param = new List<SqlParameter>();
                    param.Add(new SqlParameter("SupplierId", purchaseOrder.SupplierId));
                    param.Add(new SqlParameter("DueDate", purchaseOrder.DueDate));
                    param.Add(new SqlParameter("Description", purchaseOrder.Description));

                    DataTable dtt = new DataTable();
                    dtt.Columns.Add("ProductId", typeof(int));
                    dtt.Columns.Add("Quantity", typeof(decimal));
                    dtt.Columns.Add("UnitPrice", typeof(decimal));
                    dtt.Columns.Add("TotalPrice", typeof(decimal));
                    dtt.Columns.Add("Discount", typeof(decimal));
                    foreach (var item in purchaseOrder.OrderDetails)
                    {
                        dtt.Rows.Add(item.ProductId,item.Quantity,item.UnitPrice,item.TotalPrice,item.Discount);
                    }

                    param.Add(Converter.ToSqlParameter("OrderDetails", dtt, "dbo.udtPurchaseOrderDetails"));

                    var dt = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("AddPurchaseOrder", param.ToArray());
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.results = res;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }


        [Route("Inventory/GetPurchaseOrderList/")]
        [HttpGet]
        public IHttpActionResult GetPurchaseOrderList()
        {
            CommonResponse cr = new CommonResponse();
         try
            {

                PurchaseOrder pur = new PurchaseOrder();
                cr = DataAccess.Instance.QuotationService.getDataSetResponseBySp("GetPurchaseOrderList");
                pur.PurchaseOrderList = CommonRepository.ConvertDataTable<PurchaseOrder>(cr.results.Tables[0]);
                pur.OrderDetails = CommonRepository.ConvertDataTable<PurchaseOrderDetails>(cr.results.Tables[1]);
                if (pur.PurchaseOrderList.Count > 0)
                {
                    cr.results = pur;
                    cr.message = "Data Found";
                }
                else
                {
                    cr.message = Constant.INVAILD_DATA;
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Inventory/SearchPurchaseOrder/{Searchtxt}/")]
        [HttpGet]
        public IHttpActionResult SearchPurchaseOrder(string Searchtxt)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.PurchaseOrderService.SearchPurchaseOrder(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Inventory/GetPurchaseOrderListById/{PoId}/")]
        [HttpGet]
        public IHttpActionResult GetPurchaseOrderListById(int PoId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPurchaseOrderListById", new object[] { PoId });

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Inventory/PurchaseOrderDelete/")]
        [HttpPost]
        public IHttpActionResult PurchaseOrderDelete(PurchaseOrder purhaseOrder)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (purhaseOrder != null)
                {

                    var res = DataAccess.Instance.PurchaseOrderService.Remove(purhaseOrder.POId);
                    cr.results = res;
                    cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                }
                else
                {
                    cr.message = Constant.FAILED;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Inventory/ReceivePurchaseOrder/")]
        [HttpPost]
        public IHttpActionResult ReceivePurchaseOrder(PurchaseOrder purhaseOrder)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (purhaseOrder != null)
                {
                    var res = true;
                    purhaseOrder.UpdateBy = User.Identity.Name;
                    List<SqlParameter> param = new List<SqlParameter>();
                    param.Add(new SqlParameter("POId", purhaseOrder.POId));
                    param.Add(new SqlParameter("ReceiverComments", purhaseOrder.ReceiverComments));
                    param.Add(new SqlParameter("UpdateBy", purhaseOrder.UpdateBy));

                    DataTable dtt = new DataTable();
                    dtt.Columns.Add("ReceiveQuantity", typeof(int));
                    dtt.Columns.Add("PODetailsId", typeof(int));
                    dtt.Columns.Add("ProductId", typeof(int));

                    foreach (var item in purhaseOrder.OrderDetails)
                    {
                        dtt.Rows.Add(item.ReceiveQuantity,item.PODetailsId,item.ProductId);
                    }

                    param.Add(Converter.ToSqlParameter("UpdateOrderDetails", dtt, "dbo.udtUpdatePurchaseOrderDetails"));

                    var dt = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("UpdatePurchaseOrderReceive", param.ToArray());
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }
                else
                {
                    cr.message = Constant.FAILED;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        #endregion

        #region Sales
        [Route("Inventory/SalesAdd/")]
        [HttpPost]
        public IHttpActionResult SalesAdd(Sales sales)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (sales != null)
                {
                    var res = true;
                    sales.AddBy = User.Identity.Name;
                    List<SqlParameter> param = new List<SqlParameter>();

                    param.Add(new SqlParameter("CustomerName", sales.CustomerName));
                    param.Add(new SqlParameter("MobileNo", sales.MobileNo));
                    param.Add(new SqlParameter("Vat", sales.Vat));
                    param.Add(new SqlParameter("SubTotal", sales.SubTotal));
                    param.Add(new SqlParameter("NetPayable", sales.NetPayable));
                    param.Add(new SqlParameter("AddBy", sales.AddBy));

                    DataTable dtt = new DataTable();
                    dtt.Columns.Add("ProductId", typeof(int));
                    dtt.Columns.Add("Quantity", typeof(decimal));
                    dtt.Columns.Add("SubTotal", typeof(decimal));
                    dtt.Columns.Add("UnitPrice", typeof(decimal));
                    foreach (var item in sales.SalesDetails)
                    {
                        dtt.Rows.Add(item.ProductId, item.Quantity,item.SubTotal,item.UnitPrice);
                    }
                    param.Add(Converter.ToSqlParameter("SalesDetails", dtt, "dbo.udtSalesDetails"));


                    var dt = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("AddSales", param.ToArray());

                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.results = res;
                }
                else
                {
                    cr.message = "Data Not Found";
                }

                //cr.results = DataAccess.Instance.ProductService.SearchProduct(Searchtxt);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }



        #endregion

        #region Distribution
        [Route("Inventory/AddDistribution")]
        [HttpPost]
        public IHttpActionResult AddDistribution(Distribution distribution)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (distribution != null)
                {
                    
                    distribution.AddBy = User.Identity.Name;
                    var param = new object[] { distribution.ProductId
                                               ,distribution.Qty
                                               ,distribution.EmployeeId
                                               ,distribution.AddBy};
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("AddDistribution", param);
                    cr.results = res.Columns.Count;
                    if (cr.results > 0)
                    {
                        cr.message = Constant.SAVED;

                    }
                    else
                    {
                        cr.message = Constant.SAVED_ERROR;
                    }

                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion

        #region Asses
        [Route("Inventory/AddAssetDisposal")]
        [HttpPost]
        public IHttpActionResult AddAssetDisposal(AssetDisposal assetdisposal)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (assetdisposal != null)
                {

                    assetdisposal.AddBy = User.Identity.Name;
                    var param = new object[] { assetdisposal.ProductId
                                               ,assetdisposal.DisposalType
                                               ,assetdisposal.SellingPrice
                                               ,assetdisposal.Quantity
                                               ,assetdisposal.AccountCode
                                               ,assetdisposal.AddBy};
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("AddAssetDisposal", param);
                    cr.results = res.Columns.Count;
                   cr.message = Constant.SAVED;
                    
                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion
    }
}
