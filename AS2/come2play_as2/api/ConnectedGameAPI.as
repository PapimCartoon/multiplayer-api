//Do not change the code below because this class was generated automatically!

import come2play_as2.api.*;
	class come2play_as2.api.ConnectedGameAPI extends BaseGameAPI {
		public function ConnectedGameAPI(parameters:Object) {
			super(parameters);
		}
		public function got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function got_general_info(entries:Array/*Entry*/):Void {}
		public function got_user_info(user_id:Number, entries:Array/*Entry*/):Void {}
		public function got_my_user_id(my_user_id:Number):Void {}
		public function got_match_started(player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, match_state:Array/*UserEntry*/):Void {}
		
		public function do_store_match_state(entry:Entry):Void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_entry:UserEntry):Void {}
		
		public function do_connected_set_score(score:Number):Void { sendDoOperation('do_connected_set_score', arguments); }
		public function do_connected_match_over(did_win:Boolean):Void { sendDoOperation('do_connected_match_over', arguments); }
		public function got_match_over(player_ids:Array/*int*/):Void {}
		
		
		
	}
