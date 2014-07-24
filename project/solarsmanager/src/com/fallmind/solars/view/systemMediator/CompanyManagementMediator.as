package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CompanyManagementProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCompanyInfoProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.solarSystem.CompanyManagementView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.validators.Validator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 集群管理（新增、删除、修改、查询的类）
	 *  
	 * dataUpdated作中数据CRUD记录，最后将以其中的记录作为数据库中数据变更的依据
	 * 此模块实现中DataGrid中的数据分两类：CompanyId有值和CompanyId无值。
	 * CompanyId有值：说明此数据是从数据库取出，对其进行增删改作将记录同步到dataUpdated中；
	 * CompanyId无值：说明此数据为本次新增，对其进行增删改无须作记录，但当触发“保存”事件时，所有CompanyId无值的行将作为新增的行同步到dataUpdated中。
	 * 最终将以dataUpdated中记录为依据进行数据库中数据的统一变更 
	 **/
	public class CompanyManagementMediator extends Mediator
	{
		public static const NAME:String = "CompanyManagementMediator";
		
		private var currentDataProxy:CurrentDataProxy;
		private var getCompanyInfoProxy:GetCompanyInfoProxy;
		private var loginProxy:LoginProxy;
		private var companyManagementProxy:CompanyManagementProxy;
		private var dataUpdated:ArrayCollection;				// 作增、删、改、查记录
		
		public function CompanyManagementMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			dataUpdated = new ArrayCollection();
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			getCompanyInfoProxy = GetCompanyInfoProxy(facade.retrieveProxy(GetCompanyInfoProxy.NAME));
			companyManagementProxy = CompanyManagementProxy(facade.retrieveProxy(CompanyManagementProxy.NAME));
			
			initEventListener();
			
		}
		
		public function initEventListener():void {
			cmView.addEventListener(CompanyManagementView.CLOSE_COMPANYMANAGEMENT_VIEW, closeViewHandler);
			cmView.addEventListener(CompanyManagementView.ADD_COMPANY, addCompanyHandler);
			cmView.addEventListener(CompanyManagementView.SAVE_COMPANY_INFO, saveCompanyInfoHandler);
			cmView.addEventListener(CompanyManagementView.MODIFY_COMPANY_INFO, modifyCompanyInfoHandler);
			cmView.addEventListener(CompanyManagementView.DELETE_COMPANY, deleteCompanyHandler);
			cmView.addEventListener(CompanyManagementView.QUERY_FOR_ALL_COMPANY_INFO, queryForAllCompanyInfoHandler);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_COMPANY_MANAGEMENT,
				GetCompanyInfoProxy.GET_COMPANYINFO_SUCCESS

			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()){
				case ApplicationFacade.SHOW_COMPANY_MANAGEMENT:
					getCompanyInfoProxy.getAllCompanyInfo();
					break;
				case GetCompanyInfoProxy.GET_COMPANYINFO_SUCCESS:	// 成功获取公司列表
					if(!getCompanyInfoProxy.isGetAll){	// 非获取所有公司列表
						return;
					}
					initCompanyManagementView(getCompanyInfoProxy.companyDetail);
					break;
			}
		}
		
		private function initCompanyManagementView(data:XML):void {
			var xml:XML = XML(data);
			var companyList:XMLList = xml.children();
			var list:Array = new Array();
			var companyInfoList:ArrayCollection = new ArrayCollection();
			var i:int;
			
			
			dataUpdated.removeAll();
			
			for(i = 0; i < companyList.length(); i++){
				companyInfoList.addItem({"companyId":companyList[i].@CompanyId.toString()
						,"companyName":companyList[i].@CompanyName.toString()
						, "companyIdentifier":companyList[i].@CompanyIdentifier.toString()
						, "bg_login":companyList[i].@Bg_login.toString()
						, "bg_logo":companyList[i].@Bg_logo.toString()
						, "status":"initial"});
						
				dataUpdated.addItem({"companyId":companyList[i].@CompanyId.toString()
						,"companyName":companyList[i].@CompanyName.toString()
						, "companyIdentifier":companyList[i].@CompanyIdentifier.toString()
						, "bg_login":companyList[i].@Bg_login.toString()
						, "bg_logo":companyList[i].@Bg_logo.toString()
						, "status":"initial"});
			}
		
			
			cmView.companyList = companyInfoList;

		}
		
		public function get cmView(): CompanyManagementView {
			return viewComponent as CompanyManagementView;
		}
		
		
		/**
		 * 检验验证是否完全通过
		 * 返回值: true, 完全通过; false, 没有完全通过
		 **/ 
		public function validateAll():Boolean {
			var arr:Array = Validator.validateAll(cmView.validators);
			if (arr.length != 0) {	// 验证没有完全通过
				return false;
			}
			
			return true;
		}
		
		
		public function closeViewHandler(e:Event):void {
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(cmView);
			this.setViewComponent(null);
		}
		
		/**
		 * 查询
		 **/ 
		public function queryForAllCompanyInfoHandler(e:Event):void {
			sendNotification(ApplicationFacade.SHOW_COMPANY_MANAGEMENT);
		}
		
		/**
		 * 新增集群信息
		 **/ 
		public function addCompanyHandler(e:Event):void {
			if (!validateAll()) {	// 验证没有完全通过
				return;
			}
			
			var companyInfoList:ArrayCollection = cmView.companyList;
			
			// 在视图中的datagrid添加记录
			companyInfoList.addItem({"companyId":""
						, "companyName":cmView.companyName.text
						, "companyIdentifier":cmView.companyIdentifier.text
						, "bg_login":cmView.bg_login.text
						, "bg_logo":cmView.bg_logo.text
						, "status":"added"});
						
			cmView.lblPrompt.text = "数据已增加";
								
		}
		
		/**
		 * 删除集群信息
		 **/ 
		public function deleteCompanyHandler(e:Event):void {
			var i:int;
			var itemSel:Object = cmView.dg.selectedItem;
			var companyId:String = cmView.dg.selectedItem.companyId.toString();
			var tmp:ArrayCollection = cmView.companyList;
			
			// 从界面datagrid中删除
			for(i = 0; i < tmp.length; i++) {
				/* if(tmp[i].companyId.toString() == companyId) {
					tmp.removeItemAt(i);
				} */
				if(tmp[i] == cmView.dg.selectedItem){
					tmp.removeItemAt(i);
				}
			}
			
			
			if(companyId != "") {	// 对于非通过[新增]操作产生的行，作同步数据变更记录
				// 在记录数据集中作删除标记
				for(i = 0; i < dataUpdated.length; i++) {
					if(dataUpdated[i].companyId.toString() == companyId) {
						dataUpdated[i].status += ";deleted";
					}
				}
			}
			
			cmView.lblPrompt.text = "数据已删除";

		}
		
		/**
		 * 修改集群信息
		 **/ 
		public function modifyCompanyInfoHandler(e:Event):void {
			if (!validateAll()) {	// 验证没有完全通过
				return;
			}
			//trace(cmView.dg.selectedItem.companyId);
			var i:int;
			var itemSel:Object = cmView.dg.selectedItem;
			
			if(itemSel == null) {
				Alert.show("请选择欲修改的项！");
				return;
			}
			
			
			var companyId:String = itemSel.companyId.toString();
			itemSel.companyName = cmView.companyName.text;
			itemSel.companyIdentifier = cmView.companyIdentifier.text;
			itemSel.bg_login = cmView.bg_login.text;
			itemSel.bg_logo = cmView.bg_logo.text;
			itemSel.status += ";updated";
			
			cmView.dg.invalidateList();
			
			
			if(companyId != "") {	// 对于非通过[新增]操作产生的行，作同步数据变更记录
				// 作记录数据集中作修改标记 
				for(i = 0; i < dataUpdated.length; i++) {
					if(dataUpdated[i].companyId.toString() == itemSel.companyId.toString()) {
						dataUpdated[i].companyname = cmView.companyName.text;
						dataUpdated[i].companyIdentifier = cmView.companyIdentifier.text;
						dataUpdated[i].bg_login = cmView.bg_login.text;
						dataUpdated[i].bg_logo = cmView.bg_logo.text;
						dataUpdated[i].status += ";updated";
					}
				}
			}
			
			cmView.lblPrompt.text = "数据已修改";
			
		}
		
		/**
		 * 保存集群信息，用作最终提交修改至数据库的操作
		 **/ 
		public function saveCompanyInfoHandler(e:Event):void {
			// 将datagrid中新增的数据同步到dataUpdated中
			var i:int;
			var companyList:ArrayCollection = cmView.companyList;
			for(i = 0; i < companyList.length; i++) {
				if(companyList[i].companyId.toString() == "") {
					 dataUpdated.addItem({"companyId":""
					 	, "companyName":companyList[i].companyName.toString()
						, "companyIdentifier":companyList[i].companyIdentifier.toString()
						, "bg_login":companyList[i].bg_login.toString()
						, "bg_logo":companyList[i].bg_logo.toString()
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
					companyManagementProxy.addCompany(loginProxy.getUserName(), loginProxy.getUserPassword(), data.companyName,
							data.companyIdentifier, data.bg_login, data.bg_logo);
				}
				
				// 待删除数据
				if(REGEXP_ROWDELETED.test(data.status)) {
					companyManagementProxy.deleteCompany(loginProxy.getUserName(), loginProxy.getUserPassword(), data.companyId);
				}
				
				// 待更新数据
				if(REGEXP_ROWUPDATED.test(data.status)) {
					var updatedStr:String = 
							  "companyName:" + data.companyName.toString()
							+ ";companyIdentifier:" + data.companyIdentifier.toString()
							+ ";bg_login:\"" + data.bg_login.toString()
							+ "\";bg_logo:\"" + data.bg_logo.toString() + "\";";
					companyManagementProxy.updateCompany(loginProxy.getUserName(), loginProxy.getUserPassword(), data.companyId, 
						updatedStr);
				}
				
			}
			
			Alert.show("数据保存成功");
		
		}
		
	}
}