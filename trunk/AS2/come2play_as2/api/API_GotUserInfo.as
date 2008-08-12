//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotUserInfo extends API_Message {
		public var userId:Number;
		public var entries:Array/*Entry*/;
		public function API_GotUserInfo(userId:Number, entries:Array/*Entry*/) { super('gotUserInfo',arguments); 
			this.userId = userId;
			this.entries = entries;
			for (var i:Number=0; i<entries.length; i++) entries[i] = Entry.object2Entry(entries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', entries=' + JSON.stringify(entries); }
	}
