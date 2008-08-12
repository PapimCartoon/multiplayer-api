//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllRequestStateCalculation extends API_Message {
		public var value:Object/*Serializable*/;
		public function API_DoAllRequestStateCalculation(value:Object/*Serializable*/) { super('doAllRequestStateCalculation',arguments); 
			this.value = value;
		}
		/*override*/ public function getParametersAsString():String { return 'value=' + JSON.stringify(value); }
	}
