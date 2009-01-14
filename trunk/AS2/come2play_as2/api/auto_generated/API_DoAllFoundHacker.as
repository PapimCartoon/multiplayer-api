//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllFoundHacker extends API_Message {
		public var userId:Number;
		public var errorDescription:String;
		public static function create(userId:Number, errorDescription:String):API_DoAllFoundHacker {
			var res:API_DoAllFoundHacker = new API_DoAllFoundHacker();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.errorDescription = errorDescription;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userId = parameters[pos++];
			this.errorDescription = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -111; }
		/*override*/ public function getMethodName():String { return 'doAllFoundHacker'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [userId, errorDescription]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
