package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_DoConnectedSetScore extends API_Message {
		public var score:int;
		public static function create(score:int):API_DoConnectedSetScore {
			var res:API_DoConnectedSetScore = new API_DoConnectedSetScore();
			res.score = score;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public static var FUNCTION_ID:int = -107;
		public static var METHOD_NAME:String = 'doConnectedSetScore';
		public static var METHOD_PARAMS:Array = ['score'];
	}
}
