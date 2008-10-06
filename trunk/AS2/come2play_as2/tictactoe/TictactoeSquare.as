	import come2play_as2.api.auto_copied.*;
	
import come2play_as2.tictactoe.*;
	class come2play_as2.tictactoe.TictactoeSquare extends SerializableClass
	{
		public var row:Number, col:Number;
		public static function create(row:Number, col:Number):TictactoeSquare {			
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
