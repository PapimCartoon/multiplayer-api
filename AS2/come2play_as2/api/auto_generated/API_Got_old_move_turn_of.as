//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Got_old_move_turn_of extends API_Message {
		public var is_white:Boolean;
		public function API_Got_old_move_turn_of(is_white:Boolean) { super('got_old_move_turn_of',arguments); 
			this.is_white = is_white;
		}
		/*override*/ public function getParametersAsString():String { return 'is_white=' + JSON.stringify(is_white); }
	}
