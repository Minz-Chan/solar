package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckSetSetupProxy;
	import com.fallmind.solars.model.CheckProxy.SetupData;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.solarSystem.EditSystemSetupOldView;
	import com.fallmind.solars.view.component.solarSystem.EditSystemSetupView;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class EditSystemSetupMediator extends Mediator
	{
		public static const NAME:String = "EditSystemSetupMediator";
		public static const CHECK_GET_CURRENT_SETUP:String = "CheckGetCurrentSetup";
		public static const CHECK_SET_CURRENT_SETUP:String = "CheckSetCurrentSetup";
		private var currentSystemData:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		private var username:String;
		private var password:String;
		private var sendOrderProxy:SendOrderProxy;
		//private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var checkSetSetupProxy:CheckSetSetupProxy;
		
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
	
		
		private var offerBoxLow:String;
		private var productBoxLow:String;
		
		private var firstDisplayData:Boolean = true;
		private var boostPump_Work:String;
		private var auxiliaryDevice_Work:String;
		
		private var lastOperation:int = 0;
		private var SEARCH:int = 0;
		private var SAVE:int = 1;
		
		public function EditSystemSetupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			currentSystemData = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			
			checkSetSetupProxy = CheckSetSetupProxy(facade.retrieveProxy(CheckSetSetupProxy.NAME));
			
			username = loginProxy.getData().UserName;
			password = loginProxy.getData().UserPassword;
			
			/* currentSetupView.addEventListener(EditSystemSetupView.CLOSE_CURRENT_SETUP_VIEW, closeHandler);
			currentSetupView.addEventListener(EditSystemSetupView.SAVE_CURRENT_SETUP, saveHandler);
			currentSetupView.addEventListener(EditSystemSetupView.SHOW_CURRENT_SETUP, showCurrentSetup);
			
			currentSetupView.setState(0); */
			if(isNewVersion()){
				init();
			} else {
				initOld();
			}
		
		}
		
		public function initOld():void {
			currentSetupView.addEventListener(EditSystemSetupOldView.CLOSE_CURRENT_SETUP_VIEW, closeHandler);
			currentSetupView.addEventListener(EditSystemSetupOldView.SAVE_CURRENT_SETUP, saveHandler);	
			currentSetupView.addEventListener(EditSystemSetupOldView.SHOW_CURRENT_SETUP, showCurrentSetup);
			currentSetupView.setState(0);
		}
		public function init():void {
			currentSetupView.addEventListener(EditSystemSetupView.CLOSE_CURRENT_SETUP_VIEW, closeHandler);
			currentSetupView.addEventListener(EditSystemSetupView.SAVE_CURRENT_SETUP, saveHandler);	
			currentSetupView.addEventListener(EditSystemSetupView.SHOW_CURRENT_SETUP, showCurrentSetup);
			currentSetupView.setState(0);
		}
		private function showCurrentSetup(e:Event):void {
			currentSetupView.setState(0);
			lastOperation = SEARCH;
			// 查询系统当前设置
			sendOrderProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID(), currentSystemData.getARM_ID());
			// 下发查询輔助设备加热时间段值指令   Added by Minz.Chan 2013.01.28
			if(isNewVersion()) {
				sendOrderProxy.getCurrentSetupAuxiliaryDeviceWork(username, password, currentSystemData.getCurrentSystemID(), currentSystemData.getARM_ID());
			}
			
			getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
		}
		private function closeHandler(e:Event):void {
			closeWindow();
		}
		private function closeWindow():void {
			lastOperation = SEARCH;
			currentSystemData.startQuery();
			firstDisplayData = true;
			//PopUpManager.removePopUp(currentSetupView);
			if(isNewVersion()) {
				PopUpManager.removePopUp(EditSystemSetupView(currentSetupView));
			} else {
				PopUpManager.removePopUp(EditSystemSetupOldView(currentSetupView));
			}
			
			this.setViewComponent(null);
		}
		
		/**
		 * 时间字串前三位为整数转化为十六进制字符
		 * 参  数：
		 *   t, 时间字串（如00:20，在23：50之前）
		 * 返回值：
		 *   02（002的十六进制）
		 */ 
		private function time2HexStr(t:String):String {
			var tmpStr:String = t.substr(0,2);
			tmpStr += t.substr(3, 1);
			
			return SendOrderProxy.fillZero(1, int(tmpStr).toString(16));;
		}
		
		/**
		 * 恒热水箱分时间段水位值转换为十六进制字串
		 * 参  数：
		 *   data, 长度为6的对象（obj.startTime, obj.endTime, obj.level）数组
		 * 返回值：
		 *   十六进制字符串（如02533c5b90288cab23b4eb32000000000000，长度36）
		 */ 
		private function convertOfferBoxLow(data:Array):String {
			// Added by Minz.chan 2013.01.27
			
			if(isNewVersion()) { // 新版
				var levelStr:String = "";
				var i:int = 0;
				
				for(i = 0; i < data.length; i++) {
					if(data[i].startTime == "" && data[i].endTime == ""
					  && data[i].level == "") {
						levelStr += "ff";
						levelStr += "ff";
						levelStr += "ff";
					} else {
						levelStr += time2HexStr(data[i].startTime);
						levelStr += time2HexStr(data[i].endTime);
						levelStr += SendOrderProxy.fillZero(1, int(data[i].level).toString(16));
					}
					
				}
				
				return levelStr;
			} else { // 旧版
			
				var levelArray:Array = new Array(24);
			
				var levelStr:String = "";
				for(var i:int = 0; i < data.length; i++) {
					if(data[i].startTime != "") {
						if(int(data[i].startTime) > 23 || int(data[i].endTime) > 23) {
							Alert.show("起始时间和结束时间必须在0-23之间");
							return null;
						} 
						var startTime:int = int(data[i].startTime);
						var endTime:int = int(data[i].endTime);
						var level:int = int(data[i].level);
						for(var j:int = startTime; j <= endTime; j++) {
							levelArray[j] = level.toString();
						}
					} 
				}
				for(var j:int = 0; j < levelArray.length; j++) {
					if(levelArray[j] != null) {
						levelStr += SendOrderProxy.fillZero(1, int(levelArray[j]).toString(16));
					} else {
						levelStr += SendOrderProxy.fillZero(1, int(currentSetupView.OfferBox_Def_WL_L.text).toString(16));
					}
				}
				return levelStr;
			}
			
			
			
			
		}
		
		/**
		 * 中央热水系统供热时间段增压泵阀开启状态转换为十六进制字串
		 * 参  数:
		 *   data, 长度为6的对象（obj.startTime, obj.endTime)数组
		 * 返回值：
		 *   十六进制字串（如02535b90ffff8cabb4ebffff，长度为24）
		 */ 
		private function convertBoostPump_Work(data:Array):String {
			// Added by Minz.chan 2013.01.27
			
			
			if(isNewVersion()) {
				var pumpStr:String = "";
				var i:int = 0;
				
				for(i = 0; i < data.length; i++) {
					if((data[i].startTime == "" && data[i].endTime == "") || !data[i].isStart) {
						pumpStr += "ff";
						pumpStr += "ff";
					} else {
						pumpStr += time2HexStr(data[i].startTime);
						pumpStr += time2HexStr(data[i].endTime);
					}
					
				}
				
				return pumpStr;
			} else {
				
				var pumpArray:Array = new Array(24);
				
				var pumpStr:String = "";
				for(var i:int = 0; i < data.length; i++) {
					if(data[i].startTime != "") {
						if(int(data[i].startTime) > 23 || int(data[i].endTime) > 23) {
							Alert.show("起始时间和结束时间必须在0-23之间");
							return null;
						} 
						var startTime:int = int(data[i].startTime);
						var endTime:int = int(data[i].endTime);
						var isStart:String = data[i].isStart == true ? "1" : "0";
						for(var j:int = startTime; j <= endTime; j++) {
							pumpArray[j] = isStart;
						}
					} 
				}
				for(var j:int = 0; j < pumpArray.length; j++) {
					if(pumpArray[j] != null) {
						pumpStr += pumpArray[j].toString();
					} else {
						pumpStr += "0";
					}
				}
				var result:String = "";
				var j:int = 0;
				for(var i:int = pumpStr.length - 1; i >= 0; i--, j++) {
					result += pumpStr.charAt(i);
				}
				return parseInt(result, 2).toString();
			
			}
			
			
			
		}
		
		/**
		 * 辅助设备加热时间段辅助加热循环泵阀开启状态转换为十六进制字串
		 * 参  数:
		 *   data, 长度为6的对象（obj.startTime, obj.endTime)数组
		 * 返回值：
		 *   十六进制字串（如02535b90ffff8cabb4ebffff，长度为24）
		 */ 
		private function convertAuxiliaryDevice_Work(data:Array): String {
			return convertBoostPump_Work(data);
		}
		
		private function saveHandler(e:Event):void {
			offerBoxLow = convertOfferBoxLow(currentSetupView.offerLevelArray);
			if(isNewVersion()) {
				auxiliaryDevice_Work = convertAuxiliaryDevice_Work(currentSetupView.auxiliaryHeatArray);
			}
			boostPump_Work = convertBoostPump_Work(currentSetupView.pumpStartArray);

			// 说明起始时间和结束时间大于23，就提示用户，不保存
			if(offerBoxLow == null || boostPump_Work == null || auxiliaryDevice_Work == null) {
				return;
			}
			
			lastOperation = SAVE;
			currentSetupView.setState(1);
			
			var dataArray:Array = new Array;
			dataArray.push(int(currentSetupView.Collector_T_H.text) + 55);
			dataArray.push(int(currentSetupView.Collector_T_L.text) + 55);
			dataArray.push(int(currentSetupView.ProductBox_T_L.text) + 55);
			dataArray.push(int(currentSetupView.ProductBox_T_H.text) + 55);
			dataArray.push(int(currentSetupView.OfferBox_T_L.text) + 55);
			dataArray.push(int(currentSetupView.OfferBox_T_H.text) + 55);
			dataArray.push(int(currentSetupView.Collector_Box_T.text) + 55);
			dataArray.push(int(currentSetupView.Product_Offer_T.text) + 55);
			dataArray.push(int(currentSetupView.ReturnPipe_T_L.text) + 55);
			dataArray.push(int(currentSetupView.ProductBox_WL_H.text));
			dataArray.push(int(currentSetupView.OfferBox_WL_H.text));
			dataArray.push(int(currentSetupView.OfferBox_Def_WL_L.text));
			dataArray.push(offerBoxLow);
			//dataArray.push(float2Hex(Number(currentSetupView.TwoBox_WL_Scale.text)));
			dataArray.push(Math.round(Number(currentSetupView.TwoBox_WL_Scale.text) * 100));
			//Math.round((Number(editView.AirHeat_COP.text) * 100))
			dataArray.push(boostPump_Work);
			
			if(isNewVersion()) {
				// 辅助设备加热时间段数据
				dataArray.push(auxiliaryDevice_Work);
			}
			
			if(isNewVersion()) {
				sendOrderProxy.setSystemSetup(username, password, currentSystemData.getCurrentSystemID(), dataArray, currentSystemData.getARM_ID());
			} else {
				sendOrderProxy.setSystemSetupOld(username, password, currentSystemData.getCurrentSystemID(), dataArray, currentSystemData.getARM_ID());
			}
			
			
			// 保存用户的设置数据，和返回的实际设置数据进行对比，从而得知设置是否失败。
			var setupData:SetupData = new SetupData();
			setupData.Collector_Box_T = currentSetupView.Collector_Box_T.text;
			setupData.Collector_T_H = currentSetupView.Collector_T_H.text;
			setupData.Collector_T_L = currentSetupView.Collector_T_L.text;
			setupData.OfferBox_Def_WL_L = currentSetupView.OfferBox_Def_WL_L.text;
			setupData.OfferBox_T_H = currentSetupView.OfferBox_T_H.text;
			setupData.OfferBox_T_L = currentSetupView.OfferBox_T_L.text;
			setupData.OfferBox_WL_H = currentSetupView.OfferBox_WL_H.text;
			setupData.Product_Offer_T = currentSetupView.Product_Offer_T.text;
			setupData.ProductBox_T_H = currentSetupView.ProductBox_T_H.text;
			setupData.ProductBox_T_L = currentSetupView.ProductBox_T_L.text;
			setupData.ProductBox_WL_H = currentSetupView.ProductBox_WL_H.text;
			setupData.ReturnPipe_T_L = currentSetupView.ReturnPipe_T_L.text;
			setupData.TwoBox_WL_Scale = currentSetupView.TwoBox_WL_Scale.text;
			
			currentSetupView.setState(1);
			checkSetSetupProxy.setData(setupData);
			checkSetSetupProxy.setSystemInfo(username, password, currentSystemData.getCurrentSystemID(), new Date());
			checkSetSetupProxy.startCheck();
			//closeWindow();
		}
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.EDIT_CURRENT_SETUP,
				CheckSetSetupProxy.CHECK_SET_SETUP_FAILED,
				CheckSetSetupProxy.CHECK_SET_SETUP_OVERTIME,
				CheckSetSetupProxy.CHECK_SET_SETUP_SUCCESS,
				CheckSetSetupProxy.CHECK_SET_SETUP_WRONG,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		private function showDetail(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.YES:
					sendNotification(ApplicationFacade.SHOW_SETUP_WRONG_DETAIL);
					break;
				case Alert.NO:
					break;
			}
		}
		public override function handleNotification(notification:INotification):void {
			if(notification.getName() == CheckSetSetupProxy.CHECK_SET_SETUP_OVERTIME) {
				Alert.show("系统设置超时");
				if(currentSetupView != null) {
					currentSetupView.setState(2);
				}
			} else if(notification.getName() == CheckSetSetupProxy.CHECK_SET_SETUP_WRONG) {// 如果设置失败，也就是实际值与设置值不同
				// 如果设置界面还存在，就把设置界面中相应的设置值变红
				if(currentSetupView != null) {
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					currentSetupView.setState(0);
				} else {
					Alert.show("设置系统参数失败，是否查看详细信息？", "警告", Alert.YES | Alert.NO, null, showDetail);
				}
			} else if(notification.getName() == CheckSetSetupProxy.CHECK_SET_SETUP_SUCCESS) {
				Alert.show("设置系统参数成功");
				if(currentSetupView != null) {
					currentSetupView.setState(0);
					currentSetupView.colorBack();
					currentSetupView.setDataFromSetupData(SetupData(checkSetSetupProxy.getData()))
				}
			}
			if(currentSetupView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					currentSetupView.setState(0);
					break;
				case ApplicationFacade.EDIT_CURRENT_SETUP:
					sendOrderProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID(), currentSystemData.getARM_ID());
					if(isNewVersion()) {
						sendOrderProxy.getCurrentSetupAuxiliaryDeviceWork(username, password, currentSystemData.getCurrentSystemID(), currentSystemData.getARM_ID());
					}
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					if(lastOperation == SEARCH) {
						currentSetupView.setData(getCurrentSetupProxy.getData() as XML);
					} else if(lastOperation == SAVE) {
						currentSetupView.checkReturnData(getCurrentSetupProxy.getData() as XML);
					}
					break;
			}
		}
		public function get currentSetupView():Object {
			if(isNewVersion()) {
				return viewComponent as EditSystemSetupView;
			} else {
				return viewComponent as EditSystemSetupOldView;
			}
		}
		
		public static function float2Hex(float:Number):String {
			var hex:String = "";
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeFloat(float);
			for(var i:int = 3; i >= 0; i--) {
				for(var j:int = 0; j < 2 - int(byteArray[i]).toString(16).length; j++) {
					hex += "0";
				}
				hex += int(byteArray[i]).toString(16);
			}
			return hex;
		}
		public static function hex2Float(hex:String):String {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeByte(parseInt(hex.substr(0, 2), 16));
			byteArray.writeByte(parseInt(hex.substr(2, 2), 16));
			byteArray.writeByte(parseInt(hex.substr(4, 2), 16));
			byteArray.writeByte(parseInt(hex.substr(6, 2), 16));
			
			return byteArray.readFloat().toString();
		}
		
		/**
		 * 检测是否是新版系统
		 * 参  数：
		 *   无
		 * 返回值：
		 *   true, 新版系统
		 *   false, 旧版系统
		 */ 
		private function isNewVersion():Boolean {
			var config:ConfigManager = ConfigManager.getManageManager();
			var newVersion:String = config.getNewVersion();
			var currentVersion:String = currentSystemData.getARM_Version();
			
			if(currentVersion != null && currentVersion != ""
			  && currentVersion >= newVersion ) {
			  	// 新版
				return true;
			} else {
				// 旧版
				return false;
			}
		}

	}
}