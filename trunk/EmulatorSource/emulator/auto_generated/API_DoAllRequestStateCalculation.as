package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_DoAllRequestStateCalculation extends API_Message {
		public var keys:Array/*String*/;
		public function API_DoAllRequestStateCalculation(keys:Array/*String*/) { super('doAllRequestStateCalculation',arguments); 
			this.keys = keys;
		}
		override public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
	}
}
