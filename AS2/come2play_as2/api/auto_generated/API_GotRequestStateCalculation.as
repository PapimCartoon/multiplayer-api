//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotRequestStateCalculation extends API_Message {
		public var serverEntries:Array/*ServerEntry*/;
		public function API_GotRequestStateCalculation(serverEntries:Array/*ServerEntry*/) { super('gotRequestStateCalculation',arguments); 
			this.serverEntries = serverEntries;
			for (var i:Number=0; i<serverEntries.length; i++) serverEntries[i] = ServerEntry.object2ServerEntry(serverEntries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'serverEntries=' + JSON.stringify(serverEntries); }
	}
