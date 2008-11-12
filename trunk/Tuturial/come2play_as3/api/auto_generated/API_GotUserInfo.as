package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_GotUserInfo extends API_Message {
		public var userId:int;
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(userId:int, infoEntries:Array/*InfoEntry*/):API_GotUserInfo {
			var res:API_GotUserInfo = new API_GotUserInfo();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.infoEntries = infoEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userId = parameters[pos++];
			this.infoEntries = parameters[pos++];
		}
		override public function getFunctionId():int { return -123; }
		override public function getMethodName():String { return 'gotUserInfo'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [userId, infoEntries]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
