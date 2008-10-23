package come2play_as3.cards
{
	import come2play_as3.cards.Card;
	
	public class PlayerCard
	{
		public var card:Card;
		public var num:int;
		public function PlayerCard(card:Card,num:int)
		{
			this.num = num;
			this.card = card;
		}

	}
}