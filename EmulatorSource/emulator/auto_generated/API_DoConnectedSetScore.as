package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_DoConnectedSetScore extends API_Message {
		public var score:int;
		public function API_DoConnectedSetScore(score:int) { super('doConnectedSetScore',arguments); 
			this.score = score;
		}
		override public function getParametersAsString():String { return 'score=' + JSON.stringify(score); }
	}
}
