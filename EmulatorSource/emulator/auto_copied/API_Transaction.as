// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/API_Transaction.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import emulator.*;
	import emulator.auto_generated.*;
	
	import flash.display.*;
	import flash.utils.*;
	
	public final class API_Transaction extends API_Message {
		public var messages:Array/*API_Message*/;
		public static function create(messages:Array/*API_Message*/):API_Transaction {
			var res:API_Transaction = new API_Transaction();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.messages = messages;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.messages = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'messages=' + JSON.stringify(messages); }
		override public function toString():String { return '{API_Transaction:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'Transaction'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [messages]; }

	}
}
