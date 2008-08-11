//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotMyUserId extends API_Message {
		public var my_user_id:Number;
		public function API_GotMyUserId(my_user_id:Number) { super('got_my_user_id',arguments); 
			this.my_user_id = my_user_id;
		}
		/*override*/ public function toString():String { return '{API_GotMyUserId' + ': my_user_id=' + JSON.stringify(my_user_id)+'}'; }
	}
