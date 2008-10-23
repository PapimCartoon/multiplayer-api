package come2play_as3.cards.graphic
{
	import come2play_as3.cards.events.GraphicButtonClickEvent;
	
	import flash.events.MouseEvent;
	
	public class ButtonBarButtonImp extends ButtonBarButton_MC
	{
		private var isDisabled:Boolean;
		private var caption:String;
		public function ButtonBarButtonImp(caption:String)
		{
			this.caption = caption;
			addEventListener(MouseEvent.CLICK,doClick);
			addEventListener(MouseEvent.MOUSE_OVER,doOver);
			addEventListener(MouseEvent.MOUSE_DOWN,doDown);
			addEventListener(MouseEvent.MOUSE_OUT,doUp);
			text_txt.text = caption;
		}
		public function set disabled(disabled:Boolean):void
		{
			isDisabled = disabled;
			if(disabled)
				gotoAndStop("Disabled")
			else
				gotoAndStop("Up")
		}
		private function doClick(ev:MouseEvent):void
		{	
			if(!isDisabled)
				dispatchEvent(new GraphicButtonClickEvent(caption));
		}
		private function doOver(ev:MouseEvent):void
		{
			if(!isDisabled)
				gotoAndStop("Over")	
		}
		private function doDown(ev:MouseEvent):void
		{
			if(!isDisabled)
				gotoAndStop("Down")	
		}
		private function doUp(ev:MouseEvent):void
		{
			if(!isDisabled)
				gotoAndStop("Up")	
		}
		
	}
}