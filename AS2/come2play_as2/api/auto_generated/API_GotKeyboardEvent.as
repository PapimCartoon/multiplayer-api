//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotKeyboardEvent extends API_Message {
		public var isKeyDown:Boolean;
		public var charCode:Number;
		public var keyCode:Number;
		public var keyLocation:Number;
		public var altKey:Boolean;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public var ctrlKey:Boolean;
		public var shiftKey:Boolean;
		public static function create(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):API_GotKeyboardEvent {
			var res:API_GotKeyboardEvent = new API_GotKeyboardEvent();
			res.isKeyDown = isKeyDown;
			res.charCode = charCode;
			res.keyCode = keyCode;
			res.keyLocation = keyLocation;
			res.altKey = altKey;
			res.ctrlKey = ctrlKey;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.shiftKey = shiftKey;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.isKeyDown = parameters[pos++];
			this.charCode = parameters[pos++];
			this.keyCode = parameters[pos++];
			this.keyLocation = parameters[pos++];
			this.altKey = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.ctrlKey = parameters[pos++];
			this.shiftKey = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -125; }
		/*override*/ public function getMethodName():String { return 'gotKeyboardEvent'; }
		/*override*/ public function getMethodParameters():Array { return [isKeyDown, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey]; }
		/*override*/ public function getMethodParametersNum():Number { return 7; }
	}
