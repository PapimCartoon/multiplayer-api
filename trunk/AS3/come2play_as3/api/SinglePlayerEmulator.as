package come2play_as3.api
{
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	/**
	 * This class simulates a server that works only for a single player.
	 * It opens a localconnection and waits for the player to connect,
	 * following the standard handshake:
	 * Player calls doRegisterOnServer,
	 * and then the server will call:
	 * gotCustomInfo
	 * gotUserInfo
	 * gotMatchStarted
	 * 
	 * The server will also listen to keyboard events and call:
	 * gotKeyboardEvent
	 * 
	 * When the server gets doAllEndMatch,
	 * it will wait 2 seconds before starting a new match.
	 */
	public final class SinglePlayerEmulator extends LocalConnectionUser
	{
		public static var DEFAULT_GENERAL_INFO:Array/*InfoEntry*/ =
			[ 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_logoFullUrl,"../../Emulator/example_logo.jpg"), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameHeight,"400"), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameWidth,"400") 
			];
		public static var DEFAULT_USER_INFO:Array/*InfoEntry*/ =
				[ 	InfoEntry.create(API_Message.USER_INFO_KEY_name, "User name"),
					InfoEntry.create(API_Message.USER_INFO_KEY_avatar_url, "../../Emulator/Avatar_1.gif")
				];
		public static var DEFAULT_MATCH_STATE:Array/*ServerEntry*/ = []; // you can change this and load a saved match
		public static var DEFAULT_USER_ID:int = 42; 
		public static var DEFAULT_EXTRA_MATCH_INFO:String = ""; 
		public static var DEFAULT_MATCH_STARTED_TIME:int = 999;
						
		private var customInfoEntries:Array/*InfoEntry*/;
		private var userId:int; 
		private var userInfoEntries:Array/*InfoEntry*/;
		private var extraMatchInfo:Object/*Serializable*/;
		private var matchStartedTime:int; 
		private var userStateEntries:Array/*ServerEntry*/;
		private var apiMsgsQueue:Array/*API_Message*/ = [];
		
		public function SinglePlayerEmulator(graphics:MovieClip) {
			super(graphics,true, DEFAULT_LOCALCONNECTION_PREFIX);
			this.customInfoEntries = DEFAULT_GENERAL_INFO;
			this.userId = DEFAULT_USER_ID;
			this.userInfoEntries = DEFAULT_USER_INFO;
			this.extraMatchInfo = DEFAULT_EXTRA_MATCH_INFO;
			this.matchStartedTime = DEFAULT_MATCH_STARTED_TIME;
			this.userStateEntries = DEFAULT_MATCH_STATE;			
									
			AS3_vs_AS2.addKeyboardListener(graphics, AS3_vs_AS2.delegate(this, this.reportKeyDown));	
		}		
		private function reportKeyDown(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {		
			queueSendMessage(API_GotKeyboardEvent.create(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey) );
		}		
		
        override public function gotMessage(msg:API_Message):void {        	
			if (msg is API_Transaction) {
				var transaction:API_Transaction = msg as API_Transaction;
				for each (var innerMsg:API_Message in transaction.messages) {
					gotMessage(innerMsg);
				}
			} else if (msg is API_DoStoreState) {
				var doStore:API_DoStoreState = msg as API_DoStoreState;				
				var userEntries:Array/*UserEntry*/ = doStore.userEntries;
				var serverEntries:Array/*ServerEntry*/ = [];
				for each (var userEntry:UserEntry in userEntries) {
					var serverEntry:ServerEntry = ServerEntry.create(userEntry.key, userEntry.value, userId,userEntry.isSecret ? [userId] : null, getTimer());
					serverEntries.push(serverEntry); 
				}
				queueSendMessage(API_GotStateChanged.create(serverEntries));
				
			} else if (msg is API_DoAllEndMatch) {
				AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
			} else if (msg is API_DoRegisterOnServer) {
				doRegisterOnServer();
			} else if (msg is API_DoFinishedCallback) {
				if (apiMsgsQueue.length==0) throwError("Game sent too many DoFinishedCallback");
				apiMsgsQueue.shift();
				if (apiMsgsQueue.length>0) sendTopQueue();
			}				
  		}
  		private function doRegisterOnServer():void {
  			queueSendMessage(API_GotMyUserId.create(userId) );
  			queueSendMessage(API_GotCustomInfo.create(customInfoEntries) );
  			queueSendMessage(API_GotUserInfo.create(userId, userInfoEntries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():void {	 
  			queueSendMessage(API_GotMatchStarted.create([userId], [], extraMatchInfo, matchStartedTime, userStateEntries) );	 	
  		}
  		private function queueSendMessage(msg:API_Message):void {
  			apiMsgsQueue.push(msg);
  			if (apiMsgsQueue.length==1) sendTopQueue();
  		}
  		
  		private function sendTopQueue():void {  			
  			var msg:API_Message = apiMsgsQueue[0];
  			sendMessage(msg);
  		}
  		
  		
	}
}