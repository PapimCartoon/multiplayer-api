package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotMyUserId extends API_Message {
		public var myUserId:int;
		public function API_GotMyUserId(myUserId:int) { super('gotMyUserId',arguments); 
			this.myUserId = myUserId;
		}
		override public function getParametersAsString():String { return 'myUserId=' + JSON.stringify(myUserId); }
	}
}
