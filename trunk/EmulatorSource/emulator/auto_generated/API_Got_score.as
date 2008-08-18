package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_Got_score extends API_Message {
		public var white_score:int;
		public var black_score:int;
		public function API_Got_score(white_score:int, black_score:int) { super('got_score',arguments); 
			this.white_score = white_score;
			this.black_score = black_score;
		}
		override public function getParametersAsString():String { return 'white_score=' + JSON.stringify(white_score)+', black_score=' + JSON.stringify(black_score); }
	}
}
