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
	 * When the server gets doAllEndMatch,
	 * it will wait 2 seconds before starting a new match.
	 */
import come2play_as2.api.*;
	class come2play_as2.api.SinglePlayerEmulator extends LocalConnectionUser
	{
		public static var DEFAULT_USER_ID:Number = 42; 
		public var messageNum:Number;
		public static var DEFAULT_GENERAL_INFO:Array/*InfoEntry*/ =
			[  
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_myUserId,DEFAULT_USER_ID), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_logoFullUrl,"../../Emulator/example_logo.jpg"), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameHeight,400), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameWidth,400),
				InfoEntry.create("checkThrowingAnError",false), // testing the red error window
				// game specific info
				// I replaced the second default symbol with a camel image
				InfoEntry.create("customSymbolsStringArray",[null, "../../Emulator/camel70x70.PNG"])  
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
		private var serverStateMiror:ObjectDictionary;
		public function SinglePlayerEmulator(graphics:MovieClip) {
			super(graphics,true, DEFAULT_LOCALCONNECTION_PREFIX,true);
			this.customInfoEntries = DEFAULT_GENERAL_INFO;
			this.userId = DEFAULT_USER_ID;
			this.userInfoEntries = DEFAULT_USER_INFO;
			this.userStateEntries = DEFAULT_MATCH_STATE;
		}
		private function updateUserIds(userIdsToUpdate:Array/*int*/,uerIdsToAdd:Array/*int*/):Boolean{
			var updated:Boolean = false;
			for (var i56:Number=0; i56<uerIdsToAdd.length; i56++) { var id:Number = uerIdsToAdd[i56]; 
				if(AS3_vs_AS2.IndexOf(userIdsToUpdate,id)==-1){
					updated = true;
					userIdsToUpdate.push(id);
				}
			}
			return updated;
		}	
		private function doRevealEntry(revealEntry:RevealEntry):ServerEntry{
			var oldServerEntry:ServerEntry =ServerEntry( serverStateMiror.getValue(revealEntry.key))
			if (oldServerEntry == null) return null;
			var serverEntry:ServerEntry =ServerEntry.create(oldServerEntry.key,oldServerEntry.value,oldServerEntry.storedByUserId,oldServerEntry.visibleToUserIds,getTimer());
			if (serverEntry == null)return null;
			if (serverEntry.visibleToUserIds == null) return null;
			if (revealEntry.userIds == null) {
				serverEntry.visibleToUserIds = null;	
			}else if (!updateUserIds(serverEntry.visibleToUserIds,revealEntry.userIds)) return null;
			serverStateMiror.addEntry(serverEntry);	
			return serverEntry
		}
		private function doRevealPointer(revealEntry:RevealEntry):Object{
			var serverEntry:ServerEntry = doRevealEntry(revealEntry)
			if(serverEntry == null){
				serverEntry = ServerEntry( serverStateMiror.getValue(revealEntry.key));
				if(serverEntry == null){
					return null;
				}else{
					return serverEntry.value
				}
			}else{
				return serverEntry;
			}
		}	
		private function doRevealEntries(revealEntries:Array/*RevealEntry*/):Array/*ServerEntries*/{
			var serverEntries:Array/*ServerEntry*/ = new Array();
			var serverEntry:ServerEntry;
			var pointerObject:Object;
			for (var i93:Number=0; i93<revealEntries.length; i93++) { var revealEntry:RevealEntry = revealEntries[i93]; 
				if (revealEntry.depth == 0) {
					serverEntry = doRevealEntry(revealEntry);
					if (serverEntry!=null)	serverEntries.push(serverEntry);
				}else if (revealEntry.depth > 0) {
					for(var i:Number =0;i<=revealEntry.depth;i++){	
						pointerObject = doRevealPointer(revealEntry);
						if(pointerObject == null){
							//break;
						}else if(pointerObject instanceof ServerEntry){
							serverEntry = ServerEntry(pointerObject);
							serverEntries.push(serverEntry);
							revealEntry.key = serverEntry.value;	
						}else{
							revealEntry.key = pointerObject;
						}				
					}
				}
			}
			return serverEntries;
		}
		private function shuffleEntries(keys:Array/*Object*/,serverEntries:Array/*SErverEntry*/):Array/*ServerEntry*/{
			var randIndex:Number;
			var newServerEntries:Array = new Array();
			var serverEntry:ServerEntry;
			var currentKey:Object;
			while(serverEntries.length > 0){
				randIndex =Math.random()*serverEntries.length;
				serverEntry = serverEntries[randIndex]
				serverEntries.splice(randIndex,1);
				currentKey = keys.pop()
				newServerEntries.push(ServerEntry.create(currentKey,null,-1,[],getTimer()));
				serverStateMiror.addEntry(ServerEntry.create(currentKey,serverEntry.value,-1,[],getTimer()));
			}
			return newServerEntries;
		}
		/*storePrefrence
		 * 1 - normal do store
		 * 2 - doAllStore
		 * 3 - calculator store
		 */
		private function extractStoredData(userEntries:Array/*UserEntry*/,storePrefrence:Number):Array/*ServerEntries*/{
			var serverEntries:Array/*ServerEntry*/ = [];
			var serverEntry:ServerEntry;
			for (var i137:Number=0; i137<userEntries.length; i137++) { var userEntry:UserEntry = userEntries[i137]; 
				switch(storePrefrence){
					case 1:serverEntry = ServerEntry.create(userEntry.key, userEntry.value,userId,userEntry.isSecret ? [userId] : null, getTimer()); break;
					case 2:serverEntry = ServerEntry.create(userEntry.key, userEntry.value,-1,userEntry.isSecret ? [] : null, getTimer()); break;
					case 3:serverEntry = ServerEntry.create(userEntry.key, userEntry.value,-1,userEntry.isSecret ? [] : null, getTimer()); break;
				}
				
				serverStateMiror.addEntry(serverEntry);
				serverEntries.push(serverEntry); 
			}	
			return serverEntries;
		}
		private function combineServerEntries(serverEntries:Array/*ServerEntry*/):Array/*ServerEntry*/{
			var combinedServerEntries:Array/*ServerEntry*/ = new Array();	
			var dicArray:Array = new Array();
			for(var i:Number = (serverEntries.length -1);i>=0;i--)
			{
				var serverEntry:ServerEntry = serverEntries[i];
				if(dicArray[JSON.stringify(serverEntry.key)] == null)
				{
					dicArray[JSON.stringify(serverEntry.key)] = true;
					combinedServerEntries.unshift(serverEntry);
				}
			}
			
			return combinedServerEntries
		}
		
		private function messageHandler(msg:API_Message,transactionEntries:Array/*<InAS3> = null</InAS3>*/):Array{
		var serverEntries:Array/*ServerEntry*/ = [];
			var serverEntry:ServerEntry;
			if (msg instanceof API_Transaction) {
				var transaction:API_Transaction = API_Transaction(msg);
				var tempServerEntries:Array;
				for (var i171:Number=0; i171<transaction.messages.length; i171++) { var innerMsg:API_Message = transaction.messages[i171]; 
					tempServerEntries = messageHandler(innerMsg,serverEntries);
					if(tempServerEntries.length>0)
					serverEntries = serverEntries.concat(tempServerEntries);
				}
				if(serverEntries.length > 0)
					queueSendMessage(API_GotStateChanged.create(++messageNum,combineServerEntries(serverEntries)))
				gotMessage(transaction.callback);
			} else if (msg instanceof API_DoStoreState) {
				var doStore:API_DoStoreState = API_DoStoreState(msg);				
				serverEntries = extractStoredData(doStore.userEntries,1);
				if(doStore.revealEntries !=null)
					serverEntries = serverEntries.concat(doRevealEntries(doStore.revealEntries))
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(++messageNum,serverEntries));
				else
					return serverEntries;
				
			}else if (msg instanceof API_DoAllStoreState) { 
				var doAllStoreMsg:API_DoAllStoreState = API_DoAllStoreState(msg);
				serverEntries = extractStoredData(doAllStoreMsg.userEntries,2)
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(++messageNum,serverEntries));
				else
					return serverEntries;
        	}else if(msg instanceof API_DoAllStoreStateCalculation){
        		var stateCalculations:API_DoAllStoreStateCalculation = API_DoAllStoreStateCalculation(msg);
        		serverEntries = extractStoredData(stateCalculations.userEntries,3)
				queueSendMessage(API_GotStateChanged.create(++messageNum,serverEntries))
        	}else if (msg instanceof API_DoAllShuffleState){
        		var shuffleState:API_DoAllShuffleState = API_DoAllShuffleState(msg);
        		var Key:Object;
        		for(var i:Number =0;i<shuffleState.keys.length;i++){
        			Key = shuffleState.keys[i];
        			serverEntry = ServerEntry(serverStateMiror.getValue(Key))
        			if(serverEntry != null)
        				serverEntries.push(serverEntry);
        			else{
        				shuffleState.keys.splice(i,1);
        				i--;
        			}
        		}
        		serverEntries = shuffleEntries(shuffleState.keys,serverEntries);
        		if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(++messageNum,serverEntries));
				else
					return serverEntries;
        	}else if (msg instanceof API_DoAllRevealState){
        		var revealStateMsg:API_DoAllRevealState = API_DoAllRevealState(msg);
				serverEntries = doRevealEntries(revealStateMsg.revealEntries)
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(++messageNum,serverEntries));
				else
					return serverEntries;
        	}else if (msg instanceof API_DoAllRequestRandomState) { 
        		var doAllSecretStateMsg:API_DoAllRequestRandomState = API_DoAllRequestRandomState(msg);
				var randomINT:Number = Math.random()*int.MAX_VALUE;
				serverEntry = ServerEntry.create(doAllSecretStateMsg.key,randomINT,-1,doAllSecretStateMsg.isSecret?[]:null,getTimer())
				serverStateMiror.addEntry(serverEntry);
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(++messageNum,[serverEntry]));
				else
					return [serverEntry];
        	}else if (msg instanceof API_DoAllEndMatch) {
				var endMatch:API_DoAllEndMatch = API_DoAllEndMatch(msg);
				var finishedPlayerIds:Array = [];
				for (var i237:Number=0; i237<endMatch.finishedPlayers.length; i237++) { var matchOver:PlayerMatchOver = endMatch.finishedPlayers[i237]; 
					finishedPlayerIds.push( matchOver.playerId );
				}
				queueSendMessage( API_GotMatchEnded.create(++messageNum,finishedPlayerIds) );
				AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
			} else if (msg instanceof API_DoRegisterOnServer) {
				doRegisterOnServer();
			} else if (msg instanceof API_DoAllRequestStateCalculation) { 
				var requestStateCalculationMsg:API_DoAllRequestStateCalculation = API_DoAllRequestStateCalculation(msg);
				for (var i246:Number=0; i246<requestStateCalculationMsg.keys.length; i246++) { var key:Object = requestStateCalculationMsg.keys[i246]; 
					var entry:ServerEntry = ServerEntry(serverStateMiror.getValue(key));
					if(entry!= null)
						serverEntries.push(entry)
					else
						trace(JSON.stringify(key))
				}
				queueSendMessage(API_GotRequestStateCalculation.create(1,serverEntries))
			} else if (msg instanceof API_DoFinishedCallback) {
				if (apiMsgsQueue.length==0) throwError("Game sent too many DoFinishedCallback");
				apiMsgsQueue.shift();
				if (apiMsgsQueue.length>0) sendTopQueue();
			}	
			return [];	
		}
		
        /*override*/ public function gotMessage(msg:API_Message):Void {        	
			messageHandler(msg);			
  		}
  		private function doRegisterOnServer():Void {
  			queueSendMessage(API_GotCustomInfo.create(customInfoEntries) );
  			queueSendMessage(API_GotUserInfo.create(userId, userInfoEntries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():Void {
  			serverStateMiror = new ObjectDictionary();	
  			for (var i272:Number=0; i272<userStateEntries.length; i272++) { var serverEntry:ServerEntry = userStateEntries[i272]; 
  				serverStateMiror.addEntry(serverEntry);
			}				
			messageNum = 0;
  			queueSendMessage(API_GotMatchStarted.create(messageNum,[userId], [], userStateEntries) );	 	
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
