package come2play_as3.cheat
{
	import come2play_as3.CardChange;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cards.CardsAPI;
	import come2play_as3.cheat.ServerClasses.CardsToHold;
	import come2play_as3.cheat.events.CardClickedEvent;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	import come2play_as3.cheat.events.MenuClickEvent;
	import come2play_as3.cheat.events.PutCardsEvent;
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
		private var middleCards:MiddleCards
		private var lowerBackground:LowerBackground =  new LowerBackground()
		private var myGraphics:MovieClip = new MovieClip()
		private var upperBackground:UpperBackground = new UpperBackground
		private var cardDeck:CardDeck
		private var cardHands:Array/*CardHand*/
		private var myHand:CardHand;
		private var rivalHand:CardHand;
		private var myUserId:int;
		private var isPlayer:Boolean
		
		private var drawingCards:Array
		private var isDrawingPlayer:Boolean
		private var currentTurn:int
		public function CheatGraphics()
		{
			addChild(lowerBackground)
			addChild(myGraphics)
			addChild(upperBackground)
			cardDeck = new CardDeck()
			gameMessage =new GameMessage()
			menuController = new MenuController()
			AS3_vs_AS2.myAddEventListener("menuController",menuController,MenuClickEvent.MENU_EVENT,menuAction)

		}
		public function init(isPlayer:Boolean,myUserId:int):void{
			this.myUserId = myUserId;
			this.isPlayer = isPlayer;
			scaleX = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameWidth,400) as int)/550 
			scaleY = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameHeight,400) as int)/450 
			
			upperBackground.actionExpected_txt.text =  T.i18n("Starting Game");
			myGraphics.addChild(cardDeck)
			cardDeck.x = 500;
			cardDeck.y = 200;
			middleCards = new MiddleCards()
			
			myHand = isPlayer?new YourHand():new CardHand()
			rivalHand = new CardHand()
			drawingCards = [[],[]]
			AS3_vs_AS2.myAddEventListener("CardHand",rivalHand,CardDrawEndedEvent.CARD_DRAW_ENDED,cardDrawn)
			AS3_vs_AS2.myAddEventListener("CardHand",myHand,CardDrawEndedEvent.CARD_DRAW_ENDED,cardDrawn)
			myGraphics.addChild(rivalHand) 	
			myGraphics.addChild(myHand)
			myGraphics.addChild(middleCards)
			
		}
		private function getEventCard(cardData:CardChange,isPlayer:Boolean):CardGraphic{
			var card:CardGraphic = new CardGraphic(cardData.cardKey,isPlayer?cardData.card:null)
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
				dispatchEvent(new PutCardsEvent([ev.cardData]));
				myHand.myTurn(false)
				return;
			}	
			if(middleCards.removeCard(ev.cardKey)!=null){
				myHand.drawCard(card)
			}else if(middleCards.haveMax()){
				return;
			}else if(myHand.removeCard(ev.cardKey)!=null){
				middleCards.pickCard(card)
			}	
		}
		public function putFirst(cardChange:CardChange,isPlayer:Boolean):void{
			var removeFromHand:CardHand = isPlayer?myHand:rivalHand;
			var cardGraphic:CardGraphic = removeFromHand.removeCard(cardChange.cardKey)
			if(cardGraphic==null)	return
			cardGraphic.setCard(cardChange.card)
			middleCards.putFirst(cardGraphic)
		}
		
		private var isDrawing:Boolean
		public function drawCard(card:CardChange,isPlayer:Boolean):void{
			upperBackground.actionExpected_txt.text = T.i18n("Drawing Cards")
			var drawTo:Array = drawingCards[isPlayer?0:1]
			drawTo.push(card)
			if(isDrawing)	return
			isDrawing = true;
			drawCardGraphic();
		}
		public function putKeysInMiddle(cardsToHold:CardsToHold):void{
			middleCards.setCardValue(cardsToHold.declaredValue);
			var cardGraphic:CardGraphic 
			for each(var cardKey:CardKey in cardsToHold.keys){
				cardGraphic = rivalHand.removeCard(cardKey)
				if(cardGraphic==null)	cardGraphic = middleCards.removeCard(cardKey)
				middleCards.addCard(cardGraphic)
			}
			if(myUserId == currentTurn){
				menuController.showCheatChoiseMenu()
				addChild(menuController)
				
			}
		}
		
		private function drawCardGraphic():void{		
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
			
			if(cardChange!=null){
				drawHand.drawCard(getEventCard(cardChange,isDrawingPlayer))
				isDrawingPlayer = !isDrawingPlayer;
			}else{
				//finsih drawing
				isDrawing = false;
				finishedDrawing()
				//dispatchEvent(new CardDrawEndedEvent())
			}
			
		}
		
		public function finishedDrawing():void{
			if(currentTurn == myUserId){
				myHand.myTurn(true)
				if(middleCards.noDeck()){
					myGraphics.addChild(gameMessage)
					gameMessage.chooseCard();
				}else{
					myGraphics.addChild(gameMessage)
					gameMessage.chooseCards();
					myGraphics.addChild(menuController)
					menuController.showCardChoiseMenu();		
				}
			}else{
				myHand.myTurn(false)
			}
				
		}
		private function menuAction(ev:MenuClickEvent):void{
			switch(ev.action){
				case MenuClickEvent.DRAW_CARD:
					CardsAPI.cardsData.drawCards([myUserId],1,false)
				break;
				case MenuClickEvent.DECLARE_HIGHER:
					dispatchEvent(CardsToHold.create(middleCards.getCardKeys(),middleCards.getCardValue()+1))
				break;
				case MenuClickEvent.DECLARE_LOWER:
					dispatchEvent(CardsToHold.create(middleCards.getCardKeys(),middleCards.getCardValue()-1))
				break;
			}
			removeMyChild(gameMessage);
			removeMyChild(menuController);
		}
		private function cardDrawn(ev:CardDrawEndedEvent):void{
			drawCardGraphic();
		}
		public function setTurn(userId:int):void{
			currentTurn = userId
			if(isPlayer){
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