package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_GotMatchEnded extends API_Message {
		public var finishedPlayerIds:Array/*int*/;
		public static function create(finishedPlayerIds:Array/*int*/):API_GotMatchEnded {
			var res:API_GotMatchEnded = new API_GotMatchEnded();
			res.finishedPlayerIds = finishedPlayerIds;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.finishedPlayerIds = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'finishedPlayerIds=' + JSON.stringify(finishedPlayerIds); }
		override public function getFunctionId():int { return -120; }
		override public function getClassName():String { return 'API_GotMatchEnded'; }
		override public function getMethodName():String { return 'gotMatchEnded'; }
		override public function getFieldNames():Array { return ['finishedPlayerIds']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [finishedPlayerIds]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
