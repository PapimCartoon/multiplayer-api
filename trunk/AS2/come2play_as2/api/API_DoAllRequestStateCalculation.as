//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllRequestStateCalculation extends API_Message {
		public var keys:Array/*String*/;
		public function API_DoAllRequestStateCalculation(keys:Array/*String*/) { super('doAllRequestStateCalculation',arguments); 
			this.keys = keys;
		}
		/*override*/ public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
	}
