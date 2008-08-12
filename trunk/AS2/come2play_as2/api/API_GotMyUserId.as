//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotMyUserId extends API_Message {
		public var myUserId:Number;
		public function API_GotMyUserId(myUserId:Number) { super('gotMyUserId',arguments); 
			this.myUserId = myUserId;
		}
		/*override*/ public function getParametersAsString():String { return 'myUserId=' + JSON.stringify(myUserId); }
	}
