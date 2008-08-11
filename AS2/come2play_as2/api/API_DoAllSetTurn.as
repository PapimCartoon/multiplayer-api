//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllSetTurn extends API_Message {
		public var user_id:Number;
		public var milliseconds_in_turn:Number;
		public function API_DoAllSetTurn(user_id:Number, milliseconds_in_turn:Number) { super('do_all_set_turn',arguments); 
			this.user_id = user_id;
			this.milliseconds_in_turn = milliseconds_in_turn;
		}
		/*override*/ public function toString():String { return '{API_DoAllSetTurn' + ': user_id=' + JSON.stringify(user_id) + ': milliseconds_in_turn=' + JSON.stringify(milliseconds_in_turn)+'}'; }
	}
