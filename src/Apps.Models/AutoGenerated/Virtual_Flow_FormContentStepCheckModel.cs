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
namespace Apps.Models.Flow
{

	public partial class Flow_FormContentStepCheckModel:Virtual_Flow_FormContentStepCheckModel
	{
		
	}
	public class Virtual_Flow_FormContentStepCheckModel
	{
		[Display(Name = "GUID主键")]
		public virtual string Id { get; set; }
		[Display(Name = "所属公文")]
		public virtual string ContentId { get; set; }
		[Display(Name = "所属步骤")]
		public virtual string StepId { get; set; }
		[Display(Name = "0不通过1通过2审核中")]
		public virtual int State { get; set; }
		[Display(Name = "状态(是否完成)")]
		public virtual bool StateFlag { get; set; }
		[Display(Name = "创建时间")]
		public virtual System.DateTime CreateTime { get; set; }
		[Display(Name = "是否结束")]
		public virtual bool IsEnd { get; set; }
		[Display(Name = "是否自选审核人默认为false")]
		public virtual bool IsCustom { get; set; }
		}
}
