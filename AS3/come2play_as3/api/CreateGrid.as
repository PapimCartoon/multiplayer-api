package come2play_as3.api
{
import come2play_as3.api.auto_copied.*;

import flash.display.*;
public final class CreateGrid
{
	/**
	 * graphics should have a movieclip called 
	 * "Square_Example"
	 * This movieclip will be duplicated into a grid of movieclips:
	 * Square_<ROW>_<COL>
	 * For example,
	 * Square_0_0 , Square_0_1 , Square_0_2 , ...
	 * Square_1_0 , Square_1_1 , Square_1_2 , ...
	 * ...
	 * The grid size is determined by url parameters:
	 * ROWS and COLS
	 * The movieclips are scaled by:
	 * SQUARE_scaleX and SQUARE_scaleY
	 * (for example, if they are 50, the the size is reduced by half.)
	 * The distance between the squares are:
	 * SQUARE_deltaX and SQUARE_deltaY
	 */
	public var ROWS:int;
	public var COLS:int;
	public var SQUARE_scaleX:int;
	public var SQUARE_scaleY:int;
	public var SQUARE_startX:int;
	public var SQUARE_startY:int;
	public var SQUARE_deltaX:int;
	public var SQUARE_deltaY:int;
	public var Square_Example:MovieClip;
	public function CreateGrid(graphics:MovieClip, squareLinkageName:String, 
		defaultRows:int, defaultCols:int, defaultSize:int, defaultScale:int, defaultStartPos:int) {
		
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(graphics);
		trace("CreateGrid: url parameters are="+JSON.stringify(parameters));
		ROWS = AS3_vs_AS2.convertToInt(parameters["ROWS"]);
		COLS = AS3_vs_AS2.convertToInt(parameters["COLS"]);
		SQUARE_scaleX = AS3_vs_AS2.convertToInt(parameters["SQUARE_scaleX"]);
		SQUARE_scaleY = AS3_vs_AS2.convertToInt(parameters["SQUARE_scaleY"]);
		SQUARE_startX = AS3_vs_AS2.convertToInt(parameters["SQUARE_startX"]);
		SQUARE_startY = AS3_vs_AS2.convertToInt(parameters["SQUARE_startY"]);
		SQUARE_deltaX = AS3_vs_AS2.convertToInt(parameters["SQUARE_deltaX"]);
		SQUARE_deltaY = AS3_vs_AS2.convertToInt(parameters["SQUARE_deltaY"]);
		
		// default values
		if (ROWS==0) ROWS = defaultRows; 
		if (COLS==0) COLS = defaultCols;
		var defaultSize:int = defaultSize;
		if (SQUARE_scaleX==0) SQUARE_scaleX = defaultScale; 
		if (SQUARE_scaleY==0) SQUARE_scaleY = defaultScale; 
		if (SQUARE_deltaX==0) SQUARE_deltaX = defaultSize; 
		if (SQUARE_deltaY==0) SQUARE_deltaY = defaultSize; 
		if (SQUARE_startX==0) SQUARE_startX = defaultStartPos; 
		if (SQUARE_startY==0) SQUARE_startY = defaultStartPos; 
		
		for (var row:int=0; row<ROWS; row++)
			for (var col:int=0; col<COLS; col++) {
				var dup:MovieClip = AS3_vs_AS2.createMovieInstance(graphics, squareLinkageName, "Square_"+row+"_"+col);
				placeInGrid(dup, row, col);	
			}			
	}
	public function placeInGrid(dup:MovieClip, row:int, col:int):void {
		AS3_vs_AS2.setMovieXY(dup, SQUARE_startX + SQUARE_deltaX*row, SQUARE_startY + SQUARE_deltaY*col);
		AS3_vs_AS2.scaleMovie(dup, SQUARE_scaleX, SQUARE_scaleY);		
	}
	public function width():int {
		return 2*SQUARE_startX + SQUARE_deltaX*ROWS;
	}
	public function height():int {
		return 2*SQUARE_startY + SQUARE_deltaY*COLS;
	}
}
}