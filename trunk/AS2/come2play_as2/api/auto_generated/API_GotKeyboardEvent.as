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
		public static var FUNCTION_ID:Number = -125;
		public static var METHOD_NAME:String = 'gotKeyboardEvent';
		public static var METHOD_PARAMS:Array = ['isKeyDown', 'charCode', 'keyCode', 'keyLocation', 'altKey', 'ctrlKey', 'shiftKey'];
	}
