package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_GotUserInfo extends API_Message {
		public var userId:int;
		public var infoEntries:Array/*InfoEntry*/;
		public function API_GotUserInfo(userId:int, infoEntries:Array/*InfoEntry*/) { super('gotUserInfo',arguments); 
			this.userId = userId;
			this.infoEntries = infoEntries;
			for (var i:int=0; i<infoEntries.length; i++) infoEntries[i] = InfoEntry.object2InfoEntry(infoEntries[i]);
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', infoEntries=' + JSON.stringify(infoEntries); }
	}
}
