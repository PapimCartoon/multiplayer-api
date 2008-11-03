import come2play_as2.api.auto_copied.*;

import come2play_as2.api.*;
class come2play_as2.api.CreateGrid
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
	public var ROWS:Number;
	public var COLS:Number;
	public var squareScaleX:Number;
	public var squareScaleY:Number;
	public var squareStartX:Number;
	public var squareStartY:Number;
	public var squareDeltaX:Number;
	public var squareDeltaY:Number;
		
	public function CreateGrid(defaultRows:Number, defaultCols:Number, 
			defaultSize:Number, 
			defaultScale:Number, defaultStartPos:Number) {
		ROWS = AS3_vs_AS2.as_int(T.custom("ROWS",defaultRows)); 
		COLS = AS3_vs_AS2.as_int(T.custom("COLS",defaultCols));
		squareScaleX = AS3_vs_AS2.as_int(T.custom("squareScaleX",defaultScale)); 
		squareScaleY = AS3_vs_AS2.as_int(T.custom("squareScaleY",defaultScale)); 
		squareDeltaX = AS3_vs_AS2.as_int(T.custom("squareDeltaX",defaultSize)); 
		squareDeltaY = AS3_vs_AS2.as_int(T.custom("squareDeltaY",defaultSize)); 
		squareStartX = AS3_vs_AS2.as_int(T.custom("squareStartX",defaultStartPos)); 
		squareStartY = AS3_vs_AS2.as_int(T.custom("squareStartY",defaultStartPos));
	}
	public function createMovieClips(graphics:MovieClip, squareLinkageName:String):Void {
		for (var row:Number=0; row<ROWS; row++)
			for (var col:Number=0; col<COLS; col++) {
				var dup:MovieClip = AS3_vs_AS2.createMovieInstance(graphics, squareLinkageName, "Square_"+row+"_"+col);
				placeInGrid(dup, row, col);	
			}
	}
	public function placeInGrid(dup:MovieClip, row:Number, col:Number):Void {
		AS3_vs_AS2.setMovieXY(dup, squareStartX + squareDeltaX*row, squareStartY + squareDeltaY*col);
		AS3_vs_AS2.scaleMovie(dup, squareScaleX, squareScaleY);		
	}
	public function width():Number {
		return 2*squareStartX + squareDeltaX*ROWS;
	}
	public function height():Number {
		return 2*squareStartY + squareDeltaY*COLS;
	}
}
