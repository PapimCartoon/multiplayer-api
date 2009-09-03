package come2play_as3.cheat
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	import come2play_as3.cheat.graphics.CardDeck;
	import come2play_as3.cheat.graphics.CardGraphic;
	import come2play_as3.cheat.graphics.CardHand;
	import come2play_as3.cheat.graphics.YourHand;
	
	import flash.display.MovieClip;

	public class CheatGraphics extends MovieClip
	{
		private var lowerBackground:LowerBackground =  new LowerBackground()
		private var myGraphics:MovieClip = new MovieClip()
		private var upperBackground:UpperBackground = new UpperBackground
		private var cardDeck:CardDeck
		private var cardHands:Array/*CardHand*/
		private var myHand:CardHand;
		private var rivalHand:CardHand;
		public function CheatGraphics()
		{
			addChild(lowerBackground)
			addChild(myGraphics)
			addChild(upperBackground)
			cardDeck = new CardDeck()

		}
		public function init(isPlayer:Boolean):void{
			scaleX = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameWidth,400) as int)/550 
			scaleY = ( T.custom(API_Message.CUSTOM_INFO_KEY_gameHeight,400) as int)/450 
			
			upperBackground.actionExpected_txt.text =  T.i18n("Starting Game");
			myGraphics.addChild(cardDeck)
			cardDeck.x = 510;
			cardDeck.y = 170;
			myHand = isPlayer?new YourHand():new CardHand()
			rivalHand = new CardHand()
			AS3_vs_AS2.myAddEventListener("rivalHand",rivalHand,CardDrawEndedEvent.CARD_DRAW_ENDED,rivalDrawn)
			AS3_vs_AS2.myAddEventListener("myHand",myHand,CardDrawEndedEvent.CARD_DRAW_ENDED,iHaveDrawn)
			myGraphics.addChild(rivalHand) 	
			myGraphics.addChild(myHand)
			
		}
		
		private function drawRivalCard():void{
			rivalCards.pop();
			var card:CardGraphic = new CardGraphic()
			card.x = 510;
			card.y = 170;
			rivalHand.drawCard(card)
		}
		private function drawMyCard():void{
			var card:CardGraphic = new CardGraphic(myCards.pop())
			card.x = 510;
			card.y = 170;
			myHand.drawCard(card)
		}
		
		private function iHaveDrawn(ev:CardDrawEndedEvent):void{
			if(rivalCards.length !=0){
				drawRivalCard()
			}else if(myCards.length!=0){
				drawMyCard();
			}else{
				isDrawing = false;
			}
		}
		private function rivalDrawn(ev:CardDrawEndedEvent):void{
			if(myCards.length !=0){
				drawMyCard();
			}else if(rivalCards.length!=0){
				drawRivalCard()
			}else{
				isDrawing = false;
			}
		}
		private var rivalCards:Array = []
		private var myCards:Array = []
		private var isDrawing:Boolean
		public function drawUserCards(cardsArray:Array/*Card*/):void{
			myCards = cardsArray
			if(isDrawing)	return
			drawMyCard()
			isDrawing = true;
		}
		public function drawRivalCards(cardsKeyArray:Array/*CardKey*/):void{
			rivalCards = cardsKeyArray;
			if(isDrawing)	return
			drawRivalCard()	
			isDrawing = true;	
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