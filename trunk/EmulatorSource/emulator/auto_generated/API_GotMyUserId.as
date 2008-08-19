package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_GotMyUserId extends API_Message {
		public var myUserId:int;
		public function API_GotMyUserId(myUserId:int) { super('gotMyUserId',arguments); 
			this.myUserId = myUserId;
		}
		override public function getParametersAsString():String { return 'myUserId=' + JSON.stringify(myUserId); }
	}
}
