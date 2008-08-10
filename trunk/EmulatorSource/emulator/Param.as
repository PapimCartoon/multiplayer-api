package emulator {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class Param extends MovieClip {
		private var txtLabel:TextField;
		private var txtValue:TextField;
		private var txtTooltip:MessageBox;
		//private var movQuestion:MovieClip; // related to the tooltip that I removed
		private var tooltip:String="";
		
		public function get Label():String {
			return txtLabel.text;
		}
		
		public function set Label(val:String):void {
			txtLabel.text=val;
		}
		
		public function get Value():String {
			return txtValue.text;
		}
		
		public function set Value(val:String):void {
			txtValue.text=val;
		}
		
		public function get Tooltip():String {
			return tooltip;
		}
		
		public function set Tooltip(val:String):void {
			tooltip = val;
			//movQuestion.visible = (tooltip != "");
		}
		
		public function Param(msgBox:MessageBox,vertical:Boolean=false) {
			txtLabel = new TextField();
			txtLabel.type = TextFieldType.DYNAMIC;
			txtLabel.y = 0;
			txtLabel.x = 0;
			txtLabel.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(txtLabel);
			
			txtValue = new TextField();
			txtValue.type = TextFieldType.INPUT;
			if (vertical) {
				txtValue.x = 0;
				txtValue.y = 22;
			}else{
				txtValue.y = 0;
				txtValue.x = 155;
			}
			txtValue.width = 150;
			txtValue.height = 22;
			txtValue.border = true;
			txtValue.background = true;
			txtValue.backgroundColor = 0xFFFFFF;
			this.addChild(txtValue);
			
			/*movQuestion = new Question();
			if (vertical) {
				movQuestion.x = 150 - movQuestion.width;
			}else {
				movQuestion.x = 307;
			}
			movQuestion.visible = false;
			movQuestion.addEventListener(MouseEvent.CLICK, questionClick);
			this.addChild(movQuestion);
			*/
			txtTooltip = msgBox;
		}
		
		private function questionClick(evt:MouseEvent):void {
			txtTooltip.Show(tooltip, txtLabel.text);
		}
	}
}