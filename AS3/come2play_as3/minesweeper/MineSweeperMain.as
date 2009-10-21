package come2play_as3.minesweeper
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
	public class MineSweeperMain extends ClientGameAPI
	{
		//consts
		static public const squareSize:int = 19;
		
		private var _graphics:MovieClip;
		private static var boardWidth:int=10;
		private static var mineAmount:int=10;
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
		public var allowMoves:Boolean;
		private var computerMoveTimer:AS3_Timer;
	/** 
	 * Written by: Ofir Vainshtein (ofir@come2play.com)
 	**/
		public function MineSweeperMain(_graphics:MovieClip)
		{ 
			(new PlayerMove).register();
			(new ServerBox).register();
			(new ComputerMove).register();
			super(_graphics);
			this._graphics = _graphics;
			AS3_vs_AS2.waitForStage(_graphics,constructGame);
			computerMoveTimer = new AS3_Timer("computerMoveTimer",100,0);	
			AS3_vs_AS2.myAddEventListener("computerMoveTimer",computerMoveTimer,TimerEvent.TIMER,computerMakeMove)
		}
		public function constructGame():void
		{ 
			graphicPlayed = false;
			_graphics.addChild(new Background);
			mineSweeperLogic  = new MineSweeperLogic(this,_graphics);	
			startGraphic= new Starter()
			startGraphic.x=170;
			startGraphic.y=160;
			startGraphic.stop();
			_graphics.addChild(startGraphic);
			AS3_vs_AS2.myAddEventListener("startGraphic",startGraphic,"starterEnd",startGame);
			doRegisterOnServer();
		}
		
		private function startGame(ev:Event = null):void
		{
			if(loadServerEntries != null)
				mineSweeperLogic.loadBoard(loadServerEntries);
			if((allPlayerIds.indexOf(-1) != -1) && isPlaying){ 
				if(!(isInReview() || (isBack())) )
					computerMoveTimer.start();
			}
			allowMoves = true;
			if(! ((isBack()) || (isInReview())) )
				animationEnded("startGraphicAnimation");
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
			doStoreState([UserEntry.create(key,playerMove,false)],[RevealEntry.create(serverKey,null,1)]);
		}
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, null) as int;

			if(!computerMoveTimer.running)	computerMoveTimer.delay = T.custom("ComputerSpeed",2000) as int;
			for each(var info:InfoEntry in infoEntries){
				if(info.key == CUSTOM_INFO_KEY_gameWidth){
					_graphics.width = T.custom(CUSTOM_INFO_KEY_gameWidth,int(_graphics.width)) as int;
				}else if(info.key == CUSTOM_INFO_KEY_gameHeight){
					_graphics.height = T.custom(CUSTOM_INFO_KEY_gameHeight,int(_graphics.height)) as int;
				}
			}		
			boardWidth = T.custom("Board Width", 12) as int;
			mineAmount = T.custom("Mine Amount", 20) as int;

		}
		override public function gotRequestStateCalculation(requestId:int, serverEntries:Array):void
		{
			for each (var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored a random key");
				if (serverEntry.key == "Board Width") 
					var calcWidth:int = serverEntry.value as int;
				else if (serverEntry.key == "Mine Amount")
					var calcMineAmount:int = serverEntry.value as int;
				else if(serverEntry.key == "randomSeed")
					var calcRandomSeed:int = serverEntry.value as int;
			}
			doAllStoreStateCalculation(requestId,MineSweeperCalculatorLogic.createMineBoard(calcRandomSeed,calcMineAmount,calcWidth));	
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{

		}
		private var canSendMove:Boolean = false;
		private function computerMakeMove(ev:TimerEvent):void{
			if(!canSendMove)	return;
			var computerMove:ComputerMove = mineSweeperLogic.getComputerMove();
			if(computerMove == null) return;
			var key:Object ={xPos:computerMove.xPos,yPos:computerMove.yPos,playerId:-1}
			var serverKey:Object = {xPos:computerMove.xPos,yPos:computerMove.yPos}
			if(allowMoves){
				canSendMove = false;
				doStoreState([UserEntry.create(key,computerMove,false)],[RevealEntry.create(serverKey,null,1)]);
			}
		}
		private function isBack():Boolean{
			return T.custom(API_Message.CUSTOM_INFO_KEY_isBack,false) as Boolean
		}
		
		private function isInReview():Boolean{
			return T.custom(API_Message.CUSTOM_INFO_KEY_isInReview,false) as Boolean
		}
		
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			canSendMove = true;
			isPlaying = true;
			this.allPlayerIds = allPlayerIds.concat();
			loadServerEntries = null;
			graphicPlayed = false;
			
			startGraphic.visible = !isInReview();
			if((this.allPlayerIds.length == 1) && (!isInReview())){
				this.allPlayerIds.push(-1);
			}
			if(serverEntries.length == 0){
				doAllRequestRandomState("randomSeed",true);
				doAllStoreState([UserEntry.create("Board Width",boardWidth),UserEntry.create("Mine Amount",mineAmount)])
				doAllRequestStateCalculation(["randomSeed","Board Width","Mine Amount"]);
				mineSweeperLogic.makeBoard(boardWidth,this.allPlayerIds,myUserId);
			}else{
				loadServerEntries = serverEntries;
				//load game or viewer
				graphicPlayed = true;
				if((isBack()) || (isInReview())){
					mineSweeperLogic.makeBoard(boardWidth,this.allPlayerIds,myUserId);
					startGame();
				}else{
					mineSweeperLogic.makeBoard(boardWidth,this.allPlayerIds,myUserId);
					animationStarted("startGraphicAnimation");
					startGraphic.play();
				}
				
			}
			if(mineSweeperLogic!=null)
				mineSweeperLogic.mine = false;
			
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			AS3_GATracker.COME2PLAY_TRACKER.trackEvent("Tests","Minesweeper send","sent data");
			computerMoveTimer.reset();
			mineSweeperLogic.isPlaying = false;
		}
		private function addNewMove(serverEntries:Array/*ServerEntry*/):void{
			var serverEntry:ServerEntry = serverEntries[1];
			if(serverEntry == null){
				
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
			doAllSetMove();
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			if(!isPlaying)
				return;
			var newMove:Boolean;
			var serverEntry:ServerEntry = serverEntries[0]
			if(serverEntry.key == "randomSeed")
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" tryed to change custom info or random seed");
			}
			else if(serverEntries.length >= (boardWidth * boardWidth))//state changed due to creation of board by calculators
			{
				//got calculations made by calculator	
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				if(!isPlaying) return;
				if(!graphicPlayed)
				{
					if(! ((isBack()) || isInReview())){
						animationStarted("startGraphicAnimation");
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
				newMove = mineSweeperLogic.addPlayerMove(playerMove);
				if(newMove)	
				{	
					addNewMove(serverEntries)
					return;
				}
				doAllStoreState([UserEntry.create(serverEntry.key,null,false)]);
			}else if (serverEntry.value is ComputerMove){
				canSendMove = true;
				if(allPlayerIds.indexOf(-1) == -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored a computer move and not a player move")
				var computerMove:ComputerMove = serverEntry.value as ComputerMove;
				newMove = mineSweeperLogic.addComputerMove(computerMove);
				if(newMove){
					addNewMove(serverEntries)
					return;
				}
				
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			if(mineSweeperLogic!=null)
				mineSweeperLogic.mine = shiftKey;
		}

	}
}