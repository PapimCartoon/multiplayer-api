package come2play_as3.dominoGame
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.ErrorHandler;
	import come2play_as3.api.auto_copied.JSON;
	import come2play_as3.api.auto_copied.Logger;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.dominoGame.events.AnimationEvent;
	import come2play_as3.dominoGame.events.WinnerEvent;
	import come2play_as3.dominoGame.serverClasses.DominoComputerDraw;
	import come2play_as3.dominoGame.serverClasses.DominoComputerMove;
	import come2play_as3.dominoGame.serverClasses.DominoComputerPass;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	import come2play_as3.dominoGame.serverClasses.DominoDraw;
	import come2play_as3.dominoGame.serverClasses.DominoMove;
	import come2play_as3.dominoGame.serverClasses.DominoPass;
	import come2play_as3.dominoGame.serverClasses.PlayerTurn;
	import come2play_as3.dominoGame.usefullFunctions.Tools;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class DominoGameMain extends ClientGameAPI
	{
		private var _graphics:MovieClip
		private var dominoLogic:DominoGameLogic
		private var dominoGraphic:DominoGameGraphic
		private var myUserId:int;
		private var allPlayerIds:Array
		static public const myWidthMod:Number = 704/380
		static public const myHeightMod:Number = 432/380
		static public const DOMINO_CUBE:String = "DominoCube"
		static public const DOMINO_MOVE:String = "DominoMove"
		static public const COMPUTER_MOVE:String = "DominoComputerMove"
		static public var  dominoMax:int = 6
		static public var  dominoHand:int = 7
		static public var  dominoMaxHand:int = 13
		private var leftDominoKeys:Array = []
		private var currentTurn:int
		private var passCount:int
		public function DominoGameMain(_graphics:MovieClip)
		{
			super(_graphics);
			this._graphics = _graphics;
			(new DominoCube).register();
			(new DominoMove).register();
			(new DominoComputerMove).register();
			(new DominoComputerDraw).register();
			(new DominoComputerPass).register();
			(new DominoPass).register();
			(new DominoDraw).register();
			(new PlayerTurn).register();
			AS3_vs_AS2.waitForStage(_graphics,constructGame);
		}
		
		private function constructGame():void{
			dominoGraphic = new DominoGameGraphic()
			dominoLogic = new DominoGameLogic(dominoGraphic)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,DominoComputerMove.DOMINO_COMPUTER_MOVE,makeMove)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,DominoMove.DOMINO_MOVE,makeMove)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,WinnerEvent.DECALRE_WINNER,declareWinner)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,DominoPass.DOMINO_PASS,passTurn)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,DominoComputerDraw.DOMINO_COMPUTER_DRAW,drawDomino)
			
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,DominoDraw.DOMINO_DRAW,drawDomino)
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,DominoPass.DOMINO_PASS,passTurn)
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,AnimationEvent.ANIMATION_EVENT,handleAnimation)
			_graphics.addChild(dominoGraphic)
			dominoGraphic.startStageListening()
			doRegisterOnServer();
		}
		private var responseLength:int
		private function declareWinner(ev:WinnerEvent):void{
			if(isSinglePlayer){
				gameInProgress = false;
				doAllEndMatch([PlayerMatchOver.create(myUserId,100,100)])
				return
			}	
			var winner:int = ev.playerId
			var winnerMatchOver:PlayerMatchOver
			var loserMatchOver:PlayerMatchOver
			if(winner == -10){
				winnerMatchOver = PlayerMatchOver.create(allPlayerIds[0],100,-1)
				loserMatchOver = PlayerMatchOver.create(allPlayerIds[1],100,-1);
				doAllEndMatch([winnerMatchOver,loserMatchOver]);
			}else if(winner == -1){
				var arr:Array = dominoLogic.dominoToReveal()
				responseLength = arr.length;
				if(responseLength != 0){
					doAllRevealState(arr)
				}
			}else{
				var loser:int = (winner == allPlayerIds[0])?allPlayerIds[1]:allPlayerIds[0];
				winnerMatchOver = PlayerMatchOver.create(winner,100,100)
				loserMatchOver = PlayerMatchOver.create(loser,0,0);
				doAllEndMatch([winnerMatchOver,loserMatchOver]);
			}
			gameInProgress = false;
			
			
		}
		private function handleAnimation(ev:AnimationEvent):void{
			myDoTrace("handleAnimation",ev)
			if(ev.start){
				animationStarted(ev.animationName)
			}else{
				animationEnded(ev.animationName)
			}
		}
		/*Start of calculator code*/
		private function findBestStartingBrick(serverEntries:Array/*ServerEntry*/):int{
			var index:int
			var len:int = serverEntries.length;
			var oldDomino:DominoCube = DominoCube.create(1,2);
			var newDomino:DominoCube;
			for(var i:int=0;i<len;i++){
				var serverEntry:ServerEntry = serverEntries[i];
				newDomino = serverEntry.value as DominoCube;
				if(newDomino.isDouble() && oldDomino.isDouble()){
					if(newDomino.up>oldDomino.up){
						oldDomino = newDomino;
						index = i;
					} 
				}else if(newDomino.isDouble() && (!oldDomino.isDouble())){
					oldDomino = newDomino;
					index = i;
				}else if((!newDomino.isDouble()) && (!oldDomino.isDouble())){
					if(newDomino.value()>oldDomino.value()){
						oldDomino = newDomino;
						index = i;
					}	 
				}
			}	
			return index;
		}
		private var gameInProgress:Boolean
		
		override public function gotMatchEnded(finishedPlayerIds:Array):void{
			myDoTrace("gotMatchEnded",finishedPlayerIds)
			gameInProgress = false;
			dominoGraphic.gameEnded()
		}
		
		override public function gotRequestStateCalculation(requestId:int, serverEntries:Array):void{
			//the calculators job is to decide who goes first(has the biggest double or heighest brick)
			myDoTrace("gotRequestStateCalculation",serverEntries)
			var serverEntry:ServerEntry = serverEntries.shift();
			dominoHand = serverEntry.value;
			var bestStartBrick:int = findBestStartingBrick(serverEntries.slice(0,dominoHand*2))
			var playerTurn:int = Math.floor(bestStartBrick/dominoHand)
			doAllStoreStateCalculation(requestId,[UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(playerTurn))])
		}
		/*End of calculator code*/
		private function drawDomino(ev:DominoDraw):void{
			myDoTrace("drawDomino",ev)
			if((leftDominoKeys.length<1) ||  (!gameInProgress) || dominoGraphic.isNoMoreDomino() || isInTransaction()){	
				if((currentTurn == 1) && (isSinglePlayer)) {
					ErrorHandler.myTimeout("drawTimeout",function():void{
						dominoLogic.makeComputerMove();
					},1000);
				};
				return;
			}
			var key:Object = leftDominoKeys.shift()
			dominoGraphic.dominoesDelayed.push(JSON.stringify(key))
			doStoreState([UserEntry.create({type:DominoDraw.DOMINO_DRAW,playerId:myUserId,moveNum:dominoLogic.getMoveNum()},ev)],[revealKeyTo(key,myUserId)])
		}
		private function passTurn(ev:DominoPass):void{
			myDoTrace("passTurn",ev)
			if(isInTransaction()){	
				ErrorHandler.myTimeout("passTimeout",function():void{
					passTurn(ev)
				},1000);
				return
			}
			
			if(gameInProgress) doStoreState([UserEntry.create({type:DominoPass.DOMINO_PASS,playerId:myUserId,moveNum:dominoLogic.getMoveNum()},ev)])
		}
		private function makeMove(ev:DominoMove):void{	
			myDoTrace("try makeMove",[ev,"gameInProgress=",gameInProgress,"isInTransaction()=",isInTransaction()])
			if((gameInProgress) || (isInTransaction())){
				doStoreState([UserEntry.create(ev.getKey(),ev)],[RevealEntry.create(JSON.parse(ev.key),null)])
			}
		}
		static public var isSinglePlayer:Boolean
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			this.allPlayerIds = allPlayerIds;
			isSinglePlayer = (allPlayerIds.length == 1);
			if(isSinglePlayer){
				this.allPlayerIds.push(-1)
			}
			gameInProgress = true;
			Tools.setGamePoint(_graphics.localToGlobal(new Point()))
			Tools.setGameScale(dominoGraphic.scaleX,dominoGraphic.scaleY)
			passCount = 0;
			responseLength = 0
			currentTurn = -1;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, -1) as int;	
			var isViewer:Boolean = allPlayerIds.indexOf(myUserId) == -1
			var rivalUserIds:Array = []
			if(isViewer){
				rivalUserIds = allPlayerIds.concat();
			}else{
				rivalUserIds.push(this.allPlayerIds.indexOf(myUserId)==0?this.allPlayerIds[1]:this.allPlayerIds[0])
			}		
			dominoLogic.startGame(myUserId,rivalUserIds);
			leftDominoKeys = []
			if(serverEntries.length == 0){    //new game
				var userEntries:Array/*UserEntry*/ =[];
				var revealEntries:Array/*RevealEntry*/ = []
				var keys:Array/*Object*/ = []
				var count:int=1;
				userEntries.unshift(UserEntry.create("dominoHand",dominoHand,false))
				var brickNum:int = 0
				var revealTo:int = 0
				for(var i:int=0;i<=dominoMax;i++)
					for(var j:int=i;j<=dominoMax;j++){
						var dominoCube:DominoCube = DominoCube.create(i,j);
						var key:Object = dominoCube.getKey()
						userEntries.push(UserEntry.create(key,dominoCube,true))
						if(brickNum == dominoHand){	
							revealTo++;
							brickNum = 0;
						}
						if(revealTo<this.allPlayerIds.length)
							revealEntries.push(revealKeyTo(key,isSinglePlayer?myUserId:this.allPlayerIds[revealTo]));
						else
							leftDominoKeys.push(key)
						keys.push(key)
						brickNum++;
					}	
				doAllStoreState(userEntries)
				doAllShuffleState(keys.concat())
				keys.unshift("dominoHand");
				doAllRequestStateCalculation(keys)	
				doAllRevealState(revealEntries)
			}else{//load game
				var dominoCubeDic:Dictionary = new Dictionary()
				serverEntries.shift();
				for each(var serverEntry:ServerEntry in serverEntries){
					if(serverEntry.value is DominoCube){
						dominoCubeDic[JSON.stringify(serverEntry.key)] = serverEntry.value;
					}else if(serverEntry.value is DominoDraw){
						dominoLogic.madeMove()
					}
					if(serverEntry.key.type == DOMINO_CUBE){	
						logger.log("domino Taken: ",serverEntry);
						dominoLogic.takeDominoBrick(serverEntry)
					}
				}
				for each(serverEntry in serverEntries){
					if(serverEntry.value is DominoMove){
						var dominoMove:DominoMove = serverEntry.value as DominoMove
						dominoLogic.putBrick(dominoMove,dominoCubeDic[dominoMove.key] as DominoCube,true)
						dominoLogic.madeMove()
					}else if(serverEntry.value is PlayerTurn){
						var playerTurn:PlayerTurn = serverEntry.value as PlayerTurn
						setTurn(playerTurn)
					}
				}

			}	
		}
		private var logger:Logger = new Logger("DominoLog",40)
		private function revealKeyTo(key:Object,userId:int):RevealEntry{
			return RevealEntry.create(key,[userId])
		}
		private function getNextTurn():int{
			return(currentTurn+1)==allPlayerIds.length?0:(currentTurn+1)
		}
		private function removeKey(keyToRemove:Object):void{
			for(var i:int=0;i<leftDominoKeys.length;i++){
				var key:Object = leftDominoKeys[i];
				if(key.brickNum == keyToRemove.brickNum){
					leftDominoKeys.splice(i,1);
					return;
				}
			}				 
		}
		private function hackerAssertion(condition:Boolean,userId:int,text:String):void{
			if(!condition)	doAllFoundHacker(userId,text)
		}
		
		private function setTurn(playerTurn:PlayerTurn):void{
			currentTurn = playerTurn.playerTurn
			var userTurn:int = allPlayerIds[currentTurn]
			dominoLogic.setTurn(userTurn)
			doAllSetTurn(isSinglePlayer?myUserId:userTurn)
		}
		
		private function myDoTrace(name:String,Message:Object):void{
			if(T.custom("traceAll",false) as Boolean)	doTrace(name,Message)	
		}
		
		
		override public function gotStateChanged(serverEntries:Array):void{
			myDoTrace("gotStateChanged",serverEntries)
			var serverEntry:ServerEntry = serverEntries[0];
			if(responseLength == serverEntries.length){
				dominoLogic.declareWinner(serverEntries)
			}else if(serverEntries.length == (dominoLogic.dominoAmount+1)){//bricks recieved in first deal
				hackerAssertion(serverEntry.storedByUserId == -1,serverEntry.storedByUserId,"calculations should be made by calculators")
				serverEntry =  serverEntries.shift();
				if(isSinglePlayer){
					var counter:int = 0
					for each(serverEntry in serverEntries){
						if(serverEntry.visibleToUserIds.length>0){
							dominoLogic.takeDominoBrick(serverEntry,dominoHand>counter)
							counter++;
						}
					}
				}else{
					for each(serverEntry in serverEntries){
						dominoLogic.takeDominoBrick(serverEntry)
					}
				}		
			}else if(serverEntry.value is PlayerTurn){//set turn to a specific player
				var playerTurn:PlayerTurn = serverEntry.value as PlayerTurn
				setTurn(playerTurn)
			}else if(serverEntry.value is DominoComputerMove){
				var dominoComputerMove:DominoComputerMove = serverEntry.value as DominoComputerMove
				dominoLogic.madeMove()
				hackerAssertion(serverEntry.storedByUserId == myUserId,serverEntry.storedByUserId,"there can only be my user id in single player mode")
				serverEntry = serverEntries[1];
				if(serverEntry==null){
					serverEntry = getServerEntry(JSON.parse(dominoComputerMove.key))
				}
				passCount = 0;
				dominoLogic.putBrick(dominoComputerMove,serverEntry.value as DominoCube)
				if(gameInProgress) doAllStoreState([UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(getNextTurn()))])
			}else if(serverEntry.value is DominoMove){//got a player move
				var dominoMove:DominoMove = serverEntry.value as DominoMove
				dominoLogic.madeMove()
				hackerAssertion(serverEntry.storedByUserId == dominoMove.playerId,serverEntry.storedByUserId,"user has to move for himself")
				serverEntry = serverEntries[1];
				if(serverEntry==null){
					serverEntry = getServerEntry(JSON.parse(dominoMove.key))
				}
				passCount = 0;
				dominoLogic.putBrick(dominoMove,serverEntry.value as DominoCube)
				if(gameInProgress) doAllStoreState([UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(getNextTurn()))])
			}else if(serverEntry.value is DominoDraw){
				hackerAssertion(serverEntry.storedByUserId == serverEntry.key.playerId,serverEntry.storedByUserId,"user has to draw for himself")
				dominoLogic.madeMove()
				var shouldForce:Boolean = serverEntry.value is DominoComputerDraw
				serverEntry = serverEntries[1];
				removeKey(serverEntry.key);
				dominoLogic.takeDominoBrick(serverEntry,shouldForce)
				if((isSinglePlayer) && (shouldForce)){
					ErrorHandler.myTimeout("computerMakeMove",function():void{
						dominoLogic.makeComputerMove()
					},1000);
				}
			}else if(serverEntry.value is DominoPass){
				hackerAssertion(serverEntry.storedByUserId == serverEntry.key.playerId,serverEntry.storedByUserId,"user has to pass for himself")
				dominoLogic.madeMove()
				if(passCount >= 1)	declareWinner(new WinnerEvent(-1))
				if(dominoGraphic.isNoMoreDomino())	passCount++;
				if(gameInProgress) doAllStoreState([UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(getNextTurn()))])
			}
			
			
		}
		
	}
}