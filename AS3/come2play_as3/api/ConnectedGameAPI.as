//Do not change the code below because this class is automatically generated!

package come2play_as3.api {
	public  class ConnectedGameAPI extends BaseGameAPI {
		public function ConnectedGameAPI(parameters:Object) {
			super(parameters);
		}
		public function got_general_info(entries:Array/*Entry*/):void {}
		public function got_user_info(user_id:int, entries:Array/*Entry*/):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/):void {}
		
		public function do_store_match_state(entry:Entry):void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_entry:UserEntry):void {}
		
		public function do_connected_set_score(score:int):void { sendDoOperation('do_connected_set_score', arguments); }
		public function do_connected_match_over(did_win:Boolean):void { sendDoOperation('do_connected_match_over', arguments); }
		public function got_match_over(player_ids:Array/*int*/):void {}
		
		
		
	}
}
