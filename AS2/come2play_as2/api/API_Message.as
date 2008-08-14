//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_Message  {
		public var methodName:String;
		public var parameters:Array/*Object*/;
		public function API_Message(methodName:String, parameters:Array/*Object*/) { 
			this.methodName = methodName;
			this.parameters = parameters; // the translated parameters to pass to the LocalConnection 
		}
		public function getParametersAsString():String { return 'parameters='+JSON.stringify(parameters); }
		public function toString():String { var res:String = getParametersAsString(); return '{' + methodName + (res!='' ? ': '+res : '') +'}'; }
		public static function createMessage(name:String, parameters:Array/*Object*/):API_Message {
			switch (name) {
			case 'gotKeyboardEvent': if (parameters.length!=7) throw new Error('When creating a message from gotKeyboardEvent, the number of parameters must be 7!'); return new API_GotKeyboardEvent(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
			case 'gotCustomInfo': if (parameters.length!=1) throw new Error('When creating a message from gotCustomInfo, the number of parameters must be 1!'); return new API_GotCustomInfo(parameters[0]);
			case 'gotUserInfo': if (parameters.length!=2) throw new Error('When creating a message from gotUserInfo, the number of parameters must be 2!'); return new API_GotUserInfo(parameters[0], parameters[1]);
			case 'gotUserDisconnected': if (parameters.length!=1) throw new Error('When creating a message from gotUserDisconnected, the number of parameters must be 1!'); return new API_GotUserDisconnected(parameters[0]);
			case 'gotMyUserId': if (parameters.length!=1) throw new Error('When creating a message from gotMyUserId, the number of parameters must be 1!'); return new API_GotMyUserId(parameters[0]);
			case 'gotMatchStarted': if (parameters.length!=5) throw new Error('When creating a message from gotMatchStarted, the number of parameters must be 5!'); return new API_GotMatchStarted(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
			case 'gotMatchEnded': if (parameters.length!=1) throw new Error('When creating a message from gotMatchEnded, the number of parameters must be 1!'); return new API_GotMatchEnded(parameters[0]);
			case 'doFinishedCallback': if (parameters.length!=1) throw new Error('When creating a message from doFinishedCallback, the number of parameters must be 1!'); return new API_DoFinishedCallback(parameters[0]);
			case 'doRegisterOnServer': if (parameters.length!=0) throw new Error('When creating a message from doRegisterOnServer, the number of parameters must be 0!'); return new API_DoRegisterOnServer();
			case 'doTrace': if (parameters.length!=2) throw new Error('When creating a message from doTrace, the number of parameters must be 2!'); return new API_DoTrace(parameters[0], parameters[1]);
			case 'gotStateChanged': if (parameters.length!=1) throw new Error('When creating a message from gotStateChanged, the number of parameters must be 1!'); return new API_GotStateChanged(parameters[0]);
			case 'doStoreState': if (parameters.length!=1) throw new Error('When creating a message from doStoreState, the number of parameters must be 1!'); return new API_DoStoreState(parameters[0]);
			case 'doAllEndMatch': if (parameters.length!=1) throw new Error('When creating a message from doAllEndMatch, the number of parameters must be 1!'); return new API_DoAllEndMatch(parameters[0]);
			case 'doAllSetTurn': if (parameters.length!=2) throw new Error('When creating a message from doAllSetTurn, the number of parameters must be 2!'); return new API_DoAllSetTurn(parameters[0], parameters[1]);
			case 'doAllRevealState': if (parameters.length!=1) throw new Error('When creating a message from doAllRevealState, the number of parameters must be 1!'); return new API_DoAllRevealState(parameters[0]);
			case 'doAllShuffleState': if (parameters.length!=1) throw new Error('When creating a message from doAllShuffleState, the number of parameters must be 1!'); return new API_DoAllShuffleState(parameters[0]);
			case 'doAllFoundHacker': if (parameters.length!=2) throw new Error('When creating a message from doAllFoundHacker, the number of parameters must be 2!'); return new API_DoAllFoundHacker(parameters[0], parameters[1]);
			case 'doAllRequestStateCalculation': if (parameters.length!=1) throw new Error('When creating a message from doAllRequestStateCalculation, the number of parameters must be 1!'); return new API_DoAllRequestStateCalculation(parameters[0]);
			case 'gotRequestStateCalculation': if (parameters.length!=1) throw new Error('When creating a message from gotRequestStateCalculation, the number of parameters must be 1!'); return new API_GotRequestStateCalculation(parameters[0]);
			case 'doAllStoreStateCalculation': if (parameters.length!=1) throw new Error('When creating a message from doAllStoreStateCalculation, the number of parameters must be 1!'); return new API_DoAllStoreStateCalculation(parameters[0]);
			case 'doConnectedSetScore': if (parameters.length!=1) throw new Error('When creating a message from doConnectedSetScore, the number of parameters must be 1!'); return new API_DoConnectedSetScore(parameters[0]);
			case 'doConnectedEndMatch': if (parameters.length!=1) throw new Error('When creating a message from doConnectedEndMatch, the number of parameters must be 1!'); return new API_DoConnectedEndMatch(parameters[0]);
			}
			return null;
		}
		public static var USER_INFO_KEY_name:String = "name";
		public static var USER_INFO_KEY_avatar_url:String = "avatar_url";
		public static var USER_INFO_KEY_supervisor:String = "supervisor";
		public static var USER_INFO_KEY_credibility:String = "credibility";
		public static var USER_INFO_KEY_game_rating:String = "game_rating";
		public static var CUSTOM_INFO_KEY_logo_swf_full_url:String = "logo_swf_full_url";
	}
