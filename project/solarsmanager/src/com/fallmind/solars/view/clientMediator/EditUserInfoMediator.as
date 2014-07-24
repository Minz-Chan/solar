package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.GetCommunityProxy;
	import com.fallmind.solars.model.GetRegionProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.clientSetup.EditUserInfoView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 登录模块的视图管理类，接受用户登录事件，交给model层去处理
	 */
	public class EditUserInfoMediator extends Mediator
	{
		public static const NAME:String = "EditUserInfoMediator";
		public static const ADD_COMMUNITY_OF_USER_RETURN:String = "AddCommunityOfUserReturn";
		private var getRegionProxy:GetRegionProxy;
		private var getCommunityProxy:GetCommunityProxy;
		
		public var selectedCommunity:Array = new Array();
		public var displayCommunity:Array = new Array();
		public var notAllocatedCommunity:Array = new Array();
		private var userInfo:XML;
		
		private var loginProxy:LoginProxy;
	
		public function EditUserInfoMediator(note:Object)
		{
			super(NAME, note);
			// 侦听所管理的视图类的事件
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			getRegionProxy = GetRegionProxy(facade.retrieveProxy(GetRegionProxy.NAME));
			getCommunityProxy = GetCommunityProxy(facade.retrieveProxy(GetCommunityProxy.NAME));
			
			
			
			editUserInfoView.addEventListener(EditUserInfoView.CLOSE_EDIT_USER_INFO_VIEW, closeWindow);
			editUserInfoView.addEventListener(EditUserInfoView.SAVE_USER_INFO, saveHandler);
		}
		
		public function init():void {
			var xml:XML = loginProxy.getData() as XML;
			editUserInfoView.totalCommunity = switchXML2Array(xml.Area);
			editUserInfoView.addEventListener(EditUserInfoView.CLOSE_EDIT_USER_INFO_VIEW, closeWindow);
			editUserInfoView.addEventListener(EditUserInfoView.SAVE_USER_INFO, saveHandler);
		}
		private function saveHandler(e:Event):void {
			var result:Array = new Array;
			for each(var c:CommunityData in editUserInfoView.communityButtonData) {
				if(c.selected) {
					
					result.push(c);
				}
			}
			sendNotification(ADD_COMMUNITY_OF_USER_RETURN, result);
			PopUpManager.removePopUp(editUserInfoView);
			this.setViewComponent(null);
		}
		private function closeWindow(e:Event):void {
			this.setViewComponent(null);
		}
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ ApplicationFacade.ADD_COMMUNITY_OF_USER ];   
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.ADD_COMMUNITY_OF_USER:
					editUserInfoView.currentUserTypeID = notification.getBody().toString();
					
					var xml:XML = loginProxy.getData() as XML;
					editUserInfoView.totalCommunity = switchXML2Array(xml.Area);	// 每次添加都要获取数据
					for each(var c:CommunityData in editUserInfoView.totalCommunity) {
						c.rightID = EditUserInfoView.LOW_RIGHT;
						c.right = "基本查询";
					}
					
					userInfo = XML(loginProxy.getData());
					var areaList:XMLList;
					areaList = userInfo.Area;
					//solarInfoView.countryButtonData = 
					if(areaList.hasComplexContent()) {
						editUserInfoView.countryButtonData = userInfo.Area.Area;
						editUserInfoView.provinceButtonData = editUserInfoView.countryButtonData[0].Area;
						editUserInfoView.cityButtonData = editUserInfoView.provinceButtonData[0].Area;
						//editUserInfoView.communityButtonData = editUserInfoView.cityButtonData[0].CommunityInfo;
						
					}
					if(editUserInfoView.cityBox.selectedItem != null) {
						editUserInfoView.communityButtonData.splice(0, editUserInfoView.communityButtonData.length);
						for each(var item:CommunityData in editUserInfoView.totalCommunity) {
							if(item.city == editUserInfoView.cityBox.selectedItem.@name) {
								editUserInfoView.communityButtonData.push(item);
							}
						}
						editUserInfoView.selectedCommunityDataGrid.invalidateList();
					}
					editUserInfoView.totalCommunityData = loginProxy.getCommunityData();
					
					break;
			}
		}
		protected function get editUserInfoView():EditUserInfoView {
			return viewComponent as EditUserInfoView;
		}
		public static function switchXML2Array(source:XMLList):Array {
			var array:Array = new Array();
			var areaList:Array = new Array();
			for each(var country:XML in source.Area) {
				areaList.push(country.@name);
				if(country.Area != null) {
					for each(var province:XML in country.Area) {
						areaList.push(province.@name);
						if(province.Area != null) {
							if(province.@typeID == "4") {
								if(province.CommunityInfo != null) {
									for each(var community:XML in province.CommunityInfo) {
										var data:CommunityData = new CommunityData();
										data.community = community.@name;
										data.right = community.@CommunityRight;
										data.highestRightID = int(community.@userRightID);
										data.id = int(community.@id);
										data.rightID = int(community.@userRightID);
										data.country = areaList[0].toString();
										data.province = areaList[1].toString();
										data.city = areaList[1].toString();
										
										array.push(data);
									}
									
								}
								areaList.pop();
							}
							else {
								for each(var city:XML in province.Area) {
									areaList.push(city.@name);
									if(city.CommunityInfo != null) {
										for each(var community:XML in city.CommunityInfo) {
											var data:CommunityData = new CommunityData();
											data.community = community.@name;
											data.id = int(community.@id);
											data.right = community.@CommunityRight;
											data.rightID = int(community.@userRightID);
											data.highestRightID = int(community.@userRightID);
											data.country = areaList[0].toString();
											data.province = areaList[1].toString();
											data.city = areaList[2].toString();
											array.push(data);
										}
									}
									areaList.pop();
								}
							}
						}
						areaList.pop();
					}
				}
				areaList.pop();
			}
			return array;
		}
	}
}