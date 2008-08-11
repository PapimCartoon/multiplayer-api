//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotUserInfo extends API_Message {
		public var user_id:Number;
		public var entries:Array/*Entry*/;
		public function API_GotUserInfo(user_id:Number, entries:Array/*Entry*/) { super('got_user_info',arguments); 
			this.user_id = user_id;
			this.entries = entries;
			for (var i:Number=0; i<entries.length; i++) entries[i] = Entry.object2Entry(entries[i]);
		}
		/*override*/ public function toString():String { return '{API_GotUserInfo' + ': user_id=' + JSON.stringify(user_id) + ': entries=' + JSON.stringify(entries)+'}'; }
	}
