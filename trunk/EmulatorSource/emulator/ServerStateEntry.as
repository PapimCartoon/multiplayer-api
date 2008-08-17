package emulator {

	import flash.display.*;
	public  class ServerStateEntry  {
		public var userId:int;
		public var key:String;
		public var value:Object/*Serializable*/;
		public var authorizedUsersIds:Array;
		public function ServerStateEntry(userId:int,key:String, value:Object/*Serializable*/,authorizedUsersIds:Array) {
			this.userId = userId;
			this.key = key;
			this.value = value;
			this.authorizedUsersIds = authorizedUsersIds;
		}
		public function getParametersAsString():String { return 'authorizedUsersIds=' + JSON.stringify(authorizedUsersIds)+', key=' + JSON.stringify(key)+', value=' + JSON.stringify(value) }
		public function toString():String { return '{ServerStateEntry: ' + getParametersAsString() + '}'; }
	}
}
