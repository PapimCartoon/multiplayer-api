package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoAllEndMatch extends API_Message {
		public var finishedPlayers:Array/*PlayerMatchOver*/;
		public static function create(finishedPlayers:Array/*PlayerMatchOver*/):API_DoAllEndMatch { 
			var res:API_DoAllEndMatch = new API_DoAllEndMatch();
			res.finishedPlayers = finishedPlayers;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.finishedPlayers = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'finishedPlayers=' + JSON.stringify(finishedPlayers); }
		override public function toString():String { return '{API_DoAllEndMatch:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllEndMatch'; }
		override public function getMethodParameters():Array { return [finishedPlayers]; }
	}
}
