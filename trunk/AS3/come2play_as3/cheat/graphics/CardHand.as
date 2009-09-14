package come2play_as3.cheat.graphics
{
	import come2play_as3.cards.CardChange;
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.caurina.transitions.Tweener;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class CardHand extends MovieClip
	{
		private var cardAngle:int = 8
		protected var cards:Array
		protected var maxHolderX:int
		protected var minHolderX:int
		protected var cardEndX:int
		protected var cardEndY:int
		protected var isCardDirectionRight:Boolean
		protected var cardHolder:Sprite = new Sprite()
		protected var isDrawing:Boolean
		protected var cardsToDraw:Array/*CardGraphic*/
		protected var isMyTurn:Boolean
		private var isComputer:Boolean
		public function CardHand(isComputer:Boolean=false)
		{
			this.isComputer = isComputer;
			addChild(cardHolder)
			cards = [];
			cardsToDraw = []
			cardEndX = 300
			cardEndY = 30
		}
		public function myTurn(isYourTurn:Boolean):void{
			isMyTurn = isYourTurn;
			for each(var card:CardGraphic in cards){
				card.buttonMode = isYourTurn;
			}
		}
		public function updateData(card:CardChange):Boolean{
			for each(var cardGraphic:CardGraphic in cards){
				if(cardGraphic.isSame(card.cardKey)){
					return true;
				}
			}
			return false;
		}
		public function drawCard(card:CardGraphic,callFinishFunc:Boolean):void{
			if(isDrawing){
				cardsToDraw.unshift(card)
				return;
			}
			if(isComputer)	card.hide()
			card.buttonMode = isMyTurn;
			isDrawing = true;
			cards.push(card)
			card.rotation = isCardDirectionRight?(Math.random() * cardAngle):(Math.random() * -cardAngle)
			cardHolder.addChild(card)	
			isCardDirectionRight = !isCardDirectionRight;
			Tweener.addTween(card, {time:0.2, x:cardEndX, y:cardEndY, transition:"linear",onComplete:function():void{
				cardDrawn(callFinishFunc)
			}} );	
		
		}	
		
		private function removeCardKeyFromArr(cardsArr:Array/*CardGraphic*/,cardData:CardKey):CardGraphic{
			for(var i:int = 0;i<cardsArr.length;i++){
				var card:CardGraphic = cardsArr[i]
				if(card.isSame(cardData)){	
					cardsArr.splice(i,1);
					return card
				}
			}
			return null
		}
		public function clear():void{
			for each(var cardGraphic:CardGraphic in cards){
				cardHolder.removeChild(cardGraphic)
			}
		}
		public function getComputerMove(value:int):Array{
			var cardKeys:Array = []
			var cardGraphic:CardGraphic
			for(var i:int = 0;i<cards.length;i++){
				cardGraphic = cards[i];
				if(cardGraphic.getCardValue() == value){
					cardKeys.push(cardGraphic.getCardKey())
				}else if(value == 14){
					value = cardGraphic.getCardValue()
					cardKeys.push(cardGraphic.getCardKey())
				}
			}
			return cardKeys;
		}
		public function getRandomComputerMove():Array{
			var cardKeys:Array = []
			var precentage:int = 4;
			while(int(Math.random()*precentage) == 0){
				precentage = precentage *1.5;
				var cardKey:CardKey = getRandomNewCard(cardKeys,true)
				if(cardKey == null)	return cardKeys;
				cardKeys.push(cardKey);
				if(cardKeys.length == 4)	return cardKeys;				
			}
			return cardKeys;
		}
		public function getRandomNewCard(arr:Array/*CardKey*/,canJoker:Boolean):CardKey{
			if(arr.length == cards.length)	return null
			var index:int = int(Math.random()*cards.length)
			var cardGraphic:CardGraphic
			var cardKey:CardKey
			for(var i:int = index;i<cards.length;i++){
				cardGraphic = cards[i];
				if((!canJoker) && (cardGraphic.getCardValue()==14))	continue;
				cardKey = cardGraphic.getCardKey();
				if(!isKeyContained(arr,cardKey))	return cardKey;	
			}
			for(i = 0;i<index;i++){
				cardGraphic = cards[i];
				if((!canJoker) && (cardGraphic.getCardValue()==14))	continue;
				cardKey = cardGraphic.getCardKey();
				if(!isKeyContained(arr,cardKey))	return cardKey;	
			}
			return null;
		}
		private function isKeyContained(arr:Array/*CardKey*/,cardKey:CardKey):Boolean{
			for each(var innerKey:CardKey in arr){
				if(innerKey.num == cardKey.num)	return true;
			}
			return false;
		}
		public function removeCard(cardData:CardKey):CardGraphic{
			var cardGraphic:CardGraphic =  removeCardKeyFromArr(cards,cardData)
			if(cardGraphic!=null){
				arrangeCards();
				return cardGraphic
			}
			return removeCardKeyFromArr(cardsToDraw,cardData)
		}
		protected function arrangeCards():void{
			cards = cards.sortOn("cardValue",Array.NUMERIC)
			var jump:int = cards.length <15?(80 - cards.length * 3):35
			var start:int = cardEndX - (jump * cards.length)/2
			for(var i:int = 0;i<cards.length;i++){
				var card:CardGraphic = cards[i];
				card.x = start + jump*i;
				cardHolder.addChild(card)
			}
			maxHolderX = ((start + jump*(i-1)) - 500 )
			minHolderX = (-maxHolderX)
		}
		private function cardDrawn(callFinishFunc:Boolean):void{
			isDrawing = false;
			arrangeCards()
			if(cardsToDraw.length>0){	
				drawCard(cardsToDraw.pop(),false)	
				return;
			}
			dispatchEvent(new CardDrawEndedEvent(callFinishFunc))
		}
		public function getCardCount():int{
			return cardsToDraw.length + cards.length
		}
		
	}
}