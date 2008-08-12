package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoAllRequestStateCalculation extends API_Message {
		public var value:Object/*Serializable*/;
		public function API_DoAllRequestStateCalculation(value:Object/*Serializable*/) { super('doAllRequestStateCalculation',arguments); 
			this.value = value;
		}
		override public function getParametersAsString():String { return 'value=' + JSON.stringify(value); }
	}
}
