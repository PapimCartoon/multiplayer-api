package come2play_as3.tictactoe
{
	import come2play_as3.api.auto_copied.*;
	
	public final class TictactoeSquare extends SerializableClass
	{
		public var row:int, col:int;
		public static function create(row:int, col:int):TictactoeSquare {			
			var res:TictactoeSquare = new TictactoeSquare();
		    res.row = row;
		    res.col = col;
		    return res;
		}
		public function areEqual(s:TictactoeSquare):Boolean {
			return row==s.row && col==s.col;
		}
		public function getParametersAsString():String { return 'row=' + row+', col=' + col; }
		public function toString():String { return '{TictactoeSquare: ' + getParametersAsString() + '}'; }
	}
}