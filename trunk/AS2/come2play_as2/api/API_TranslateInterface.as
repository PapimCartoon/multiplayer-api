//Do not change the code below because this class was generated automatically!

import come2play_as2.api.*;
	class come2play_as2.api.API_TranslateInterface  {
		public function translate_got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_got_general_info(keys:Array/*String*/, values:Array/*Serializable*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_got_user_info(user_id:Number, keys:Array/*String*/, values:Array/*Serializable*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_do_agree_on_match_over(finished_players:Array/*PlayerMatchOver*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_do_store_match_state(entries:Array/*Entry*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_got_stored_match_state(user_id:Number, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
		public function translate_do_juror_end_match(finished_players:Array/*PlayerMatchOver*/):Array { throw new Error('You forgot to implement an interface method!'); return null; }
	}
