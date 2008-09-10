package come2play_as3.minesweeper
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
	public class MineSweeper_Main extends ClientGameAPI
	{
		private var graphics:MovieClip;
		
		private static var boardHeight:int=10;
		private static var boardWidth:int=10;
		private static var mineAmount:int=10;
		//calculator variables
		private var emptyBoxes:Array;
		private var newCalculatorBoard:Array
		
		private var loadServerEntries:Array;
		private var startGraphic:Starter;
		private var mineSweeper_Logic:MineSweeper_Logic;
		private var myUserId:int; //my user id
		private var users:Array; // information about all users
		private var players:Array; //playing user ids
	/** 
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function MineSweeper_Main(graphics:MovieClip)
		{ 
			super(graphics);
			this.graphics = graphics;
			AS3_vs_AS2.waitForStage(graphics,constructGame);
		}
		public function constructGame(ev:TimerEvent):void
		{ 
				graphics.addChild(new Background);
				users = new Array(); 
				mineSweeper_Logic  = new MineSweeper_Logic(this,graphics,boardWidth,boardHeight);
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
			if(loadServerEntries == null)
				mineSweeper_Logic.buildBoard(users,players);
			else
				mineSweeper_Logic.loadBoard(users,players,loadServerEntries)
		}
		public function doesExist(pos:Object,arr:Array):Boolean
		{
			for each(var arrPos:Object in arr)
			{
				if((arrPos.xPos == pos.xPos) && (arrPos.yPos == pos.yPos))
					return true;
			}
			return false;
		}
		public function gameOver():void
		{
			doAllEndMatch(mineSweeper_Logic.endMatch());
		}
		public function pressMine(xPos:int,yPos:int,isMine:Boolean):void
		{
			var playerMove:PlayerMove = PlayerMove.create(xPos,yPos,isMine,myUserId);
			doStoreState([UserEntry.create(myUserId+"_"+xPos+"_"+ yPos,playerMove,false)]);
		}
		
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
				
		}
		override public function gotRequestStateCalculation(serverEntries:Array):void
		{
		
			var serverEntry:ServerEntry = serverEntries[0];
			var randomSeed:RandomGenerator= new RandomGenerator(serverEntry.value);
			var mines:Array = new Array();
			//create mine positions
			while(mines.length < mineAmount)
			{
				var mineUncalculated:int = randomSeed.nextInRange(0, boardHeight * boardWidth);
				var newPos:Object = {xPos: int(mineUncalculated/boardWidth),yPos:(mineUncalculated%boardWidth)};
				if (!doesExist(newPos,mines))
					mines.push(newPos);
			}
			//initialize a blank board
			newCalculatorBoard= new Array();
			for(var i:int=0;i<boardWidth;i++)
			{
				newCalculatorBoard[i] = new Array();
				for(var j:int=0;j<boardHeight;j++)
					newCalculatorBoard[i][j]=0		
			}
			//put mines on board		
			for(i=0;i<boardWidth;i++)
				for(j=0;j<boardHeight;j++)
				{
					if(doesExist({xPos:i,yPos:j},mines))
					{
						newCalculatorBoard[i][j] = 10;
						newCalculatorBoard[i][j-1]++;
						newCalculatorBoard[i][j+1]++;
						if(i > 0)
						{
							newCalculatorBoard[i-1][j]++;
							newCalculatorBoard[i-1][j+1]++;
							newCalculatorBoard[i-1][j-1]++;
						}
						if((i+1) < boardWidth)
						{
							newCalculatorBoard[i+1][j]++;
							newCalculatorBoard[i+1][j+1]++;
							newCalculatorBoard[i+1][j-1]++;
						}
					}
				}
				
				
			var sort:UnionSort = new UnionSort(newCalculatorBoard,boardWidth,boardHeight);
				
			//find connected squares to each white square and create ServerEntries
			
			var userEntries:Array= new Array();
			for(i=0;i<boardWidth;i++)
				for(j=0;j<boardHeight;j++)	
				{
					var serverBox:ServerBox = new ServerBox();
					serverBox.xPos = i ;
					serverBox.yPos = j ;
					if(newCalculatorBoard[i][j]>9)
					{
						serverBox.isMine = true;
						userEntries.push(UserEntry.create(i+"_"+j,serverBox,true));
					}
					else if((newCalculatorBoard[i][j]!=0))
					{
						serverBox.isMine = false;
						serverBox.borderingMines =newCalculatorBoard[i][j];
						userEntries.push(UserEntry.create(i+"_"+j,serverBox,true));
					}
					
					if(newCalculatorBoard[i][j] == 0)
						userEntries.push(UserEntry.create(i+"_"+j,"deadSpace_"+sort.getBrick(i,j),true)); 
					
				}
				var deadSpaceGrpoups:Array = sort.blankBoxArrays;
				for(i=0;i<deadSpaceGrpoups.length;i++)
				{
					userEntries.push(UserEntry.create("deadSpace_"+sort.getId(i),deadSpaceGrpoups[i],true));
				}
				doAllStoreStateCalculation(userEntries);
				
			
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
			mineSweeper_Logic.myUserId = myUserId;
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			users.push({userId:userId,entries:entries});
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
		{
			trace("Start***************"+myUserId)
			trace(allPlayerIds)
			trace(JSON.stringify(users))
			trace("end*********"+myUserId)
			players = allPlayerIds;
			mineSweeper_Logic.renewBoard();
			loadServerEntries = null;
			if(serverEntries.length == 0)
			{
				doAllRequestRandomState("randomSeed",true);
				doAllRequestStateCalculation(["randomSeed"]);
			}
			else
			{
				loadServerEntries = serverEntries;
				//load game or viewer
				startGraphic.play();
			}
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0]
				
			if(serverEntries.length > boardHeight * boardWidth)
			{
				//got calculations made by calculator	
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				startGraphic.play();
			}
			else if(serverEntry.value is PlayerMove)
			{
				var playerMove:PlayerMove = serverEntry.value as PlayerMove;
				if(playerMove.takingPlayer != serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data for another user")
				if(!mineSweeper_Logic.isMoveTaken(playerMove))					
					doAllRevealState([RevealEntry.create(playerMove.xPos+"_"+playerMove.yPos,null,1)]);	
				else
					if(myUserId == playerMove.takingPlayer)
						doStoreState([UserEntry.create(playerMove.takingPlayer+"_"+playerMove.xPos+"_"+playerMove.yPos,null,false)]);
			}
			else if(serverEntry.value is ServerBox)
			{
				var serverBox:ServerBox = serverEntry.value as ServerBox;
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				 mineSweeper_Logic.addBoxesServer(serverBox);
			}
			else if(serverEntry.value is Array)
			{
				var blankSquares:Array = serverEntry.value as Array;
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");	
				mineSweeper_Logic.addBlankBoxesServer(blankSquares);
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			mineSweeper_Logic.mine = shiftKey;
		}
	}
}