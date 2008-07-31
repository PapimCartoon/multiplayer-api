package come2play_as3.tictactoe
{
import come2play_as3.api.*;
import come2play_as3.util.JSON;

import flash.display.*;
	
public final class TicTacToe_Main
{
	public function TicTacToe_Main(graphics:MovieClip)
	{
		graphics.stop();
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(graphics);
		trace("TicTacToe parameters="+JSON.stringify(parameters));
		var ROWS:int = AS3_vs_AS2.convertToInt(parameters["ROWS"]);
		var COLS:int = AS3_vs_AS2.convertToInt(parameters["COLS"]);
		var SQUARE_scaleX:int = AS3_vs_AS2.convertToInt(parameters["SQUARE_scaleX"]);
		var SQUARE_scaleY:int = AS3_vs_AS2.convertToInt(parameters["SQUARE_scaleY"]);
		var SQUARE_deltaX:int = AS3_vs_AS2.convertToInt(parameters["SQUARE_deltaX"]);
		var SQUARE_deltaY:int = AS3_vs_AS2.convertToInt(parameters["SQUARE_deltaY"]);
		
		// default values
		if (ROWS==0) ROWS = 3; 
		if (COLS==0) COLS = 3;
		var defaultSize:int = 100;
		if (SQUARE_scaleX==0) SQUARE_scaleX = defaultSize; 
		if (SQUARE_scaleY==0) SQUARE_scaleY = defaultSize; 
		if (SQUARE_deltaX==0) SQUARE_deltaX = defaultSize; 
		if (SQUARE_deltaY==0) SQUARE_deltaY = defaultSize; 
		 
		// Duplicating Square_Example, and creating a grid of squares of size ROWS x COLS
		var square:MovieClip = AS3_vs_AS2.getMovieChild(graphics,"Square_Example");
		AS3_vs_AS2.setVisible(square,false);		
		
		for (var row:int=0; row<ROWS; row++)
			for (var col:int=0; col<COLS; col++) {
				var dup:MovieClip = AS3_vs_AS2.duplicateMovie(square,"Square_"+row+"_"+col);
				AS3_vs_AS2.setMovieXY(square, dup, SQUARE_deltaX*row, SQUARE_deltaY*col);
				AS3_vs_AS2.scaleMovie(dup, SQUARE_scaleX, SQUARE_scaleY);			
			}
		
		if (parameters["apiType"]==null) {
			// creating a server for the single player			
			var sPrefix:String = BaseGameAPI.DEFAULT_LOCALCONNECTION_HANDSHAKE_PREFIX;
			parameters["prefix"] = sPrefix;
			var general_info_entries:Array/*Entry*/ =
				[ new Entry("logo_swf_full_url","example_logo.jpg") ];
			var	user_id:int = 24; 
			var user_info_entries:Array/*Entry*/ =
				[ 	new Entry("name", "Yoav Zibin"),
					new Entry("avatar_url", "Avatar_1.gif")
				];
			var extra_match_info:Object/*Serializable*/ = "";
			var match_started_time:int = 999; 
			var match_state:Array/*UserEntry*/ = []; // empty game (not loading a game)
			if (false) {
				// loading a saved game
				match_state = 
					[ 
						new UserEntry("1",[0,0],user_id),
						new UserEntry("2",[1,1],user_id), 
						new UserEntry("3",[1,0],user_id)
					];			
			}
			new SinglePlayerEmulator(graphics,
				sPrefix,
				general_info_entries,
				user_id, 
				user_info_entries,
				extra_match_info, 
				match_started_time,
				match_state);
		}
		new TicTacToe_graphic(graphics, ROWS, COLS);
	}

}
}