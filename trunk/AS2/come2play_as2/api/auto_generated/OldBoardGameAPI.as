//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.OldBoardGameAPI extends BaseGameAPI {
		public function OldBoardGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function doRegisterOnServer():Void { sendMessage( new API_DoRegisterOnServer() ); }
		public function doTrace(name:String, message:Object/*Serializable*/):Void { sendMessage( new API_DoTrace(name, message) ); }
		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, serverEntries:Array/*ServerEntry*/):Void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {}
		
		public function do_graphic_command_without_enum(movie_id:Number, func_name:String, func_args:Array/*Object*/):Void { sendMessage( new API_Do_graphic_command_without_enum(movie_id, func_name, func_args) ); }
		public function got_graphic_command(new_movie_parents:Array/*int*/, new_movie_name_ids:Array/*int*/, graphic_commands:Array/*Object*/):Void {}
		public function got_save_graphic_command(arr:Array/*int*/, pos:Number):Void {}
		public function got_old_move_turn_of(is_white:Boolean):Void {}
		public function got_match_over_waiting_others(white_score:Number, black_score:Number):Void {}
		public function got_no_available_moves(is_white:Boolean):Void {}
		public function got_score(white_score:Number, black_score:Number):Void {}
		public function got_move_number(current_move_num:Number, total_moves_num:Number):Void {}
		public function got_can_cancel_move(is_enabled:Boolean):Void {}
		public function do_cancel():Void { sendMessage( new API_Do_cancel() ); }
		public function got_can_roll_dice(is_enabled:Boolean):Void {}
		public function do_roll_dice():Void { sendMessage( new API_Do_roll_dice() ); }
		public function do_automatic_roll(is_automatic:Boolean):Void { sendMessage( new API_Do_automatic_roll(is_automatic) ); }
		public function do_chess_3D_or_2D(is_3D:Boolean):Void { sendMessage( new API_Do_chess_3D_or_2D(is_3D) ); }
		public function do_make_move_animations(with_animation:Boolean):Void { sendMessage( new API_Do_make_move_animations(with_animation) ); }
		public function do_make_dice_animations(with_animation:Boolean):Void { sendMessage( new API_Do_make_dice_animations(with_animation) ); }
		public function do_make_animations_on_forward(with_animation:Boolean):Void { sendMessage( new API_Do_make_animations_on_forward(with_animation) ); }
		
		
		
		
		
		
	}
