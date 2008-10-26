package come2play_as3.cheat.graphic
{
	import come2play_as3.cards.events.GraphicButtonClickEvent;
	
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class ButtonBarButtonImp extends ButtonBarButton_MC
	{
		private var isDisabled:Boolean;
		private var eventName:String;
		private var padding:int = 20;
		public function ButtonBarButtonImp(eventName:String,caption:String)
		{
			this.eventName = eventName;
			addEventListener(MouseEvent.CLICK,doClick);
			addEventListener(MouseEvent.MOUSE_OVER,doOver);
			addEventListener(MouseEvent.MOUSE_DOWN,doDown);
			addEventListener(MouseEvent.MOUSE_OUT,doOut);
			addEventListener(MouseEvent.MOUSE_UP,doUp);
			text_txt.autoSize = TextFieldAutoSize.CENTER;
			text_txt.text = caption;
			this.width = text_txt.width + padding;
			text_txt.scaleX = 1/ this.scaleX;
		}
		public function set disabled(disabled:Boolean):void
		{
			if(isDisabled != disabled)
			{
				isDisabled = disabled;
				if(disabled)
					gotoAndStop("Disabled")
				else
					gotoAndStop("Up")
			}
		}
		private function doClick(ev:MouseEvent):void
		{	
			if(!isDisabled)
				dispatchEvent(new GraphicButtonClickEvent(eventName));
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
				gotoAndStop("Over")	
		}
		private function doOut(ev:MouseEvent):void
		{
			if(!isDisabled)
				gotoAndStop("Up")	
		}
		
	}
}