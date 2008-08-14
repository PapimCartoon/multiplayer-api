package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class API_DoConnectedSetScore extends API_Message {
		public var score:int;
		public function API_DoConnectedSetScore(score:int) { super('doConnectedSetScore',arguments); 
			this.score = score;
		}
		override public function getParametersAsString():String { return 'score=' + JSON.stringify(score); }
	}
}
