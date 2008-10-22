package come2play_as3.cards.graphic
{
	import come2play_as3.cards.events.CardRecievedEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class CardGraphic extends MovieClip
	{
		protected var yourCards:PlayerHand;
		protected var rivalHandsArray:Array/*RivalHand*/;
		private var myUserId:int;
		private var allPlayersIds:Array;
		private var currentPlayer:int;
		public function CardGraphic()
		{
			addEventListener(CardRecievedEvent.CardRecieved,dealNextCard,true);
			rivalHandsArray = new Array();
		}
		public function init(myUserId:int,allPlayersIds:Array):void
		{
			if(yourCards!=null)
				if(contains(yourCards))
					removeChild(yourCards);
			for each(var rivalHand:RivalHand in rivalHandsArray)
				if(contains(rivalHand))
					removeChild(rivalHand);
			yourCards = new PlayerHand();
			addChild(yourCards);
			currentPlayer = 0;
			var mod:int = allPlayersIds.indexOf(myUserId);
			var cahngedNum:int;
			for(var i:int = 0 ; i<allPlayersIds.length;i++)
			{
				cahngedNum = i - mod;
				if(cahngedNum < 0)
					cahngedNum = allPlayersIds.length + mod;
				rivalHandsArray[i] = new RivalHand(cahngedNum)
				addChild(rivalHandsArray[i]);
			}		
					
			this.myUserId = myUserId;
			this.allPlayersIds = allPlayersIds;

		}
		
		public function addCards(cards:Array/*Card*/):void
		{
			yourCards.addCards(cards);
		}

		public function rivalAddCards(rivalId:int,amountOfCards:int):void
		{
			var rivalHand:RivalHand = rivalHandsArray[allPlayersIds.indexOf(rivalId)];
			rivalHand.addCards(amountOfCards);
		}
		
		public function devideCards():void
		{
			var dealCardToHand:Hand;
			if (allPlayersIds[currentPlayer] == myUserId)
				dealCardToHand = yourCards;
			else
				dealCardToHand = rivalHandsArray[currentPlayer];
			dealCardToHand.dealCard();

		}
		
		private function dealNextCard(ev:Event):void
		{
			currentPlayer++;
			devideCards();
		}
		
	}
}