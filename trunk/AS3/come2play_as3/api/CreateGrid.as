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
	 * The grid parameters are determined by gotCustomInfo:
	 * The grid size is ROWS and COLS
	 * The movieclips are scaled by:
	 * SQUARE_scaleX and SQUARE_scaleY
	 * (for example, if they are 50, the the size is reduced by half.)
	 * The distance between the squares are:
	 * SQUARE_deltaX and SQUARE_deltaY
	 * And the initial position of the first square is: 
	 * SQUARE_startX and SQUARE_startY
	 */
	public static var GridPrefix:String = "Grid_";
	public var ROWS:int;
	public var COLS:int;
	public var SQUARE_scaleX:int;
	public var SQUARE_scaleY:int;
	public var SQUARE_startX:int;
	public var SQUARE_startY:int;
	public var SQUARE_deltaX:int;
	public var SQUARE_deltaY:int;
	
	public var Square_Example:MovieClip;
	
	public function gotCustomInfo(key:String, value:*):void {
		if (StaticFunctions.startsWith(key,GridPrefix)) {
			this[ key.substr(GridPrefix.length) ] = value;
		}		
	}
	public function CreateGrid( 
		defaultRows:int, defaultCols:int, defaultSize:int, 
		defaultScale:int, defaultStartPos:int) {
		
		ROWS = defaultRows; 
		COLS = defaultCols;
		SQUARE_scaleX = defaultScale; 
		SQUARE_scaleY = defaultScale; 
		SQUARE_deltaX = defaultSize; 
		SQUARE_deltaY = defaultSize; 
		SQUARE_startX = defaultStartPos; 
		SQUARE_startY = defaultStartPos; 
	}
	public function createMovieClips(graphics:MovieClip, squareLinkageName:String):void {
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