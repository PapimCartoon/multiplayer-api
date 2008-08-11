package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotStoredMatchState extends API_Message {
		public var user_id:int;
		public var entries:Array/*StateEntry*/;
		public function API_GotStoredMatchState(user_id:int, entries:Array/*StateEntry*/) { super('got_stored_match_state',arguments); 
			this.user_id = user_id;
			this.entries = entries;
			for (var i:int=0; i<entries.length; i++) entries[i] = StateEntry.object2StateEntry(entries[i]);
		}
		override public function toString():String { return '{API_GotStoredMatchState' + ': user_id=' + JSON.stringify(user_id) + ': entries=' + JSON.stringify(entries)+'}'; }
	}
}
