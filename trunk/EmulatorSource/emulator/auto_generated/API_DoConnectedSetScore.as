package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_DoConnectedSetScore extends API_Message {
		public var score:int;
		public static function create(score:int):API_DoConnectedSetScore { 
			var res:API_DoConnectedSetScore = new API_DoConnectedSetScore();
			res.score = score;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.score = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'score=' + JSON.stringify(score); }
		override public function toString():String { return '{API_DoConnectedSetScore:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doConnectedSetScore'; }
		override public function getMethodParameters():Array { return [score]; }
	}
}
