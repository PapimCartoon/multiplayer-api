//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotUserDisconnected extends API_Message {
		public var userId:Number;
		public static function create(userId:Number):API_GotUserDisconnected {
			var res:API_GotUserDisconnected = new API_GotUserDisconnected();
			res.userId = userId;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userId = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId); }
		/*override*/ public function getFunctionId():Number { return -122; }
		/*override*/ public function getClassName():String { return 'API_GotUserDisconnected'; }
		/*override*/ public function getMethodName():String { return 'gotUserDisconnected'; }
		/*override*/ public function getFieldNames():Array { return ['userId']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [userId]; }
		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}
