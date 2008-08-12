//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotCustomInfo extends API_Message {
		public var entries:Array/*Entry*/;
		public function API_GotCustomInfo(entries:Array/*Entry*/) { super('gotCustomInfo',arguments); 
			this.entries = entries;
			for (var i:Number=0; i<entries.length; i++) entries[i] = Entry.object2Entry(entries[i]);
		}
		/*override*/ public function getParametersAsString():String { return 'entries=' + JSON.stringify(entries); }
	}
