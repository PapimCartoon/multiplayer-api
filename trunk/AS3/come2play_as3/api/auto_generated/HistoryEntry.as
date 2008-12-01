package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class HistoryEntry extends API_Message {
		public var message:API_Message;
		public var gotTimeInMilliSeconds:int;
		public static function create(message:API_Message, gotTimeInMilliSeconds:int):HistoryEntry {
			var res:HistoryEntry = new HistoryEntry();
			res.message = message;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.gotTimeInMilliSeconds = gotTimeInMilliSeconds;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.message = parameters[pos++];
			this.gotTimeInMilliSeconds = parameters[pos++];
		}
		override public function getFunctionId():int { return -85; }
		override public function getMethodName():String { return 'historyEntry'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [message, gotTimeInMilliSeconds]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
