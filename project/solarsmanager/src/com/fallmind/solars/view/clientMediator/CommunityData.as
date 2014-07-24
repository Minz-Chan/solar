package com.fallmind.solars.view.clientMediator
{
	public class CommunityData
	{
		public var country:String;
		public var province:String;
		public var city:String;
		public var right:String;
		public var community:String;
		public var id:int;
		public var selected:Boolean;
		public var rightID:int;
		public var highestRightID:int;
		
		public var systemName:String;
		public var alarmName:String;
		public var alarmTime:String;
		public var alarmID:String;
		
		public var failedOrder:String;
		public var orderTime:String;
		public var orderFunction:String;
		
		public function CommunityData()
		{
			selected = false;
		}

	}
}