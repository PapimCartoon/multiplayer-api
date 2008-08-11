//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.SummaryGameAPI  {
		public static var SUMMARY_API:Array = [
		['got_keyboard_event', [['is_key_down','boolean'], ['charCode','int'], ['keyCode','int'], ['keyLocation','int'], ['altKey','boolean'], ['ctrlKey','boolean'], ['shiftKey','boolean']] ]
		,['got_general_info', [['entries','null']] ]
		,['got_user_info', [['user_id','int'], ['entries','null']] ]
		,['got_user_disconnected', [['user_id','int']] ]
		,['got_my_user_id', [['my_user_id','int']] ]
		,['got_match_started', [['all_player_ids','int[]'], ['finished_player_ids','int[]'], ['extra_match_info','Object'], ['match_started_time','int'], ['match_state','null']] ]
		,['do_finished_callback', [['method_name','String']] ]
		,['do_register_on_server', [] ]
		,['do_store_trace', [['name','String'], ['message','Object']] ]
		,['do_store_match_state', [['entries','null']] ]
		,['got_stored_match_state', [['user_id','int'], ['entries','null']] ]
		,['do_all_end_match', [['finished_players','null']] ]
		,['got_match_over', [['finished_player_ids','int[]']] ]
		,['do_all_set_turn', [['user_id','int'], ['milliseconds_in_turn','int']] ]
		,['got_turn_of', [['user_id','int']] ]
		,['do_all_reveal_state', [['entries','null']] ]
		,['do_all_shuffle_state', [['keys','String[]']] ]
		,['do_all_found_hacker', [['user_id','int'], ['error_description','String']] ]
		,['do_all_request_impartial_state', [['value','Object']] ]
		,['got_request_impartial_state', [['secret_seed','int'], ['value','Object']] ]
		,['do_connected_set_score', [['score','int']] ]
		,['do_connected_match_over', [['did_win','boolean']] ]
		];
	}
