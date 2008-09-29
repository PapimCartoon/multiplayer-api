//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMyUserId extends API_Message {
		public var myUserId:Number;
		public static function create(myUserId:Number):API_GotMyUserId {
			var res:API_GotMyUserId = new API_GotMyUserId();
			res.myUserId = myUserId;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.myUserId = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'myUserId=' + JSON.stringify(myUserId); }
		/*override*/ public function getFunctionId():Number { return -121; }
		/*override*/ public function toString():String { return '{API_GotMyUserId:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'gotMyUserId'; }
		/*override*/ public function getMethodParameters():Array { return [myUserId]; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}
