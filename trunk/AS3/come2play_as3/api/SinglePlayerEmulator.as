package come2play_as3.api
{
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.DisplayObjectContainer;
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
	 * When the server gets doAllEndMatch,
	 * it will wait 2 seconds before starting a new match.
	 */
	public final class SinglePlayerEmulator extends LocalConnectionUser
	{
		public static var DEFAULT_USER_ID:int = 42; 
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
		private var userId:int; 
		private var userInfoEntries:Array/*InfoEntry*/;
		private var userStateEntries:Array/*ServerEntry*/;
		private var apiMsgsQueue:Array/*API_Message*/ = [];
		private var serverStateMiror:ObjectDictionary;
		public function SinglePlayerEmulator(graphics:DisplayObjectContainer) {
			super(graphics,true, DEFAULT_LOCALCONNECTION_PREFIX,true);
			this.customInfoEntries = DEFAULT_GENERAL_INFO;
			this.userId = DEFAULT_USER_ID;
			this.userInfoEntries = DEFAULT_USER_INFO;
			this.userStateEntries = DEFAULT_MATCH_STATE;
		}
		private function updateUserIds(userIdsToUpdate:Array/*int*/,uerIdsToAdd:Array/*int*/):Boolean{
			var updated:Boolean = false;
			for each(var id:int in uerIdsToAdd){
				if(AS3_vs_AS2.IndexOf(userIdsToUpdate,id)==-1){
					updated = true;
					userIdsToUpdate.push(id);
				}
			}
			return updated;
		}	
		private function doRevealEntry(revealEntry:RevealEntry):ServerEntry{
			var oldServerEntry:ServerEntry =/*as*/ serverStateMiror.getValue(revealEntry.key) as ServerEntry
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
				serverEntry = /*as*/ serverStateMiror.getValue(revealEntry.key) as ServerEntry;
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
			for each (var revealEntry:RevealEntry in revealEntries) {
				if (revealEntry.depth == 0) {
					serverEntry = doRevealEntry(revealEntry);
					if (serverEntry!=null)	serverEntries.push(serverEntry);
				}else if (revealEntry.depth > 0) {
					for(var i:int =0;i<=revealEntry.depth;i++){	
						pointerObject = doRevealPointer(revealEntry);
						if(pointerObject == null){
							//break;
						}else if(pointerObject is ServerEntry){
							serverEntry = /*as*/pointerObject as ServerEntry;
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
			var randIndex:int;
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
		private function extractStoredData(userEntries:Array/*UserEntry*/,storePrefrence:int):Array/*ServerEntries*/{
			var serverEntries:Array/*ServerEntry*/ = [];
			var serverEntry:ServerEntry;
			for each (var userEntry:UserEntry in userEntries) {
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
			
			return combinedServerEntries
		}
		private function messageHandler(msg:API_Message,transactionEntries:Array/*<InAS3>*/ = null/*</InAS3>*/):void{
		var serverEntries:Array/*ServerEntry*/ = [];
			var serverEntry:ServerEntry;
			if (msg is API_Transaction) {
				var transaction:API_Transaction = /*as*/msg as API_Transaction;
				for each (var innerMsg:API_Message in transaction.messages) {
					messageHandler(innerMsg,serverEntries);
				}
				if(serverEntries.length > 0)
					queueSendMessage(API_GotStateChanged.create(serverEntries))
				gotMessage(transaction.callback);
			} else if (msg is API_DoStoreState) {
				var doStore:API_DoStoreState = /*as*/msg as API_DoStoreState;				
				serverEntries = extractStoredData(doStore.userEntries,1);
				if(doStore.revealEntries !=null)
					serverEntries = serverEntries.concat(doRevealEntries(doStore.revealEntries))
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(serverEntries));
				else
					transactionEntries = transactionEntries.concat(serverEntries);
				
			}else if (msg is API_DoAllStoreState) { 
				var doAllStoreMsg:API_DoAllStoreState = /*as*/msg as API_DoAllStoreState;
				serverEntries = extractStoredData(doAllStoreMsg.userEntries,2)
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(serverEntries));
				else
					transactionEntries = transactionEntries.concat(serverEntries);
        	}else if(msg is API_DoAllStoreStateCalculation){
        		var stateCalculations:API_DoAllStoreStateCalculation = /*as*/msg as API_DoAllStoreStateCalculation;
        		serverEntries = extractStoredData(stateCalculations.userEntries,3)
				queueSendMessage(API_GotStateChanged.create(serverEntries))
        	}else if (msg is API_DoAllShuffleState){
        		var shuffleState:API_DoAllShuffleState = /*as*/msg as API_DoAllShuffleState;
        		var Key:Object;
        		for(var i:int =0;i<shuffleState.keys.length;i++){
        			Key = shuffleState.keys[i];
        			serverEntry = /*as*/serverStateMiror.getValue(Key) as ServerEntry
        			if(serverEntry != null)
        				serverEntries.push(serverEntry);
        			else{
        				shuffleState.keys.splice(i,1);
        				i--;
        			}
        		}
        		serverEntries = shuffleEntries(shuffleState.keys,serverEntries);
        		if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(serverEntries));
				else
					transactionEntries = transactionEntries.concat(serverEntries);
        	}else if (msg is API_DoAllRevealState){
        		var revealStateMsg:API_DoAllRevealState = /*as*/msg as API_DoAllRevealState;
				serverEntries = doRevealEntries(revealStateMsg.revealEntries)
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create(serverEntries));
				else
					transactionEntries = transactionEntries.concat(serverEntries);
        	}else if (msg is API_DoAllRequestRandomState) { 
        		var doAllSecretStateMsg:API_DoAllRequestRandomState = /*as*/msg as API_DoAllRequestRandomState;
				var randomINT:int = Math.random()*int.MAX_VALUE;
				serverEntry = ServerEntry.create(doAllSecretStateMsg.key,randomINT,-1,doAllSecretStateMsg.isSecret?[]:null,getTimer())
				serverStateMiror.addEntry(serverEntry);
				if(transactionEntries == null)
					queueSendMessage(API_GotStateChanged.create([serverEntry]));
				else
					transactionEntries = transactionEntries.concat([serverEntry]);
        	}else if (msg is API_DoAllEndMatch) {
				var endMatch:API_DoAllEndMatch = /*as*/msg as API_DoAllEndMatch;
				var finishedPlayerIds:Array = [];
				for each (var matchOver:PlayerMatchOver in endMatch.finishedPlayers) {
					finishedPlayerIds.push( matchOver.playerId );
				}
				queueSendMessage( API_GotMatchEnded.create(finishedPlayerIds) );
				AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), 2000);
			} else if (msg is API_DoRegisterOnServer) {
				doRegisterOnServer();
			} else if (msg is API_DoAllRequestStateCalculation) { 
				var requestStateCalculationMsg:API_DoAllRequestStateCalculation = /*as*/msg as API_DoAllRequestStateCalculation;
				for each (var key:Object in requestStateCalculationMsg.keys){
					var entry:ServerEntry = /*as*/serverStateMiror.getValue(key) as ServerEntry;
					if(entry!= null)
						serverEntries.push(entry)
					else
						trace(JSON.stringify(key))
				}
				queueSendMessage(API_GotRequestStateCalculation.create(1,serverEntries))
			} else if (msg is API_DoFinishedCallback) {
				if (apiMsgsQueue.length==0) throwError("Game sent too many DoFinishedCallback");
				apiMsgsQueue.shift();
				if (apiMsgsQueue.length>0) sendTopQueue();
			}		
		}
		
        override public function gotMessage(msg:API_Message):void {        	
			messageHandler(msg);			
  		}
  		private function doRegisterOnServer():void {
  			queueSendMessage(API_GotCustomInfo.create(customInfoEntries) );
  			queueSendMessage(API_GotUserInfo.create(userId, userInfoEntries) );
	 		sendNewMatch();
  		}
  		private function sendNewMatch():void {
  			serverStateMiror = new ObjectDictionary();	
  			for each(var serverEntry:ServerEntry in userStateEntries) {
  				serverStateMiror.addEntry(serverEntry);
			}				
  			queueSendMessage(API_GotMatchStarted.create([userId], [], userStateEntries) );	 	
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