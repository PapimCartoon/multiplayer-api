package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;
	import come2play_as3.dominoGame.DominoGameMain;

	public class DominoCube extends SerializableClass
	{
		public var up:int;
		public var down:int;	
		static public function create(up:int,down:int):DominoCube{
			var res:DominoCube = new DominoCube()
			res.up = up;
			res.down = down;
			return res
		}
		public function getFlippedCopy():DominoCube{
			var res:DominoCube = new DominoCube()
			res.up = down;
			res.down = up;
			return res
		}
		private function getMod(num:int):int{
			var add:int
			for(var i:int = 0;i<num;i++){
				add+=(DominoGameMain.dominoMax - i);
			}
			return add;
		}
		
		public function getKey():Object{
			return {type:DominoGameMain.DOMINO_CUBE,brickNum:(/*DominoGameMain.dominoMax*up*/getMod(up)+down)}
		}
		public function isDouble():Boolean{
			return up == down;
		}
		public function value():int{
			return up + down;
		}
		override public function toString():String{
			return "["+up+" : "+down+"]";
		}
	}
}