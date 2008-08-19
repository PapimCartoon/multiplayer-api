package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_Message  {
		public var methodName:String;
		public var parameters:Array/*Object*/;
		public function API_Message(methodName:String, parameters:Array/*Object*/) { 
			/*Only in AS3*/if (getQualifiedClassName(this)=='emulator::API_Message') throw new Error('Do not use new API_Message(...), use API_Message.createMessage(...)');
			this.methodName = methodName;
			this.parameters = parameters; // the translated parameters to pass to the LocalConnection 
		}
		public function getParametersAsString():String { return 'parameters='+JSON.stringify(parameters); }
		public function toString():String { var res:String = getParametersAsString(); return '{' + methodName + (res!='' ? ': '+res : '') +'}'; }
		public static function createMessage(name:String, parameters:Array/*Object*/):API_Message {
			switch (name) {
			case 'doFinishedCallback': if (parameters.length!=1) throw new Error('When creating a message from doFinishedCallback, the number of parameters must be 1!'); return new API_DoFinishedCallback(parameters[0]);
			case 'doRegisterOnServer': if (parameters.length!=0) throw new Error('When creating a message from doRegisterOnServer, the number of parameters must be 0!'); return new API_DoRegisterOnServer();
			case 'doTrace': if (parameters.length!=2) throw new Error('When creating a message from doTrace, the number of parameters must be 2!'); return new API_DoTrace(parameters[0], parameters[1]);
			case 'gotKeyboardEvent': if (parameters.length!=7) throw new Error('When creating a message from gotKeyboardEvent, the number of parameters must be 7!'); return new API_GotKeyboardEvent(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
			case 'gotCustomInfo': if (parameters.length!=1) throw new Error('When creating a message from gotCustomInfo, the number of parameters must be 1!'); return new API_GotCustomInfo(parameters[0]);
			case 'gotUserInfo': if (parameters.length!=2) throw new Error('When creating a message from gotUserInfo, the number of parameters must be 2!'); return new API_GotUserInfo(parameters[0], parameters[1]);
			case 'gotUserDisconnected': if (parameters.length!=1) throw new Error('When creating a message from gotUserDisconnected, the number of parameters must be 1!'); return new API_GotUserDisconnected(parameters[0]);
			case 'gotMyUserId': if (parameters.length!=1) throw new Error('When creating a message from gotMyUserId, the number of parameters must be 1!'); return new API_GotMyUserId(parameters[0]);
			case 'gotMatchStarted': if (parameters.length!=5) throw new Error('When creating a message from gotMatchStarted, the number of parameters must be 5!'); return new API_GotMatchStarted(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
			case 'gotMatchEnded': if (parameters.length!=1) throw new Error('When creating a message from gotMatchEnded, the number of parameters must be 1!'); return new API_GotMatchEnded(parameters[0]);
			case 'gotStateChanged': if (parameters.length!=1) throw new Error('When creating a message from gotStateChanged, the number of parameters must be 1!'); return new API_GotStateChanged(parameters[0]);
			case 'doStoreState': if (parameters.length!=1) throw new Error('When creating a message from doStoreState, the number of parameters must be 1!'); return new API_DoStoreState(parameters[0]);
			case 'doAllEndMatch': if (parameters.length!=1) throw new Error('When creating a message from doAllEndMatch, the number of parameters must be 1!'); return new API_DoAllEndMatch(parameters[0]);
			case 'doAllSetTurn': if (parameters.length!=2) throw new Error('When creating a message from doAllSetTurn, the number of parameters must be 2!'); return new API_DoAllSetTurn(parameters[0], parameters[1]);
			case 'doAllRevealState': if (parameters.length!=1) throw new Error('When creating a message from doAllRevealState, the number of parameters must be 1!'); return new API_DoAllRevealState(parameters[0]);
			case 'doAllShuffleState': if (parameters.length!=1) throw new Error('When creating a message from doAllShuffleState, the number of parameters must be 1!'); return new API_DoAllShuffleState(parameters[0]);
			case 'doAllRequestRandomState': if (parameters.length!=2) throw new Error('When creating a message from doAllRequestRandomState, the number of parameters must be 2!'); return new API_DoAllRequestRandomState(parameters[0], parameters[1]);
			case 'doAllFoundHacker': if (parameters.length!=2) throw new Error('When creating a message from doAllFoundHacker, the number of parameters must be 2!'); return new API_DoAllFoundHacker(parameters[0], parameters[1]);
			case 'doAllRequestStateCalculation': if (parameters.length!=1) throw new Error('When creating a message from doAllRequestStateCalculation, the number of parameters must be 1!'); return new API_DoAllRequestStateCalculation(parameters[0]);
			case 'gotRequestStateCalculation': if (parameters.length!=1) throw new Error('When creating a message from gotRequestStateCalculation, the number of parameters must be 1!'); return new API_GotRequestStateCalculation(parameters[0]);
			case 'doAllStoreStateCalculation': if (parameters.length!=1) throw new Error('When creating a message from doAllStoreStateCalculation, the number of parameters must be 1!'); return new API_DoAllStoreStateCalculation(parameters[0]);
			case 'doConnectedSetScore': if (parameters.length!=1) throw new Error('When creating a message from doConnectedSetScore, the number of parameters must be 1!'); return new API_DoConnectedSetScore(parameters[0]);
			case 'doConnectedEndMatch': if (parameters.length!=1) throw new Error('When creating a message from doConnectedEndMatch, the number of parameters must be 1!'); return new API_DoConnectedEndMatch(parameters[0]);
			case 'do_graphic_command_without_enum': if (parameters.length!=3) throw new Error('When creating a message from do_graphic_command_without_enum, the number of parameters must be 3!'); return new API_Do_graphic_command_without_enum(parameters[0], parameters[1], parameters[2]);
			case 'got_graphic_command': if (parameters.length!=3) throw new Error('When creating a message from got_graphic_command, the number of parameters must be 3!'); return new API_Got_graphic_command(parameters[0], parameters[1], parameters[2]);
			case 'got_save_graphic_command': if (parameters.length!=2) throw new Error('When creating a message from got_save_graphic_command, the number of parameters must be 2!'); return new API_Got_save_graphic_command(parameters[0], parameters[1]);
			case 'got_old_move_turn_of': if (parameters.length!=1) throw new Error('When creating a message from got_old_move_turn_of, the number of parameters must be 1!'); return new API_Got_old_move_turn_of(parameters[0]);
			case 'got_match_over_waiting_others': if (parameters.length!=2) throw new Error('When creating a message from got_match_over_waiting_others, the number of parameters must be 2!'); return new API_Got_match_over_waiting_others(parameters[0], parameters[1]);
			case 'got_no_available_moves': if (parameters.length!=1) throw new Error('When creating a message from got_no_available_moves, the number of parameters must be 1!'); return new API_Got_no_available_moves(parameters[0]);
			case 'got_score': if (parameters.length!=2) throw new Error('When creating a message from got_score, the number of parameters must be 2!'); return new API_Got_score(parameters[0], parameters[1]);
			case 'got_move_number': if (parameters.length!=2) throw new Error('When creating a message from got_move_number, the number of parameters must be 2!'); return new API_Got_move_number(parameters[0], parameters[1]);
			case 'got_can_cancel_move': if (parameters.length!=1) throw new Error('When creating a message from got_can_cancel_move, the number of parameters must be 1!'); return new API_Got_can_cancel_move(parameters[0]);
			case 'do_cancel': if (parameters.length!=0) throw new Error('When creating a message from do_cancel, the number of parameters must be 0!'); return new API_Do_cancel();
			case 'got_can_roll_dice': if (parameters.length!=1) throw new Error('When creating a message from got_can_roll_dice, the number of parameters must be 1!'); return new API_Got_can_roll_dice(parameters[0]);
			case 'do_roll_dice': if (parameters.length!=0) throw new Error('When creating a message from do_roll_dice, the number of parameters must be 0!'); return new API_Do_roll_dice();
			case 'do_automatic_roll': if (parameters.length!=1) throw new Error('When creating a message from do_automatic_roll, the number of parameters must be 1!'); return new API_Do_automatic_roll(parameters[0]);
			case 'do_chess_3D_or_2D': if (parameters.length!=1) throw new Error('When creating a message from do_chess_3D_or_2D, the number of parameters must be 1!'); return new API_Do_chess_3D_or_2D(parameters[0]);
			case 'do_make_move_animations': if (parameters.length!=1) throw new Error('When creating a message from do_make_move_animations, the number of parameters must be 1!'); return new API_Do_make_move_animations(parameters[0]);
			case 'do_make_dice_animations': if (parameters.length!=1) throw new Error('When creating a message from do_make_dice_animations, the number of parameters must be 1!'); return new API_Do_make_dice_animations(parameters[0]);
			case 'do_make_animations_on_forward': if (parameters.length!=1) throw new Error('When creating a message from do_make_animations_on_forward, the number of parameters must be 1!'); return new API_Do_make_animations_on_forward(parameters[0]);
			}
			return null;
		}
		public static const USER_INFO_KEY_name:String = "name";
		public static const USER_INFO_KEY_avatar_url:String = "avatar_url";
		public static const USER_INFO_KEY_supervisor:String = "supervisor";
		public static const USER_INFO_KEY_credibility:String = "credibility";
		public static const USER_INFO_KEY_game_rating:String = "game_rating";
		public static const CUSTOM_INFO_KEY_logo_swf_full_url:String = "logo_swf_full_url";
	}
}
