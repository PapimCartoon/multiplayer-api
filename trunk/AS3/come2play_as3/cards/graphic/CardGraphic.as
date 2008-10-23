package come2play_as3.cards.graphic
{
	import come2play_as3.cards.CardDefenitins;
	import come2play_as3.cards.events.CardRecievedEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CardGraphic extends MovieClip
	{
		protected var yourCards:PlayerHand;
		protected var rivalHandsArray:Array/*RivalHand*/;
		private var myUserId:int;
		private var allPlayersIds:Array;
		private var currentPlayer:int;
		private var background:Sprite;
		private var buttonBar:ButtonBarImp;
		public function CardGraphic()
		{
			buttonBar= new ButtonBarImp();
			buttonBar.addButton("Confirm")
			//buttonBar.scaleX = CardDefenitins.cardSize //* 0.01;
			//buttonBar.scaleY = CardDefenitins.cardSize * 0.01;
			
			addEventListener(CardRecievedEvent.CardRecieved,dealNextCard,true);
			rivalHandsArray = new Array();
		}
		public function init(myUserId:int,allPlayersIds:Array):void
		{
			this.myUserId = myUserId;
			background = new Sprite();
			this.allPlayersIds = allPlayersIds;
			buttonBar.y = CardDefenitins.CONTAINER_gameHeight + 10 - buttonBar.height;
			buttonBar.x = CardDefenitins.CONTAINER_gameWidth - buttonBar.width;
			background.graphics.beginFill(0x5A24A0);
			background.graphics.drawRect(0,0,CardDefenitins.CONTAINER_gameWidth,CardDefenitins.CONTAINER_gameHeight);
			background.graphics.endFill();
			addChild(background)
			if(yourCards!=null)
				if(contains(yourCards))
					removeChild(yourCards);
			for each(var rivalHand:RivalHand in rivalHandsArray)
				if(contains(rivalHand))
					removeChild(rivalHand);
			yourCards = new PlayerHand();
			currentPlayer = 0;
			var mod:int = allPlayersIds.indexOf(myUserId);
			var cahngedNum:int;
			for(var i:int = 0 ; i<allPlayersIds.length;i++)
			{
				cahngedNum = i - mod;
				if(cahngedNum < 0)
					cahngedNum = allPlayersIds.length + cahngedNum;
				rivalHandsArray[i] = new RivalHand(cahngedNum)
				addChild(rivalHandsArray[i]);
			}
			addChild(yourCards);		
			addChild(buttonBar);		


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
			if(currentPlayer == allPlayersIds.indexOf(myUserId))
				yourCards.showCard();
			currentPlayer++;
			if(currentPlayer >= allPlayersIds.length)
				currentPlayer = 0;
			devideCards();
		}
		
	}
}