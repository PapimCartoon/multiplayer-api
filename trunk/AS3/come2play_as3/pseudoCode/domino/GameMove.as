package come2play_as3.pseudoCode.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GameMove extends SerializableClass
	{
		public var isTakingCube:Boolean,cube:DominoCube;
		
		public static function create(isTakingCube:Boolean,cube:DominoCube):GameMove
		{
			var res:GameMove = new GameMove();
			res.isTakingCube = isTakingCube;
			res.cube = cube;
			return res;
		}
	}
}

