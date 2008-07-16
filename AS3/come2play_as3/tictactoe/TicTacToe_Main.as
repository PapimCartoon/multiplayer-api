package come2play_as3.tictactoe
{
import flash.display.MovieClip;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import come2play_as3.api.*;
	
public final class TicTacToe_Main
{
	public function TicTacToe_Main(graphics:MovieClip)
	{
		graphics.stop();
		var parameters:Object = graphics.root.loaderInfo.parameters;
		var apiType:String = parameters["apiType"]; // either ClientGameAPI, ScriptGameAPI, SecureClientGameAPI
		var ROWS:int = int(parameters["ROWS"]);
		var COLS:int = int(parameters["COLS"]);
		var WIN_LENGTH:int = int(parameters["WIN_LENGTH"]);
		var PLAYERS_NUM_IN_SINGLE_PLAYER:int = int(parameters["PLAYERS_NUM_IN_SINGLE_PLAYER"]);
		var SQUARE_scaleX:int = int(parameters["SQUARE_scaleX"]);
		var SQUARE_scaleY:int = int(parameters["SQUARE_scaleY"]);
		var SQUARE_deltaX:int = int(parameters["SQUARE_deltaX"]);
		var SQUARE_deltaY:int = int(parameters["SQUARE_deltaY"]);
		
		// default values
		if (ROWS==0) ROWS = 5; 
		if (COLS==0) COLS = 5; 
		if (WIN_LENGTH==0) WIN_LENGTH = 4; 
		if (PLAYERS_NUM_IN_SINGLE_PLAYER==0) PLAYERS_NUM_IN_SINGLE_PLAYER = 3;
		var defaultSize:int = 66;
		if (SQUARE_scaleX==0) SQUARE_scaleX = defaultSize; 
		if (SQUARE_scaleY==0) SQUARE_scaleY = defaultSize; 
		if (SQUARE_deltaX==0) SQUARE_deltaX = defaultSize; 
		if (SQUARE_deltaY==0) SQUARE_deltaY = defaultSize; 
		
		// Duplicating Square_Example, and creating a grid of squares of size ROWS x COLS
		var square:MovieClip = graphics.getChildByName("Square_Example") as MovieClip;
		square.visible = false;
		square.scaleX = SQUARE_scaleX/100;
		square.scaleY = SQUARE_scaleY/100;
		var width:int = square.width;
		var height:int = square.height;
		var x:int = square.x;
		var y:int = square.y;
		trace("Square's size "+width+"x"+height);
		var _Class:Class = getDefinitionByName(getQualifiedClassName(square)) as Class;
		
		for (var row:int=0; row<ROWS; row++)
			for (var col:int=0; col<COLS; col++) {
				var dup:MovieClip = new _Class();
				dup.scaleX = SQUARE_scaleX/100;
				dup.scaleY = SQUARE_scaleY/100;
				dup.name = "Square_"+row+"_"+col;
				dup.x = x+SQUARE_deltaX*row;
				dup.y = y+SQUARE_deltaY*col;
				graphics.addChild(dup); 				
			}
		
		// Creating the correct API
		var tictactoe:TicTacToe_graphic = new TicTacToe_graphic(graphics,ROWS,COLS, WIN_LENGTH, PLAYERS_NUM_IN_SINGLE_PLAYER);
		
		//ClientGameAPI, ScriptGameAPI, SecureClientGameAPI
		if (apiType=="ClientGameAPI") {
			new TicTacToe_ClientGameAPI(tictactoe, parameters);
		} else
			new TicTacToe_SinglePlayerTest(tictactoe);
	}

}
}