	import come2play_as2.util.JSON;
	
	
	/**
	 * This class simulates a server that works only for a single player.
	 * It opens a localconnection and waits for the player to connect,
	 * following the standard handshake:
	 * Player calls do_register_on_server,
	 * and then the server will call:
	 * got_general_info
	 * got_user_info
	 * got_match_started
	 * 
	 * The server will also listen to keyboard events and call:
	 * got_keyboard_event
	 * 
	 * When the server gets do_agree_on_match_over or do_juror_end_match,
	 * it will wait 2 seconds before starting a new match.
	 */
import come2play_as2.api.*;
	class come2play_as2.api.SinglePlayerEmulator
	{
		public static var DEFAULT_GENERAL_INFO:Array =
			[ new Entry(BaseGameAPI.GENERAL_INFO_KEY_logo_swf_full_url,"../Emulator/example_logo.jpg") ];
		public static var DEFAULT_USER_INFO:Array =
				[ 	new Entry(BaseGameAPI.USER_INFO_KEY_name, "User name"),
					new Entry(BaseGameAPI.USER_INFO_KEY_avatar_url, "../Emulator/Avatar_1.gif")
				];
		public static var DEFAULT_MATCH_STATE:Array = []; // you can change this and load a saved match
		public static var DEFAULT_USER_ID:Number = 42; 
		public static var DEFAULT_EXTRA_MATCH_INFO:String = ""; 
		public static var DEFAULT_MATCH_STARTED_TIME:Number = 999;
				
		private var lcDoChannel:LocalConnection;  
		private var sDoChanel:String;
		private var sGotChanel:String;
		
		private var general_info_entries:Array/*Entry*/;
		private var user_id:Number; 
		private var user_info_entries:Array/*Entry*/;
		private var extra_match_info:Object/*Serializable*/;
		private var match_started_time:Number; 
		private var match_state:Array/*UserEntry*/;
		
		public function SinglePlayerEmulator(graphics:MovieClip) {
			this.general_info_entries = DEFAULT_GENERAL_INFO;
			this.user_id = DEFAULT_USER_ID;
			this.user_info_entries = DEFAULT_USER_INFO;
			this.extra_match_info = DEFAULT_EXTRA_MATCH_INFO;
			this.match_started_time = DEFAULT_MATCH_STARTED_TIME;
			this.match_state = DEFAULT_MATCH_STATE;			
			
			var sPrefix:String = BaseGameAPI.DEFAULT_LOCALCONNECTION_PREFIX;									
			sDoChanel = BaseGameAPI.getDoChanelString(sPrefix);
			sGotChanel = BaseGameAPI.getGotChanelString(sPrefix);
			
  			lcDoChannel = new LocalConnection();
			AS3_vs_AS2.addStatusListener(lcDoChannel, this, ["localconnection_callback"]);
			trace("SinglePlayerEmulator connected on channel="+sDoChanel);
			lcDoChannel.connect(sDoChanel);
						
			AS3_vs_AS2.addKeyboardListener(graphics, AS3_vs_AS2.delegate(this, this.reportKeyDown));	
		}		
		private function reportKeyDown(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {		
			sendCallback(new API_GotKeyboardEvent(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey) );
		}		
		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):Void {
			trace("SinglePlayerEmulator got methodName="+methodName+" parameters="+JSON.stringify(parameters));
			try {
				var msg:API_Message = API_Message.createMessage(methodName, parameters);
				if (msg instanceof API_DoAllEndMatch) {
					AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
				} else if (msg instanceof API_DoRegisterOnServer) {
					do_register_on_server();
				}		
			} catch(err:Error) {
				BaseGameAPI.error("Error thrown in SinglePlayerEmulator:"+AS3_vs_AS2.error2String(err));
			}					
  		}
  		private function do_register_on_server():Void {
  			sendCallback(new API_GotMyUserId(user_id) );
  			sendCallback(new API_GotGeneralInfo(general_info_entries) );
  			sendCallback(new API_GotUserInfo(user_id, user_info_entries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():Void {	 
  			sendCallback(new API_GotMatchStarted([user_id], [], extra_match_info, match_started_time,match_state) );	 	
  		}
  		private function sendCallback(msg:API_Message):Void {
  			var methodName:String = msg.methodName;
  			var parameters:Array = msg.parameters;
  			trace("sendCallback on channel="+sGotChanel+' for methodName='+methodName+' parameters='+JSON.stringify(parameters));
  			lcDoChannel.send(sGotChanel, "localconnection_callback", methodName, parameters);
  		}
	}
