package come2play_as3.cheat.graphics
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public class CircleCounterImp extends CircleCounter
	{
		private var circleShape:Shape
		public function CircleCounterImp():void{
			circleShape = new Shape()
			circleShape.x = 26
			circleShape.y = 23
			setCircleColor(0x19559B)
			addChild(circleShape)
			addChild(cardNum_txt)
			scaleX = scaleY = 0.6
		}
		public function setCards(num:int):void{
			cardNum_txt.text = String(num);
		}
		public function setCircleColor(color:uint):void{
			var buttonMatrix:Matrix = new Matrix();
			buttonMatrix.createGradientBox(40,40,Math.PI/2,0,-20)
			circleShape.graphics.lineStyle(1,0xFFFFFF,1,true)
			circleShape.graphics.beginGradientFill(GradientType.LINEAR,[0xFFFFFF,color],[1,1],[0,95],buttonMatrix,SpreadMethod.PAD,InterpolationMethod.RGB)
			circleShape.graphics.drawCircle(0,0,20)
			circleShape.graphics.endFill();

			
		}
		
	}
}