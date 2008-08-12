//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllShuffleState extends API_Message {
		public var keys:Array/*String*/;
		public function API_DoAllShuffleState(keys:Array/*String*/) { super('doAllShuffleState',arguments); 
			this.keys = keys;
		}
		/*override*/ public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
	}
