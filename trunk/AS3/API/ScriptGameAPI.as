//Do not change the code below because this class is automatically generated!

package  {
	public  class ScriptGameAPI extends BaseGameAPI {
		public function ScriptGameAPI(parameters:Object) {
			super(parameters);
		}
		public function got_general_info(keys:Array/*String[]*/, values:Array/*Serializable[]*/):void {}
		public function got_user_info(user_id:int, keys:Array/*String[]*/, values:Array/*Serializable[]*/):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(player_ids:Array/*int[]*/, extra_match_info:Object/*Serializable*/, match_started_time:int):void {}
		public function got_match_over(player_ids:Array/*int[]*/):void {}
		public function got_start_turn_of(user_id:int):void {}
		public function got_end_turn_of(user_id:int):void {}
		
		public function do_store_match_state(key:String, value:Object/*Serializable*/):void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_ids:Array/*int[]*/, keys:Array/*String[]*/, values:Array/*Serializable[]*/):void {}
		
		public function do_send_message(to_user_ids:Array/*int[]*/, value:Object/*Serializable*/):void { sendDoOperation('do_send_message', arguments); }
		public function got_message(user_id:int, value:Object/*Serializable*/):void {}
		
		public function do_set_timer(key:String, in_seconds:int, pass_back:Object/*Serializable*/):void { sendDoOperation('do_set_timer', arguments); }
		public function got_timer(from_user_id:int, key:String, in_seconds:int, pass_back:Object/*Serializable*/):void {}
		
		public function do_send_to_script(message:String):void { sendDoOperation('do_send_to_script', arguments); }
		public function got_from_script(type:String, from_player_id:int, message:String):void {}
		public function got_error_in_script_output(timed_out_url:Array/*String[]*/, url:String, url_output:String, url_output_headers:String, error_message:String):void {}
		
		
		
		
	}
}
