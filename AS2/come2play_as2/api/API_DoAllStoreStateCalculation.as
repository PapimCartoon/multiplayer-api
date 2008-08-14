//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllStoreStateCalculation extends API_Message {
		public var stateEntries:Array/*StateEntry*/;
		public function API_DoAllStoreStateCalculation(stateEntries:Array/*StateEntry*/) { super('doAllStoreStateCalculation',arguments); 
			this.stateEntries = stateEntries;
			for (var i:Number=0; i<stateEntries.length; i++) stateEntries[i] = StateEntry.object2StateEntry(stateEntries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'stateEntries=' + JSON.stringify(stateEntries); }
	}
