package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_GotStateChanged extends API_Message {
		public var msgNum:int;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(msgNum:int, serverEntries:Array/*ServerEntry*/):API_GotStateChanged {
			var res:API_GotStateChanged = new API_GotStateChanged();
			res.msgNum = msgNum;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.serverEntries = serverEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.msgNum = parameters[pos++];
			this.serverEntries = parameters[pos++];
		}
		override public function getFunctionId():int { return -119; }
		override public function getMethodName():String { return 'gotStateChanged'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [msgNum, serverEntries]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
