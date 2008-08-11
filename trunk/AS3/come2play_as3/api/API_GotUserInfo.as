package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotUserInfo extends API_Message {
		public var user_id:int;
		public var entries:Array/*Entry*/;
		public function API_GotUserInfo(user_id:int, entries:Array/*Entry*/) { super('got_user_info',arguments); 
			this.user_id = user_id;
			this.entries = entries;
			for (var i:int=0; i<entries.length; i++) entries[i] = Entry.object2Entry(entries[i]);
		}
		override public function toString():String { return '{API_GotUserInfo' + ': user_id=' + JSON.stringify(user_id) + ': entries=' + JSON.stringify(entries)+'}'; }
	}
}
