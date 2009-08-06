package come2play_as3.dominoGame.LogicClasses
{
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	
	public class MiddleBoard
	{
		private var middle:DominoCube
		private var right:Array = []
		private var left:Array = []
		static private var rightNum:int
		static private var leftNum:int
		public function addCenter(cube:DominoCube):void{
			middle = cube
			if(cube.up == cube.down)
				rightNum = leftNum = middle.up
			else{
				rightNum = middle.up;
				leftNum = middle.down;
			}
		}
		public function addRight(cube:DominoCube):void{
			if(rightNum == cube.up)
				rightNum = cube.down
			else
				rightNum = cube.up	
		}
		public function addLeft(cube:DominoCube):void{
			if(leftNum == cube.up)
				leftNum = cube.down
			else
				leftNum = cube.up
		}
		static public function canAddLeft(cube:DominoCube):Boolean{
			return ((leftNum == cube.up) || (leftNum == cube.down))
		}
		static public function canAddRight(cube:DominoCube):Boolean{
			return ((rightNum == cube.up) || (rightNum == cube.down))
		}
		public function canAddCenter():Boolean{
			return middle==null;
		}
	}
}