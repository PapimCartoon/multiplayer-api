package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_Got_can_roll_dice extends API_Message {
		public var is_enabled:Boolean;
		public function API_Got_can_roll_dice(is_enabled:Boolean) { super('got_can_roll_dice',arguments); 
			this.is_enabled = is_enabled;
		}
		override public function getParametersAsString():String { return 'is_enabled=' + JSON.stringify(is_enabled); }
	}
}
