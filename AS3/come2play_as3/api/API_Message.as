package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_Message  {
		public var methodName:String;
		public var parameters:Array/*Object*/;
		public function API_Message(methodName:String, parameters:Array/*Object*/) { 
			this.methodName = methodName;
			this.parameters = parameters; // the translated parameters to pass to the LocalConnection 
		}
		public function toString():String { return '{API_Message: methodName='+methodName+' parameters='+JSON.stringify(parameters)+'}'; }
		public static function createMessage(name:String, parameters:Array/*Object*/):API_Message {
			switch (name) {
			case 'got_keyboard_event': if (parameters.length!=7) throw new Error('When creating a message from got_keyboard_event, the number of parameters must be 7!'); return new API_GotKeyboardEvent(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
			case 'got_general_info': if (parameters.length!=1) throw new Error('When creating a message from got_general_info, the number of parameters must be 1!'); return new API_GotGeneralInfo(parameters[0]);
			case 'got_user_info': if (parameters.length!=2) throw new Error('When creating a message from got_user_info, the number of parameters must be 2!'); return new API_GotUserInfo(parameters[0], parameters[1]);
			case 'got_user_disconnected': if (parameters.length!=1) throw new Error('When creating a message from got_user_disconnected, the number of parameters must be 1!'); return new API_GotUserDisconnected(parameters[0]);
			case 'got_my_user_id': if (parameters.length!=1) throw new Error('When creating a message from got_my_user_id, the number of parameters must be 1!'); return new API_GotMyUserId(parameters[0]);
			case 'got_match_started': if (parameters.length!=5) throw new Error('When creating a message from got_match_started, the number of parameters must be 5!'); return new API_GotMatchStarted(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
			case 'do_finished_callback': if (parameters.length!=1) throw new Error('When creating a message from do_finished_callback, the number of parameters must be 1!'); return new API_DoFinishedCallback(parameters[0]);
			case 'do_register_on_server': if (parameters.length!=0) throw new Error('When creating a message from do_register_on_server, the number of parameters must be 0!'); return new API_DoRegisterOnServer();
			case 'do_store_trace': if (parameters.length!=2) throw new Error('When creating a message from do_store_trace, the number of parameters must be 2!'); return new API_DoStoreTrace(parameters[0], parameters[1]);
			case 'do_store_match_state': if (parameters.length!=1) throw new Error('When creating a message from do_store_match_state, the number of parameters must be 1!'); return new API_DoStoreMatchState(parameters[0]);
			case 'got_stored_match_state': if (parameters.length!=2) throw new Error('When creating a message from got_stored_match_state, the number of parameters must be 2!'); return new API_GotStoredMatchState(parameters[0], parameters[1]);
			case 'do_all_end_match': if (parameters.length!=1) throw new Error('When creating a message from do_all_end_match, the number of parameters must be 1!'); return new API_DoAllEndMatch(parameters[0]);
			case 'got_match_over': if (parameters.length!=1) throw new Error('When creating a message from got_match_over, the number of parameters must be 1!'); return new API_GotMatchOver(parameters[0]);
			case 'do_all_set_turn': if (parameters.length!=2) throw new Error('When creating a message from do_all_set_turn, the number of parameters must be 2!'); return new API_DoAllSetTurn(parameters[0], parameters[1]);
			case 'got_turn_of': if (parameters.length!=1) throw new Error('When creating a message from got_turn_of, the number of parameters must be 1!'); return new API_GotTurnOf(parameters[0]);
			case 'do_all_reveal_state': if (parameters.length!=1) throw new Error('When creating a message from do_all_reveal_state, the number of parameters must be 1!'); return new API_DoAllRevealState(parameters[0]);
			case 'do_all_shuffle_state': if (parameters.length!=1) throw new Error('When creating a message from do_all_shuffle_state, the number of parameters must be 1!'); return new API_DoAllShuffleState(parameters[0]);
			case 'do_all_found_hacker': if (parameters.length!=2) throw new Error('When creating a message from do_all_found_hacker, the number of parameters must be 2!'); return new API_DoAllFoundHacker(parameters[0], parameters[1]);
			case 'do_all_request_impartial_state': if (parameters.length!=1) throw new Error('When creating a message from do_all_request_impartial_state, the number of parameters must be 1!'); return new API_DoAllRequestImpartialState(parameters[0]);
			case 'got_request_impartial_state': if (parameters.length!=2) throw new Error('When creating a message from got_request_impartial_state, the number of parameters must be 2!'); return new API_GotRequestImpartialState(parameters[0], parameters[1]);
			case 'do_connected_set_score': if (parameters.length!=1) throw new Error('When creating a message from do_connected_set_score, the number of parameters must be 1!'); return new API_DoConnectedSetScore(parameters[0]);
			case 'do_connected_match_over': if (parameters.length!=1) throw new Error('When creating a message from do_connected_match_over, the number of parameters must be 1!'); return new API_DoConnectedMatchOver(parameters[0]);
			}
			return null;
		}
	}
}
