//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Got_no_available_moves extends API_Message {
		public var is_white:Boolean;
		public function API_Got_no_available_moves(is_white:Boolean) { super('got_no_available_moves',arguments); 
			this.is_white = is_white;
		}
		/*override*/ public function getParametersAsString():String { return 'is_white=' + JSON.stringify(is_white); }
	}
