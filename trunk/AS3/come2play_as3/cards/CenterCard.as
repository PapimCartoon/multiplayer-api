package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CenterCard extends SerializableClass
	{
		public var playerId:int;
		public var cardKey:int;
		public function CenterCard()
		{
			super("CenterCard");
		}
		static public function create(playerId:int,cardKey:int):CenterCard
		{
			var res:CenterCard = new CenterCard();
			res.playerId = playerId;
			res.cardKey = cardKey;
			return res;
		}
		
	}
}