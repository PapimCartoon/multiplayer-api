//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoStoreMatchState extends API_Message {
		public var entries:Array/*StateEntry*/;
		public function API_DoStoreMatchState(entries:Array/*StateEntry*/) { super('do_store_match_state',arguments); 
			this.entries = entries;
			for (var i:Number=0; i<entries.length; i++) entries[i] = StateEntry.object2StateEntry(entries[i]);
		}
		/*override*/ public function toString():String { return '{API_DoStoreMatchState' + ': entries=' + JSON.stringify(entries)+'}'; }
	}
