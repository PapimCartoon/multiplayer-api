package come2play_as3.cheat
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.ErrorHandler;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.cards.Card;
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

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
		private var isViewer:Boolean
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
		
		private var soundChannel:SoundChannel
		private var backgroundSound:BackgroundLoop
		private var soundController:SoundController
		private var isCheaterLock:Boolean
		private var waitingCards:Array
		private var waitingActions:Array
		
		private var myTimeouts:Dictionary;
		public function CheatGraphics()
		{
			addChild(lowerBackground)
			addChild(myGraphics)
			addChild(upperBackground)
			myTimeouts = new Dictionary();
			backgroundSound = new  BackgroundLoop()	
			soundChannel = backgroundSound.play(0,100);
			soundChannel.soundTransform = new SoundTransform(0.30)
			cardDeck = new CardDeck()
			gameMessage =new GameMessage(soundChannel)
			menuController = new MenuController()
			soundController = new SoundController()
			soundController.stop();
			soundController.buttonMode = true;
			soundController.x = 475;
			soundController.y = 3
			upperBackground.addChild(soundController)
			AS3_vs_AS2.myAddEventListener("menuController",menuController,MenuClickEvent.MENU_EVENT,menuAction)
			AS3_vs_AS2.myAddEventListener("cardDeck",cardDeck,MenuClickEvent.MENU_EVENT,menuAction)
			AS3_vs_AS2.myAddEventListener("menuController",menuController,"JokerValue",jokerAction)
			
			AS3_vs_AS2.myAddEventListener("soundController",soundController,MouseEvent.CLICK,changeSound)
			
			
			
		}
		private function changeSound(ev:MouseEvent):void{
			if(soundController.currentFrame == 1){
				soundController.gotoAndStop(2)
				soundChannel.soundTransform = new SoundTransform(0)
			}else{
				soundController.gotoAndStop(1)
				soundChannel.soundTransform = new SoundTransform(0.30)
			}
			
		}
		
		public function init(isViewer:Boolean,myUserId:int,rivalId:int):void{
			waitingCards = []
			waitingActions = []
			isPlaying = true;
			turnNumber = 1;
			lastCardHold = null
			this.isViewer = isViewer;
			this.myUserId = myUserId;
			this.rivalId = rivalId;
			scaleX = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameWidth,400) as int)/550 
			scaleY = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameHeight,400) as int)/450 
			
			upperBackground.actionExpected_txt.text =  T.i18n("Starting Game");
			myGraphics.addChild(cardDeck)
			cardDeck.x = 480;
			cardDeck.y = 215;
			
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
			if(isViewer)	myHand.endY = 400
			
			
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
		private function canPerformAutoTrust(arr:Array,ev:Event):Boolean{
			if(isCheaterLock){
				menuController.stopCheatTimer()
				isCheaterLock = false;
				cardDeck.canDraw(false)
				myHand.myTurn(false)
				arr.push(ev)
				dispatchEvent(CallCheater.create(false,myUserId))
				return true;
			}
			return false
		}
		
		
		private function clickedCard(ev:CardClickedEvent):void{
			if(isViewer)	return
			if(canPerformAutoTrust(waitingCards,ev))	return
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
			var middleCardAmount:int = middleCards.choosenAmount();
			cardDeck.canDraw(middleCardAmount == 0)
			menuController.setMiddleAmount(middleCardAmount)
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
				myTimeouts["amIRight"] = ErrorHandler.myTimeout("amIRight",function():void{
					if(!isViewer){
						gameMessage.amIRight(isUserCheater,lastCardHold.cheatingUser == myUserId,rivalId)
						myGraphics.addChild(gameMessage)
						CardsAPI.cardsData.takeCardsToHand(middleCards.getThrownIds(),isUserCheater?lastCardHold.cheatingUser:lastCardHold.callingUser)
					}
					lastCardHold = null;
					takeCards = true;
					delete myTimeouts["amIRight"];
					myTimeouts["endTakeThrownCards"] = ErrorHandler.myTimeout("endTakeThrownCards",function():void{
						CardsAPI.cardsData.animationEnded("takeThrownCards")
						delete myTimeouts["endTakeThrownCards"];
					},1500);
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
				takeCards = false;
				upperBackground.actionExpected_txt.text = T.i18n("Taking Cards")
				var releveantHand:CardHand
				var cardGraphic:CardGraphic
				var isMe:Boolean
				for each(cardChange in cards){
					isMe = (cardChange.userId == myUserId)
					releveantHand = isMe?myHand:rivalHand
					var viewerReleveantHand:CardHand = isMe?rivalHand:myHand
					if(!releveantHand.updateData(cardChange)){	
						cardGraphic = middleCards.removeThrownCard(cardChange.card)
						if((isMe) || (rivalId !=0)){
							if((cardGraphic==null) && (isViewer)){
								continue;
							}
							cardGraphic.setCard(cardChange.card)
						}else{
							cardGraphic.setCardData(cardChange.card)
						}
						cardGraphic.setKey(cardChange.cardKey)
						cardsToDraw.push(cardGraphic)	
					}		
				}
				for each(cardGraphic in cardsToDraw){
					releveantHand.drawCard(cardGraphic,false)
				}
				CardsAPI.cardsData.animationStarted("drawCards")
				myTimeouts["drawCards"] = ErrorHandler.myTimeout("CheatGraphics",function():void{
					CardsAPI.cardsData.animationEnded("drawCards")
					delete myTimeouts["drawCards"]
				},(cardsToDraw.length + 1) * 200)
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
				if((isViewer) && (cardGraphic==null)){
					cardGraphic = myHand.removeCard(cardKey)
				}
				if(cardGraphic!=null){
					cardGraphic.setCardData(null)
					cardGraphic.setValue(cardsToHold.declaredValue)
					cardGraphic.startFlip()
					middleCards.addCard(cardGraphic)
				}
			}
			if(isViewer){
				
			}else if(myUserId == currentTurn){
				var rivalCards:Array = CardsAPI.cardsData.getCardsInUserHand(rivalId)
				menuController.showCheatChoiseMenu(cardsToHold,rivalHand.getCardCount()!=0)
				if(rivalHand.getCardCount() != 0){
					isCheaterLock = true;
					myHand.myTurn(true)
					cardDeck.canDraw(true)
				}
				myGraphics.addChild(menuController)	
			}else{
				var isMoveCheat:Boolean = middleCards.isMoveCheat(cardsToHold.declaredValue)
				gameMessage.willCallBluff(isMoveCheat,rivalId)
				myGraphics.addChild(gameMessage)
				if(rivalId == 0){
					var isComputerCallCheat:Boolean
					var rand:int = Math.random()*10
					if(myHand.getCardCount() == 0){
						isComputerCallCheat = true;
					}else if(isMoveCheat){
						if(rand<=(cardsToHold.keys.length + 2))	isComputerCallCheat = true;
					}else{
						if(rand<=cardsToHold.keys.length)	isComputerCallCheat = true;
					}
					myTimeouts["CallCheater"] = ErrorHandler.myTimeout("CallCheater",function():void{
						delete myTimeouts["CallCheater"];
						dispatchEvent(CallCheater.create(isComputerCallCheat,rivalId))
					},isMoveCheat?2000:1000)
				}
			}
		}
		public function callCheater(callCheater:CallCheater):void{
			menuController.stopCheatTimer()
			isCheaterLock = false;
			removeMyChild(gameMessage)
			if(callCheater.isCheater){
				CardsAPI.cardsData.putCards(lastCardHold.keys,callCheater.callingUser == myUserId)
			}else{
				if(isViewer){
					bluffSuccessEnd()
				}if((lastCardHold.cheatingUser == myUserId) && (middleCards.isMoveCheat(lastCardHold.declaredValue))){
					myGraphics.addChild(gameMessage)
					gameMessage.bluffSuccess();
					myTimeouts["bluffSuccessEnd"] = ErrorHandler.myTimeout("bluffSuccessEnd",bluffSuccessEnd,1000)
				}else{
					bluffSuccessEnd()
					for(var i:int=0;i<waitingCards.length;i++)
						clickedCard(waitingCards[i])
					for(i=0;i<waitingActions.length;i++)
						menuAction(waitingActions[i])
					waitingActions = []
					waitingCards = []
				}
				
				
			}
		}
		private function bluffSuccessEnd():void{
			delete myTimeouts["bluffSuccessEnd"];
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
			if(isViewer)	return
			if(currentTurn == myUserId){
				myHand.myTurn(true)
				if(middleCards.noDeck()){
					myGraphics.addChild(gameMessage)
					gameMessage.chooseCard();
				}else{
					myGraphics.addChild(menuController)
					menuController.showCardChoiseMenu(middleCards.getCardValue());	
					cardDeck.canDraw(true)	
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
					myTimeouts["doComputerMove"] = ErrorHandler.myTimeout("doComputerMove",doComputerMove,1000)
				}else{
					removeMyChild(gameMessage);
					myHand.myTurn(false)
				}
				
			}
				
		}
		private function doComputerMove():void{
			delete myTimeouts["doComputerMove"]
			myHand.myTurn(false)
			removeMyChild(gameMessage);
			if(middleCards.noDeck()){
				var cardKey:CardKey = rivalHand.getRandomNewCard([])
				if(cardKey == null)	return;
				var cardData:Card = rivalHand.getCardData(cardKey)
				if(cardData.value == 14){
					CardsAPI.cardsData.putCards([cardKey],false,JokerValue.create(Math.random()*13+1,cardKey))
				}else{
					CardsAPI.cardsData.putCards([cardKey],false)
				}
			}else{
				var computerMoveArr:Array = []
				var isHigher:Boolean = (int(Math.random()*2)) == 1
				computerMoveArr = rivalHand.getComputerMove(middleCards.getCardValue() + (isHigher?1:-1))
				if(computerMoveArr.length == 0){
					isHigher = !isHigher;
					computerMoveArr = rivalHand.getComputerMove(middleCards.getCardValue() + (isHigher?1:-1))
				}
				if(computerMoveArr.length == 0){
					computerMoveArr = rivalHand.getRandomComputerMove();
					if(rivalHand.getCardCount() == computerMoveArr.length)	computerMoveArr.pop();	
				} 
				if(computerMoveArr.length>0){
					dispatchEvent(CardsToHold.create(computerMoveArr,middleCards.getCardValue()+ (isHigher?1:-1),rivalId,myUserId))
				}else{
					CardsAPI.cardsData.singlePlayerDrawCards(true,1,false);
				}
			}
		}	
		private function removeMenuController():void{
			menuController.close()
		}
		public function gameEnded():void{
			for(var str:String in myTimeouts){
				ErrorHandler.myClearTimeout(str,myTimeouts[str])
			}
			myTimeouts = new Dictionary();
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
					if(canPerformAutoTrust(waitingActions,ev))	return
					if(middleCardsNum!=0)	return;
					if(cardDeck.availableCards == 0)	return;
					myHand.myTurn(false)
					if(rivalId == 0){
						CardsAPI.cardsData.singlePlayerDrawCards(false,1,false);
					}else{
						CardsAPI.cardsData.drawCards([myUserId],1,false)
					}
				break;
				case MenuClickEvent.DECLARE_HIGHER:
				if(middleCardsNum==0)	return;
					myHand.myTurn(false)
					dispatchEvent(CardsToHold.create(middleCards.getCardKeys(),middleCards.getCardValue()+1,myUserId,rivalId))
				break;
				case MenuClickEvent.DECLARE_LOWER:
					if(middleCardsNum==0)	return;
					myHand.myTurn(false)
					dispatchEvent(CardsToHold.create(middleCards.getCardKeys(),middleCards.getCardValue()-1,myUserId,rivalId))
				break;
				//recieving player
				case MenuClickEvent.DO_NOT_CALL_CHEATER:
					isCheaterLock = false;
					dispatchEvent(CallCheater.create(false,myUserId))
				break;
				case MenuClickEvent.CALL_CHEATER:
					isCheaterLock = false;
					dispatchEvent(CallCheater.create(true,myUserId))
				break;
				
			}
			removeMyChild(gameMessage);
			cardDeck.canDraw(false)
			removeMenuController()
		}
		public function setTurn(userId:int):void{
			currentTurn = userId
			if(currentTurn == myUserId){
				if(userId == myUserId){
					upperBackground.actionExpected_txt.text = T.i18n("Your turn");
				}else{
					var userName:String = GameMessage.getUserName(userId)
					upperBackground.actionExpected_txt.text = T.i18nReplace("$userName$'s turn",{userName:userName});
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