//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Got_move_number extends API_Message {
		public var current_move_num:Number;
		public var total_moves_num:Number;
		public function API_Got_move_number(current_move_num:Number, total_moves_num:Number) { super('got_move_number',arguments); 
			this.current_move_num = current_move_num;
			this.total_moves_num = total_moves_num;
		}
		/*override*/ public function getParametersAsString():String { return 'current_move_num=' + JSON.stringify(current_move_num)+', total_moves_num=' + JSON.stringify(total_moves_num); }
	}
