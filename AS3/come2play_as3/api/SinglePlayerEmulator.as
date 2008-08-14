package come2play_as3.api
{
	import come2play_as3.util.JSON;
	
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
	public final class SinglePlayerEmulator
	{
		public static var DEFAULT_GENERAL_INFO:Array/*InfoEntry*/ =
			[ new InfoEntry(API_Message.CUSTOM_INFO_KEY_logo_swf_full_url,"../Emulator/example_logo.jpg") ];
		public static var DEFAULT_USER_INFO:Array/*InfoEntry*/ =
				[ 	new InfoEntry(API_Message.USER_INFO_KEY_name, "User name"),
					new InfoEntry(API_Message.USER_INFO_KEY_avatar_url, "../Emulator/Avatar_1.gif")
				];
		public static var DEFAULT_MATCH_STATE:Array/*ServerEntry*/ = []; // you can change this and load a saved match
		public static var DEFAULT_USER_ID:int = 42; 
		public static var DEFAULT_EXTRA_MATCH_INFO:String = ""; 
		public static var DEFAULT_MATCH_STARTED_TIME:int = 999;
				
		private var lcDoChannel:LocalConnection;  
		private var sDoChanel:String;
		private var sGotChanel:String;
		
		private var customInfoEntries:Array/*InfoEntry*/;
		private var userId:int; 
		private var userInfoEntries:Array/*InfoEntry*/;
		private var extraMatchInfo:Object/*Serializable*/;
		private var matchStartedTime:int; 
		private var userStateEntries:Array/*ServerEntry*/;
		
		public function SinglePlayerEmulator(graphics:MovieClip) {
			this.customInfoEntries = DEFAULT_GENERAL_INFO;
			this.userId = DEFAULT_USER_ID;
			this.userInfoEntries = DEFAULT_USER_INFO;
			this.extraMatchInfo = DEFAULT_EXTRA_MATCH_INFO;
			this.matchStartedTime = DEFAULT_MATCH_STARTED_TIME;
			this.userStateEntries = DEFAULT_MATCH_STATE;			
			
			var sPrefix:String = BaseGameAPI.DEFAULT_LOCALCONNECTION_PREFIX;									
			sDoChanel = BaseGameAPI.getDoChanelString(sPrefix);
			sGotChanel = BaseGameAPI.getGotChanelString(sPrefix);
			
  			lcDoChannel = new LocalConnection();
			AS3_vs_AS2.addStatusListener(lcDoChannel, this, ["localconnection_callback"]);
			trace("SinglePlayerEmulator connected on channel="+sDoChanel);
			lcDoChannel.connect(sDoChanel);
						
			AS3_vs_AS2.addKeyboardListener(graphics, AS3_vs_AS2.delegate(this, this.reportKeyDown));	
		}		
		private function reportKeyDown(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {		
			sendCallback(new API_GotKeyboardEvent(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey) );
		}		
		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
			try {
				var msg:API_Message = API_Message.createMessage(methodName, parameters);
				if (msg is API_DoAllEndMatch) {
					AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
				} else if (msg is API_DoRegisterOnServer) {
					doRegisterOnServer();
				}		
			} catch(err:Error) {
				BaseGameAPI.error("Error thrown in SinglePlayerEmulator:"+AS3_vs_AS2.error2String(err));
			}					
  		}
  		private function doRegisterOnServer():void {
  			sendCallback(new API_GotMyUserId(userId) );
  			sendCallback(new API_GotCustomInfo(customInfoEntries) );
  			sendCallback(new API_GotUserInfo(userId, userInfoEntries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():void {	 
  			sendCallback(new API_GotMatchStarted([userId], [], extraMatchInfo, matchStartedTime, userStateEntries) );	 	
  		}
  		private function sendCallback(msg:API_Message):void {
  			var methodName:String = msg.methodName;
  			var parameters:Array = msg.parameters;
  			lcDoChannel.send(sGotChanel, "localconnection_callback", methodName, parameters);
  		}
	}
}