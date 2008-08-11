//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotUserDisconnected extends API_Message {
		public var user_id:Number;
		public function API_GotUserDisconnected(user_id:Number) { super('got_user_disconnected',arguments); 
			this.user_id = user_id;
		}
		/*override*/ public function toString():String { return '{API_GotUserDisconnected' + ': user_id=' + JSON.stringify(user_id)+'}'; }
	}
