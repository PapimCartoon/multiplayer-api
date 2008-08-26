package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoAllFoundHacker extends API_Message {
		public var userId:int;
		public var errorDescription:String;
		public static function create(userId:int, errorDescription:String):API_DoAllFoundHacker {
			var res:API_DoAllFoundHacker = new API_DoAllFoundHacker();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.errorDescription = errorDescription;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userId = parameters[pos++];
			this.errorDescription = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', errorDescription=' + JSON.stringify(errorDescription); }
		override public function toString():String { return '{API_DoAllFoundHacker:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodName():String { return 'doAllFoundHacker'; }
		override public function getMethodParameters():Array { return [userId, errorDescription]; }
	}
}
