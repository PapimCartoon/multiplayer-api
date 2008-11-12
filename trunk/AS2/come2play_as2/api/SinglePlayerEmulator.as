	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	
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
import come2play_as2.api.*;
	class come2play_as2.api.SinglePlayerEmulator extends LocalConnectionUser
	{
		public static var DEFAULT_USER_ID:Number = 42; 
		public static var DEFAULT_GENERAL_INFO:Array/*InfoEntry*/ =
			[  
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_myUserId,DEFAULT_USER_ID), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_logoFullUrl,"../../Emulator/example_logo.jpg"), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameHeight,400), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameWidth,400) 
			];
		public static var DEFAULT_USER_INFO:Array/*InfoEntry*/ =
				[ 	InfoEntry.create(API_Message.USER_INFO_KEY_name, "User name"),
					InfoEntry.create(API_Message.USER_INFO_KEY_avatar_url, "../../Emulator/Avatar_1.gif")
				];
		public static var DEFAULT_MATCH_STATE:Array/*ServerEntry*/ = []; // you can change this and load a saved match
						
		private var customInfoEntries:Array/*InfoEntry*/;
		private var userId:Number; 
		private var userInfoEntries:Array/*InfoEntry*/;
		private var userStateEntries:Array/*ServerEntry*/;
		private var apiMsgsQueue:Array/*API_Message*/ = [];
		
		public function SinglePlayerEmulator(graphics:MovieClip) {
			super(graphics,true, DEFAULT_LOCALCONNECTION_PREFIX);
			this.customInfoEntries = DEFAULT_GENERAL_INFO;
			this.userId = DEFAULT_USER_ID;
			this.userInfoEntries = DEFAULT_USER_INFO;
			this.userStateEntries = DEFAULT_MATCH_STATE;			
									
			AS3_vs_AS2.addKeyboardListener(graphics, AS3_vs_AS2.delegate(this, this.reportKeyDown));	
		}		
		private function reportKeyDown(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {		
			queueSendMessage(API_GotKeyboardEvent.create(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey) );
		}		
		
        /*override*/ public function gotMessage(msg:API_Message):Void {        	
			if (msg instanceof API_Transaction) {
				var transaction:API_Transaction = API_Transaction(msg);
				for (var i61:Number=0; i61<transaction.messages.length; i61++) { var innerMsg:API_Message = transaction.messages[i61]; 
					gotMessage(innerMsg);
				}
				gotMessage(transaction.callback);
			} else if (msg instanceof API_DoStoreState) {
				var doStore:API_DoStoreState = API_DoStoreState(msg);				
				var userEntries:Array/*UserEntry*/ = doStore.userEntries;
				var serverEntries:Array/*ServerEntry*/ = [];
				for (var i69:Number=0; i69<userEntries.length; i69++) { var userEntry:UserEntry = userEntries[i69]; 
					var serverEntry:ServerEntry = ServerEntry.create(userEntry.key, userEntry.value, userId,userEntry.isSecret ? [userId] : null, getTimer());
					serverEntries.push(serverEntry); 
				}
				queueSendMessage(API_GotStateChanged.create(serverEntries));
				
			} else if (msg instanceof API_DoAllEndMatch) {
				var endMatch:API_DoAllEndMatch = API_DoAllEndMatch(msg);
				var finishedPlayerIds:Array = [];
				for (var i78:Number=0; i78<endMatch.finishedPlayers.length; i78++) { var matchOver:PlayerMatchOver = endMatch.finishedPlayers[i78]; 
					finishedPlayerIds.push( matchOver.playerId );
				}
				queueSendMessage( API_GotMatchEnded.create(finishedPlayerIds) );
				AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
			} else if (msg instanceof API_DoRegisterOnServer) {
				doRegisterOnServer();
			} else if (msg instanceof API_DoFinishedCallback) {
				if (apiMsgsQueue.length==0) throwError("Game sent too many DoFinishedCallback");
				apiMsgsQueue.shift();
				if (apiMsgsQueue.length>0) sendTopQueue();
			}				
  		}
  		private function doRegisterOnServer():Void {
  			queueSendMessage(API_GotCustomInfo.create(customInfoEntries) );
  			queueSendMessage(API_GotUserInfo.create(userId, userInfoEntries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():Void {	 
  			queueSendMessage(API_GotMatchStarted.create([userId], [], userStateEntries) );	 	
  		}
  		private function queueSendMessage(msg:API_Message):Void {
  			apiMsgsQueue.push(msg);
  			if (apiMsgsQueue.length==1) sendTopQueue();
  		}
  		
  		private function sendTopQueue():Void {  			
  			var msg:API_Message = apiMsgsQueue[0];
  			sendMessage(msg);
  		}
  		
  		
	}
