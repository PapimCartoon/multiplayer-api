package come2play_as3.minesweeper
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.ui.Mouse;
import flash.utils.*;
	public class MineSweeperMain extends ClientGameAPI
	{
		//consts
		static public const squareSize:int = 19;
		
		private var graphics:MovieClip;
		private static var boardHeight:int=10;
		private static var boardWidth:int=10;
		private static var mineAmount:int=10;
		private var stageX:int = 0;
		private var stageY:int = 0;
		//calculator variables
		private var emptyBoxes:Array;
		private var newCalculatorBoard:Array
		private var graphicPlayed:Boolean;
		
		private var loadServerEntries:Array;
		private var startGraphic:Starter;
		private var mineSweeperLogic:MineSweeperLogic;
		private var myUserId:int; //my user id
		private var allPlayerIds:Array; //playing user ids
		private var isPlaying:Boolean;
		private var allowMoves:Boolean;
	/** 
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function MineSweeperMain(graphics:MovieClip)
		{ 
			(new PlayerMove).register();
			(new ServerBox).register();
			super(graphics);
			this.graphics = graphics;
			AS3_vs_AS2.waitForStage(graphics,constructGame);
		}
		public function constructGame():void
		{ 
			graphicPlayed = false;
			graphics.addChild(new Background);
			mineSweeperLogic  = new MineSweeperLogic(this,graphics);	
			startGraphic= new Starter()
			startGraphic.x=170;
			startGraphic.y=160;
			startGraphic.stop();
			graphics.addChild(startGraphic);
			startGraphic.addEventListener("starterEnd",startGame);
			doRegisterOnServer();
		}
		
		private function startGame(ev:Event = null):void
		{
			//mineSweeperLogic.makeBoard(boardWidth,boardHeight,stageX,stageY,allPlayerIds,myUserId);
			if(loadServerEntries != null)
				mineSweeperLogic.loadBoard(loadServerEntries);
			if(! (T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean) )
				animationEnded();
			allowMoves = true;
		}
		public function gameOver(playerMatchOverArr:Array/*PlayerMatchOver*/):void
		{
			doAllEndMatch(playerMatchOverArr);
			isPlaying = false;
			allowMoves = false;
		}
		public function makePlayerMove(playerMove:PlayerMove):void
		{
			var key:Object ={xPos:playerMove.xPos,yPos:playerMove.yPos,playerId:playerMove.playerId}
			var serverKey:Object = {xPos:playerMove.xPos,yPos:playerMove.yPos}
			if(allowMoves){
				doStoreState([UserEntry.create(key,playerMove,false)],[RevealEntry.create(serverKey,null,1)]);
			}
		}
		
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, null) as int;
			stageX = T.custom(CUSTOM_INFO_KEY_gameStageX, null) as int;
			stageY = T.custom(CUSTOM_INFO_KEY_gameStageY, null) as int;
			for each(var info:InfoEntry in infoEntries){
				if(info.key == CUSTOM_INFO_KEY_gameWidth){
					graphics.width = T.custom(CUSTOM_INFO_KEY_gameWidth,int(graphics.width)) as int;
				}else if(info.key == CUSTOM_INFO_KEY_gameHeight){
					graphics.height = T.custom(CUSTOM_INFO_KEY_gameHeight,int(graphics.height)) as int;
				}
				mineSweeperLogic.setNewGraphicScale(graphics.scaleX,graphics.scaleY);
			}		
			boardWidth = T.custom("Board Width", 12) as int;
			boardHeight =  T.custom("Board height", 12) as int;
			mineAmount = T.custom("Mine Amount", 20) as int;

		}
		override public function gotRequestStateCalculation(requestId:int, serverEntries:Array):void
		{
			for each (var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored a random key");
				if (serverEntry.key == "Board height") 
					var calcHeight:int = serverEntry.value as int;
				else if (serverEntry.key == "Board Width") 
					var calcWidth:int = serverEntry.value as int;
				else if (serverEntry.key == "Mine Amount")
					var calcMineAmount:int = serverEntry.value as int;
				else if(serverEntry.key == "randomSeed")
					var calcRandomSeed:int = serverEntry.value as int;
			}
			
			
			//BOARD_WIDTHstr,BOARD_HEIGHTstr,MINE_AMOUNTstr
			doAllStoreStateCalculation(requestId,MineSweeperCalculatorLogic.createMineBoard(calcRandomSeed,calcMineAmount,calcWidth,calcHeight));	
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{

		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			isPlaying = true;
			this.allPlayerIds = allPlayerIds;
			loadServerEntries = null;
			graphicPlayed = false;
			if(serverEntries.length == 0)
			{
				doAllRequestRandomState("randomSeed",true);
				doAllStoreState([UserEntry.create("Board Width",boardWidth),UserEntry.create("Board height",boardHeight),UserEntry.create("Mine Amount",mineAmount)])
				doAllRequestStateCalculation(["randomSeed","Board Width","Board height","Mine Amount"]);
				mineSweeperLogic.makeBoard(boardWidth,boardHeight,stageX,stageY,allPlayerIds,myUserId);
			}
			else
			{
				loadServerEntries = serverEntries;
				//load game or viewer
				graphicPlayed = true;
				if((T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean))
				{
					mineSweeperLogic.makeBoard(boardWidth,boardHeight,stageX,stageY,allPlayerIds,myUserId);
					startGame();
				}
				else
				{
					mineSweeperLogic.makeBoard(boardWidth,boardHeight,stageX,stageY,allPlayerIds,myUserId);
					animationStarted();
					startGraphic.play();
				}
				
			}
			
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			mineSweeperLogic.isPlaying = false;
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			if(!isPlaying)
				return;
			var serverEntry:ServerEntry = serverEntries[0]
			if(serverEntries.length == 4)
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" tryed to change custom info or random seed");
			}
			else if(serverEntries.length >= (boardHeight * boardWidth))//state changed due to creation of board by calculators
			{
				//got calculations made by calculator	
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				if(!isPlaying) return;
				if(!graphicPlayed)
				{
					if(! (T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean))
					{
						animationStarted();
						startGraphic.play();
					}
				}
			}
			else if(serverEntry.value is PlayerMove)//state changed due to player move
			{
				var playerMove:PlayerMove = serverEntry.value as PlayerMove;
				if(playerMove.playerId != serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data for another user");
				if(playerMove.playerId != serverEntry.key.playerId) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" key did not match the value");
				if(!isPlaying) return;
				var newMove:Boolean = mineSweeperLogic.addPlayerMove(playerMove);
				if(newMove)	
				{	
					serverEntry = serverEntries[1];
					if(serverEntry == null){
						trace("Ok")
					}else if (serverEntry.value == null){
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" deleting a move must be agreed by all users");
						//if(!isPlaying) return;
					}else if(serverEntry.value is ServerBox)//state changed due to RevealEntry caused by a player move
					{
						var serverBox:ServerBox = serverEntry.value as ServerBox;
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
						if(!isPlaying) return;
						mineSweeperLogic.addServerBox(serverBox);
					}else if (serverEntry.value == null){
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" deleting a move must be agreed by all users");
						//if(!isPlaying) return;
					}else if(serverEntry.value.type == "deadSpace")//player found a safe zone
					{
						serverEntry = serverEntries[2];
						if(serverEntry == null) return;
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
						if(!isPlaying) return;
						if(serverEntry.value is Array)
						{
							var safeSquares:Array = serverEntry.value as Array;
							mineSweeperLogic.addSafeZone(safeSquares);
						}
					}		
					//doAllRevealState([RevealEntry.create(key,null,1)]);	
					doAllSetMove();
					return;
				}
				doAllStoreState([UserEntry.create(serverEntry.key,null,false)]);
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			if(mineSweeperLogic!=null)
				mineSweeperLogic.mine = shiftKey;
		}

	}
}