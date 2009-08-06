package come2play_as3.dominoGame.graphicClasses
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MyHelpClip extends Sprite
	{
		private var _graphics:Help = new Help()
		public function MyHelpClip()
		{
			addChild(_graphics)
			AS3_vs_AS2.myAddEventListener("closer",_graphics.closer,MouseEvent.CLICK,closeThis)
			
		}
		private function closeThis(ev:MouseEvent):void{
			if(parent!=null)	parent.removeChild(this);
		}
		
	}
}