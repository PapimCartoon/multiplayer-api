package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoConnectedSetScore extends API_Message {
		public var score:int;
		public function API_DoConnectedSetScore(score:int) { super('do_connected_set_score',arguments); 
			this.score = score;
		}
		override public function toString():String { return '{API_DoConnectedSetScore' + ': score=' + JSON.stringify(score)+'}'; }
	}
}
