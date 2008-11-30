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
		private const BOARD_WIDTHstr:String = "Height"
		private const BOARD_HEIGHTstr:String = "Width"
		private const MINE_AMOUNTstr:String = "mineAmount"
		
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
		private var usersData:Array; // information about all playing users
		private var allUsersData:Array; // information about all users
		private var allPlayerIds:Array; //playing user ids
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
			allUsersData = new Array(); 
			startGraphic= new Starter()
			startGraphic.x=170;
			startGraphic.y=160;
			startGraphic.stop();
			graphics.addChild(startGraphic);
			startGraphic.addEventListener("starterEnd",startGame);
			doRegisterOnServer();
		}
		
		private function startGame(ev:Event):void
		{
			mineSweeperLogic.makeBoard(boardWidth,boardHeight,stageX,stageY,allPlayerIds,usersData,myUserId);
			if(loadServerEntries != null)
				mineSweeperLogic.loadBoard(loadServerEntries);
		}
		public function gameOver(playerMatchOverArr:Array/*PlayerMatchOver*/):void
		{
			doAllEndMatch(playerMatchOverArr);
		}
		public function makePlayerMove(playerMove:PlayerMove):void
		{
			var key:Object ={xPos:playerMove.xPos,yPos:playerMove.yPos,playerId:playerMove.playerId}
			doStoreState([UserEntry.create(key,playerMove,false)]);
		}
		
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, null) as int;
			stageX = T.custom(CUSTOM_INFO_KEY_gameStageX, null) as int;
			stageY = T.custom(CUSTOM_INFO_KEY_gameStageY, null) as int;
			
			graphics.width = T.custom(CUSTOM_INFO_KEY_gameWidth,graphics.width) as int;
			graphics.height = T.custom(CUSTOM_INFO_KEY_gameHeight,graphics.height) as int;
			trace("trace this:"+graphics.scaleX+"/"+graphics.scaleY)
			mineSweeperLogic.setNewGraphicScale(graphics.scaleX,graphics.scaleY);
			boardWidth = T.custom(BOARD_WIDTHstr, 12) as int;
			boardHeight =  T.custom(BOARD_HEIGHTstr, 12) as int;
			mineAmount = T.custom(MINE_AMOUNTstr, 20) as int;

		}
		override public function gotRequestStateCalculation(requestId:int, serverEntries:Array):void
		{
			for each (var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored a random key");
				if (serverEntry.key == BOARD_HEIGHTstr) 
					var calcHeight:int = serverEntry.value as int;
				else if (serverEntry.key == BOARD_WIDTHstr) 
					var calcWidth:int = serverEntry.value as int;
				else if (serverEntry.key == MINE_AMOUNTstr)
					var calcMineAmount:int = serverEntry.value as int;
				else if(serverEntry.key == "randomSeed")
					var calcRandomSeed:int = serverEntry.value as int;
			}
			
			
			//BOARD_WIDTHstr,BOARD_HEIGHTstr,MINE_AMOUNTstr
			doAllStoreStateCalculation(requestId,MineSweeperCalculatorLogic.createMineBoard(calcRandomSeed,calcMineAmount,calcWidth,calcHeight));	
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			for each(var infoEntry:InfoEntry in entries)
			{
				if(infoEntry.key == "name")
				{
					for each(var previousPlayer:Object in allUsersData)
						if(previousPlayer.userId == userId) return;
					allUsersData.push({userId:userId,name:infoEntry.value});
				}
			}
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			this.allPlayerIds = allPlayerIds;
			loadServerEntries = null;
			graphicPlayed = false;
			usersData = new Array();
			for each (var obj:Object in allUsersData)
			{
				if(allPlayerIds.indexOf(obj.userId) != -1)
					usersData.push(obj);
			}
			
			for(var i:int = usersData.length ;i<allPlayerIds.length;i++)
				usersData.push({userId:allPlayerIds[i],name:"player "+allPlayerIds[i]});
			if(serverEntries.length == 0)
			{
				doAllRequestRandomState("randomSeed",true);
				doAllStoreState([UserEntry.create(BOARD_WIDTHstr,boardWidth),UserEntry.create(BOARD_HEIGHTstr,boardHeight),UserEntry.create(MINE_AMOUNTstr,mineAmount)])
				doAllRequestStateCalculation(["randomSeed",BOARD_WIDTHstr,BOARD_HEIGHTstr,MINE_AMOUNTstr]);
			}
			else
			{
				loadServerEntries = serverEntries;
				//load game or viewer
				graphicPlayed = true;
				startGraphic.play();
				
			}
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0]
			if(serverEntries.length == 4)
			{
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" tryed to change custom info or random seed");
			}
			else if(serverEntries.length >= (boardHeight * boardWidth))//state changed due to creation of board by calculators
			{
				//got calculations made by calculator	
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				if(!graphicPlayed)
					startGraphic.play();
			}
			else if(serverEntry.value is PlayerMove)//state changed due to player move
			{
				var playerMove:PlayerMove = serverEntry.value as PlayerMove;
				if(playerMove.playerId != serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data for another user");
				if(playerMove.playerId != serverEntry.key.playerId) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" key did not match the value");
				var newMove:Boolean = mineSweeperLogic.addPlayerMove(playerMove);
				if(newMove)	
				{	
					var key:Object = {xPos:playerMove.xPos,yPos:playerMove.yPos};			
					doAllRevealState([RevealEntry.create(key,null,1)]);	
					return;
				}
				if(myUserId == playerMove.playerId)
					doStoreState([UserEntry.create(serverEntry.key,null,false)]);
			}
			else if(serverEntry.value is ServerBox)//state changed due to RevealEntry caused by a player move
			{
				var serverBox:ServerBox = serverEntry.value as ServerBox;
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
					mineSweeperLogic.addServerBox(serverBox);
			}
			else if(serverEntry.value.type == "deadSpace")//player found a safe zone
			{
				serverEntry = serverEntries[1];
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				if(serverEntry.value is Array)
				{
					var safeSquares:Array = serverEntry.value as Array;
					mineSweeperLogic.addSafeZone(safeSquares);
				}
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			mineSweeperLogic.mine = shiftKey;
		}
	}
}