package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
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
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', infoEntries=' + JSON.stringify(infoEntries); }
		override public function getFunctionId():int { return -123; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getClassName():String { return 'API_GotUserInfo'; }
		override public function getMethodName():String { return 'gotUserInfo'; }
		override public function getFieldNames():Array { return ['userId', 'infoEntries']; }
		override public function getMethodParameters():Array { return [userId, infoEntries]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
