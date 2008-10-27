package come2play_as3.cheat
{
	
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
					doStoreState([ UserEntry.create({type:"PlayerCall",playerId:myUserId},PlayerCall.create(myUserId,lastCall+1))]);
				break;
				case "downNum":
					chooseCards(false);
					putInCenter(choosenCards,false);
					doStoreState([ UserEntry.create({type:"PlayerCall",playerId:myUserId},PlayerCall.create(myUserId,lastCall-1))]);
				break;
				case "callCheater":
				cheatGraphics.clear();
				doStoreState([UserEntry.create(CheatTypeClass.create(myUserId,CheatTypeClass.CALLCHEATER),CallCheater.create(myUserId,true))])
				break;
				case "trust":
				cheatGraphics.clear();
				doStoreState([UserEntry.create(CheatTypeClass.create(myUserId,CheatTypeClass.CALLCHEATER),CallCheater.create(myUserId,false))])
				break;
				case "ok":
				cheatGraphics.clear();
				cheatGraphics.clearShownCards();
				doStoreState([UserEntry.create(CheatTypeClass.create(myUserId,CheatTypeClass.NEXTTURN),NextTurn.create())])
				break;
			}
		}
		private function setNextTurn():void
		{
			var turnPos:int = allPlayerIds.indexOf(playerIdTurn);
			turnPos ++;
			if(turnPos >= allPlayerIds.length)
				turnPos = 0;
			playerIdTurn = allPlayerIds[turnPos];
			setTrun();	
		}
		private function setTrun():void
		{
			turnReplays = 0;
			callCheater = null;
			cheatGraphics.clear();
			doAllSetTurn(playerIdTurn,10000);
			if(myUserId == playerIdTurn)
			{
				chooseCards(true);
				cheatGraphics.setMyTrun(lastCall);
			}
		}
		private function cardsShown(ev:CardShownEvent):void
		{
			cheatGraphics.clear();
			cheatGraphics.okMessage();
			allowPassingTurn = true;
		}
		override public function gotMiddleCards(revealdCards:Array/*PlayerCard*/):void
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
		override public function gotPlayerPutCardsSecret(keys:Array, playerId:int):void
		{
			cardsInMiddle = cardsInMiddle.concat(keys);
			lastCardsPutInMiddle = keys;
			cheatGraphics.clear();
			if(myUserId != playerIdTurn)
				cheatGraphics.callCheater();
			//setNextTurn();		
		}
		
		override public function gotCards(cards:Array/*Card*/):void
		{
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
			
			//doTrace("Rival "+rivalId,amountOfCards);
		}
		override public function gotMatchStarted2(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			cardsInMiddle = new Array();
			allowPassingTurn = false;
			this.allPlayerIds = allPlayerIds;
			cheatGraphics.initCheat();
			lastCall = 2;
			storeDecks(1,true);
			for each(var playerId:int in allPlayerIds)
				drawCards(int(54/allPlayerIds.length),playerId);
			playerIdTurn = allPlayerIds[0];
			setTrun();
				
		}
		override public function gotMatchLoaded(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{	
			cardsInMiddle = new Array();
			allowPassingTurn = false;
			this.allPlayerIds = allPlayerIds;
			cheatGraphics.initCheat();
			doTrace("me","Load match");
			//storeDecks(2,false);
			//drawCards(3,allPlayerIds[0])
		}
		override public function gotStateChangedNoCards(serverEntries:Array):void
		{
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.value is PlayerCall)
				{
					var playerCall:PlayerCall = serverEntry.value as PlayerCall;
					if(( (playerCall.callNum == 13) && (playerCall.callNum == 1)) ||
						( (playerCall.callNum == 1) && (playerCall.callNum == 13)) ||
						(Math.abs(lastCall - playerCall.callNum) == 1) )
						{
							if(playerCall.playerId !=serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,"tried to send a message on someone elses name");
							lastCall = playerCall.callNum;
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
								setNextTurn();
						}

				}
				else if(serverEntry.value is NextTurn)
				{
					if(allowPassingTurn)
					{
						allowPassingTurn = false;
						cheatGraphics.clearShownCards();
						setNextTurn();
					}
				}
			}
		}
	}
}