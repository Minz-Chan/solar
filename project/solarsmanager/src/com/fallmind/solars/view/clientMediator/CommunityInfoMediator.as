package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.model.DeleteCommunityInfoProxy;
	import com.fallmind.solars.model.GetCommunityProxy;
	import com.fallmind.solars.model.GetRegionProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveCommunityInfoProxy;
	import com.fallmind.solars.view.component.clientSetup.CommunityInfoManageView;
	import com.fallmind.solars.view.component.clientSetup.EditCommunityInfoView;
	
	import flash.events.Event;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 登录模块的视图管理类，接受用户登录事件，交给model层去处理
	 */
	public class CommunityInfoMediator extends Mediator
	{
		public static const NAME:String = "CommunityInfoMediator";
		public static const EDIT_COMMUNITY:String = "EditCommunity";
		public static const ADD_COMMUNITY:String = "AddCommunity";
		private var loginProxy:LoginProxy;
		private var deleteProxy:DeleteCommunityInfoProxy;
		private var getRegionProxy:GetRegionProxy;
		private var getCommunityProxy:GetCommunityProxy;
		private var userInfo:XML;
		private var firstCreateWindow:Boolean = true;
		
		private var lastCountrySelectIndex:int = 0;
		private var lastProvinceSelectIndex:int = 0;
		private var lastCitySelectIndex:int = 0;
		
		public function CommunityInfoMediator(note:Object)
		{
			super(NAME, note);
			// 侦听所管理的视图类的事件
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			deleteProxy = DeleteCommunityInfoProxy(facade.retrieveProxy(DeleteCommunityInfoProxy.NAME));
			getRegionProxy = GetRegionProxy(facade.retrieveProxy(GetRegionProxy.NAME));
			getCommunityProxy = GetCommunityProxy(facade.retrieveProxy(GetCommunityProxy.NAME));
			
			communityInfoView.addEventListener( CommunityInfoManageView.ADD_COMMUNITY, addCommunity);
			communityInfoView.addEventListener( CommunityInfoManageView.EDIT_COMMUNITY, editCommunity);
			communityInfoView.addEventListener( CommunityInfoManageView.DELETE_COMMUNITY, deleteCommunity);
		}
		
		private function closePopWindow(e:Event):void {
			facade.retrieveMediator( EditCommunityInfoMediator.NAME).setViewComponent(null);
		}
		private function addCommunity(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员") {
				Alert.show("没有权限");
				return;
			}
			
			createWin(EditCommunityInfoView);
			var belongAreaID:int;
			if(communityInfoView.cityBox.selectedItem != null) {
				belongAreaID = communityInfoView.cityBox.selectedItem.@AreaID;
			} else if( communityInfoView.provinceBox.selectedItem != null) {
				belongAreaID = communityInfoView.provinceBox.selectedItem.@AreaID;
			}
			
			// 记录修改前combobox的顺序，刷新的时候用
			lastCountrySelectIndex = communityInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = communityInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = communityInfoView.cityBox.selectedIndex;
			
			sendNotification(ADD_COMMUNITY, belongAreaID);
		}
		
		private function editCommunity(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员") {
				Alert.show("没有权限");
				return;
			}
			if(communityInfoView.communityDataGrid.selectedItem == null) {
				Alert.show("请选择一个小区");
				return;
			}
			createWin(EditCommunityInfoView);
			//trace(communityInfoView.communityDataGrid.selectedItems);
			sendNotification(EDIT_COMMUNITY, communityInfoView.communityDataGrid.selectedItem);
			
			lastCountrySelectIndex = communityInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = communityInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = communityInfoView.cityBox.selectedIndex;
		}
		
		private function deleteCommunity(e:Event):void {
			if(loginProxy.getData().UserType == "普通操作员") {
				Alert.show("没有权限");
				return;
			}
			if( communityInfoView.communityDataGrid.selectedItem == null) {
				Alert.show("请选择一个小区");
				return;
			}
			// 记录删除前comboBox的顺序，以便刷新的时候用
			lastCountrySelectIndex = communityInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = communityInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = communityInfoView.cityBox.selectedIndex;
			
			deleteProxy.deleteCommunityInfo(loginProxy.getData().UserName, loginProxy.getData().UserPassword, communityInfoView.communityDataGrid.selectedItem.@CommunityID );
		}
		
		private function createWin(className:Class):void {
			var u:TitleWindow = className(PopUpManager.createPopUp(communityInfoView.parent.parent.parent.parent.parent, className, true));
			//u.x = communityInfoView.stage.width / 2 - u.width / 2;
			//u.y = communityInfoView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateWindow) {
				facade.registerMediator(new EditCommunityInfoMediator(u));
				firstCreateWindow = false;
			} else {
				var temp:EditCommunityInfoMediator = facade.retrieveMediator(EditCommunityInfoMediator.NAME) as EditCommunityInfoMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
		}
		
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ LoginProxy.LOGIN_SUCCESS,		// 如果登陆成功就刷新所有的数据容器
					  DeleteCommunityInfoProxy.DELETE_COMMUNITY_SUCCESS,	// 监视删除成功事件，删除成功就刷新
					  DeleteCommunityInfoProxy.DELETE_COMMUNITY_FAILED,
					  GetRegionProxy.GET_REGION_SUCCESS,
					  SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_SUCCESS,
					  SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_FAILED,
					  GetCommunityProxy.GET_COMMUNITY_SUCCESS ];   
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case GetCommunityProxy.GET_COMMUNITY_SUCCESS:
					communityInfoView.totalCommunityData = getCommunityProxy.getData().row;
					communityInfoView.communityData = getCommunityProxy.getData().row.(@BelongAreaID == communityInfoView.cityBox.selectedItem.@AreaID);
					break;
				case GetRegionProxy.GET_REGION_SUCCESS:
					userInfo = XML(loginProxy.getData());
					// 从getRegionProxy中得到地域信息
					if(XML(getRegionProxy.getData()).children().length() == 0) {
						break;
					}
					communityInfoView.totalData = getRegionProxy.getData() as XML;
					//communityInfoView.totalCommunityData = loginProxy.getCommunityData();
					
					// 设置小区信息的ComboBox的内容
					communityInfoView.countryButtonData = getRegionProxy.getData().row.(@TypeLevel == "1");
					var selectedCountryID:String;
					if(communityInfoView.countryButtonData.length() != 0) {
						selectedCountryID = communityInfoView.countryButtonData[lastCountrySelectIndex].@AreaID;
					}
					communityInfoView.provinceButtonData = getRegionProxy.getData().row.((@TypeLevel == "2" || @TypeLevel == "4") && @BelongRel == selectedCountryID);
					var selectedProvinceID:String;
					if(communityInfoView.provinceButtonData.length() != 0) {
						selectedProvinceID = communityInfoView.provinceButtonData[lastProvinceSelectIndex].@AreaID;
					}
					communityInfoView.cityButtonData = getRegionProxy.getData().row.(@TypeLevel == "3" && @BelongRel == selectedProvinceID);
					
					communityInfoView.countryBox.selectedIndex = this.lastCountrySelectIndex;
					communityInfoView.provinceBox.selectedIndex = this.lastProvinceSelectIndex;
					communityInfoView.cityBox.selectedIndex = this.lastCitySelectIndex;
					
					// 向数据库申请获取小区数据
					getCommunityProxy.getCommunity(loginProxy.getUserName(), loginProxy.getUserPassword());
					break;
				case DeleteCommunityInfoProxy.DELETE_COMMUNITY_SUCCESS:
					//var n:String = loginProxy.getData().UserName;
					//var p:String = loginProxy.getData().UserPassword;
					//loginProxy.login(n, p);		// 再登陆一次，重新取得所有数据
					loginProxy.refresh();
					break;
				case DeleteCommunityInfoProxy.DELETE_COMMUNITY_FAILED:
					Alert.show("删除失败");
					break;
				case SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_FAILED:	// 失败就提示
					Alert.show(notification.getBody().toString());
					break;
				case SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_SUCCESS:	// 成功就刷新
					Alert.show("保存成功");
					//loginProxy.login(loginProxy.getData().UserName, loginProxy.getData().UserPassword);
					loginProxy.refresh();
							// 再登陆一次，重新取得所有数据
					break;
			}
		}
		public function get communityInfoView():CommunityInfoManageView {
			return viewComponent as CommunityInfoManageView;
		}
		
		private function initView(e:Event):void {
			communityInfoView.provinceButtonData = XML(loginProxy.getData()).Area; 
		}
	}
}