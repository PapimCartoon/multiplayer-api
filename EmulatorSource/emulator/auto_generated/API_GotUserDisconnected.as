package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_GotUserDisconnected extends API_Message {
		public var userId:int;
		public static function create(userId:int):API_GotUserDisconnected { 
			var res:API_GotUserDisconnected = new API_GotUserDisconnected();
			res.userId = userId;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userId = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId); }
		override public function toString():String { return '{API_GotUserDisconnected:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'gotUserDisconnected'; }
		override public function getMethodParameters():Array { return [userId]; }
	}
}
