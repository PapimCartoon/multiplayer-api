//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Got_can_cancel_move extends API_Message {
		public var is_enabled:Boolean;
		public function API_Got_can_cancel_move(is_enabled:Boolean) { super('got_can_cancel_move',arguments); 
			this.is_enabled = is_enabled;
		}
		/*override*/ public function getParametersAsString():String { return 'is_enabled=' + JSON.stringify(is_enabled); }
	}
