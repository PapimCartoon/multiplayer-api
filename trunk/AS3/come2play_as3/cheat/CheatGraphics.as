package come2play_as3.cheat
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.ErrorHandler;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cards.CardChange;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cheat.ServerClasses.CallCheater;
	import come2play_as3.cheat.ServerClasses.CardsToHold;
	import come2play_as3.cheat.ServerClasses.JokerValue;
	import come2play_as3.cheat.ServerClasses.PlayerTurn;
	import come2play_as3.cheat.events.CardClickedEvent;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	import come2play_as3.cheat.events.MenuClickEvent;
	import come2play_as3.cheat.graphics.CardDeck;
	import come2play_as3.cheat.graphics.CardGraphic;
	import come2play_as3.cheat.graphics.CardHand;
	import come2play_as3.cheat.graphics.GameMessage;
	import come2play_as3.cheat.graphics.MenuController;
	import come2play_as3.cheat.graphics.MiddleCards;
	import come2play_as3.cheat.graphics.YourHand;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class CheatGraphics extends MovieClip
	{
		private var gameMessage:GameMessage
		private var menuController:MenuController;
		private var lowerBackground:LowerBackground =  new LowerBackground()
		private var myGraphics:MovieClip = new MovieClip()
		private var upperBackground:UpperBackground = new UpperBackground
		private var cardDeck:CardDeck
		
		private var middleCards:MiddleCards
		private var rivalHand:CardHand;
		private var myHand:CardHand;
	
		private var myUserId:int;
		private var rivalId:int
		private var turnNumber:int
		private var drawingCards:Array
		private var isDrawingPlayer:Boolean
		private var currentTurn:int
		private var isDrawing:Boolean
		private var lastCardHold:CardsToHold
		private var takeCards:Boolean
		private var isPlaying:Boolean
		
		public function CheatGraphics()
		{
			addChild(lowerBackground)
			addChild(myGraphics)
			addChild(upperBackground)
			cardDeck = new CardDeck()
			gameMessage =new GameMessage()
			menuController = new MenuController()
			AS3_vs_AS2.myAddEventListener("menuController",menuController,MenuClickEvent.MENU_EVENT,menuAction)
			AS3_vs_AS2.myAddEventListener("menuController",menuController,"JokerValue",jokerAction)
			
			
		}
		public function init(isViewer:Boolean,myUserId:int,rivalId:int):void{
			isPlaying = true;
			turnNumber = 1;
			lastCardHold = null
			this.myUserId = myUserId;
			this.rivalId = rivalId;
			//scaleX = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameWidth,400) as int)/550 
			//scaleY = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameHeight,400) as int)/450 
			
			upperBackground.actionExpected_txt.text =  T.i18n("Starting Game");
			myGraphics.addChild(cardDeck)
			cardDeck.x = 480;
			cardDeck.y = 200;
			
			if(myHand!=null){
				myHand.clear()
				myGraphics.removeChild(myHand)
			}	
			if(rivalHand!=null)	{
				rivalHand.clear()
				myGraphics.removeChild(rivalHand)
			}
			if(middleCards!=null){
				middleCards.clear();
				myGraphics.removeChild(middleCards) 
			}
			
			middleCards = new MiddleCards()
			myHand = isViewer?new CardHand():new YourHand()
			rivalHand = new CardHand(rivalId == 0)
			drawingCards = [[],[]]
			AS3_vs_AS2.myAddEventListener("CardHand",rivalHand,CardDrawEndedEvent.CARD_DRAW_ENDED,drawCardGraphic)
			AS3_vs_AS2.myAddEventListener("CardHand",myHand,CardDrawEndedEvent.CARD_DRAW_ENDED,drawCardGraphic)
			myGraphics.addChild(rivalHand)
			myGraphics.addChild(middleCards) 	
			myGraphics.addChild(myHand)
			
			
		}
		private function getEventCard(cardData:CardChange,isPlayer:Boolean):CardGraphic{
			var card:CardGraphic = new CardGraphic(cardData.cardKey,cardData.card)
			AS3_vs_AS2.myAddEventListener("CardGraphic",card,CardClickedEvent.CARD_CLICKED,clickedCard)
			card.x = 510;
			card.y = 170;
			return card;
		}
		private function removeMyChild(disp:DisplayObject):void{
			if(disp.parent != null)	disp.parent.removeChild(disp)
		}	
		private function clickedCard(ev:CardClickedEvent):void{
			var card:CardGraphic = ev.target as CardGraphic
			removeMyChild(gameMessage)
			if(middleCards.noDeck()){//first turn in phase
				
				if(ev.cardData.value == 14){
					myGraphics.addChild(menuController)
					menuController.showJokerChoiceMenu(ev.cardKey)
				}else{
					CardsAPI.cardsData.putCards([ev.cardKey],true)
				}
				myHand.myTurn(false)
				return;
			}	
			if(middleCards.removeCard(ev.cardKey)!=null){
				myHand.drawCard(card,false)
			}else if(middleCards.choosenAmount()>5){
				return;
			}else if(myHand.removeCard(ev.cardKey)!=null){
				middleCards.pickCard(card)
			}else{
				StaticFunctions.assert(false,"should not happen");
			}	
			menuController.setMiddleAmount(middleCards.choosenAmount())
		}
		
		
		
		public function putFirst(cardChangeArr:Array/*CardChange*/,jokerValue:JokerValue = null):void{
			var cardChange:CardChange
			if(lastCardHold == null){
				setNextTurn()
				cardChange = cardChangeArr[0];
				var isPlayer:Boolean = (cardChange.userId == myUserId)
				var removeFromHand:CardHand = isPlayer?myHand:rivalHand;
				var cardGraphic:CardGraphic = removeFromHand.removeCard(cardChange.cardKey)
				if(cardGraphic==null)	return
				cardGraphic.setCard(cardChange.card);
				middleCards.putFirst(cardGraphic,jokerValue);
				finishedDrawing();
			}else{
				var isUserCheater:Boolean
				var claimValue:int = lastCardHold.declaredValue
				for each(cardChange in cardChangeArr){
					middleCards.revealCard(cardChange)
					if(cardChange.card.value == 14)	continue;
					if(claimValue == 14){	
						claimValue = cardChange.card.value;
					}else if(claimValue != cardChange.card.value){
						isUserCheater = true;
					}
				}
				CardsAPI.cardsData.animationStarted("takeThrownCards")
				ErrorHandler.myTimeout("CheatGraphics",function():void{
					gameMessage.amIRight(isUserCheater,lastCardHold.cheatingUser == myUserId)
					myGraphics.addChild(gameMessage)
					CardsAPI.cardsData.takeCardsToHand(middleCards.getThrownIds(),isUserCheater?lastCardHold.cheatingUser:lastCardHold.callingUser)
					lastCardHold = null;
					takeCards = true;
					ErrorHandler.myTimeout("CheatGraphics",function():void{
						CardsAPI.cardsData.animationEnded("takeThrownCards")
					},1000);
				},1000)
				
			}
		}
		public function drawCards(cards:Array/*CardChange*/):void{
			var cardChange:CardChange
			var cardsToDraw:Array = []
			if(!takeCards){
				setNextTurn()
				upperBackground.actionExpected_txt.text = T.i18n("Drawing Cards")
				for each(cardChange in cards)
					drawCard(cardChange)
				if(isDrawing)	return
				isDrawing = true;
				drawCardGraphic();
			}else{
				//return;
				takeCards = false;
				upperBackground.actionExpected_txt.text = T.i18n("Taking Cards")
				var releveantHand:CardHand
				var cardGraphic:CardGraphic
				for each(cardChange in cards){
					releveantHand = (cardChange.userId == myUserId)?myHand:rivalHand
					if(!releveantHand.updateData(cardChange)){	
						cardGraphic = middleCards.removeThrownCard(cardChange.card)
						cardGraphic.setCard(cardChange.card)
						cardGraphic.setKey(cardChange.cardKey)
						cardsToDraw.push(cardGraphic)	
					}		
				}
				for each(cardGraphic in cardsToDraw){
					releveantHand.drawCard(cardGraphic,false)
				}
				finishedDrawing()
			}	
		}
		private function drawCard(cardChange:CardChange):void{
			var isPlayer:Boolean = (cardChange.userId == myUserId)
			var drawTo:Array = drawingCards[isPlayer?0:1]
			drawTo.push(cardChange)
		}
		private function setNextTurn():void{
			turnNumber++
			dispatchEvent(PlayerTurn.create(myUserId,turnNumber))
		}
		
		public function putKeysInMiddle(cardsToHold:CardsToHold):void{
			setNextTurn()
			lastCardHold = cardsToHold
			middleCards.setCardValue(cardsToHold.declaredValue);
			var cardGraphic:CardGraphic 
			for each(var cardKey:CardKey in cardsToHold.keys){
				cardGraphic = rivalHand.removeCard(cardKey)
				if(cardGraphic!=null){
					cardGraphic.setCard(null)
					cardGraphic.setValue(cardsToHold.declaredValue)
					middleCards.addCard(cardGraphic)
				}
			}
			if(myUserId == currentTurn){
				var rivalCards:Array = CardsAPI.cardsData.getCardsInUserHand(rivalId)
				menuController.showCheatChoiseMenu(cardsToHold,rivalHand.getCardCount()!=0)
				myGraphics.addChild(menuController)	
			}else{
				var isMoveCheat:Boolean = middleCards.isMoveCheat(cardsToHold.declaredValue)
				gameMessage.willCallBluff(isMoveCheat)
				myGraphics.addChild(gameMessage)
				if(rivalId == 0){
					var rand:int = Math.random()*10
					if(isMoveCheat){
						if(rand>cardsToHold.keys.length)	isMoveCheat =!isMoveCheat;
					}else{
						if(rand==1)	isMoveCheat =!isMoveCheat;
					}
					dispatchEvent(CallCheater.create(isMoveCheat,rivalId))
				}
			}
		}
		public function callCheater(callCheater:CallCheater):void{
			removeMyChild(gameMessage)
			if(callCheater.isCheater){
				CardsAPI.cardsData.putCards(lastCardHold.keys,callCheater.callingUser == myUserId)
			}else{
				if(lastCardHold.cheatingUser == myUserId){
					myGraphics.addChild(gameMessage)
					middleCards.isMoveCheat(lastCardHold.declaredValue)
					gameMessage.bluffSuccess();
					ErrorHandler.myTimeout("bluffSuccess",bluffSuccessEnd,1000)
				}else{
					bluffSuccessEnd()
				}
				
				
			}
		}
		private function bluffSuccessEnd():void{
			middleCards.throwMiddle()
			finishedDrawing()
		}
		
		private function drawCardGraphic(ev:CardDrawEndedEvent=null):void{		
			var callEndFunc:Boolean = ev==null?false:ev.callFinishFunc;	
			var drawFrom:Array
			var cardChange:CardChange
			var drawHand:CardHand
			
			if((drawingCards[0].length > 0) && (drawingCards[1].length > 0)){
				drawFrom = drawingCards[isDrawingPlayer?0:1];
				cardChange = drawFrom.pop();
				drawHand = isDrawingPlayer?myHand:rivalHand;
			}else if(drawingCards[0].length > 0){
				isDrawingPlayer = true;
				drawFrom = drawingCards[0];
				cardChange = drawFrom.pop();
				drawHand = myHand;
			}else if(drawingCards[1].length > 0){
				isDrawingPlayer = false;
				drawFrom = drawingCards[1];
				cardChange = drawFrom.pop();
				drawHand = rivalHand;
			}
			if(cardChange==null){
				isDrawing = false;
				if(callEndFunc)	finishedDrawing()
			}else{
				drawHand.drawCard(getEventCard(cardChange,isDrawingPlayer),true)
				isDrawingPlayer = !isDrawingPlayer;
			}
			
		}
		
		public function finishedDrawing():void{
			if(currentTurn == myUserId){
				myHand.myTurn(true)
				if(middleCards.noDeck()){
					myGraphics.addChild(gameMessage)
					gameMessage.chooseCard();
				}else{
					myGraphics.addChild(menuController)
					menuController.showCardChoiseMenu(middleCards.getCardValue());		
				}
			}
			if(myHand.getCardCount() == 0){
				CardsAPI.cardsData.declareWinner(myUserId)
				return;
			}else if(rivalHand.getCardCount() == 0){
				CardsAPI.cardsData.declareWinner(rivalId == 0?myUserId:rivalId)
				return;
			}
			if(currentTurn != myUserId){
				if(rivalId == 0){
					myHand.myTurn(false)
					removeMyChild(gameMessage);
					if(middleCards.noDeck()){
						CardsAPI.cardsData.putCards([rivalHand.getRandomNewCard([],false)],false)
					}else{
						var computerMoveArr:Array = []
						var isHigher:Boolean = (int(Math.random()*2)) == 1
						computerMoveArr = rivalHand.getComputerMove(middleCards.getCardValue() + (isHigher?1:-1))
						if(computerMoveArr.length == 0){
							isHigher = !isHigher;
							computerMoveArr = rivalHand.getComputerMove(middleCards.getCardValue() + (isHigher?1:-1))
						}
						if(computerMoveArr.length == 0) computerMoveArr = rivalHand.getRandomComputerMove();
						if(computerMoveArr.length>0){
							dispatchEvent(CardsToHold.create(computerMoveArr,middleCards.getCardValue()+ (isHigher?1:-1),rivalId,myUserId))
						}else{
							CardsAPI.cardsData.singlePlayerDrawCards(true,1,false);
						}
					}
				}else{
					removeMyChild(gameMessage);
					myHand.myTurn(false)
				}
				
			}
				
		}
		private function removeMenuController():void{
			menuController.close()
		}
		public function gameEnded():void{
			isPlaying = false;
			myHand.myTurn(false);
			removeMyChild(gameMessage)
			removeMenuController()
		}
		private function jokerAction(ev:JokerValue):void{
			CardsAPI.cardsData.putCards([ev.cardKey],true,ev)
		}
		
		private function menuAction(ev:MenuClickEvent):void{
			if(!isPlaying)	return
			var middleCardsNum:int = middleCards.choosenAmount()
			switch(ev.action){
				//putting player
				case MenuClickEvent.DRAW_CARD:
					if(middleCardsNum!=0)	return;
					if(cardDeck.availableCards == 0)	return;
					if(rivalId == 0){
						CardsAPI.cardsData.singlePlayerDrawCards(false,1,false);
					}else{
						CardsAPI.cardsData.drawCards([myUserId],1,false)
					}
				break;
				case MenuClickEvent.DECLARE_HIGHER:
				if(middleCardsNum==0)	return;
					dispatchEvent(CardsToHold.create(middleCards.getCardKeys(),middleCards.getCardValue()+1,myUserId,rivalId))
				break;
				case MenuClickEvent.DECLARE_LOWER:
					if(middleCardsNum==0)	return;
					dispatchEvent(CardsToHold.create(middleCards.getCardKeys(),middleCards.getCardValue()-1,myUserId,rivalId))
				break;
				//recieving player
				case MenuClickEvent.DO_NOT_CALL_CHEATER:
					dispatchEvent(CallCheater.create(false,myUserId))
				break;
				case MenuClickEvent.CALL_CHEATER:
					dispatchEvent(CallCheater.create(true,myUserId))
				break;
				
			}
			removeMyChild(gameMessage);
			removeMenuController()
		}
		public function setTurn(userId:int):void{
			currentTurn = userId
			if(currentTurn == myUserId){
				if(userId == myUserId){
					upperBackground.actionExpected_txt.text = T.i18n("your turn");
				}else{
					upperBackground.actionExpected_txt.text = T.i18n("opponent turn");
				}		
			}else{
				upperBackground.actionExpected_txt.text = "";
			}
		}
		public function setDeckSize(size:int):void{
			cardDeck.setCards(size)
		}
		public function setRivalName(str:String):void{
			upperBackground.rivalName_txt.text = str
		}
		public function setUserName(str:String):void{
			upperBackground.yourName_txt.text = str
		}
		
	}
}