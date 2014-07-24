package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.model.AddRegionProxy;
	import com.fallmind.solars.model.DeleteRegionProxy;
	import com.fallmind.solars.model.GetRegionProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.clientSetup.RegionInfoManageView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class RegionInfoMediator extends Mediator
	{
		public static const NAME:String = "RegionInfoMediator";
		private var loginProxy:LoginProxy;
		private var addRegionProxy:AddRegionProxy;
		private var userName:String;
		private var password:String;
		private var getRegionProxy:GetRegionProxy;
		private var deleteRegionProxy:DeleteRegionProxy;
		
		private var lastSelectedCountryID:String = null;
		private var lastSelectedProvinceID:String = null;
		private var lastSelectedCityID:String = null;
		
		private var addProvince:Boolean = false;
		private var addCountry:Boolean = false;
		private var addCity:Boolean = false;
		private var delProvince:Boolean = false;
		private var delCountry:Boolean = false;
		private var delCity:Boolean = false;
		
		public function RegionInfoMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			addRegionProxy = AddRegionProxy(facade.retrieveProxy(AddRegionProxy.NAME));
			getRegionProxy = GetRegionProxy(facade.retrieveProxy(GetRegionProxy.NAME));
			deleteRegionProxy = DeleteRegionProxy(facade.retrieveProxy(DeleteRegionProxy.NAME));
			
			regionView.addEventListener(RegionInfoManageView.ADD_COUNTRY, addCountryHandler);
			regionView.addEventListener(RegionInfoManageView.ADD_PROVINCE, addProvinceHandler);
			regionView.addEventListener(RegionInfoManageView.ADD_CITY, addCityHandler);
			regionView.addEventListener(RegionInfoManageView.DELETE_REGION, deleteRegionHandler);
		}
		private function deleteRegionHandler(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员") {
				Alert.show("没有权限");
				return;
			}
			if(regionView.deleteRegionType == "1") {
				delCountry = true;
			}
			if(regionView.deleteRegionType == "2") {
				delProvince = true;
			}
			if(regionView.deleteRegionType == "3") {
				delCity = true;
			}
			if(regionView.countryList.selectedItem != null) {
				lastSelectedCountryID = regionView.countryList.selectedItem.@AreaID;
			}
			if(regionView.provinceList.selectedItem != null) {
				lastSelectedProvinceID = regionView.provinceList.selectedItem.@AreaID;
			}
			if(regionView.cityList.selectedItem != null) {
				lastSelectedCityID = regionView.cityList.selectedItem.@AreaID;
			}
			deleteRegionProxy.deleteRegion(userName, password, regionView.deleteRegionID);
		}
		private function addCountryHandler(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员") {
				Alert.show("没有权限");
				return;
			}
			if(regionView.countryInput.text == "") {
				Alert.show("不能为空");
				return;
			}
			addCountry = true;
			for each(var item:XML in regionView.countryData) {
				if(item.@AreaName == regionView.countryInput.text) {
					Alert.show(regionView.countryInput.text + "已经在列表中" );
					return;
				}
			}
			if(regionView.countryList.selectedItem != null) {
				lastSelectedCountryID = regionView.countryList.selectedItem.@AreaID;
			}
			if(regionView.provinceList.selectedItem != null) {
				lastSelectedProvinceID = regionView.provinceList.selectedItem.@AreaID;
			}
			if(regionView.cityList.selectedItem != null) {
				lastSelectedCityID = regionView.cityList.selectedItem.@AreaID;
			}
			addRegionProxy.addRegion(userName, password, regionView.countryInput.text, "1", "-1");
		}
		private function addProvinceHandler(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员") {
				Alert.show("没有权限");
				return;
			}
			addProvince = true;
			if(regionView.provinceInput.text == "") {
				Alert.show("不能为空");
				return;
			}
			
			
			for each(var item:XML in regionView.provinceData) {
				if(item.@AreaName == regionView.provinceInput.text) {
					Alert.show(regionView.provinceInput.text + "已经在列表中" );
					return;
				}
			}
			
			if(regionView.countryList.selectedItem != null) {
				lastSelectedCountryID = regionView.countryList.selectedItem.@AreaID;
			}
			if(regionView.provinceList.selectedItem != null) {
				lastSelectedProvinceID = regionView.provinceList.selectedItem.@AreaID;
			}
			if(regionView.cityList.selectedItem != null) {
				lastSelectedCityID = regionView.cityList.selectedItem.@AreaID;
			}
			addRegionProxy.addRegion(userName, password, regionView.provinceInput.text, "2", regionView.countryList.selectedItem.@AreaID);
		}
		private function addCityHandler(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员" ) {
				Alert.show("没有权限");
				return;
			}
			addCity = true;
			if(regionView.cityInput.text == "") {
				Alert.show("不能为空");
				return;
			}
			
			for each(var item:XML in regionView.cityData) {
				if(item.@AreaName == regionView.cityInput.text) {
					Alert.show(regionView.cityInput.text + "已经在列表中");
					return;
				}
			}
			if(regionView.countryList.selectedItem != null) {
				lastSelectedCountryID = regionView.countryList.selectedItem.@AreaID;
			}
			if(regionView.provinceList.selectedItem != null) {
				lastSelectedProvinceID = regionView.provinceList.selectedItem.@AreaID;
			}
			if(regionView.cityList.selectedItem != null) {
				lastSelectedCityID = regionView.cityList.selectedItem.@AreaID;
			}
			addRegionProxy.addRegion(userName, password, regionView.cityInput.text, "3", regionView.provinceList.selectedItem.@AreaID);
		}
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ 
					  GetRegionProxy.GET_REGION_FAILED,
					  GetRegionProxy.GET_REGION_SUCCESS,
					  AddRegionProxy.ADD_REGION_FAILED,
					  AddRegionProxy.ADD_REGION_SUCCESS,
					  DeleteRegionProxy.DELETE_REGION_FAILED,
					  DeleteRegionProxy.DELETE_REGION_SUCCESS
					];
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case GetRegionProxy.GET_REGION_SUCCESS:
					userName = loginProxy.getData().UserName;
					password = loginProxy.getData().UserPassword;
					regionView.totalData = getRegionProxy.getData() as XML;
					regionView.countryData = getRegionProxy.getData().row.(@TypeLevel == "1");
					
					if(lastSelectedCountryID != null) {
						regionView.provinceData = getRegionProxy.getData().row.((@TypeLevel == "2" || @TypeLevel == "4") && @BelongRel == lastSelectedCountryID);
					} else {
						//regionView.provinceData = getRegionProxy.getData().row.(@TypeLevel == "2" || @TypeLevel == "4");
					}
					if(lastSelectedProvinceID != null) {
						regionView.cityData = getRegionProxy.getData().row.(@TypeLevel == "3" && @BelongRel == lastSelectedProvinceID);
					} else {
						//regionView.cityData = getRegionProxy.getData().row.(@TypeLevel == "3");
					}
					if(addCountry || delCountry) {
						regionView.provinceData = null;
						regionView.cityData = null;
						addCountry = false;
						delCountry = false;
					}
					if(addProvince || delProvince) {
						regionView.cityData = null;
						addProvince = false;
						delProvince = false;
					}
					
					break;
				case AddRegionProxy.ADD_REGION_FAILED:
					Alert.show("添加失败");
					break;
				case AddRegionProxy.ADD_REGION_SUCCESS:
					//loginProxy.login(userName, password);
					loginProxy.refresh();
					break;
				case DeleteRegionProxy.DELETE_REGION_SUCCESS:
					//loginProxy.login(userName, password);
					loginProxy.refresh();
					break;
				case DeleteRegionProxy.DELETE_REGION_FAILED:
					Alert.show("删除失败");
					break;
			}
		}
		protected function get regionView():RegionInfoManageView {
			return viewComponent as RegionInfoManageView;
		}
	}
}