package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotTurnOf extends API_Message {
		public var user_id:int;
		public function API_GotTurnOf(user_id:int) { super('got_turn_of',arguments); 
			this.user_id = user_id;
		}
		override public function toString():String { return '{API_GotTurnOf' + ': user_id=' + JSON.stringify(user_id)+'}'; }
	}
}
