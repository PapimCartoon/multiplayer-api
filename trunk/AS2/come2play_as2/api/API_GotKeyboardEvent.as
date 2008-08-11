//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotKeyboardEvent extends API_Message {
		public var is_key_down:Boolean;
		public var charCode:Number;
		public var keyCode:Number;
		public var keyLocation:Number;
		public var altKey:Boolean;
		public var ctrlKey:Boolean;
		public var shiftKey:Boolean;
		public function API_GotKeyboardEvent(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean) { super('got_keyboard_event',arguments); 
			this.is_key_down = is_key_down;
			this.charCode = charCode;
			this.keyCode = keyCode;
			this.keyLocation = keyLocation;
			this.altKey = altKey;
			this.ctrlKey = ctrlKey;
			this.shiftKey = shiftKey;
		}
		/*override*/ public function toString():String { return '{API_GotKeyboardEvent' + ': is_key_down=' + JSON.stringify(is_key_down) + ': charCode=' + JSON.stringify(charCode) + ': keyCode=' + JSON.stringify(keyCode) + ': keyLocation=' + JSON.stringify(keyLocation) + ': altKey=' + JSON.stringify(altKey) + ': ctrlKey=' + JSON.stringify(ctrlKey) + ': shiftKey=' + JSON.stringify(shiftKey)+'}'; }
	}
