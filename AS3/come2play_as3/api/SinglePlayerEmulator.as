package come2play_as3.api
{
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.MovieClip;
	import flash.net.LocalConnection;
	
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
			[ InfoEntry.create(API_Message.CUSTOM_INFO_KEY_logo_swf_full_url,"../../Emulator/example_logo.jpg") ];
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
			sendMessage(API_GotKeyboardEvent.create(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey) );
		}		
		
        override public function gotMessage(msg:API_Message):void {
			if (msg is API_DoAllEndMatch) {
				AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
			} else if (msg is API_DoRegisterOnServer) {
				doRegisterOnServer();
			}				
  		}
  		private function doRegisterOnServer():void {
  			sendMessage(API_GotMyUserId.create(userId) );
  			sendMessage(API_GotCustomInfo.create(customInfoEntries) );
  			sendMessage(API_GotUserInfo.create(userId, userInfoEntries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():void {	 
  			sendMessage(API_GotMatchStarted.create([userId], [], extraMatchInfo, matchStartedTime, userStateEntries) );	 	
  		}
	}
}