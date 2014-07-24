package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetHistoryDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.solarSystem.HistoryDataDisplayView;
	import com.fallmind.solars.view.component.solarSystem.HistoryDataView;
	
	import flash.events.Event;
	
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class HistoryDataMediator extends Mediator
	{
		public static const NAME:String = "HistoryInfoMediator";
		private var historyDataProxy:GetHistoryDataProxy;
		private var loginProxy:LoginProxy;
		private var currentSystemDataProxy:CurrentDataProxy;
		private var userName:String;
		private var password:String;
		
		private var startTime:String;
		private var endTime:String;
		
		private var firstCreate:Boolean = true;
		
		public var historyDisplayViewIsShowed:Boolean = false;
		
		public function HistoryDataMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			historyDataProxy = GetHistoryDataProxy(facade.retrieveProxy(GetHistoryDataProxy.NAME));
			currentSystemDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			historyDataView.addEventListener(HistoryDataView.HISTORYDATA_VIEW_CONFIRM, getHistoryDataHandler);
			historyDataView.addEventListener(HistoryDataView.CLOSE_HISTORY_DATA_VIEW, closeWindow);
			
			userName = loginProxy.getData().UserName;
			password = loginProxy.getData().UserPassword;
		}
		
		private function closeWindow(e:Event):void {
			PopUpManager.removePopUp(historyDataView);
			this.setViewComponent(null);
		}
		
		public function init():void {
			historyDataView.addEventListener(HistoryDataView.HISTORYDATA_VIEW_CONFIRM, getHistoryDataHandler);
			historyDataView.addEventListener(HistoryDataView.CLOSE_HISTORY_DATA_VIEW, closeWindow);
		}
		
		public function get historyDataView():HistoryDataView {
			return viewComponent as HistoryDataView;
		}
		
		private function getHistoryDataHandler(e:Event):void {
			var startTime:String = historyDataView.startYear.selectedItem.data + "-" + historyDataView.startMonth.selectedItem.data + "-" +
				historyDataView.startDay.selectedItem.data + " " + historyDataView.startHour.selectedItem.data + ":" + historyDataView.startMinute.selectedItem.data;
			var endTime:String = historyDataView.endYear.selectedItem.data + "-" + historyDataView.endMonth.selectedItem.data + "-" +
				historyDataView.endDay.selectedItem.data + " " + historyDataView.endHour.selectedItem.data + ":" + historyDataView.endMinute.selectedItem.data;
			
			this.startTime = startTime;
			this.endTime = endTime;
			// 获取历史数据，分页获取，第一次获取第一页，每页5条数据
			historyDataProxy.GetHistoryData(userName, password, currentSystemDataProxy.getCurrentSystemID(), startTime, endTime, "1", "5");
		}
		public override function listNotificationInterests():Array {
			return [
				GetHistoryDataProxy.GET_HISTORYDATA_SUCCESS
			];
		}
		public override function handleNotification(notification:INotification):void {
			if(historyDataView == null) {
				return;
			}
			switch(notification.getName()) {
				case GetHistoryDataProxy.GET_HISTORYDATA_SUCCESS:
					historyDataView.confirmButton.enabled = true;
					if(XML(historyDataProxy.getData()).hasComplexContent() == false) {
						Alert.show("无数据");
						break;
					} else {
						if(!historyDisplayViewIsShowed) {
							createHistoryDisplayView(historyDataProxy.getData() as XML);
							historyDisplayViewIsShowed = true;
						}
						break;
					}
			}
		}
		private function createHistoryDisplayView(data:XML):void {
			var u:HistoryDataDisplayView = HistoryDataDisplayView(PopUpManager.createPopUp(historyDataView.parent, HistoryDataDisplayView, true));
			//u.x = historyDataView.stage.width / 2 - u.width / 2;
			//u.y = historyDataView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreate) {
				var a:HistoryDataDisplayMediator = new HistoryDataDisplayMediator(u);
				facade.registerMediator(a);
				firstCreate = false;
				a.startTime = startTime;
				a.endTime = endTime;
				a.systemID = currentSystemDataProxy.getCurrentSystemID();
			} else {
				var temp:HistoryDataDisplayMediator = facade.retrieveMediator(HistoryDataDisplayMediator.NAME) as HistoryDataDisplayMediator;
				temp.setViewComponent(u); 
				temp.init();
				temp.startTime = startTime;
				temp.endTime = endTime;
				temp.systemID = currentSystemDataProxy.getCurrentSystemID();
			}
			var arr:Array = new Array;
			
			var totalData:Array = new Array;
			for each(var gridRow:GridRow in historyDataView.checkBoxGrid.getChildren()) {
				for each(var gridItem:GridItem in gridRow.getChildren()) {
					totalData.push(gridItem.getChildAt(0) as CheckBox);
				}
			}
			for(var i:int = 0; i < totalData.length; i += 3) {
				if(CheckBox(totalData[i]).selected) {
					var object:Object = {
						name : CheckBox(totalData[i]).label,
						data : CheckBox(totalData[i]).name
					}
					arr.push(object);
				}
			}
			for(var i:int = 1; i < totalData.length; i += 3) {
				if(CheckBox(totalData[i]).selected) {
					var object:Object = {
						name : CheckBox(totalData[i]).label,
						data : CheckBox(totalData[i]).name
					}
					arr.push(object);
				}
			}
			for(var i:int = 2; i < totalData.length; i += 3) {
				if(CheckBox(totalData[i]).selected) {
					var object:Object = {
						name : CheckBox(totalData[i]).label,
						data : CheckBox(totalData[i]).name
					}
					arr.push(object);
				}
			}
			if(CheckBox(totalData[totalData.length - 1]).selected) {
				var object:Object = {
					name : CheckBox(totalData[totalData.length - 1]).label,
					data : CheckBox(totalData[totalData.length - 1]).name
				}
				arr.push(object);
			}
			
			// 创建显示数据的界面
			u.createDataGrid(arr);
			// 给界面填充数据
			u.setData(data.Data[0]);
			u.pagingBar.totalRecord = int(data.TotalSize);
			u.pagingBar.dataBind(true);
		}
	}
}