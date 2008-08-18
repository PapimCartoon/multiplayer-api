package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class API_MethodsSummary  {
		public var methodName:String;
		public var parameterNames:Array/*String*/;
		public var parameterTypes:Array/*String*/;
		public function API_MethodsSummary(methodName:String, parameterNames:Array/*String*/, parameterTypes:Array/*String*/) {
			this.methodName = methodName;
			this.parameterNames = parameterNames;
			this.parameterTypes = parameterTypes;
		}
		public static var SUMMARY_API:Array/*API_MethodsSummary*/ = [
		 new API_MethodsSummary('doFinishedCallback', ['callbackName'], ['String'] )
		, new API_MethodsSummary('doRegisterOnServer', [], [] )
		, new API_MethodsSummary('doTrace', ['name', 'message'], ['String', 'Object/*Serializable*/'] )
		, new API_MethodsSummary('gotKeyboardEvent', ['isKeyDown', 'charCode', 'keyCode', 'keyLocation', 'altKey', 'ctrlKey', 'shiftKey'], ['Boolean', 'int', 'int', 'int', 'Boolean', 'Boolean', 'Boolean'] )
		, new API_MethodsSummary('gotCustomInfo', ['infoEntries'], ['Array/*InfoEntry*/'] )
		, new API_MethodsSummary('gotUserInfo', ['userId', 'infoEntries'], ['int', 'Array/*InfoEntry*/'] )
		, new API_MethodsSummary('gotUserDisconnected', ['userId'], ['int'] )
		, new API_MethodsSummary('gotMyUserId', ['myUserId'], ['int'] )
		, new API_MethodsSummary('gotMatchStarted', ['allPlayerIds', 'finishedPlayerIds', 'extraMatchInfo', 'matchStartedTime', 'serverEntries'], ['Array/*int*/', 'Array/*int*/', 'Object/*Serializable*/', 'int', 'Array/*ServerEntry*/'] )
		, new API_MethodsSummary('gotMatchEnded', ['finishedPlayerIds'], ['Array/*int*/'] )
		, new API_MethodsSummary('gotStateChanged', ['serverEntries'], ['Array/*ServerEntry*/'] )
		, new API_MethodsSummary('doStoreState', ['userEntries'], ['Array/*UserEntry*/'] )
		, new API_MethodsSummary('doAllEndMatch', ['finishedPlayers'], ['Array/*PlayerMatchOver*/'] )
		, new API_MethodsSummary('doAllSetTurn', ['userId', 'milliSecondsInTurn'], ['int', 'int'] )
		, new API_MethodsSummary('doAllRevealState', ['revealEntries'], ['Array/*RevealEntry*/'] )
		, new API_MethodsSummary('doAllShuffleState', ['keys'], ['Array/*String*/'] )
		, new API_MethodsSummary('doAllRequestRandomState', ['key', 'isSecret'], ['String', 'Boolean'] )
		, new API_MethodsSummary('doAllFoundHacker', ['userId', 'errorDescription'], ['int', 'String'] )
		, new API_MethodsSummary('doAllRequestStateCalculation', ['keys'], ['Array/*String*/'] )
		, new API_MethodsSummary('gotRequestStateCalculation', ['serverEntries'], ['Array/*ServerEntry*/'] )
		, new API_MethodsSummary('doAllStoreStateCalculation', ['userEntries'], ['Array/*UserEntry*/'] )
		, new API_MethodsSummary('doConnectedSetScore', ['score'], ['int'] )
		, new API_MethodsSummary('doConnectedEndMatch', ['didWin'], ['Boolean'] )
		, new API_MethodsSummary('do_graphic_command_without_enum', ['movie_id', 'func_name', 'func_args'], ['int', 'String', 'Array/*Object*/'] )
		, new API_MethodsSummary('got_graphic_command', ['new_movie_parents', 'new_movie_name_ids', 'graphic_commands'], ['Array/*int*/', 'Array/*int*/', 'Array/*Object*/'] )
		, new API_MethodsSummary('got_save_graphic_command', ['arr', 'pos'], ['Array/*int*/', 'int'] )
		, new API_MethodsSummary('got_old_move_turn_of', ['is_white'], ['Boolean'] )
		, new API_MethodsSummary('got_match_over_waiting_others', ['white_score', 'black_score'], ['int', 'int'] )
		, new API_MethodsSummary('got_no_available_moves', ['is_white'], ['Boolean'] )
		, new API_MethodsSummary('got_score', ['white_score', 'black_score'], ['int', 'int'] )
		, new API_MethodsSummary('got_move_number', ['current_move_num', 'total_moves_num'], ['int', 'int'] )
		, new API_MethodsSummary('got_can_cancel_move', ['is_enabled'], ['Boolean'] )
		, new API_MethodsSummary('do_cancel', [], [] )
		, new API_MethodsSummary('got_can_roll_dice', ['is_enabled'], ['Boolean'] )
		, new API_MethodsSummary('do_roll_dice', [], [] )
		, new API_MethodsSummary('do_automatic_roll', ['is_automatic'], ['Boolean'] )
		, new API_MethodsSummary('do_chess_3D_or_2D', ['is_3D'], ['Boolean'] )
		, new API_MethodsSummary('do_make_move_animations', ['with_animation'], ['Boolean'] )
		, new API_MethodsSummary('do_make_dice_animations', ['with_animation'], ['Boolean'] )
		, new API_MethodsSummary('do_make_animations_on_forward', ['with_animation'], ['Boolean'] )
		];
	}
}
