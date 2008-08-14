package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class API_GotUserInfo extends API_Message {
		public var userId:int;
		public var entries:Array/*Entry*/;
		public function API_GotUserInfo(userId:int, entries:Array/*Entry*/) { super('gotUserInfo',arguments); 
			this.userId = userId;
			this.entries = entries;
			for (var i:int=0; i<entries.length; i++) entries[i] = Entry.object2Entry(entries[i]);
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', entries=' + JSON.stringify(entries); }
	}
}
