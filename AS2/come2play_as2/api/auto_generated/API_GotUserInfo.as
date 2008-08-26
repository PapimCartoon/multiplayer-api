//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotUserInfo extends API_Message {
		public var userId:Number;
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(userId:Number, infoEntries:Array/*InfoEntry*/):API_GotUserInfo {
			var res:API_GotUserInfo = new API_GotUserInfo();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.infoEntries = infoEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userId = parameters[pos++];
			this.infoEntries = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', infoEntries=' + JSON.stringify(infoEntries); }
		/*override*/ public function toString():String { return '{API_GotUserInfo:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodName():String { return 'gotUserInfo'; }
		/*override*/ public function getMethodParameters():Array { return [userId, infoEntries]; }
	}
