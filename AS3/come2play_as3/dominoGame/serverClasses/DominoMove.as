package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.dominoGame.DominoGameMain;

	public class DominoMove extends DominoCube
	{
		static public const DOMINO_MOVE:String = "DominoMove"
		public var dominoCube:DominoCube
		public var connectToRight:Boolean
		public var brickOrientation:int
		public var playerId:int;
		public var moveNum:int
		public var key:Object
		public static function create(playerId:int,key:Object,dominoCube:DominoCube,connectToRight:Boolean,brickOrientation:int,moveNum:int):DominoMove{
			var res:DominoMove = new DominoMove()
			res.key = key;
			res.moveNum = moveNum;
			res.playerId = playerId;
			res.dominoCube = dominoCube;
			res.connectToRight = connectToRight
			res.brickOrientation = brickOrientation
			return res;
		}	
		override public function getKey():Object{
			return {type:DominoGameMain.DOMINO_MOVE,playerId:playerId,moveNum:moveNum}
		}	
	}
}