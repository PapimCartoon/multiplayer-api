package come2play_as3.cheat.graphics
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class WrapButton extends Sprite
	{
		private var sp:SimpleButton
		private var text:TextField
		public function WrapButton(sp:SimpleButton,butoonText:String)
		{
			this.sp = sp;
			x = sp.x
			y = sp.y
			sp.x = sp.y = 0;	
			text = new TextField()
			text.selectable = false;
			text.mouseEnabled = false
			text.text = butoonText
			addChild(sp)
			addChild(text)
		}
		
	}
}