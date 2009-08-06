package come2play_as3.dominoGame.usefullFunctions
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class Tools
	{
		static private var xMod:int;
		static private var yMod:int;
		static public var scaleX:Number
		static public var scaleY:Number
		static public function setGameScale(_scaleX:Number,_scaleY:Number):void{
			scaleX = _scaleX;
			scaleY = _scaleY
		}
		
		static public function setGamePoint(p:Point):void{
			xMod = p.x;
			yMod = p.y;
		}
		static public function localToGlobal(sp:DisplayObject,xPos:int,yPos:int/*,withMode:Boolean*/):Point{
			var p:Point = sp.localToGlobal(new Point(xPos,yPos))
			p.x-=xMod;
			p.y-=yMod;
			//trace( scaleX)
			//p.x = p.x * scaleX
			return p
		}
		static public function globalToLocal(sp:DisplayObject,xPos:int,yPos:int):Point{
			xPos+=xMod;
			yPos+=yMod;
			var p:Point = sp.globalToLocal(new Point(xPos,yPos))
			return p
		}

	}
}