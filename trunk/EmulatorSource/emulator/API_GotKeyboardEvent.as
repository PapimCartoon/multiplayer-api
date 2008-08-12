package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_GotKeyboardEvent extends API_Message {
		public var isKeyDown:Boolean;
		public var charCode:int;
		public var keyCode:int;
		public var keyLocation:int;
		public var altKey:Boolean;
		public var ctrlKey:Boolean;
		public var shiftKey:Boolean;
		public function API_GotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean) { super('gotKeyboardEvent',arguments); 
			this.isKeyDown = isKeyDown;
			this.charCode = charCode;
			this.keyCode = keyCode;
			this.keyLocation = keyLocation;
			this.altKey = altKey;
			this.ctrlKey = ctrlKey;
			this.shiftKey = shiftKey;
		}
		override public function getParametersAsString():String { return 'isKeyDown=' + JSON.stringify(isKeyDown)+', charCode=' + JSON.stringify(charCode)+', keyCode=' + JSON.stringify(keyCode)+', keyLocation=' + JSON.stringify(keyLocation)+', altKey=' + JSON.stringify(altKey)+', ctrlKey=' + JSON.stringify(ctrlKey)+', shiftKey=' + JSON.stringify(shiftKey); }
	}
}
