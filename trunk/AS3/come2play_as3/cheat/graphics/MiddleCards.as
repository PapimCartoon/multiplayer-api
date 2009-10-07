package come2play_as3.cheat.graphics
{
	import come2play_as3.cards.Card;
	import come2play_as3.cards.CardChange;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.ServerClasses.JokerValue;
	import come2play_as3.cheat.caurina.transitions.Tweener;
	
	import flash.display.Sprite;

	public class MiddleCards extends Sprite
	{
		private var circleCounter:CircleCounterImp
		private var placeCard:PlaceCard
		private var choosenCards:Sprite
		private var choosenCardsArray:Array/*CardGraphic*/
		private var thrownDeckArray:Array/*CardGraphic*/
		private var thrownDeck:Sprite
		private var cardEndY:int = 215
		private var cardEndX:int = 250
		private var cardValue:int = -1
		private var foldToDeck:FoldToDeck;
		public function MiddleCards()
		{
			circleCounter = new CircleCounterImp()
			circleCounter.x = cardEndX + 15
			circleCounter.y = cardEndY - 55
			foldToDeck = new FoldToDeck()
			placeCard = new PlaceCard()
			choosenCardsArray = new Array();
			thrownDeckArray = new Array();	
			choosenCards = new Sprite()
			thrownDeck = new Sprite()
			circleCounter.visible = false
			addChild(thrownDeck)
			addChild(choosenCards)
			addChild(circleCounter)
		}
		public function clear():void{
			circleCounter.visible = false
			for each(var cardGraphic:CardGraphic in choosenCardsArray){
				choosenCards.removeChild(cardGraphic)
			}
			for each(cardGraphic in thrownDeckArray){
				thrownDeck.removeChild(cardGraphic)
			}
		}
		public function choosenAmount():int{
			return choosenCardsArray.length
		}
		public function noDeck():Boolean{
			return thrownDeckArray.length == 0;
		}
		public function pickCard(cardGraphic:CardGraphic):void{
			circleCounter.visible = false
			choosenCardsArray.push(cardGraphic)
			placeCard.play()
			Tweener.addTween(cardGraphic, {time:0.2, x:cardEndX, y:cardEndY, transition:"easeOutSine",onComplete:cardPicked} );	
		}
		public function putFirst(cardGraphic:CardGraphic,jokerValue:JokerValue):void{
			circleCounter.visible = false
			if(jokerValue==null){
				cardValue = cardGraphic.getCardValue();
			}else{
				cardValue = jokerValue.jokerValue
				cardGraphic.setValue(cardValue)
			}	 
			thrownDeckArray.push(cardGraphic)
			thrownDeck.addChild(cardGraphic)
			cardGraphic.buttonMode = false;
			placeCard.play()
			Tweener.addTween(cardGraphic, {time:0.2, x:cardEndX, y:cardEndY, transition:"easeOutSine"} );
		}
		private function cardPicked():void{
			arrangeCards()
		}
		private function arrangeCards():void{
			var jump:int = choosenCardsArray.length <15?(80 - choosenCardsArray.length * 3):35
			var start:int = cardEndX - (jump * choosenCardsArray.length)/2
			for(var i:int = 0;i<choosenCardsArray.length;i++){
				var card:CardGraphic = choosenCardsArray[i];
				card.x = start + jump*i;
				choosenCards.addChild(card)
			}
		}
		public function setCardValue(value:int):void{
			cardValue = value;
		}
		public function getCardValue():int{
			return cardValue;
		}
		public function removeHold():void{
			for each(var card:CardGraphic in choosenCardsArray){
				card.buttonMode = false;
			}
		}
		public function getCardKeys():Array/*CardKey*/{
			var keys:Array/*CardKey*/ = []
			for each(var card:CardGraphic in choosenCardsArray){
				keys.push(card.getCardKey())
			}
			return keys;
		}
		public function isMoveCheat(value:int):Boolean{
			for each(var card:CardGraphic in choosenCardsArray){
				var cardValue:int = card.getCardValue()
				if(cardValue == 14)	continue;
				if(value == 14){	
					value = cardValue
				}else if(cardValue != value){
					return true
				}
			}
			return false;
		}
		
		private var isCardDirectionRight:Boolean
		public function addCard(cardGraphic:CardGraphic):void{
			cardGraphic.rotation = isCardDirectionRight?(Math.random() * 8):(Math.random() * -8)
			cardGraphic.buttonMode = false;
			pickCard(cardGraphic)
			isCardDirectionRight = !isCardDirectionRight;	
			circleCounter.visible = false
		}
		public function throwMiddle(userCards:int):void{
			foldToDeck.play()
			for each(var cardGraphic:CardGraphic in choosenCardsArray){
				cardGraphic.setCard(null)
				cardGraphic.buttonMode = false;
				thrownDeck.addChild(cardGraphic)
				thrownDeckArray.push(cardGraphic)	
				Tweener.addTween(cardGraphic, {time:0.2, x:cardEndX, y:cardEndY, transition:"easeOutSine"} );
			}
			choosenCardsArray = [];
			var thrownCardsCount:int = thrownDeckArray.length
			circleCounter.visible = true
			circleCounter.setCards(thrownCardsCount)	
			circleCounter.setCircleColor((thrownCardsCount + userCards)>30?0xFF0000:0x19559B)
			
		}
		public function revealCard(cardChange:CardChange):void{
			for each(var card:CardGraphic in choosenCardsArray){
				if(card.isSame(cardChange.cardKey)){
					card.setCard(cardChange.card)
					return;
				}
			}
		}
		public function getThrownIds():Array{
			var keys:Array/*CardKey*/ = []
			for each(var cardGraphic:CardGraphic in thrownDeckArray){
				keys.push(cardGraphic.getCardKey())
			}
			for each(cardGraphic in choosenCardsArray){
				keys.push(cardGraphic.getCardKey())
			}
			return keys;
		}
		private function removeCardFromArray(cardKey:CardKey,arr:Array):CardGraphic{
			var cardGraphic:CardGraphic
			for(var i:int = 0;i<arr.length;i++){
				cardGraphic = arr[i]
				if(cardGraphic.isSame(cardKey)){	
					arr.splice(i,1);
					return cardGraphic
				}	
			}
			return null;
		}
		public function removeThrownCard(cardData:Card):CardGraphic{
			var cardGraphic:CardGraphic
			for(var i:int = 0;i<choosenCardsArray.length;i++){
				cardGraphic = choosenCardsArray[i];
				if(cardGraphic.isSameCard(cardData)){
					choosenCardsArray.splice(i,1);
					return cardGraphic;
				}
			}
			cardGraphic = thrownDeckArray.pop()
			return cardGraphic==null?choosenCardsArray.pop():cardGraphic;
		}
		public function removeCard(cardKey:CardKey):CardGraphic{
			var cardGraphic:CardGraphic = removeCardFromArray(cardKey,choosenCardsArray)
			if(cardGraphic!=null)	arrangeCards();
			return cardGraphic;
		}
	}
}