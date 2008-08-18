//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoFinishedCallback extends API_Message {
		public var callbackName:String;
		public function API_DoFinishedCallback(callbackName:String) { super('doFinishedCallback',arguments); 
			this.callbackName = callbackName;
		}
		/*override*/ public function getParametersAsString():String { return 'callbackName=' + JSON.stringify(callbackName); }
	}
