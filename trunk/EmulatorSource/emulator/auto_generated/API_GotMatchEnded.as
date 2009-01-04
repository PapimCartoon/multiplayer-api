package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_GotMatchEnded extends API_Message {
		public var msgNum:int;
		public var finishedPlayerIds:Array/*int*/;
		public static function create(msgNum:int, finishedPlayerIds:Array/*int*/):API_GotMatchEnded {
			var res:API_GotMatchEnded = new API_GotMatchEnded();
			res.msgNum = msgNum;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.finishedPlayerIds = finishedPlayerIds;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.msgNum = parameters[pos++];
			this.finishedPlayerIds = parameters[pos++];
		}
		override public function getFunctionId():int { return -120; }
		override public function getMethodName():String { return 'gotMatchEnded'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [msgNum, finishedPlayerIds]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
