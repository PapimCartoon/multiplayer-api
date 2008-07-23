package come2play_as3.api
{
	import come2play_as3.util.JSON;
	
	import flash.display.MovieClip;
	import flash.net.LocalConnection;
	
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
	public final class SinglePlayerEmulator
	{
		private var lcHandshake:LocalConnection; 
		private var lcDoChannel:LocalConnection;  
		private var iChanel:int;
		private var sDoChanel:String;
		private var sGotChanel:String;
		private var sPrefix:String;
		
		private var general_info_entries:Array/*Entry*/;
		private var user_id:int; 
		private var user_info_entries:Array/*Entry*/;
		private var extra_match_info:Object/*Serializable*/;
		private var match_started_time:int; 
		private var match_state:Array/*UserEntry*/;
		
		public function SinglePlayerEmulator(
			graphics:MovieClip,
			sPrefix:String,
			general_info_entries:Array/*Entry*/,
			user_id:int, 
			user_info_entries:Array/*Entry*/,
			extra_match_info:Object/*Serializable*/, 
			match_started_time:int, 
			match_state:Array/*UserEntry*/
			)
		{
			this.sPrefix = sPrefix;
			this.general_info_entries = general_info_entries;
			this.user_id = user_id;
			this.user_info_entries = user_info_entries;
			this.extra_match_info = extra_match_info;
			this.match_started_time = match_started_time;
			this.match_state = match_state;			
			
			lcHandshake = new LocalConnection();
			var thisObj:SinglePlayerEmulator = this;
			AS3_vs_AS2.addStatusListener(lcHandshake, this, ["localconnection_callback"]);
			
			var handShakeStr:String = BaseGameAPI.getHandshakeString(sPrefix);
			trace("SinglePlayerEmulator connected on channel="+handShakeStr);
			lcHandshake.connect(handShakeStr);
						
			AS3_vs_AS2.addKeyboardListener(graphics, AS3_vs_AS2.delegate(this, this.reportKeyDown));	
		}		
		private function reportKeyDown(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {		
			sendCallback("got_keyboard_event",[is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey]);
		}		
		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
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
  		private function do_register_on_server(iChannel:int):void {
  			this.iChanel = iChannel;
			sDoChanel = BaseGameAPI.getDoChanelString(sPrefix, iChanel);
			sGotChanel = BaseGameAPI.getGotChanelString(sPrefix, iChanel);
			
  			lcDoChannel = new LocalConnection();
			AS3_vs_AS2.addStatusListener(lcDoChannel, this, ["localconnection_callback"]);
			lcDoChannel.connect(sDoChanel);
			
			sendCallback("got_my_user_id",[user_id]);
			sendInfo("got_general_info", general_info_entries);
			sendInfo("got_user_info", user_info_entries);	
	 		sendNewMatch();
  		}
  		private function sendNewMatch():void {	 	
			sendCallback("got_match_started", [ [user_id], extra_match_info, match_started_time]);	 	
  			sendInfo("got_stored_match_state", match_state);
  		}
  		private function sendCallback(methodName:String, parameters:Array):void {
  			trace("sendCallback on channel="+sGotChanel+' for methodName='+methodName+' parameters='+JSON.stringify(parameters));
  			lcDoChannel.send(sGotChanel, "localconnection_callback", methodName, parameters);
  		}
  		private function sendInfo(name:String, entries:Array/*Entry*/):void {
  			var keys:Array = [];
			var values:Array = [];
			var user_ids:Array = name=="got_stored_match_state" ? [] : null;
			translate_entries(entries, keys, values, user_ids);
			var parameters:Array = [keys, values];
			if (name=="got_user_info") parameters = [user_id].concat(parameters);
			if (name=="got_stored_match_state") parameters = [user_ids].concat(parameters);
			sendCallback(name, parameters);			
  		}
		private function translate_entries(entries:Array, keys:Array, values:Array, user_ids:Array):void {
			for (var i:int = 0; i<entries.length; i++) {
				var entry:Entry = entries[i];
				keys[i] = entry.key;
				values[i] = entry.value;
				if (user_ids!=null) user_ids[i] = AS3_vs_AS2.asUserEntry(entry).user_id;
			}
		}
	}
}