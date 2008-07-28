import come2play_as2.api.*;

/**
 * This graphics handles both the insecure ClientAPI
 * as well as the SecureClientAPI, therefore it inherits from 
 * 	CombinedClientAndSecureGameAPI.
 *  
 * See the game rules in TicTacToe_logic.
 * 
 * When a player wins, he gets some of the stakes, and the rest continue playing, 
 * until only a single player remains (and he doesn't get any stakes).
 * Each winner gets half of what the previous winner got,
 * so if we have 4 players:
 * 1st place gets: 4/7
 * 2nd place gets: 2/7
 * 3rd place gets: 1/7
 * and 4th place gets nothing!
 * Because the percentage are accumilative 
 * (the percentage are from the remainder of what is left in the pot),
 * we should rephrase the above as: 
 * 1st place gets: 4/7
 * 2nd place gets: 2/3 of the remainder (3/7 of the pot)
 * 3rd place gets: the remainder (1/7 of the pot)
 * 4th place gets nothing.
 * If you have 5 players:
 * 1st place gets: 8/15
 * 2nd place gets: 4/7 of the remainder (7/15 of the pot)
 * 3rd place gets: 2/3 of the remainder (3/15 of the pot)
 * 4th place gets: the remainder (1/15 of the pot)
 * 5th place gets nothing.
 * The formula for the I-th place (except last place) out of N players is:
 *  2^(N-I-1) / (2^(N-I) - 1)
 *  
 * Written by: Yoav Zibin (yoav@zibin.net)
 */
import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TicTacToe_graphic extends CombinedClientAndSecureGameAPI {
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	public var ROWS:Number;
	public var COLS:Number;
	public var WIN_LENGTH:Number;
	public var PLAYERS_NUM_IN_SINGLE_PLAYER:Number;
	
	private var graphics:MovieClip;
	private var squares:Array/*TicTacToe_SquareGraphic[]*/;
	private var logic:TicTacToe_logic;
	private var all_player_ids:Array/*int*/;
	private var ongoing_colors:Array/*int*/;
	private var my_user_id:Number = -42;
	private var turnOfColor:Number; // a number between 0 and all_player_ids.length
	public static var VIEWER:Number = -1; 	
	private var myColor:Number; // either VIEWER, or a number between 0 and player_ids.length
	private var disconnected_num:Number;
	private var isSecureAPI:Boolean;
	
	public function TicTacToe_graphic(parameters:Object, isSecureAPI:Boolean,
			graphics:MovieClip, ROWS:Number, COLS:Number, 
			WIN_LENGTH:Number, PLAYERS_NUM_IN_SINGLE_PLAYER:Number) {
		super(parameters);
		this.isSecureAPI = isSecureAPI;
		this.graphics = graphics;
		this.ROWS = ROWS;
		this.COLS = COLS;
		this.WIN_LENGTH = WIN_LENGTH;
		this.PLAYERS_NUM_IN_SINGLE_PLAYER = PLAYERS_NUM_IN_SINGLE_PLAYER;
		
		squares = new Array(ROWS);
		for(var row:Number=0; row<ROWS; row++) {
			squares[row] = new Array(COLS);
			for(var col:Number=0; col<COLS; col++)
				squares[row][col] = new TicTacToe_SquareGraphic(this, AS3_vs_AS2.getMovieChild(graphics,"Square_"+row+"_"+col), row, col);				
		}		
		do_register_on_server();	 
	}
	
	private function assert(val:Boolean, args:Array):Void {
		if (!val) BaseGameAPI.throwError("Assertion failed with arguments: "+args.join(" , "));
	}
	public function myTrace(key:String, args:Array):Void {
		trace("MyTrace "+key+": "+args.join(" , "));
		do_store_trace(key, args);
	}
	private function shouldDoOperation():Boolean {
		return isJuror() ||
			(myColor!=VIEWER && (isSinglePlayer() || AS3_vs_AS2.IndexOf(ongoing_colors, myColor)!=-1));		
	}
	private function isJuror():Boolean {
		return my_user_id==-1;
	}
	private function getColor(player_id:Number):Number {
		return AS3_vs_AS2.IndexOf(all_player_ids, player_id);
	}
	
	// overriding functions	
	/*override*/ public function got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {
		if (!is_key_down) return;
		if (!(ROWS==3 && COLS==3)) return;
		var delta:Number = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:Number =  2-int(delta/3);
			var row:Number =  (delta%3);
			dispatchMoveIfLegal(row, col);
		}
	}
	/*override*/ public function got_my_user_id(my_user_id:Number):Void {
		this.my_user_id = my_user_id;
	}
	/*override*/ public function got_general_info(entries:Array/*Entry*/):Void {
		for (var i112:Number=0; i112<entries.length; i112++) { var entry:Entry = entries[i112]; 
			if (entry.key=="logo_swf_full_url") {
				var logo_swf_full_url:String = entry.value.toString();	
				trace("logo_swf_full_url="+logo_swf_full_url)
				for(var row:Number=0; row<ROWS; row++) 
					for(var col:Number=0; col<COLS; col++)
						(squares[row][col] /*as TicTacToe_SquareGraphic*/).got_logo(logo_swf_full_url);
			}		
		}
	}
	/*override*/ public function got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, match_state:Array/*UserEntry*/):Void {
		this.all_player_ids = all_player_ids;
		assert(all_player_ids.length<=4, ["The graphics of TicTacToe can handle at most 4 players. all_player_ids=", all_player_ids]);
		turnOfColor = 0;
		var index_of_my_user_id:Number = AS3_vs_AS2.IndexOf(all_player_ids,my_user_id);
		myColor = index_of_my_user_id==-1 ? VIEWER : 
				index_of_my_user_id;
		disconnected_num = 0;
		var players_num:Number = playersNumber();
		ongoing_colors = [];
		for (var color:Number=0; color<players_num; color++)
			ongoing_colors.push(color);
		logic = new TicTacToe_logic(ROWS,COLS,WIN_LENGTH, players_num);
		for (var i135:Number=0; i135<match_state.length; i135++) { var user_entry:UserEntry = match_state[i135]; 
			if (!isSinglePlayer()) turnOfColor = getColor(user_entry.user_id);	// some users may have disconnected in the middle of the game	
			doUserEntry(user_entry, true);	//we should not call do_agree_on_match_over when loading the match	
		}
		if (finished_player_ids.length>0)
			matchOverForPlayers(finished_player_ids);
		
		setOnPress(true);
	}
	/*override*/ public function got_match_over(finished_player_ids:Array/*int*/):Void {
		if (matchOverForPlayers(finished_player_ids))
			setOnPress(true); // need to call it only if the current color was changed
		// if there is one player left (due to other users that disconnected),
		// then I don't end the game because the container will give the user an option
		// to either: win, cancel, or save the game.
	}	
	/*override*/ public function got_secure_stored_match_state(secret_level:Number, user_entry:UserEntry):Void {
		assert(secret_level==SecretLevels.PUBLIC, ["All communication in TicTacToe is PUBLIC, secret_level=",secret_level]);
		got_stored_match_state(user_entry);
	}
	/*override*/ public function got_stored_match_state(user_entry:UserEntry):Void {		
		// the moves are done in alternating turns: color 0, then color 1 (in a round robin)
		var user_id:Number = user_entry.user_id;
		if (user_id==my_user_id) return; // The player ignores his own got_stored_match_state, because he already updated the logic before he sent it to the server
		var color_of_user:Number = getColor(user_id);
		if (color_of_user==-1) return;  // viewers can store match state, so we just ignore whatever a viewer placed in the match state
		if (AS3_vs_AS2.IndexOf(ongoing_colors, color_of_user)==-1) return; // player already disconnected
		// In SinglePlayer: the player already called return before, but a viewer (there can be viewers even for singleplayer games!) still needs to call doUserEntry 
		if (!isSinglePlayer()) 
			assert(turnOfColor==color_of_user, ["Got an entry from player=",user_id," of color=",color_of_user," but expecting one from color=", turnOfColor]);			
		doUserEntry(user_entry, false);
	}
	
	private function matchOverForPlayers(finished_player_ids:Array/*int*/):Boolean {
		if (logic==null) return false; // match already ended
		var colors:Array/*int*/ = [];
		for (var i171:Number=0; i171<finished_player_ids.length; i171++) { var p_id:Number = finished_player_ids[i171]; 
			var color_of_p_id:Number = getColor(p_id);
			assert(color_of_p_id!=-1, ["Didn't find player_id=",p_id]); 
			colors.push(color_of_p_id);
		}
		disconnected_num += colors.length;
		return matchOverForColors(colors);
	}
	private function matchOverForColors(colors:Array/*int*/):Boolean {	
		var shouldChange_turnOfColor:Boolean = false;
		for (var i181:Number=0; i181<colors.length; i181++) { var color:Number = colors[i181]; 
			var ongoing_index:Number = AS3_vs_AS2.IndexOf(ongoing_colors, color);
			if (ongoing_index==-1) continue; // already finished (when the game ends normally, I immediately call matchOverForColors. see makeMove) 
			ongoing_colors.splice(ongoing_index, 1);
			if (color==turnOfColor) {
				shouldChange_turnOfColor = true;
			}
			myTrace("matchOverForColor",[color, " shouldChange_turnOfColor=",shouldChange_turnOfColor]);	
		}
		if (ongoing_colors.length==0) {
			setOnPress(false); // turns off the squares
			logic = null;
		} else if (shouldChange_turnOfColor) {
			update_turnOfColor();
		}		
		return shouldChange_turnOfColor;
	}
	private function doUserEntry(user_entry:UserEntry, isSavedGame:Boolean):Void {
		var data:Array = AS3_vs_AS2.asArray(user_entry.value);
		makeMove(data[0], data[1], isSavedGame);		
	}
	// makeMove updates the logic and the graphics
	private function playersNumber():Number {
		return isSinglePlayer() ? PLAYERS_NUM_IN_SINGLE_PLAYER : all_player_ids.length;
	}
	private function isSinglePlayer():Boolean {
		return all_player_ids.length==1;
	}
	private function getNextTurnOfColor():Number {
		var next_turn_of_color:Number = turnOfColor;
		while (true) {	
			next_turn_of_color++;
			if (next_turn_of_color==playersNumber()) next_turn_of_color = 0;
			if (AS3_vs_AS2.IndexOf(ongoing_colors, next_turn_of_color)!=-1) break;
		}	
		return next_turn_of_color;
	}
	private function update_turnOfColor():Void {	
		turnOfColor = getNextTurnOfColor();
	}
	private static function arrayCopy(arr:Array):Array {
		var res:Array = [];
		for (var i223:Number=0; i223<arr.length; i223++) { var x:Object = arr[i223]; 
			res.push(x);
		}
		return res;			
	}
	private function makeMove(row:Number, col:Number, isSavedGame:Boolean):Void {
		logic.makeMove(turnOfColor, row, col);
		// update the graphics
		var square:TicTacToe_SquareGraphic = squares[row][col];
		square.setColor(turnOfColor);	
		
		var didWin:Boolean = logic.isWinner(row, col);
		var isBoardFull:Boolean = logic.isBoardFull();
		if (!didWin && !isBoardFull) {
			update_turnOfColor();		
		} else {
			//game is over for one player (but the other players, if there are more than 2 remaining players, will continue playing)
			var finished_players:Array/*PlayerMatchOver*/ = [];
			var isGameOver:Boolean = 
				isBoardFull || ongoing_colors.length==2;
			if (isSinglePlayer()) {
				if (isGameOver) 
					finished_players.push(
						new PlayerMatchOver(all_player_ids[0], 0, -1) );				
			} else {
				var score:Number;
				var percentage:Number;
				if (didWin) {
					//2^(N-I) / (2^(N-I-1) - 1)
					//winner is turnOfColor
					score = ongoing_colors.length-disconnected_num;					
					if (isBoardFull) {
						percentage = 100; // there won't be any other winners
					} else {
						// 1<<5 = 32
						var frac_top:Number = 1 << (2*(playersNumber() - disconnected_num) - ongoing_colors.length - 2);
						var frac_bottom:Number = frac_top*2 - 1;
						percentage = 100*Number(frac_top)/Number(frac_bottom);
					}
					finished_players.push(
						new PlayerMatchOver(all_player_ids[turnOfColor], score, percentage) );	
					
					if (ongoing_colors.length==2) {
						// last player gets nothing
						var last_color_id:Number = ongoing_colors[0]==turnOfColor ? ongoing_colors[1] : ongoing_colors[0];
						var last_player_id:Number = all_player_ids[last_color_id];
						score = -1;
						percentage = 0;
						finished_players.push(
							new PlayerMatchOver(last_player_id, score, percentage) );
					}
				}		
				if (isBoardFull) { // Important: it can happen that someone won and the board has just filled up!					
					for (var i276:Number=0; i276<ongoing_colors.length; i276++) { var ongoing_color:Number = ongoing_colors[i276]; 
						var ongoing_player_id:Number = all_player_ids[ongoing_color];
						if (!PlayerMatchOver.isInArr(finished_players, ongoing_player_id)) {
							if (didWin) {
								// someone just won, and now the board is full. the other players get nothing!
								score = -1;
								percentage = 0;
							} else {
								// the board became full. With two players it means the game was tied/drawed.
								// so the remaining players split the pot between themselves.
								score = 0;
								// We can either say the percentage is:
								//  100/ongoing_colors.length  - divide the remainder evenly
								//  or 
								// 	-1  - return back the stakes (minus what was given to previous winners; the server will divide the left overs evenly among the remaining players.) 
								percentage = -1; 
							}
							finished_players.push(
								new PlayerMatchOver(ongoing_player_id, score, percentage) );
						}
					}
				}	
			}
			
			var finished_colors:Array/*int*/ = 
				isGameOver ? arrayCopy(ongoing_colors) : [turnOfColor];
			if (!isSavedGame && finished_players.length>0 && shouldDoOperation()) { 
				if (!isSecureAPI)
					do_agree_on_match_over(finished_players);
				else {
					if (isJuror()) do_juror_end_match(finished_players);
				}
			}
			matchOverForColors(finished_colors);	
		}		
		
		if (!isSavedGame) setOnPress(true);
	}
	
	public function dispatchMoveIfLegal(row:Number, col:Number):Void {		
		myTrace("dispatchMoveIfLegal", ["row=",row," col=",col]);
		if (logic==null) return; // game not in progress
		if (myColor==VIEWER) return; // viewer cannot make a move
		if (!isSinglePlayer() && myColor!=turnOfColor) return; // not my turn
		if (!logic.isSquareAvailable(row, col)) return; // already filled this square (e.g., if you press on the keyboard, you may choose a cell that is already full)
		// The order of events should be: 
		//  do_end_my_turn, do_store_match_state, 
		//	and then maybe do_agree_on_match_over or do_juror_end_match
		// 	and finally if the game is not over, 
		//		we'll call either do_start_my_turn or do_juror_set_turn
		if (!isSecureAPI && !isSinglePlayer())
			do_end_my_turn( [all_player_ids[getNextTurnOfColor()]] );
		if (shouldDoOperation())
			do_store_match_state( new Entry(""+logic.getMoveNumber(), [row, col]) );		
		makeMove(row, col, false);
	}
	private function setOnPress(isInProgress:Boolean):Void {
		//trace("setOnPress with isInProgress="+isInProgress);
		if (logic==null) return; 		
		if (isInProgress && !isSinglePlayer() && shouldDoOperation()) {
			if (!isSecureAPI) {
				if (myColor==turnOfColor) do_start_my_turn();
			} else {
				if (isJuror()) do_juror_set_turn(all_player_ids[turnOfColor]);
			}
		}		
		for(var row:Number=0; row<ROWS; row++)
			for(var col:Number=0; col<COLS; col++) {
				if (logic.isSquareAvailable(row, col)) {
					var square:TicTacToe_SquareGraphic = squares[row][col];
					square.setOnPress(
						!isInProgress ? TicTacToe_SquareGraphic.BTN_NONE : // the match was over
						myColor==VIEWER ? TicTacToe_SquareGraphic.BTN_NONE : // a viewer never has the turn
						isSinglePlayer() ? turnOfColor : // single player always has the turn
						myColor==turnOfColor ?  
							turnOfColor : // I have the turn
							TicTacToe_SquareGraphic.BTN_NONE); // not my turn		
				}							
			}
	}
}
