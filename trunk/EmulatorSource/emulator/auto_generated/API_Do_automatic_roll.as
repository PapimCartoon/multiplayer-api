package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_Do_automatic_roll extends API_Message {
		public var is_automatic:Boolean;
		public function API_Do_automatic_roll(is_automatic:Boolean) { super('do_automatic_roll',arguments); 
			this.is_automatic = is_automatic;
		}
		override public function getParametersAsString():String { return 'is_automatic=' + JSON.stringify(is_automatic); }
	}
}
