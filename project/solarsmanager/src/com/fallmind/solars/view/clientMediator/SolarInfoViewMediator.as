package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.AddSolarSystemProxy;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckPassword2Proxy;
	import com.fallmind.solars.model.DeleteSolarSystemProxy;
	import com.fallmind.solars.model.EditSolarSystemProxy;
	import com.fallmind.solars.model.GetCommunityProxy;
	import com.fallmind.solars.model.GetRegionProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	import com.fallmind.solars.view.component.clientSetup.AddSolarSystemView;
	import com.fallmind.solars.view.component.clientSetup.EditSolarSystemView;
	import com.fallmind.solars.view.component.clientSetup.SolarInfoManageView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 登录模块的视图管理类，接受用户登录事件，交给model层去处理
	 */
	public class SolarInfoViewMediator extends Mediator
	{
		public static const NAME:String = "SolarInfoMediator";
		private var loginProxy:LoginProxy;
		private var solarInfoProxy:SolarInfoProxy;
		private var userInfo:XML;
		private var solarInfo:XML;
		private var deleteSystemProxy:DeleteSolarSystemProxy;
		private var addSystemProxy:AddSolarSystemProxy;
		private var regionProxy:GetRegionProxy;
		private var userName:String;
		private var password:String;
		private var firstCreateWindow:Boolean = true;
		private var firstCreateEditWindow:Boolean = true;
		
		private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var getCommunityProxy:GetCommunityProxy;
		private var getRegionProxy:GetRegionProxy;
		
		private var checkPassword2Proxy:CheckPassword2Proxy;
		
		
		private var lastCountrySelectIndex:int = 0;
		private var lastProvinceSelectIndex:int = 0;
		private var lastCitySelectIndex:int = 0;
		private var lastCommunitySelectIndex:int = 0;
		
		
		public function SolarInfoViewMediator(note:Object)
		{
			super(NAME, note);
			// 侦听所管理的视图类的事件
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			solarInfoProxy = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
			deleteSystemProxy = DeleteSolarSystemProxy(facade.retrieveProxy(DeleteSolarSystemProxy.NAME));
			addSystemProxy = AddSolarSystemProxy(facade.retrieveProxy(AddSolarSystemProxy.NAME));
			regionProxy = GetRegionProxy(facade.retrieveProxy(GetRegionProxy.NAME));
			checkPassword2Proxy = CheckPassword2Proxy(facade.retrieveProxy(CheckPassword2Proxy.NAME));
			
			checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			getCommunityProxy = GetCommunityProxy(facade.retrieveProxy(GetCommunityProxy.NAME));
			getRegionProxy = GetRegionProxy(facade.retrieveProxy(GetRegionProxy.NAME));
			solarInfoProxy = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
		
			
			solarInfoView.addEventListener(SolarInfoManageView.ADD_SOLARSYSTEM, addHandler);
			solarInfoView.addEventListener(SolarInfoManageView.DELETE_SOLARSYSTEM, deleteHandler);
			solarInfoView.addEventListener(SolarInfoManageView.EDIT_SOLARSYSTEM, editHandler);
		}
		private function editHandler(e:Event):void {
			lastCountrySelectIndex = solarInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = solarInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = solarInfoView.cityBox.selectedIndex;
			lastCommunitySelectIndex = solarInfoView.communityBox.selectedIndex;
			
			var u:EditSolarSystemView = EditSolarSystemView(PopUpManager.createPopUp(solarInfoView.parent.parent.parent.parent.parent, EditSolarSystemView, true));
			PopUpManager.centerPopUp(u);
			if(firstCreateEditWindow) {
				var a:EditSolarSystemViewMediator = new EditSolarSystemViewMediator(u);
				a.setSystemData(XML(solarInfoView.solarSystemDataGrid.selectedItem));
				facade.registerMediator(a);
				firstCreateWindow = false;
			} else {
				var temp:EditSolarSystemViewMediator = EditSolarSystemViewMediator(facade.retrieveMediator(EditSolarSystemViewMediator.NAME));
				temp.setViewComponent(u); 
				temp.init();
				temp.setSystemData(XML(solarInfoView.solarSystemDataGrid.selectedItem));
			}
			
		}
		
		private function createWin():AddSolarSystemView {
			var u:AddSolarSystemView = AddSolarSystemView(PopUpManager.createPopUp(solarInfoView.parent.parent.parent.parent.parent, AddSolarSystemView, true));
			PopUpManager.centerPopUp(u);
			if(firstCreateWindow) {
				facade.registerMediator(new AddSolarSystemViewMediator(u));
				firstCreateWindow = false;
			} else {
				var temp:AddSolarSystemViewMediator = AddSolarSystemViewMediator(facade.retrieveMediator(AddSolarSystemViewMediator.NAME));
				temp.setViewComponent(u); 
				temp.init();
			}
			return u;
		}
		
		private function addHandler(e:Event):void {
			if(getCommunityProxy.getUserRightID(solarInfoView.communityBox.selectedItem.@CommunityID) == ApplicationFacade.LOW_RIGHT) {
				Alert.show("您没有修改该小区的权限");
				return;
			}
			lastCountrySelectIndex = solarInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = solarInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = solarInfoView.cityBox.selectedIndex;
			lastCommunitySelectIndex = solarInfoView.communityBox.selectedIndex;
			
			createWin();	
			sendNotification(ApplicationFacade.ADD_SOLARSYSTEM, solarInfoView.communityBox.selectedItem.@CommunityID);
		}
		
		private function deleteHandler(e:Event):void {
			if(solarInfoProxy.getUserRightID(solarInfoView.solarSystemDataGrid.selectedItem.@System_ID) == ApplicationFacade.LOW_RIGHT) {
				Alert.show("您没有修改该小区的权限");
				return;
			}
			lastCountrySelectIndex = solarInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = solarInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = solarInfoView.cityBox.selectedIndex;
			lastCommunitySelectIndex = solarInfoView.communityBox.selectedIndex;
			deleteSystemProxy.deleteSolarSystem(userName, password, solarInfoView.solarSystemDataGrid.selectedItem.@System_ID);
		}
		
		
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ LoginProxy.LOGIN_SUCCESS,
					  SolarInfoProxy.LOAD_SOLARSYSTEM_SUCCESS,
					  DeleteSolarSystemProxy.DELETE_SOLARSYSTEM_SUCCESS,
					  DeleteSolarSystemProxy.DELETE_SOLARSYSTEM_FAILED,
					  AddSolarSystemProxy.ADD_SOLARSYSTEM_FAILED,
					  AddSolarSystemProxy.ADD_SOLARSYSTEM_SUCCESS,
					  GetRegionProxy.GET_REGION_SUCCESS,
					  GetCommunityProxy.GET_COMMUNITY_SUCCESS,
					  ApplicationFacade.SHOW_ADD_SYSTEM_INSTALL,	// 弹出设置系统安装情况的界面
					  ApplicationFacade.SHOW_ADD_SYSTEM_PASSWORD_WRONG_DETAIL,	// 弹出添加系统界面，提示用户哪个字段没有设置成功
					  EditSolarSystemProxy.EDIT_SOLARSYSTEM_SUCCESS
			 		];
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				//case ApplicationFacade.SHOW_ADD_SYSTEM_INSTALL:
					//createSystemInstallView();
					//break;
				/*case ApplicationFacade.SHOW_ADD_SYSTEM_PASSWORD_WRONG_DETAIL:
					var temp:AddSolarSystemView = createWin();
					sendNotification(ApplicationFacade.ADD_SOLARSYSTEM, solarInfoView.communityBox.selectedItem.@CommunityID);
					temp.setFromAddSystemData(checkPassword2Proxy.systemData);
					temp.checkPassword(checkPassword2Proxy.realPassword);
					break;*/
				case LoginProxy.LOGIN_SUCCESS:
					userName = loginProxy.getUserName();
					password = loginProxy.getUserPassword();
					break;
				case GetCommunityProxy.GET_COMMUNITY_SUCCESS:
					solarInfoView.totalCommunityData = getCommunityProxy.getData().row;
					
					solarInfoView.communityButtonData = getCommunityProxy.getData().row.(@BelongAreaID == solarInfoView.cityButtonData[lastCitySelectIndex].@AreaID);
					solarInfoProxy.getSolarsSystem(loginProxy.getUserName(), loginProxy.getUserPassword());
					break;
				case GetRegionProxy.GET_REGION_SUCCESS:
					userInfo = XML(loginProxy.getData());
					if(XML(getRegionProxy.getData()).children().length() == 0) {
						break;
					}
					solarInfoView.totalData = getRegionProxy.getData() as XML;
					
					solarInfoView.countryButtonData = getRegionProxy.getData().row.(@TypeLevel == "1");
					var selectedCountryID:String;
					if(solarInfoView.countryButtonData.length() != 0) {
						selectedCountryID = solarInfoView.countryButtonData[lastCountrySelectIndex].@AreaID;
					}
					solarInfoView.provinceButtonData = getRegionProxy.getData().row.((@TypeLevel == "2" || @TypeLevel == "4") && @BelongRel == selectedCountryID);
					var selectedProvinceID:String;
					if(solarInfoView.provinceButtonData.length() != 0) {
						selectedProvinceID = solarInfoView.provinceButtonData[lastProvinceSelectIndex].@AreaID;
					}
					solarInfoView.cityButtonData = getRegionProxy.getData().row.(@TypeLevel == "3" && @BelongRel == selectedProvinceID);
					
					solarInfoView.countryBox.selectedIndex = this.lastCountrySelectIndex;
					solarInfoView.provinceBox.selectedIndex = this.lastProvinceSelectIndex;
					solarInfoView.cityBox.selectedIndex = this.lastCitySelectIndex;
					
					getCommunityProxy.getCommunity(loginProxy.getUserName(), loginProxy.getUserPassword());
					break;
				case SolarInfoProxy.LOAD_SOLARSYSTEM_SUCCESS:
					solarInfo = XML(solarInfoProxy.getData());
					
					solarInfoView.totalSolarInfo = solarInfo.row;
					
					solarInfoView.solarInfoData = solarInfo.row.(@BelCommunityID==solarInfoView.communityBox.selectedItem.@CommunityID);
					break;
				case DeleteSolarSystemProxy.DELETE_SOLARSYSTEM_SUCCESS:
					//loginProxy.login(userName, password);
					loginProxy.refresh();
					break;
				case DeleteSolarSystemProxy.DELETE_SOLARSYSTEM_FAILED:
					Alert.show("删除失败");
					break;
				case AddSolarSystemProxy.ADD_SOLARSYSTEM_FAILED:
					Alert.show("添加失败");
					break;
				case EditSolarSystemProxy.EDIT_SOLARSYSTEM_SUCCESS:
				case AddSolarSystemProxy.ADD_SOLARSYSTEM_SUCCESS:
					//loginProxy.login(userName, password);
					loginProxy.refresh();
					break;
			}
		}
		protected function get solarInfoView():SolarInfoManageView {
			return viewComponent as SolarInfoManageView;
		}
	}
}