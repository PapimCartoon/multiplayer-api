package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_GotRequestStateCalculation extends API_Message {
		public var secretSeed:int;
		public var value:Object/*Serializable*/;
		public function API_GotRequestStateCalculation(secretSeed:int, value:Object/*Serializable*/) { super('gotRequestStateCalculation',arguments); 
			this.secretSeed = secretSeed;
			this.value = value;
		}
		override public function getParametersAsString():String { return 'secretSeed=' + JSON.stringify(secretSeed)+', value=' + JSON.stringify(value); }
	}
}
