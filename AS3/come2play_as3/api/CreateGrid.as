package come2play_as3.api
{
import come2play_as3.api.auto_copied.*;

import flash.display.*;
public final class CreateGrid
{
	/**
	 * graphics should have a linkage name called <squareLinkageName>.
	 * A grid of movieclips will be instantiated and added as children to graphics. 
	 * The movieclips will be called:
	 * Square_<ROW>_<COL>
	 * For example,
	 * Square_0_0 , Square_0_1 , Square_0_2 , ...
	 * Square_1_0 , Square_1_1 , Square_1_2 , ...
	 * Square_2_0 , Square_2_1 , Square_2_2 , ...
	 * ...
	 * 
	 * The grid parameters are determined by gotCustomInfo:
	 * The grid size is ROWS times COLS
	 * The movieclips are scaled by:
	 * squareScaleX and squareScaleY
	 * (for example, if they are 50, then the size is reduced by half.)
	 * The distance between the squares is:
	 * squareDeltaX and squareDeltaY
	 * And the initial position of the first square is: 
	 * squareStartX and squareStartY
	 */
	public var ROWS:int;
	public var COLS:int;
	public var squareScaleX:int;
	public var squareScaleY:int;
	public var squareStartX:int;
	public var squareStartY:int;
	public var squareDeltaX:int;
	public var squareDeltaY:int;
		
	public function CreateGrid(defaultRows:int, defaultCols:int, 
			defaultSize:int, 
			defaultScale:int, defaultStartPos:int) {
		ROWS = AS3_vs_AS2.as_int(T.custom("ROWS",defaultRows)); 
		COLS = AS3_vs_AS2.as_int(T.custom("COLS",defaultCols));
		StaticFunctions.assert(ROWS>1 && ROWS<=10, ["Illegal ROWS=",ROWS]);
		StaticFunctions.assert(COLS>1 && COLS<=10, ["Illegal COLS=",COLS]);
		squareScaleX = AS3_vs_AS2.as_int(T.custom("squareScaleX",defaultScale)); 
		squareScaleY = AS3_vs_AS2.as_int(T.custom("squareScaleY",defaultScale)); 
		squareDeltaX = AS3_vs_AS2.as_int(T.custom("squareDeltaX",defaultSize)); 
		squareDeltaY = AS3_vs_AS2.as_int(T.custom("squareDeltaY",defaultSize)); 
		squareStartX = AS3_vs_AS2.as_int(T.custom("squareStartX",defaultStartPos)); 
		squareStartY = AS3_vs_AS2.as_int(T.custom("squareStartY",defaultStartPos));
	}
	public function createMovieClips(graphics:MovieClip, squareLinkageName:String):void {
		for (var row:int=0; row<ROWS; row++)
			for (var col:int=0; col<COLS; col++) {
				var dup:MovieClip = AS3_vs_AS2.createMovieInstance(graphics, squareLinkageName, "Square_"+row+"_"+col);
				placeInGrid(dup, row, col);	
			}
	}
	public function placeInGrid(dup:MovieClip, row:int, col:int):void {
		AS3_vs_AS2.setMovieXY(dup, squareStartX + squareDeltaX*row, squareStartY + squareDeltaY*col);
		AS3_vs_AS2.scaleMovie(dup, squareScaleX, squareScaleY);		
	}
	public function width():int {
		return 2*squareStartX + squareDeltaX*ROWS;
	}
	public function height():int {
		return 2*squareStartY + squareDeltaY*COLS;
	}
}
}