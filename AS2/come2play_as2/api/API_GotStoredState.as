//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotStoredState extends API_Message {
		public var userId:Number;
		public var stateEntries:Array/*StateEntry*/;
		public function API_GotStoredState(userId:Number, stateEntries:Array/*StateEntry*/) { super('gotStoredState',arguments); 
			this.userId = userId;
			this.stateEntries = stateEntries;
			for (var i:Number=0; i<stateEntries.length; i++) stateEntries[i] = StateEntry.object2StateEntry(stateEntries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', stateEntries=' + JSON.stringify(stateEntries); }
	}
