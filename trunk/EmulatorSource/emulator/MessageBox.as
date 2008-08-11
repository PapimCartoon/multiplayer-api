package emulator {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import fl.controls.*;

	public class MessageBox extends MovieClip {
		private var txtMessage:TextField;
		private var txtTitle:TextField;
		private var txtScrollable:TextArea;
		private var btnOK:Button;
		
		public function MessageBox() {
			txtMessage = new TextField;
			txtMessage.autoSize = TextFieldAutoSize.LEFT;
			txtMessage.multiline = true;
			txtMessage.wordWrap = true;
			txtMessage.width = 250;
			this.addChild(txtMessage);
			
			txtTitle = new TextField;
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			txtTitle.width = 250;
			txtTitle.textColor = 0xFFFFFF;
			this.addChild(txtTitle);
			
			txtScrollable = new TextArea();
			txtScrollable.editable = false;
			txtScrollable.visible = false;
			txtScrollable.wordWrap = true;
			this.addChild(txtScrollable);
			
			btnOK = new Button();
			btnOK.label="Ok";
			btnOK.width=45;
			btnOK.addEventListener(MouseEvent.CLICK, btnOKClick);
			this.addChild(btnOK);
			
			this.visible = false;
		}
		
		public function keyDown(evt:KeyboardEvent):void {
			if (evt.charCode == Keyboard.ESCAPE) {
				this.visible = false;
			}
		}
		
		private function btnOKClick(evt:MouseEvent):void {
			this.visible = false;
		}
		
		public function Show(text:String, title:String = ""):void {
			this.graphics.clear();
			
			txtScrollable.visible = false;
			txtMessage.text = text;
			txtMessage.x = (stage.stageWidth - txtMessage.textWidth) / 2;
			txtMessage.y = (stage.stageHeight - txtMessage.textHeight) / 2;
			
			var w:int, _y:int, _x:int,_h:int;
			_y = txtMessage.y;
			_x = txtMessage.x;
			_h = txtMessage.textHeight;
			if (txtMessage.textWidth > (txtTitle.textWidth+15)) {
				w = txtMessage.textWidth+20;
			}else {
				w = txtTitle.textWidth+20;
			}
			
			if (txtMessage.height > stage.stageHeight - 100) {
				txtScrollable.text = text;
				txtScrollable.visible = true;
				txtScrollable.setSize(w, stage.stageHeight - 100);
				txtScrollable.x = (stage.stageWidth - w) / 2;
				txtScrollable.y = 65;
				_x = txtScrollable.x;
				_y = 65;
				_h = stage.stageHeight - 90;
				txtMessage.text = "";
			}
			
			txtTitle.text = title;
			txtTitle.x = _x;
			txtTitle.y = _y - 25;
			this.graphics.beginFill(0x80BE40);
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.moveTo(txtTitle.x-5 , txtTitle.y+25);
			this.graphics.lineTo(txtTitle.x - 5, txtTitle.y-5);
			this.graphics.lineTo(_x + w + 5,txtTitle.y-5);
			this.graphics.lineTo(_x + w + 5, txtTitle.y+25);
			this.graphics.lineStyle(1, 0x80BE40);
			this.graphics.lineTo(_x - 5, txtTitle.y+25);
			this.graphics.endFill();
			
			btnOK.y = txtTitle.y-3;
			btnOK.x = txtTitle.x+w-40;
			
			this.graphics.lineStyle(1, 0x000000, 0);
			this.graphics.beginFill(0xFFFFFF, 0.1);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			this.graphics.beginFill(0xEEEEEE);
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.moveTo(_x - 5 , _y + _h+5);
			this.graphics.lineTo(_x - 5, _y-5);
			this.graphics.lineStyle(1, 0xEEEEEE);
			this.graphics.lineTo(_x + w + 5, _y-5);
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.lineTo(_x + w + 5, _y + _h+5);
			this.graphics.lineTo(_x - 5, _y + _h+5);
			this.graphics.endFill();
			
			this.visible = true;
		}
	}
}