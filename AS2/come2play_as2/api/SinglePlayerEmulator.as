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
			[ new Entry(BaseGameAPI.GENERAL_INFO_KEY_logo_swf_full_url,"example_logo.jpg") ];
		public static var DEFAULT_USER_INFO:Array =
				[ 	new Entry(BaseGameAPI.USER_INFO_KEY_name, "User name"),
					new Entry(BaseGameAPI.USER_INFO_KEY_avatar_url, "Avatar_1.gif")
				];
		public static var DEFAULT_MATCH_STATE:Array = []; // you can change this and load a saved match
		public static var DEFAULT_USER_ID:Number = 42; 
		public static var DEFAULT_EXTRA_MATCH_INFO:String = ""; 
		public static var DEFAULT_MATCH_STARTED_TIME:Number = 999;
				
		private var lcHandshake:LocalConnection; 
		private var lcDoChannel:LocalConnection;  
		private var iChanel:Number;
		private var sDoChanel:String;
		private var sGotChanel:String;
		private var sPrefix:String;
		
		private var general_info_entries:Array/*Entry*/;
		private var user_id:Number; 
		private var user_info_entries:Array/*Entry*/;
		private var extra_match_info:Object/*Serializable*/;
		private var match_started_time:Number; 
		private var match_state:Array/*UserEntry*/;
		private var api:API_GotDispatcher;
		
		public function SinglePlayerEmulator(graphics:MovieClip) {
			api = new API_GotDispatcher(AS3_vs_AS2.delegate(this,this.sendCallback));
			this.sPrefix = BaseGameAPI.DEFAULT_LOCALCONNECTION_HANDSHAKE_PREFIX;
			this.general_info_entries = DEFAULT_GENERAL_INFO;
			this.user_id = DEFAULT_USER_ID;
			this.user_info_entries = DEFAULT_USER_INFO;
			this.extra_match_info = DEFAULT_EXTRA_MATCH_INFO;
			this.match_started_time = DEFAULT_MATCH_STARTED_TIME;
			this.match_state = DEFAULT_MATCH_STATE;			
									
			lcHandshake = new LocalConnection();
			var thisObj:SinglePlayerEmulator = this;
			AS3_vs_AS2.addStatusListener(lcHandshake, this, ["localconnection_callback"]);
			
			var handShakeStr:String = BaseGameAPI.getHandshakeString(sPrefix);
			trace("SinglePlayerEmulator connected on channel="+handShakeStr);
			lcHandshake.connect(handShakeStr);
						
			AS3_vs_AS2.addKeyboardListener(graphics, AS3_vs_AS2.delegate(this, this.reportKeyDown));	
		}		
		private function reportKeyDown(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {		
			api.API_got_keyboard_event(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey);
		}		
		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):Void {
			trace("SinglePlayerEmulator got methodName="+methodName+" parameters="+JSON.stringify(parameters));
			try {
				switch(methodName) {
				case "do_agree_on_match_over":
				case "do_juror_end_match":
					AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
					break;
				case "do_register_on_server":
					do_register_on_server(parameters[0]);
					break;
				}		
			} catch(err:Error) {
				BaseGameAPI.error("Error thrown in SinglePlayerEmulator:"+AS3_vs_AS2.error2String(err));
			}					
  		}
  		private function do_register_on_server(iChannel:Number):Void {
  			this.iChanel = iChannel;
			sDoChanel = BaseGameAPI.getDoChanelString(sPrefix, iChanel);
			sGotChanel = BaseGameAPI.getGotChanelString(sPrefix, iChanel);
			
  			lcDoChannel = new LocalConnection();
			AS3_vs_AS2.addStatusListener(lcDoChannel, this, ["localconnection_callback"]);
			lcDoChannel.connect(sDoChanel);
			
			api.API_got_my_user_id(user_id);
			sendInfo("got_general_info", general_info_entries);
			sendInfo("got_user_info", user_info_entries);	
	 		sendNewMatch();
  		}
  		private function sendNewMatch():Void {	 	
			sendInfo("got_match_started", match_state);	 	
  		}
  		public function sendCallback(methodName:String, parameters:Array):Void {
  			trace("sendCallback on channel="+sGotChanel+' for methodName='+methodName+' parameters='+JSON.stringify(parameters));
  			lcDoChannel.send(sGotChanel, "localconnection_callback", methodName, parameters);
  		}
  		private function sendInfo(name:String, entries:Array/*Entry*/):Void {
  			var keys:Array = [];
			var values:Array = [];
			var user_ids:Array = name=="got_match_started" ? [] : null;
			translate_entries(entries, keys, values, user_ids);
			var parameters:Array = [keys, values];
			if (name=="got_user_info")
				api.API_got_user_info(user_id, keys, values);
			else if (name=="got_general_info")
				api.API_got_general_info(keys, values);
			else if (name=="got_match_started")
				api.API_got_match_started( [user_id], [], extra_match_info, match_started_time, user_ids, keys, values, null);
  		}
		private function translate_entries(entries:Array, keys:Array, values:Array, user_ids:Array):Void {
			for (var i:Number = 0; i<entries.length; i++) {
				var entry:Entry = entries[i];
				keys[i] = entry.key;
				values[i] = entry.value;
				if (user_ids!=null) user_ids[i] = AS3_vs_AS2.asUserEntry(entry).user_id;
			}
		}
	}
