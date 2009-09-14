package come2play_as3.cheat.graphics
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class WrapButton extends Sprite
	{
		private var sp:SimpleButton
		private var text:TextField
		public function WrapButton(sp:SimpleButton,buttonText:String)
		{
			this.sp = sp;
			x = sp.x
			y = sp.y
			sp.x = sp.y = 0;	
			addChild(sp)
			text = new TextField()
			text.setTextFormat(new TextFormat("Arial",12,0xFFFFFF,true))
			text.defaultTextFormat = new TextFormat("Arial",12,0xFFFFFF,true)
			text.mouseEnabled = false;
			text.text = buttonText
			text.x = (sp.width - text.textWidth)/2 - 2
			text.y = (sp.height - text.textHeight)/2 - 2
			
			addChild(text);
			
		}
		
	}
}