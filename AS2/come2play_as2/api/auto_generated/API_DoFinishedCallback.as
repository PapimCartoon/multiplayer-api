//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoFinishedCallback extends API_Message {
		public var callbackName:String;
		public static function create(callbackName:String):API_DoFinishedCallback { 
			var res:API_DoFinishedCallback = new API_DoFinishedCallback();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.callbackName = callbackName;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.callbackName = parameters[pos++];
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getParametersAsString():String { return 'callbackName=' + JSON.stringify(callbackName); }
		/*override*/ public function toString():String { return '{API_DoFinishedCallback:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doFinishedCallback'; }
		/*override*/ public function getMethodParameters():Array { return [callbackName]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

