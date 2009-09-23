package come2play_as3.cheat.graphics
{
	public class CircleCounterImp extends CircleCounter
	{
		public function CircleCounterImp():void{
			scaleX = scaleY = 0.6
		}
		public function setCards(num:int):void{
			cardNum_txt.text = String(num);
		}
		
	}
}