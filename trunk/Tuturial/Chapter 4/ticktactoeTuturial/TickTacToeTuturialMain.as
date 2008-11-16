﻿package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic; // An instance of the game's Logic class
		private var allPlayerIds:Array/*int*/; // An array containing all the user Ids
		private var myUserId:int;//the id of the current user
		private var isGameOver:Boolean;//is the game in progress
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			super(stageMovieClip);
			(new TickTacToeMove).register();// registers a serializable class
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.addEventListener(SetNextTurnEvent.SetNextTurnEvent,nextTurn);
			gameLogic.addEventListener(GameOverEvent.GameOverEvent,gameOver);
			doRegisterOnServer()//registers your game on the server
		}
		/**
		*Sets the next playe'r turn on the server
		*/
		private function nextTurn(ev:SetNextTurnEvent):void
		{
			doAllSetTurn(allPlayerIds[ev.nextPlayerId-1],-1);//Sets a player turn on the server
		}
		/**
		*Sets a palyer's turn
		*/
		private function setTurn():void
		{
			gameLogic.allowMoves(allPlayerIds.indexOf(myUserId) + 1);
		}
		/**
		*Gets a TickTacToeMove from the game's logic
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		private function gotUserMove(ev:TickTacToeMove):void
		{
			if(!isGameOver)
				doStoreState([UserEntry.create({xPos:ev.xPos,yPos:ev.yPos},ev)])
		}
		/**
		*Gets a GameOverEvent from the game's logic
		*
		*@param ev a GameOverEvent instance
		*/
		private function gameOver(ev:GameOverEvent):void
		{
			isGameOver = true;
			var finishedPlayers:Array = new Array();
			var playerMatchOver:PlayerMatchOver;
			for each(var userId:int in allPlayerIds)
			{
				if(userId == ev.winingPlayer)
					playerMatchOver= PlayerMatchOver.create(userId,100,100)
				else
					playerMatchOver= PlayerMatchOver.create(userId,0,0);
				finishedPlayers.push(playerMatchOver)
			}
			
			doAllEndMatch(finishedPlayers);
		}
		/**
		*A function triggered by a server message passing custom info to the game
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		override public function gotCustomInfo(infoEntries:Array):void
		{
			gameLogic.stageX = T.custom(CUSTOM_INFO_KEY_gameStageX,0) as int;
			gameLogic.stageY = T.custom(CUSTOM_INFO_KEY_gameStageY,0) as int;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,null) as int;
		}
		/**
		*A function triggered by a server message calling a begining of a game
		*
		*@param allPlayerIds an Array of all the player ids
		*@param finishedPlayerIds an Array of all the finished player ids
		*@param serverEntries an Array of ServerEntry elements in case of a load
		*/
		override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):void
		{
			isGameOver = false;
			this.allPlayerIds = allPlayerIds;
			gameLogic.startNewGame(allPlayerIds.length);
			setTurn()
		}
		/**
		*A function triggered by a server message called by a doStoreState function 
		*
		*@param serverEntries an Array of ServerEntry elements recived
		*/
		override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void
		{
			var serverEntry:ServerEntry = serverEntries[0];
			var gameMove:TickTacToeMove;
			if(serverEntry.value is TickTacToeMove)
			{
				gameMove = serverEntry.value as TickTacToeMove;
				if ((gameMove.xPos !=serverEntry.key.xPos) || (gameMove.yPos !=serverEntry.key.yPos))
					throw new Error("Key does not match the value");
				gameLogic.makeTurn(gameMove);	
			}
		}
	}
}