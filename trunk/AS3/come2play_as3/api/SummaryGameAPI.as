package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class SummaryGameAPI  {
		public static var SUMMARY_API:Array = [
		['got_keyboard_event', [['is_key_down','boolean'], ['charCode','int'], ['keyCode','int'], ['keyLocation','int'], ['altKey','boolean'], ['ctrlKey','boolean'], ['shiftKey','boolean']] ]
		,['got_general_info', [['keys','String[]'], ['values','Object[]']] ]
		,['got_user_info', [['user_id','int'], ['keys','String[]'], ['values','Object[]']] ]
		,['got_user_disconnected', [['user_id','int']] ]
		,['got_my_user_id', [['my_user_id','int']] ]
		,['got_match_started', [['all_player_ids','int[]'], ['finished_player_ids','int[]'], ['extra_match_info','Object'], ['match_started_time','int'], ['user_ids','int[]'], ['keys','String[]'], ['values','Object[]'], ['secret_levels','int[]']] ]
		,['do_agree_on_match_over', [['finished_player_ids','int[]'], ['scores','int[]'], ['pot_percentages','int[]']] ]
		,['got_match_over', [['finished_player_ids','int[]']] ]
		,['do_start_my_turn', [] ]
		,['got_start_turn_of', [['user_id','int']] ]
		,['do_end_my_turn', [['next_turn_of_player_ids','int[]']] ]
		,['got_end_turn_of', [['user_id','int']] ]
		,['do_store_match_state', [['keys','String[]'], ['values','Object[]'], ['secret_levels','int[]']] ]
		,['got_stored_match_state', [['user_id','int'], ['keys','String[]'], ['values','Object[]'], ['secret_levels','int[]']] ]
		,['do_send_message', [['to_user_ids','int[]'], ['value','Object']] ]
		,['got_message', [['user_id','int'], ['value','Object']] ]
		,['do_client_protocol_error_with_description', [['error_description','String']] ]
		,['do_connected_set_score', [['score','int']] ]
		,['do_connected_match_over', [['did_win','boolean']] ]
		,['do_juror_unfold_match_state', [['key','String'], ['to_user_id','int']] ]
		,['do_juror_shuffle_match_state', [['keys','String[]']] ]
		,['do_juror_set_turn', [['turn_of_player_id','int']] ]
		,['do_juror_end_match', [['finished_player_ids','int[]'], ['scores','int[]'], ['pot_percentages','int[]']] ]
		];
	}
}
