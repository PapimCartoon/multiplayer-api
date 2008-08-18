package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class API_Do_chess_3D_or_2D extends API_Message {
		public var is_3D:Boolean;
		public function API_Do_chess_3D_or_2D(is_3D:Boolean) { super('do_chess_3D_or_2D',arguments); 
			this.is_3D = is_3D;
		}
		override public function getParametersAsString():String { return 'is_3D=' + JSON.stringify(is_3D); }
	}
}
