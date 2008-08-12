package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoAllFoundHacker extends API_Message {
		public var userId:int;
		public var errorDescription:String;
		public function API_DoAllFoundHacker(userId:int, errorDescription:String) { super('doAllFoundHacker',arguments); 
			this.userId = userId;
			this.errorDescription = errorDescription;
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', errorDescription=' + JSON.stringify(errorDescription); }
	}
}
