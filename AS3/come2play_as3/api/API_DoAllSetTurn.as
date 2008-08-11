package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoAllSetTurn extends API_Message {
		public var user_id:int;
		public var milliseconds_in_turn:int;
		public function API_DoAllSetTurn(user_id:int, milliseconds_in_turn:int) { super('do_all_set_turn',arguments); 
			this.user_id = user_id;
			this.milliseconds_in_turn = milliseconds_in_turn;
		}
		override public function toString():String { return '{API_DoAllSetTurn' + ': user_id=' + JSON.stringify(user_id) + ': milliseconds_in_turn=' + JSON.stringify(milliseconds_in_turn)+'}'; }
	}
}
