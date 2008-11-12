package ticktactoeTuturial
{
	import flash.display.MovieClip;

	public class TickTacToeTuturialGraphic extends MovieClip
	{
		private var BoardMc:MovieClip;
		private var board:Array;
		public function TickTacToeTuturialGraphic()
		{
			
		}
		/**
		*Refreshes the board for a new game
		*
		*/
		private function refreshBoard():void
		{
			if(BoardMc !=null)
				if(contains(BoardMc))
					removeChild(BoardMc);
			BoardMc = new MovieClip();
		}
		/**
		*Commits a game move graphicly
		*
		*@param gameMove a TickTacToeMove class representing a player move
		*/
		public function makeTurn(gameMove:TickTacToeMove):void
		{
			var tempSquare:TickTacToeTuturialSquare = board[gameMove.xPos][gameMove.yPos];
			if(gameMove.playerTurn == 1)
				tempSquare.gotoAndStop("Tick");
			else if(gameMove.playerTurn == 2)
				tempSquare.gotoAndStop("Tac");
			else if(gameMove.playerTurn == 3)
				tempSquare.gotoAndStop("Toe");
		}
		/**
		*Creates a new board
		*
		*/
		public function createNewBoard():void
		{
			refreshBoard()
			board = new Array()
			var tempSquare:TickTacToeTuturialSquare;
			for(var i:int = 1;i<=3;i++)
			{
				board[i] = new Array();
				for(var j:int = 1;j<=3;j++)
				{
					tempSquare = new TickTacToeTuturialSquare();
					tempSquare.stop();
					tempSquare.x = (i-1)*100
					tempSquare.y = (j-1)*100
					board[i][j] = tempSquare	
					BoardMc.addChild(board[i][j]);
				}
			}
			addChild(BoardMc);
		}
		
	}
}