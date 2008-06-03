class SquareAS2 extends MovieClip{
		private var borderColor:Number;
		private var fillColor:Number;
		private var sqrX:Number;
		private var sqrY:Number;
		private var sqrI:Number;
		private var sqrJ:Number;
		private var symX:XSymbol;
		private var symO:OSymbol;
		private var checked:Boolean;
		private var value:Number;
		//private var logo:BitmapData = null;
		private var obj:MovieClip;
		
		public function get I():Number {
			return sqrI;
		}
		
		public function get J():Number {
			return sqrJ;
		}
		
		public function get Checked():Boolean {
			return checked;
		}
		
		public function set Checked(val:Boolean):Void {
			checked=val;
		}
		
		public function get Value():Number {
			return value;
		}
		
		public function set Value(val:Number):Void {
			value=val;
		}
		
		public function SquareAS2(_width:Number,_height:Number,_i:Number,_j:Number,_borderColor:Number = 0x000000, _fillColor:Number = 0x0066CC ) {
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
		
		public function renew(_checked:Boolean, _value:Number):Void {
			checked = _checked;
			value = _value;
			draw();
		}
		
		public function addLogo(/*_logo:BitmapData*/):Void {
			//logo = _logo;
			draw();
		}
		
		private function draw():Void {
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
			if (this.value == 0) {
				symX.visible = true;
				symO.visible = false;
			}else if (this.value == 1) {
				symX.visible = false;
				symO.visible = true;
			}else{
				symX.visible = false;
				symO.visible = false;
			}
		}
	}