//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllFoundHacker extends API_Message {
		public var userId:Number;
		public var errorDescription:String;
		public function API_DoAllFoundHacker(userId:Number, errorDescription:String) { super('doAllFoundHacker',arguments); 
			this.userId = userId;
			this.errorDescription = errorDescription;
		}
		/*override*/ public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', errorDescription=' + JSON.stringify(errorDescription); }
	}
