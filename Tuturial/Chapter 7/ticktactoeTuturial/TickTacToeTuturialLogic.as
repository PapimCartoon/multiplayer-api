﻿package ticktactoeTuturial
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class TickTacToeTuturialLogic extends EventDispatcher
	{
		private var gameGraphic:TickTacToeTuturialGraphic
		private var gameBoard:Array;
		private var playerTurn:int; // who's player turn it is
		private var playerAmount:int;// how many players are playing the game
		private var closedSquares:int;// how many squres were captured
		private var xMod:int;//the game's x position on the stage
		private var yMod:int;//the game's y position on the stage
		private var myTurn:Boolean;//is player's turn
		private var logoUrl:String;//url of logo
		private var gameWidth:int;//the game's width
		private var gameHeight:int;//the game's height
		/**
		*The game's constructor
		*
		*@param graphic A pointer to a graphical object on which the game will be displayed
		*/
		public function TickTacToeTuturialLogic(graphic:MovieClip)
		{
			gameGraphic=new TickTacToeTuturialGraphic();
			graphic.addChild(gameGraphic);
			gameGraphic.addEventListener(MouseEvent.CLICK,clickSquare);
		}
		/**
		*Translates a click on the graphics into a TickTacToeMove and send it to the main class
		*/
		private function clickSquare(ev:MouseEvent):void
		{
			if(!myTurn)
				return;
			var xPos:int = ((ev.stageX-xMod) / gameWidth)+1;
			var yPos:int = ((ev.stageY-yMod) / gameHeight)+1;
			trace(xPos+" / "+yPos)
			if((xPos > 3) || (xPos<1))
				return;
			if((yPos > 3) || (yPos<1))
				return;
			if(gameBoard[xPos][yPos] == 0)
				dispatchEvent(TickTacToeMove.create(playerTurn,xPos,yPos));
		}
		/**
		*Traces who won,and send the main class that a certin player has won
		*
		*@winingPlayer wining Player Id
		*/
		private function gameOver(winingPlayer:int):void
		{
			dispatchEvent(new GameOverEvent(winingPlayer));
			trace("player : "+winingPlayer+" Won" )
		}
		/**
		*Checks if the game is over,if so calls the gameOver function
		*/
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
		/**
		*Allows the player to make a move if its his turn
		*
		*@param nextPlayerTurn The Id of the player allowed to make a move
		*/
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
		/**
		*Commits a player turn to the board
		*
		*@param gameMove A TickTacToeMove class representing the next player move
		*/
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
		/**
		*Starts a new game
		*
		*@param playerAmount How many players will be playing the game
		*/
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
		/**
		*Set's the game board's logo
		*
		*@param LogoUrl logo to load
		*/
		public function set LogoUrl(LogoUrl:String):void{logoUrl = LogoUrl;}
		/**
		*Set's the game board's Width
		*
		*@param stageWidth the width of the stage
		*/
		public function set stageWidth(stageWidth:int):void{gameGraphic.gameWidth = gameWidth = (stageWidth/3);}
		/**
		*Set's the game board's height
		*
		*@param stageHeight the height of the stage
		*/
		public function set stageHeight(stageHeight:int):void{gameGraphic.gameHeight = gameHeight = (stageHeight/3);}
		/**
		*Set's the modefier for the x position
		*
		*@param gameX the game's x position on the stage
		*/
		public function set stageX(gameX:int):void
		{
			xMod = gameX;	
		}
		/**
		*Set's the modefier for the y position
		*
		*@param gameY the game's y position on the stage
		*/
		public function set stageY(gameY:int):void
		{
			yMod = gameY;
		}

	}
}