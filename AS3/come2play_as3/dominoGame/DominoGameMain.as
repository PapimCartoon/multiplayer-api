package come2play_as3.dominoGame
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.Logger;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.dominoGame.events.AnimationEvent;
	import come2play_as3.dominoGame.events.WinnerEvent;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	import come2play_as3.dominoGame.serverClasses.DominoDraw;
	import come2play_as3.dominoGame.serverClasses.DominoMove;
	import come2play_as3.dominoGame.serverClasses.DominoPass;
	import come2play_as3.dominoGame.serverClasses.PlayerTurn;
	import come2play_as3.dominoGame.usefullFunctions.Tools;
	
	import flash.display.MovieClip;
	import flash.geom.Point;

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
			(new DominoPass).register();
			(new DominoDraw).register();
			(new PlayerTurn).register();
			AS3_vs_AS2.waitForStage(_graphics,constructGame);
		}
		private function constructGame():void{
			dominoGraphic = new DominoGameGraphic()
			dominoLogic = new DominoGameLogic(dominoGraphic)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,DominoMove.DOMINO_MOVE,makeMove)
			AS3_vs_AS2.myAddEventListener("dominoLogic",dominoLogic,WinnerEvent.DECALRE_WINNER,declareWinner)
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,DominoDraw.DOMINO_DRAW,drawDomino)
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,DominoPass.DOMINO_PASS,passTurn)
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,AnimationEvent.ANIMATION_EVENT,handleAnimation)
			_graphics.addChild(dominoGraphic)
			dominoGraphic.startStageListening()
			doRegisterOnServer();
		}
		private function declareWinner(ev:WinnerEvent):void{
			if(allPlayerIds.length == 1){
				if(ev.playerId!=myUserId)	return;
				gameInProgress = false;
				doAllEndMatch([PlayerMatchOver.create(myUserId,100,100)])
				return
			}	
			var winner:int = ev.playerId
			var winnerMatchOver:PlayerMatchOver
			var loserMatchOver:PlayerMatchOver
			if(winner == -1){
				winnerMatchOver = PlayerMatchOver.create(allPlayerIds[0],50,-1)
				loserMatchOver = PlayerMatchOver.create(allPlayerIds[1],50,-1);
			}else{
				var loser:int = (winner == allPlayerIds[0])?allPlayerIds[1]:allPlayerIds[0];
				winnerMatchOver = PlayerMatchOver.create(winner,100,100)
				loserMatchOver = PlayerMatchOver.create(loser,0,0);
			}
			gameInProgress = false;
			doAllEndMatch([winnerMatchOver,loserMatchOver]);
			
		}
		private function handleAnimation(ev:AnimationEvent):void{
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
			gameInProgress = false;
			dominoGraphic.gameEnded()
		}
		
		override public function gotRequestStateCalculation(requestId:int, serverEntries:Array):void{
			//the calculators job is to decide who goes first(has the biggest double or heighest brick)
			var serverEntry:ServerEntry = serverEntries.shift();
			dominoHand = serverEntry.value;
			var bestStartBrick:int = findBestStartingBrick(serverEntries.slice(0,dominoHand*2))
			var playerTurn:int = Math.floor(bestStartBrick/dominoHand)
			doAllStoreStateCalculation(requestId,[UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(playerTurn))])
		}
		/*End of calculator code*/
		private function drawDomino(ev:DominoDraw):void{
			if((leftDominoKeys.length<1) || (isInTransaction()) || (!gameInProgress))	return;
			var key:Object = leftDominoKeys.shift()
			dominoGraphic.dominoesDelayed.push(key)
			doStoreState([UserEntry.create({type:DominoDraw.DOMINO_DRAW,playerId:myUserId,moveNum:dominoLogic.getMoveNum()},ev)],[revealKeyTo(key,myUserId)])
		}
		private function passTurn(ev:DominoPass):void{
			if(gameInProgress) doStoreState([UserEntry.create({type:DominoPass.DOMINO_PASS,playerId:myUserId,moveNum:dominoLogic.getMoveNum()},ev)])
		}
		private function makeMove(ev:DominoMove):void{	
			if(gameInProgress)	doStoreState([UserEntry.create(ev.getKey(),ev)])
		}
		
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void{
			this.allPlayerIds = allPlayerIds;
			gameInProgress = true;
			Tools.setGamePoint(_graphics.localToGlobal(new Point()))
			Tools.setGameScale(dominoGraphic.scaleX,dominoGraphic.scaleY)
			passCount = 0;
			currentTurn = -1;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId, -1) as int;	
			var isViewer:Boolean = allPlayerIds.indexOf(myUserId) == -1
			var rivalUserIds:Array = []
			if(isViewer){
				rivalUserIds = allPlayerIds.concat();
			}else{
				rivalUserIds.push(allPlayerIds.indexOf(myUserId)==0?allPlayerIds[1]:allPlayerIds[0])
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
						if(revealTo<allPlayerIds.length)
							revealEntries.push(revealKeyTo(key,allPlayerIds[revealTo]));
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
				for each(var serverEntry:ServerEntry in serverEntries){
					if(serverEntry.value is DominoMove){
						dominoLogic.putBrick(serverEntry.value as DominoMove)
					}else if(serverEntry.value is PlayerTurn){
						var playerTurn:PlayerTurn = serverEntry.value as PlayerTurn
						setTurn(playerTurn)
					}else if(!(serverEntry.key is String)){
						if(serverEntry.key.type == DOMINO_CUBE){	
							dominoLogic.takeDominoBrick(serverEntry)
						}
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
		private function setTurn(playerTurn:PlayerTurn):void{
			currentTurn = playerTurn.playerTurn
			var userTurn:int = allPlayerIds[currentTurn]
			if(allPlayerIds.length == 1)	userTurn = myUserId // todo: replace this with single player
			dominoLogic.setTurn(userTurn)
			doAllSetTurn(userTurn)
		}
		
		override public function gotStateChanged(serverEntries:Array):void{
			var serverEntry:ServerEntry = serverEntries[0];
			if(serverEntries.length == (dominoLogic.dominoAmount+1)){//bricks recieved in first deal
				serverEntry =  serverEntries.shift();
				for each(serverEntry in serverEntries){
					dominoLogic.takeDominoBrick(serverEntry)
				}
			}else if(serverEntry.value is PlayerTurn){//set turn to a specific player
				var playerTurn:PlayerTurn = serverEntry.value as PlayerTurn
				setTurn(playerTurn)
			}else if(serverEntry.value is DominoMove){//got a player move
				passCount = 0;
				dominoLogic.putBrick(serverEntry.value as DominoMove)
				if(gameInProgress) doStoreState([UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(getNextTurn()))])
			}else if(serverEntry.value is DominoDraw){
				serverEntry = serverEntries[1];
				removeKey(serverEntry.key);
				dominoLogic.takeDominoBrick(serverEntry)
			}else if(serverEntry.value is DominoPass){
				if(passCount == 1)	declareWinner(new WinnerEvent(-1))
				if(gameInProgress) doStoreState([UserEntry.create({type:"PlayerTurn"},PlayerTurn.create(getNextTurn()))])
				if(dominoGraphic.isNoMoreDomino())	passCount++;
				
			}
			
			
		}
		
	}
}