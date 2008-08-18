//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotUserDisconnected extends API_Message {
		public var userId:Number;
		public function API_GotUserDisconnected(userId:Number) { super('gotUserDisconnected',arguments); 
			this.userId = userId;
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId); }
	}
