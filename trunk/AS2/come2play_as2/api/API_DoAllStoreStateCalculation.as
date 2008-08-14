//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllStoreStateCalculation extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public function API_DoAllStoreStateCalculation(userEntries:Array/*UserEntry*/) { super('doAllStoreStateCalculation',arguments); 
			this.userEntries = userEntries;
			for (var i:Number=0; i<userEntries.length; i++) userEntries[i] = UserEntry.object2UserEntry(userEntries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
	}
