package come2play_as3.dominoGame.graphicClasses
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class DominoButton
	{
		private var _graphic:MovieClip
		private var _enabled:Boolean = true;
		public function DominoButton(_graphic:MovieClip,clickThis:Function)
		{
			this._graphic = _graphic;
			_graphic.gotoAndStop(1)
			AS3_vs_AS2.myAddEventListener("dominoButton",_graphic,MouseEvent.CLICK,clickThis)
			AS3_vs_AS2.myAddEventListener("dominoButton",_graphic,MouseEvent.MOUSE_OVER,mouseOver)
			AS3_vs_AS2.myAddEventListener("dominoButton",_graphic,MouseEvent.MOUSE_OUT,mouseOut)
			AS3_vs_AS2.myAddEventListener("dominoButton",_graphic,MouseEvent.MOUSE_DOWN,mouseDown)
			AS3_vs_AS2.myAddEventListener("dominoButton",_graphic,MouseEvent.MOUSE_UP,mouseUp)
		}
		public function get enabled():Boolean{
			return _enabled
		}
		public function set enabled(value:Boolean):void{
			if(value == _enabled)	return;
			_graphic.mouseChildren = _graphic.mouseEnabled = _enabled = value;
			if(_enabled)
				_graphic.gotoAndStop(1)
			else
				_graphic.gotoAndStop(4)			
		}
		private function mouseOver(ev:MouseEvent):void{
			if(_enabled)
				_graphic.gotoAndStop(2)
		}
		private function mouseOut(ev:MouseEvent):void{
			if(_enabled)
				_graphic.gotoAndStop(1)
		}
		private function mouseDown(ev:MouseEvent):void{
			if(_enabled)
				_graphic.gotoAndStop(3)
		}
		private function mouseUp(ev:MouseEvent):void{
			if(_enabled)
				_graphic.gotoAndStop(2)
		}
	}
}