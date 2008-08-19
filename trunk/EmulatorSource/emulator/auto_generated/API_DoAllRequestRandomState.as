package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_DoAllRequestRandomState extends API_Message {
		public var key:String;
		public var isSecret:Boolean;
		public function API_DoAllRequestRandomState(key:String, isSecret:Boolean) { super('doAllRequestRandomState',arguments); 
			this.key = key;
			this.isSecret = isSecret;
		}
		override public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', isSecret=' + JSON.stringify(isSecret); }
	}
}
