package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class BlankCardGraphic extends Card_MC
	{
		public function BlankCardGraphic(cardScale:int = 25)
		{
			scaleX = scaleY = cardScale / 100
			Symbole_MC.stop()
			Letter_MC.stop()
			AS3_vs_AS2.myAddEventListener("BlankCardGraphic",this,MouseEvent.MOUSE_OVER,addGlow)
			AS3_vs_AS2.myAddEventListener("BlankCardGraphic",this,MouseEvent.MOUSE_OUT,removeGlow)
		}
		public function addGlow(ev:MouseEvent):void{
			filters = [new GlowFilter(0x66FFFF,1,8,8,2.2)]
		}
		public function removeGlow(ev:MouseEvent):void{
			filters = []
		}
		public function setValue(value:int):void{
			var newValue:int
			if(value == 14){
				newValue = 1;
			}else if(value == 0){
				newValue = 13
			}else{
				newValue = value
			}
			Symbole_MC.gotoAndStop(20);
			Letter_MC.gotoAndStop(29+newValue)
		}
		
	}
}