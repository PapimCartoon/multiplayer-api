package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_GotKeyboardEvent extends API_Message {
		public var isKeyDown:Boolean;
		public var charCode:int;
		public var keyCode:int;
		public var keyLocation:int;
		public var altKey:Boolean;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public var ctrlKey:Boolean;
		public var shiftKey:Boolean;
		public static function create(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):API_GotKeyboardEvent {
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
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.isKeyDown = parameters[pos++];
			this.charCode = parameters[pos++];
			this.keyCode = parameters[pos++];
			this.keyLocation = parameters[pos++];
			this.altKey = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.ctrlKey = parameters[pos++];
			this.shiftKey = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'isKeyDown=' + JSON.stringify(isKeyDown)+', charCode=' + JSON.stringify(charCode)+', keyCode=' + JSON.stringify(keyCode)+', keyLocation=' + JSON.stringify(keyLocation)+', altKey=' + JSON.stringify(altKey)+', ctrlKey=' + JSON.stringify(ctrlKey)+', shiftKey=' + JSON.stringify(shiftKey); }
		override public function getFunctionId():int { return -125; }
		override public function toString():String { return '{API_GotKeyboardEvent:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'gotKeyboardEvent'; }
		override public function getMethodParameters():Array { return [isKeyDown, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey]; }
		override public function getMethodParametersNum():int { return 7; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
