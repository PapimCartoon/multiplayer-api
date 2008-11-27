package come2play_as3.cheat
{
	
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cards.PlayerCard;
	import come2play_as3.cards.connectionClasses.CardTypeClass;
	import come2play_as3.cards.events.CardShownEvent;
	import come2play_as3.cards.events.GraphicButtonClickEvent;
	import come2play_as3.cheat.connectionClasses.CallCheater;
	import come2play_as3.cheat.connectionClasses.CheatTypeClass;
	import come2play_as3.cheat.connectionClasses.NextTurn;
	import come2play_as3.cheat.connectionClasses.PlayerCall;
	
	import flash.display.MovieClip;

	public class CheatMain extends CardsAPI
	{
		private var cheatGraphics:CheatGraphic;
		private var cardsInMiddle:Array;/*CardTypeClass*/
		private var lastCardsPutInMiddle:Array;/*CardTypeClass*/
		private var allPlayerIds:Array;/*int*/
		private var choosenCards:Array;
		private var lastCall:int;
		private var playerIdTurn:int;
		private var turnReplays:int;
		private var callCheater:CallCheater;
		private var allowPassingTurn:Boolean;
		private var isShowingCards:Boolean;
		private var playerCards:Array;
		private var loading:Boolean;
		public function CheatMain(graphics:MovieClip)
		{
			(new PlayerCall).register();
			(new CallCheater).register();
			(new CheatTypeClass).register();
			(new NextTurn).register();
			cheatGraphics = new CheatGraphic();
			graphics.addChild(cheatGraphics);
			super(cheatGraphics);
			cheatGraphics.addEventListener(GraphicButtonClickEvent.GraphicButtonClick,graphicButtonClick,true);
			cheatGraphics.addEventListener(CardShownEvent.CardShown,cardsShown);
			doRegisterOnServer();
		}	
		
		private function graphicButtonClick(ev:GraphicButtonClickEvent):void
		{
			switch(ev.name)
			{
				case "upNum":
					chooseCards(false);
					putInCenter(choosenCards,false);
					doStoreState([ UserEntry.create({type:"PlayerCall",playerId:myUserId},PlayerCall.create(myUserId,lastCall+1,choosenCards.length))]);
				break;
				case "downNum":
					chooseCards(false);
					putInCenter(choosenCards,false);
					doStoreState([ UserEntry.create({type:"PlayerCall",playerId:myUserId},PlayerCall.create(myUserId,lastCall-1,choosenCards.length))]);
				break;
				case "callCheater":
				minimizeMessageBox();
				cheatGraphics.clear();
				doStoreState([UserEntry.create(CheatTypeClass.create(myUserId,CheatTypeClass.CALLCHEATER),CallCheater.create(myUserId,true))])
				break;
				case "trust":
				minimizeMessageBox();
				cheatGraphics.clear();
				doStoreState([UserEntry.create(CheatTypeClass.create(myUserId,CheatTypeClass.CALLCHEATER),CallCheater.create(myUserId,false))])
				break;
				case "ok":
				cheatGraphics.clear();
				clearCards();
				doStoreState([UserEntry.create(CheatTypeClass.create(myUserId,CheatTypeClass.NEXTTURN),NextTurn.create())])
				break;
			}
		}
		private function minimizeMessageBox():void
		{
			cheatGraphics.appendToPlayer(allPlayerIds.indexOf(playerIdTurn))
		}
		
		private function clearCards():void
		{
			if(isShowingCards)
			{
				cheatGraphics.clearShownCards();
				isShowingCards = false;
				if((myUserId == playerIdTurn) && (!allowPassingTurn))
				{
					chooseCards(true);
					cheatGraphics.setMyTrun(lastCall);
				}
			}
		}
		
		private function isMatchOver(playerId:int):void
		{
			var turnPos:int = allPlayerIds.indexOf(playerId);
			if (playerCards[turnPos] == 0)
			{
				allPlayerIds.splice(turnPos,1);
				playerCards.splice(turnPos,1);
				if(allPlayerIds.length == 1)
				{
					doAllEndMatch([PlayerMatchOver.create(playerId,30*allPlayerIds.length,100)]); 
					doAllEndMatch([PlayerMatchOver.create(allPlayerIds[0],0,0)]); 
				}
				else
					doAllEndMatch([PlayerMatchOver.create(playerId,30*allPlayerIds.length,70)]); 
			}
		}
		
		private function setNextTurn(clearBox:Boolean):void
		{
			
			var turnPos:int = allPlayerIds.indexOf(playerIdTurn);
			turnPos ++;
			if(turnPos >= allPlayerIds.length)
				turnPos = 0;
			var lastId:int = playerIdTurn;
			playerIdTurn = allPlayerIds[turnPos];
			isMatchOver(lastId);
			setTrun(clearBox);	
		}
		private function setTrun(clearBox:Boolean):void
		{
			turnReplays = 0;
			callCheater = null;
			if(clearBox) cheatGraphics.clear();				
			doAllSetTurn(playerIdTurn,-1);
			if((myUserId == playerIdTurn) && (clearBox || (!isShowingCards)))
			{
				chooseCards(true);
				cheatGraphics.setMyTrun(lastCall);
			}
		}
		private function cardsShown(ev:CardShownEvent):void
		{
			cheatGraphics.clear();
			cheatGraphics.okMessage();
			isShowingCards = true;
			allowPassingTurn = true;
		}
		override public function revealMiddleCards(revealdCards:Array/*PlayerCard*/):void
		{
			var foundCheater:Boolean = false;
			for each(var playerCard:PlayerCard in revealdCards)
			{
				if( (playerCard.card.value !=100) && (playerCard.card.value != lastCall))
					foundCheater = true;
			}
			if(!foundCheater)
				takeCardsFromMiddle(callCheater.callerId,cardsInMiddle);
			else
				takeCardsFromMiddle(playerIdTurn,cardsInMiddle);
			cardsInMiddle = new Array();	
		}
		override public function gotPlayerPutCardsInMiddleHidden(keys:Array, playerId:int):void
		{
			cardsInMiddle = cardsInMiddle.concat(keys);
			lastCardsPutInMiddle = keys;
			cheatGraphics.clear();
			playerCards[allPlayerIds.indexOf(playerId)]-=keys.length;
			if(loading)
			{
				loading = false;
				setNextTurn(true);
				return;
			}
			if(myUserId != playerIdTurn)
			{
				cheatGraphics.callCheater();
			}
			//setNextTurn();		
		}
		
		override public function gotCards(cards:Array/*Card*/):void
		{
			playerCards[allPlayerIds.indexOf(myUserId)]+=cards.length;
			//doTrace("me :"+myUserId,JSON.stringify(cards))
		}
		override public function gotChoosenCards(choosenCards:Array):void
		{
			this.choosenCards = choosenCards;
			if(choosenCards.length >= 1)
				cheatGraphics.enableButtons = true;
			else
				cheatGraphics.enableButtons = false;
			
			if(choosenCards.length == 6)
				CardDefenitins.canCardsBeSelected = false;	
			//putInCenter(choosenCards);
		}
		override public function rivalGotCards(rivalId:int, amountOfCards:int):void
		{
			playerCards[allPlayerIds.indexOf(rivalId)]+=amountOfCards;
			//doTrace("Rival "+rivalId,amountOfCards);
		}
		override public function gotNewMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			var cardsToDeal:int = 54/allPlayerIds.length;
			cardsInMiddle = new Array();
			playerCards = new Array();
			allowPassingTurn = false;
			this.allPlayerIds = allPlayerIds;
			cheatGraphics.initCheat();
			lastCall = 2;
			storeDecks(1,true);
			for each(var playerId:int in allPlayerIds)
			{
				playerCards[allPlayerIds.indexOf(playerId)] = 0;
				drawCards(cardsToDeal,playerId);
			}
			playerIdTurn = allPlayerIds[0];
			setTrun(true);
				
		}
		override public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{	
			var playerCall:PlayerCall;
			var time:int = 0;
			loading = true;
			cardsInMiddle = new Array();
			playerCards = new Array();
			allowPassingTurn = false;
			this.allPlayerIds = allPlayerIds;
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.value is PlayerCall)
				{
					if(time<serverEntry.changedTimeInMilliSeconds)
					{
						time = serverEntry.changedTimeInMilliSeconds
						playerCall = serverEntry.value as PlayerCall;
						lastCall = playerCall.callNum;
						playerIdTurn = playerCall.playerId;
					}
				}
			}
			cheatGraphics.initCheat();
			if(serverEntries.length == 0)
			{
				lastCall = 2;
				playerIdTurn = allPlayerIds[0];
				setTrun(true);
			}
			
			
		}
		override public function gotStateChangedNoCards(serverEntries:Array):void
		{
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.value is PlayerCall)
				{
					clearCards();
					var playerCall:PlayerCall = serverEntry.value as PlayerCall;
					if(( (playerCall.callNum == 13) && (playerCall.callNum == 1)) ||
						( (playerCall.callNum == 1) && (playerCall.callNum == 13)) ||
						(Math.abs(lastCall - playerCall.callNum) == 1) )
						{
							if(playerCall.playerId !=serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,"tried to send a message on someone elses name");
							if(playerCall.callNum > 13)
								lastCall = 1
							else if(playerCall.callNum < 1)
								lastCall = 13
							else
								lastCall = playerCall.callNum;
							if(playerIdTurn == myUserId)
								cheatGraphics.removeMessageBox()
							else
								cheatGraphics.putCall(playerCall)			
						}
						else
							doAllFoundHacker(serverEntry.storedByUserId,"tryed to cheat with his call");
				}
				else if(serverEntry.value is CallCheater)
				{
					if(callCheater != null)
						if(callCheater.isCheater)
							return
					callCheater = serverEntry.value as CallCheater;
					
					if(callCheater.callerId !=serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,"tried to send a message on someone elses name");
						if(callCheater.isCheater)
						{
							var revealEntries:Array = new Array();
							for each(var key:CardTypeClass in lastCardsPutInMiddle)
								revealEntries.push(RevealEntry.create(key,null));
							doAllRevealState(revealEntries);
							cheatGraphics.clear();
						}
						else
						{
							turnReplays++;
							if(turnReplays == (allPlayerIds.length-1))
								setNextTurn(true);
						}

				}
				else if(serverEntry.value is NextTurn)
				{
					if(allowPassingTurn)
					{
						allowPassingTurn = false;
						setNextTurn(false);
					}
				}
			}
		}
	}
}