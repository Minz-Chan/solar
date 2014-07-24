package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.FuelManagementProxy;
	import com.fallmind.solars.model.GetFuelProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.solarSystem.FuelManagementView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.validators.Validator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class FuelManagementMediator extends Mediator
	{
		
		public static const NAME:String = "FuelManagementMediator";
		
		private var currentDataProxy:CurrentDataProxy;
		private var getFuelProxy:GetFuelProxy;
		private var loginProxy:LoginProxy;
		private var fuelManagementProxy:FuelManagementProxy;
		
		private var dataUpdated:ArrayCollection;
		
		public function FuelManagementMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			dataUpdated = new ArrayCollection();
			
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			getFuelProxy = GetFuelProxy(facade.retrieveProxy(GetFuelProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			fuelManagementProxy = FuelManagementProxy(facade.retrieveProxy(FuelManagementProxy.NAME));
			
			
			initEventListener();
			
		}
		
		public function initEventListener():void {
			fmView.addEventListener(FuelManagementView.ADD_FUEL, addHandler);
			fmView.addEventListener(FuelManagementView.DELETE_FUEL, deleteHandler);
			fmView.addEventListener(FuelManagementView.CLOSE_FUELMANAGEMENT_VIEW, closeViewHandler);
			fmView.addEventListener(FuelManagementView.UPDATE_FUELINFO, updateHandler);
			fmView.addEventListener(FuelManagementView.SAVA_CHANGE_OF_FUELSINFO, saveHandler);
			fmView.addEventListener(FuelManagementView.QUERY_FUELS_DATA, queryHandler);
			fmView.addEventListener(FuelManagementView.COMBOX_CHANGE, comboxChangeHandler);
		}
		
		override public function handleNotification(notification:INotification):void {
		
			switch(notification.getName()){
				case ApplicationFacade.SHOW_FUEL_MANAGEMENT:
					getFuelProxy.getFuelsByFuelType(loginProxy.getUserName(), loginProxy.getUserPassword(), "all");
					break;
				case GetFuelProxy.GET_FUEL_SUCCESS:
					if(getFuelProxy.type == "all") {
						initFuelManagementView(getFuelProxy.fuelsDetail);
					}
					break;
			}
		
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_FUEL_MANAGEMENT,
				GetFuelProxy.GET_FUEL_SUCCESS
			]; 
		}
		
		public function get fmView(): FuelManagementView {
			return viewComponent as FuelManagementView;
		}
		
		public function initFuelManagementView(data:XML):void {
			var fuelList:XMLList = data.children();
			var fuelInfoList:ArrayCollection = new ArrayCollection();
			var i:int;
			
			
			dataUpdated.removeAll();
			
			for(i = 0; i < fuelList.length(); i++){
				fuelInfoList.addItem({"id":fuelList[i].@id.toString()
						,"fuelName":fuelList[i].@FuelName.toString()
						, "fuelType":fuelList[i].@FuelType.toString()
						, "param1":fuelList[i].@param1.toString()
						, "param2":fuelList[i].@param2.toString()
						, "status":"initial"});
				dataUpdated.addItem({"id":fuelList[i].@id.toString()
						,"fuelName":fuelList[i].@FuelName.toString()
						, "fuelType":fuelList[i].@FuelType.toString()
						, "param1":fuelList[i].@param1.toString()
						, "param2":fuelList[i].@param2.toString()
						, "status":"initial"});
			}
			
			fmView.fuelsList = fuelInfoList;
			
			comboxChangeHandler(null);		
		}
		
		/**
		 * 检验验证是否完全通过
		 * 返回值: true, 完全通过; false, 没有完全通过
		 **/ 
		public function validateAll():Boolean {
			var arr:Array = Validator.validateAll(fmView.validators);
			if (arr.length != 0) {	// 验证没有完全通过
				return false;
			}
			
			return true;
		}
		
		
		/**
		 * 触发Combox change事件，进行数据过滤 
		 */ 
		private function comboxChangeHandler(e:Event):void {
			var type:String = fmView.fuelType.selectedItem.data.toString();
			var fuelInfoList:ArrayCollection = new ArrayCollection();
			
			for each(var data in fmView.fuelsList) {
				if(data.fuelType == type) {
					fuelInfoList.addItem(data);				
				} 
			}
			
			fmView.fuelsListForShow = fuelInfoList;
		}
		
		/**
		 * 查询燃料信息
		 */ 
		private function queryHandler(e:Event):void {
			sendNotification(ApplicationFacade.SHOW_FUEL_MANAGEMENT);	
		}
		
		
		/**
		 * 关闭 
		 */ 
		private function closeViewHandler(e:Event):void {
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(fmView);
			this.setViewComponent(null);
		}
		
		/**
		 * 新增燃料 
		 */ 
		private function addHandler(e:Event):void {
			if (!validateAll()) {	// 验证没有完全通过
				return;
			}
			
			var fuelType:String = fmView.fuelType.selectedItem.data.toString();
			var fuelName:String = fmView.fuelName.text;
			var param1:String = fmView.param1.text;
			var param2:String = "0";
			
			var fuelsInfo:ArrayCollection = fmView.fuelsList;
			fuelsInfo.addItem({"id":""
						, "fuelName":fuelName
						, "fuelType":fuelType
						, "param1":param1
						, "param2":param2
						, "status":"added"});
						
			fmView.lblPrompt.text = "数据已新增";
			
			comboxChangeHandler(null);
			
		}
		
		/**
		 * 删除燃料 
		 */ 
		private function deleteHandler(e:Event):void {
			var i:int;
			var id:String = fmView.dg.selectedItem.id;
			var itemSel:Object = fmView.dg.selectedItem;
			var fuelsInfo:ArrayCollection = fmView.fuelsList;
			
			// 在DataGrid视图上移除
			for(i = 0; i < fuelsInfo.length; i++) {
				if(fuelsInfo[i] == itemSel){
					fuelsInfo.removeItemAt(i);
				}
			}
			
			
			if(id != "") { // 对于非通过[新增]操作产生的行，作同步数据变更记录
				for(i = 0; i < dataUpdated.length; i++) {
					if(dataUpdated[i].id.toString() == id) {
						dataUpdated[i].status += ";deleted";
					}
				}
			}
			
			fmView.lblPrompt.text = "数据已删除";
			
			comboxChangeHandler(null);
		}
		
		
		/**
		 * 修改燃料信息 
		 */ 
		private function updateHandler(e:Event):void {
			if (!validateAll()) {	// 验证没有完全通过
				return;
			}
			
			// 修改DataGrid视图上的信息
			var i:int;
			var itemSel:Object = fmView.dg.selectedItem;
			var fuelsInfo:ArrayCollection = fmView.fuelsList;
			
			if(itemSel == null) {
				Alert.show("请选择欲修改的项！");
				return;
			}
			
			for(i = 0; i < fuelsInfo.length; i++) {
				if(fuelsInfo[i] == itemSel){
					fuelsInfo[i].fuelName = fmView.fuelName.text;
					fuelsInfo[i].fuelType = fmView.fuelType.selectedItem.data.toString();
					fuelsInfo[i].param1 = fmView.param1.text;
					fuelsInfo[i].param2 = "0"
				}
			}
			
			if(itemSel.id != "") {	// 对于非通过[新增]操作产生的行，作同步数据变更记录
				for(i = 0; i < dataUpdated.length; i++) {
					if(dataUpdated[i].id.toString() == itemSel.id.toString()) {
						dataUpdated[i].fuelName = itemSel.fuelName;
						dataUpdated[i].fuelType = itemSel.fuelType;
						dataUpdated[i].param1 = itemSel.param1;
						dataUpdated[i].param2 = itemSel.param2;
						dataUpdated[i].status += ";updated";
					}
				}
			}
			
			fmView.lblPrompt.text = "数据已修改";
			
			comboxChangeHandler(null);
		}
		
		/**
		 * 保存所作编辑, 用作将修改提交至数据库
		 */ 
		private function saveHandler(e:Event):void {
			// 将datagrid中新增的数据同步到dataUpdated中
			var i:int;
			var fuelsList:ArrayCollection = fmView.fuelsList;
			for(i = 0; i < fuelsList.length; i++) {
				if(fuelsList[i].id.toString() == "") {
					dataUpdated.addItem({"id":""
						, "fuelName":fuelsList[i].fuelName.toString()
						, "fuelType":fuelsList[i].fuelType.toString()
						, "param1":fuelsList[i].param1.toString()
						, "param2":fuelsList[i].param2.toString()
						, "status":"added"});
				}
			}

			var REGEXP_ROWDELETED:RegExp = /^initial[\s\S]*deleted$/;
			var REGEXP_ROWUPDATED:RegExp = /^initial[\s\S]*updated$/;
			var REGEXP_ROWADDED:RegExp = /^added$/;
			var REGEXP_ROWADDEDDELETED:RegExp = /^added[\s\S]*deleted$/;
			
			
			for each(var data in dataUpdated){
				trace(data.status);

				// 待增加数据
				if(REGEXP_ROWADDED.test(data.status)) {
					fuelManagementProxy.addFuel(loginProxy.getUserName(), loginProxy.getUserPassword(), data.fuelName, data.fuelType, 
							data.param1, data.param2); 
				}
				
				// 待删除数据
				if(REGEXP_ROWDELETED.test(data.status)) {
					fuelManagementProxy.deleteFuel(loginProxy.getUserName(), loginProxy.getUserPassword(), data.id);
				}
				
				// 待更新数据
				if(REGEXP_ROWUPDATED.test(data.status)) {
					var updatedStr:String = 
							  "fuelName:" + data.fuelName.toString()
							+ ";fuelType:" + data.fuelType.toString()
							+ ";param1:" + data.param1.toString()
							+ ";param2:" + data.param2.toString() + ";";
					fuelManagementProxy.updateFuel(loginProxy.getUserName(), loginProxy.getUserPassword(), data.id, updatedStr);
				}
				
			}
			
			Alert.show("数据保存成功");

		}
		
		
	}
}