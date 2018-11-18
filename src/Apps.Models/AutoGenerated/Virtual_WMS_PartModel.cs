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

	public partial class WMS_PartModel:Virtual_WMS_PartModel
	{
		
	}
	public class Virtual_WMS_PartModel
	{
		[Display(Name = "物料ID")]
		public virtual int id { get; set; }
		[Display(Name = "物料编码")]
		public virtual string part_code { get; set; }
		[Display(Name = "物料名称")]
		public virtual string part_name { get; set; }
		[Display(Name = "物料类型")]
		public virtual string part_type { get; set; }
		[Display(Name = "客户编码")]
		public virtual string customer_code { get; set; }
		[Display(Name = "物流号")]
		public virtual string logistics_code { get; set; }
		[Display(Name = "额外信息编码")]
		public virtual string other_code { get; set; }
		[Display(Name = "每箱数量")]
		public virtual Nullable<decimal> pcs { get; set; }
		[Display(Name = "保管员")]
		public virtual string storeman { get; set; }
		[Display(Name = "物料状态")]
		public virtual string status { get; set; }
		[Display(Name = "未设置")]
		public virtual string created_by { get; set; }
		[Display(Name = "未设置")]
		public virtual Nullable<System.DateTime> creation_date { get; set; }
		[Display(Name = "未设置")]
		public virtual string updated_by { get; set; }
		[Display(Name = "未设置")]
		public virtual Nullable<System.DateTime> update_date { get; set; }
		}
}
