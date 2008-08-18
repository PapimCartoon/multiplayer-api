package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class OldBoardGameAPI extends BaseGameAPI {
		public function OldBoardGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function doRegisterOnServer():void { sendMessage( new API_DoRegisterOnServer() ); }
		public function doTrace(name:String, message:Object/*Serializable*/):void { sendMessage( new API_DoTrace(name, message) ); }
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:int, serverEntries:Array/*ServerEntry*/):void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {}
		
		public function do_graphic_command_without_enum(movie_id:int, func_name:String, func_args:Array/*Object*/):void { sendMessage( new API_Do_graphic_command_without_enum(movie_id, func_name, func_args) ); }
		public function got_graphic_command(new_movie_parents:Array/*int*/, new_movie_name_ids:Array/*int*/, graphic_commands:Array/*Object*/):void {}
		public function got_save_graphic_command(arr:Array/*int*/, pos:int):void {}
		public function got_old_move_turn_of(is_white:Boolean):void {}
		public function got_match_over_waiting_others(white_score:int, black_score:int):void {}
		public function got_no_available_moves(is_white:Boolean):void {}
		public function got_score(white_score:int, black_score:int):void {}
		public function got_move_number(current_move_num:int, total_moves_num:int):void {}
		public function got_can_cancel_move(is_enabled:Boolean):void {}
		public function do_cancel():void { sendMessage( new API_Do_cancel() ); }
		public function got_can_roll_dice(is_enabled:Boolean):void {}
		public function do_roll_dice():void { sendMessage( new API_Do_roll_dice() ); }
		public function do_automatic_roll(is_automatic:Boolean):void { sendMessage( new API_Do_automatic_roll(is_automatic) ); }
		public function do_chess_3D_or_2D(is_3D:Boolean):void { sendMessage( new API_Do_chess_3D_or_2D(is_3D) ); }
		public function do_make_move_animations(with_animation:Boolean):void { sendMessage( new API_Do_make_move_animations(with_animation) ); }
		public function do_make_dice_animations(with_animation:Boolean):void { sendMessage( new API_Do_make_dice_animations(with_animation) ); }
		public function do_make_animations_on_forward(with_animation:Boolean):void { sendMessage( new API_Do_make_animations_on_forward(with_animation) ); }
		
		
		
		
		
		
	}
}
