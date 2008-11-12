package ticktactoeTuturial
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class TickTacToeTuturialLogic extends EventDispatcher
	{
		private var gameGraphic:TickTacToeTuturialGraphic
		private var gameBoard:Array;
		private var playerTurn:int;
		private var playerAmount:int;
		private var closedSquares:int
		private var myTurn:Boolean;
		private var xMod:int;
		private var yMod:int;
		private var logoUrl:String;
		private var gameWidth:int;
		private var gameHeight:int;
		public function TickTacToeTuturialLogic(graphic:MovieClip)
		{
			gameGraphic=new TickTacToeTuturialGraphic();
			graphic.addChild(gameGraphic);
			gameGraphic.addEventListener(MouseEvent.CLICK,clickSquare);
		}
		private function clickSquare(ev:MouseEvent):void
		{
			if(!myTurn)
				return;
			var xPos:int = ((ev.stageX-xMod) / gameWidth)+1;
			var yPos:int = ((ev.stageY-yMod) / gameHeight)+1;
			if((xPos > 3) || (xPos<1))
				return;
			if((yPos > 3) || (yPos<1))
				return;
			if(gameBoard[xPos][yPos] == 0)
				dispatchEvent(TickTacToeMove.create(playerTurn,xPos,yPos));
		}
		private function gameOver(winingPlayer:int):void
		{
			dispatchEvent(new GameOverEvent(winingPlayer));
		}
		private function checkGameOver():void
		{
			for(var i:int = 1;i<=3;i++)
			{
				if((gameBoard[i][1] == gameBoard[i][2]) && (gameBoard[i][2] == gameBoard[i][3]) && (gameBoard[i][1]!=0))
				{
					gameOver(gameBoard[i][1])
					return;
				}	
				if((gameBoard[1][i] == gameBoard[2][i]) && (gameBoard[2][i] == gameBoard[3][i]) && (gameBoard[1][i]!=0))
				{
					gameOver(gameBoard[1][i])
					return;
				}	
			}
			if((gameBoard[1][1] == gameBoard[2][2]) && (gameBoard[2][2] == gameBoard[3][3]) && (gameBoard[2][2]!=0))
			{
					gameOver(gameBoard[2][2])
					return;
			}		
			if((gameBoard[3][1] == gameBoard[2][2]) && (gameBoard[2][2] == gameBoard[1][3]) && (gameBoard[2][2]!=0))
			{
					gameOver(gameBoard[2][2])
					return;
			}	
			
			if(closedSquares == 9)
				gameOver(0);
				
		}
		public function allowMoves(nextPlayerTurn:int):void
		{
			if(playerTurn == nextPlayerTurn)
			{
				myTurn = true;
			}
			else
			{
				myTurn = false;
			}
			dispatchEvent(new SetNextTurnEvent(playerTurn));
		}
		public function makeTurn(gameMove:TickTacToeMove):void
		{
			if(playerTurn == gameMove.playerTurn)
			{
				closedSquares++;
				playerTurn = playerTurn%playerAmount + 1;
				gameBoard[gameMove.xPos][gameMove.yPos] = gameMove.playerTurn;
				gameGraphic.makeTurn(gameMove);
				checkGameOver();
			}
		}
		public function startNewGame(playerAmount:int,userAvatars:Array/*String*/):void
		{
			this.playerAmount = playerAmount;
			playerTurn = 1;
			closedSquares = 0;
			gameBoard = new Array();
			for(var i:int = 1;i<=3;i++)
			{
				gameBoard[i] = new Array();
				for(var j:int = 1;j<=3;j++)
				{
					gameBoard[i][j] = 0;
				}
			}
			gameGraphic.createNewBoard(logoUrl,userAvatars);
		}

		public function set LogoUrl(LogoUrl:String):void{logoUrl = LogoUrl;}
		public function set stageWidth(stageWidth:int):void{gameGraphic.gameWidth = gameWidth = (stageWidth/3);}
		public function set stageHeight(stageHeight:int):void{gameGraphic.gameHeight = gameHeight = (stageHeight/3);}
		public function set stageX(gameX:int):void
		{
			xMod = gameX;	
		}
		public function set stageY(gameY:int):void
		{
			yMod = gameY;
		}

	}
}