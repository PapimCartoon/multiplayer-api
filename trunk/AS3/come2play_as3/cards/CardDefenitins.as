package come2play_as3.cards
{
	public class CardDefenitins
	{
		static public var cardSize:int = 45;//precentage of actual card size\
		static public var cardSpeed:Number = 0.15;//card dealing speed
		static public var rivalCardSpacing:int = 10;//space between rival cards
		static public var playerCardSpacing:int = 15;//space between your cards
		static public var playerXPositions:Array = [580,550,50,50] //player X Positions
		static public var playerYPositions:Array = [370,50,50,280] //player Y Positions
		static public var playerNumber:int = 2;  //Number of players
		static public var canCardsBeSelected:Boolean = false;
		static public var cardWidth:int;
		static public var cardHeight:int;
		static public var CONTAINER_gameWidth:int
		static public var CONTAINER_gameHeight:int
	}
}