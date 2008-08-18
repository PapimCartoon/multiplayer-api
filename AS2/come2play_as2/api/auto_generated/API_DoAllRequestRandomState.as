//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllRequestRandomState extends API_Message {
		public var key:String;
		public var isSecret:Boolean;
		public function API_DoAllRequestRandomState(key:String, isSecret:Boolean) { super('doAllRequestRandomState',arguments); 
			this.key = key;
			this.isSecret = isSecret;
		}
		/*override*/ public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', isSecret=' + JSON.stringify(isSecret); }
	}
