package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class API_DoStoreState extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public function API_DoStoreState(userEntries:Array/*UserEntry*/) { super('doStoreState',arguments); 
			this.userEntries = userEntries;
			for (var i:int=0; i<userEntries.length; i++) userEntries[i] = UserEntry.object2UserEntry(userEntries[i]);
		}
		override public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
	}
}
