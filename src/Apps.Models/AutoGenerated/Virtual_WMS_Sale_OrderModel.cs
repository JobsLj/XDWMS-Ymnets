//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

using Apps.Models;
using System;
using System.ComponentModel.DataAnnotations;
namespace Apps.Models.WMS
{

	public partial class WMS_Sale_OrderModel:Virtual_WMS_Sale_OrderModel
	{
		
	}
	public class Virtual_WMS_Sale_OrderModel
	{
		[Display(Name = "未设置")]
		public virtual int Id { get; set; }
		[Display(Name = "销售单号（业务）")]
		public virtual string SaleBillNum { get; set; }
		[Display(Name = "销售单号（系统）")]
		public virtual string SellBillNum { get; set; }
		[Display(Name = "计划发货日期")]
		public virtual Nullable<System.DateTime> PlanDeliveryDate { get; set; }
		[Display(Name = "客户")]
		public virtual int CustomerId { get; set; }
		[Display(Name = "物料Id")]
		public virtual int PartId { get; set; }
		[Display(Name = "数量")]
		public virtual decimal Qty { get; set; }
		[Display(Name = "箱数")]
		public virtual Nullable<decimal> BoxQty { get; set; }
		[Display(Name = "库存")]
		public virtual Nullable<int> InvId { get; set; }
		[Display(Name = "子库存")]
		public virtual Nullable<int> SubInvId { get; set; }
		[Display(Name = "批次号：YYYYMM")]
		public virtual string Lot { get; set; }
		[Display(Name = "备注")]
		public virtual string Remark { get; set; }
		[Display(Name = "打印状态")]
		public virtual string PrintStaus { get; set; }
		[Display(Name = "打印日期")]
		public virtual Nullable<System.DateTime> PrintDate { get; set; }
		[Display(Name = "打印人")]
		public virtual string PrintMan { get; set; }
		[Display(Name = "确认状态")]
		public virtual string ConfirmStatus { get; set; }
		[Display(Name = "确认人")]
		public virtual string ConfirmMan { get; set; }
		[Display(Name = "确认时间")]
		public virtual Nullable<System.DateTime> ConfirmDate { get; set; }
		[Display(Name = "未设置")]
		public virtual string Attr1 { get; set; }
		[Display(Name = "未设置")]
		public virtual string Attr2 { get; set; }
		[Display(Name = "未设置")]
		public virtual string Attr3 { get; set; }
		[Display(Name = "未设置")]
		public virtual string Attr4 { get; set; }
		[Display(Name = "未设置")]
		public virtual string Attr5 { get; set; }
		[Display(Name = "创建人")]
		public virtual string CreatePerson { get; set; }
		[Display(Name = "创建时间")]
		public virtual Nullable<System.DateTime> CreateTime { get; set; }
		[Display(Name = "修改人")]
		public virtual string ModifyPerson { get; set; }
		[Display(Name = "修改时间")]
		public virtual Nullable<System.DateTime> ModifyTime { get; set; }
		[Display(Name = "未设置")]
		public virtual string ConfirmMessage { get; set; }
		[Display(Name = "未设置")]
		public virtual Nullable<decimal> Volume { get; set; }
		}
}
