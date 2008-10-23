package come2play_as3.cards.graphic
{
	
	import flash.events.MouseEvent;
	
	public class ButtonBarImp extends ButtonBar_MC
	{
		private var allButtons:Array;
		public function ButtonBarImp()
		{
			allButtons = new Array();

		}
		public function addButton(newButtonText:String):void
		{
			var tempButtonImp:ButtonBarButtonImp = new ButtonBarButtonImp(newButtonText);
			tempButtonImp.x = 200;
			tempButtonImp.y =60;
			allButtons.push(tempButtonImp);
			addChild(tempButtonImp);
				//		button.text_txt.text="Confirm"
			//buttonBar.button.addEventListener(MouseEvent.CLICK,doConfirm);
			//"Confirm"
		}
		
	}
}