package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_DoAllEndMatch extends API_Message {
		public var finishedPlayers:Array/*PlayerMatchOver*/;
		public static function create(finishedPlayers:Array/*PlayerMatchOver*/):API_DoAllEndMatch {
			var res:API_DoAllEndMatch = new API_DoAllEndMatch();
			res.finishedPlayers = finishedPlayers;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.finishedPlayers = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'finishedPlayers=' + JSON.stringify(finishedPlayers); }
		override public function getFunctionId():int { return -116; }
		override public function getClassName():String { return 'API_DoAllEndMatch'; }
		override public function getMethodName():String { return 'doAllEndMatch'; }
		override public function getFieldNames():Array { return ['finishedPlayers']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [finishedPlayers]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
