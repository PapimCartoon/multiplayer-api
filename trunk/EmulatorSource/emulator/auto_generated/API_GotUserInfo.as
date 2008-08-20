package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_GotUserInfo extends API_Message {
		public var userId:int;
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(userId:int, infoEntries:Array/*InfoEntry*/):API_GotUserInfo { 
			var res:API_GotUserInfo = new API_GotUserInfo();
			res.userId = userId;
			res.infoEntries = infoEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userId = parameters[pos++];
			this.infoEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', infoEntries=' + JSON.stringify(infoEntries); }
		override public function toString():String { return '{API_GotUserInfo:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'gotUserInfo'; }
		override public function getMethodParameters():Array { return [userId, infoEntries]; }
	}
}
