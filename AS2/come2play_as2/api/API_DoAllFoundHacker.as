//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoAllFoundHacker extends API_Message {
		public var user_id:Number;
		public var error_description:String;
		public function API_DoAllFoundHacker(user_id:Number, error_description:String) { super('do_all_found_hacker',arguments); 
			this.user_id = user_id;
			this.error_description = error_description;
		}
		/*override*/ public function toString():String { return '{API_DoAllFoundHacker' + ': user_id=' + JSON.stringify(user_id) + ': error_description=' + JSON.stringify(error_description)+'}'; }
	}
