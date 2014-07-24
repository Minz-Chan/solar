// ActionScript file
package com.fallmind.solars.model.CheckProxy {
	/**
	 * 保存设置系统参数的数据结构
	 */
	public class SetupData {
		public var Collector_T_H:String;// 集热板定温出水水温（度）
		public var Collector_T_L:String;//集热板最低水温（度）
		public var ProductBox_T_L:String; // 产热水箱最低水温（度）
		public var ProductBox_T_H:String; // 产热水箱最高水温（度）
		public var OfferBox_T_L:String; // 供热水箱最低水温（度）
		public var OfferBox_T_H:String; // 供热水箱最高水温（度）
		public var Collector_Box_T:String; // 集热器-水箱循环温差（度）
		public var Product_Offer_T:String; // 产热水箱-供热水箱循环温差（度）
		public var ReturnPipe_T_L:String; // 回水管最低水温（度）
		public var ProductBox_WL_H:String; // 产热水箱满水水位（%）
		public var OfferBox_WL_H:String; // 供热水箱满水水位（%）
		public var TwoBox_WL_Scale:String; // 产供最低水位配对比例
		public var OfferBox_Def_WL_L:String; // 供热水箱单位时段默认最低水位（%）
	}
}