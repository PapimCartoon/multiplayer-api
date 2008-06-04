package {
	import flash.display.*;
	import flash.geom.Matrix;

	public class Square extends MovieClip {
		private var borderColor:uint;
		private var fillColor:uint;
		private var sqrX:int;
		private var sqrY:int;
		private var sqrI:int;
		private var sqrJ:int;
		private var symX:XSymbol;
		private var symO:OSymbol;
		private var checked:Boolean;
		private var value:int;
		private var logo:BitmapData=null;
		
		public function get I():int {
			return sqrI;
		}
		
		public function get J():int {
			return sqrJ;
		}
		
		public function get Checked():Boolean {
			return checked;
		}
		
		public function set Checked(val:Boolean):void {
			checked=val;
		}
		
		public function get Value():int {
			return value;
		}
		
		public function set Value(val:int):void {
			value=val;
		}
		
		public function Square(_width:int,_height:int,_i:int,_j:int,_borderColor:uint = 0x000000, _fillColor:uint = 0x0066CC ) {
			sqrX = _width;
			sqrY = _height;
			sqrI = _i;
			sqrJ = _j;
			borderColor = _borderColor;
			fillColor = _fillColor;
			
			checked = false;
			value = -1;
			
			symX = new XSymbol();
			symX.x = (sqrX - symX.width) / 2;
			symX.y = (sqrY - symX.height) / 2;
			symX.visible = false;
			this.addChild(symX);
			
			symO = new OSymbol();
			symO.x = (sqrX - symO.width) / 2;
			symO.y = (sqrY - symO.height) / 2;
			symO.visible=false;
			this.addChild(symO);
			
			draw();
		}
		
		public function renew(_checked:Boolean, _value:int):void {
			checked = _checked;
			value = _value;
			draw();
		}
		
		public function addLogo(_logo:BitmapData):void {
			logo = _logo;
			draw();
		}
		
		private function draw() {
			this.graphics.clear();
			if (!this.checked) {
				this.graphics.beginFill(fillColor);
				this.graphics.lineStyle(1, borderColor);
				this.graphics.moveTo(0, 0);
				this.graphics.lineTo(0, sqrY);
				this.graphics.lineTo(sqrX, sqrY);
				this.graphics.lineTo(sqrX, 0);
				this.graphics.lineTo(0, 0);
				this.graphics.endFill();
				if (logo != null) {
					this.graphics.beginBitmapFill(logo, new Matrix, false, false);
					this.graphics.drawRect(0, 0, sqrX, sqrY);
					this.graphics.endFill();
				}
			}
			symX.visible = (this.value == 0);
            symO.visible = (this.value == 1);
		}
	}
}