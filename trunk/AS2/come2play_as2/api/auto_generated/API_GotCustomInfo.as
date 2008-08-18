//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotCustomInfo extends API_Message {
		public var infoEntries:Array/*InfoEntry*/;
		public function API_GotCustomInfo(infoEntries:Array/*InfoEntry*/) { super('gotCustomInfo',arguments); 
			this.infoEntries = infoEntries;
			for (var i:Number=0; i<infoEntries.length; i++) infoEntries[i] = InfoEntry.object2InfoEntry(infoEntries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'infoEntries=' + JSON.stringify(infoEntries); }
	}
