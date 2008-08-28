import come2play_as2.api.auto_copied.*;

import come2play_as2.api.*;
class come2play_as2.api.CreateGrid
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
	public var ROWS:Number;
	public var COLS:Number;
	public var SQUARE_scaleX:Number;
	public var SQUARE_scaleY:Number;
	public var SQUARE_startX:Number;
	public var SQUARE_startY:Number;
	public var SQUARE_deltaX:Number;
	public var SQUARE_deltaY:Number;
	public var Square_Example:MovieClip;
	public function CreateGrid(graphics:MovieClip, squareLinkageName:String, 
		defaultRows:Number, defaultCols:Number, defaultSize:Number, defaultStartPos:Number) {
		
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
		var defaultSize:Number = defaultSize;
		if (SQUARE_scaleX==0) SQUARE_scaleX = defaultSize; 
		if (SQUARE_scaleY==0) SQUARE_scaleY = defaultSize; 
		if (SQUARE_deltaX==0) SQUARE_deltaX = defaultSize; 
		if (SQUARE_deltaY==0) SQUARE_deltaY = defaultSize; 
		if (SQUARE_startX==0) SQUARE_startX = defaultStartPos; 
		if (SQUARE_startY==0) SQUARE_startY = defaultStartPos; 
		
		for (var row:Number=0; row<ROWS; row++)
			for (var col:Number=0; col<COLS; col++) {
				var dup:MovieClip = AS3_vs_AS2.duplicateMovie(graphics, squareLinkageName, "Square_"+row+"_"+col);
				placeInGrid(dup, row, col);	
			}			
	}
	public function placeInGrid(dup:MovieClip, row:Number, col:Number):Void {
		AS3_vs_AS2.setMovieXY(dup, SQUARE_startX + SQUARE_deltaX*row, SQUARE_startY + SQUARE_deltaY*col);
		AS3_vs_AS2.scaleMovie(dup, SQUARE_scaleX, SQUARE_scaleY);		
	}

}
