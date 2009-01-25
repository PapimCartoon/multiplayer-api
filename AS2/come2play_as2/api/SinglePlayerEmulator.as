﻿	import come2play_as2.api.auto_copied.*;
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
	 * When NUM_OF_PLAYERS=1, there is a single player,
	 * which is suitable for real-time games (like MineSweeper).
	 * In turn-based games (like Monopoly), you can simulate several players.
	 * The emulator will start with the first player,
	 * and whenever it receives a call doAllSetTurn(X),
	 * then it will end the match, change CUSTOM_INFO_KEY_myUserId to X,
	 * and load the match.
	 * 
	 * When the server gets doAllEndMatch,
	 * it will wait 2 seconds before starting a new match.
	 */
import come2play_as2.api.*;
	class come2play_as2.api.SinglePlayerEmulator extends LocalConnectionUser
	{
		public static var START_NEW_GAME_AFTER_MILLISECONDS:Number = 5000;
		public static var NUM_OF_PLAYERS:Number = 1;
		public static var DEFAULT_USER_IDS:Array/*int*/ = [42,43,44,45];
		private static function getFirstPlayerId():Number {
			return DEFAULT_USER_IDS[0];
		}
		private static function getPlayerIds():Array/*int*/ {
			var res:Array/*int*/ = [];
			for (var i:Number=0; i<NUM_OF_PLAYERS; i++)
				res.push(DEFAULT_USER_IDS[i]);
			return res;			
		}
		public static var DEFAULT_FINISHED_USER_IDS:Array/*int*/ = []; // if you want to simulate loading a match where some users already finished playing
		public static var DEFAULT_CUSTOM_INFO:Array/*InfoEntry*/ =
			[   
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_logoFullUrl,"../../Emulator/example_logo.jpg"), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameHeight,400), 
				InfoEntry.create(API_Message.CUSTOM_INFO_KEY_gameWidth,400),
				InfoEntry.create("checkThrowingAnError",false) // testing the red error window
			];
		public static var OVERRIDING_CUSTOM_INFO:Array/*InfoEntry*/ = []; // set by reflection, do not set it in the code!
		public static var DEFAULT_USERS_INFO:Array/*InfoEntry[]*/ =
			[
				[ 	InfoEntry.create(API_Message.USER_INFO_KEY_name, "Player A"),
					InfoEntry.create(API_Message.USER_INFO_KEY_avatar_url, "../../Emulator/Avatar_1.gif")
				],
				[ 	InfoEntry.create(API_Message.USER_INFO_KEY_name, "Player B"),
					InfoEntry.create(API_Message.USER_INFO_KEY_avatar_url, "../../Emulator/Avatar_2.gif")
				],
				[ 	InfoEntry.create(API_Message.USER_INFO_KEY_name, "Player C"),
					InfoEntry.create(API_Message.USER_INFO_KEY_avatar_url, "../../Emulator/Avatar_3.gif")
				],
				[ 	InfoEntry.create(API_Message.USER_INFO_KEY_name, "Player D"),
					InfoEntry.create(API_Message.USER_INFO_KEY_avatar_url, "../../Emulator/Avatar_4.gif")
				]
			];
		public static var DEFAULT_MATCH_STATE:Array/*ServerEntry*/ = []; // you can change this and load a saved match
		
		public static var EXTRA_CALLBACKS:Array/*API_Message*/ = [];
												 
		private var messageNum:Number = 10000;
		private var curUserId:Number; // the current userId (we change this curUserId when getting doAllSetTurn)
		private var finishedUserIds:Array/*int*/;
		private var apiMsgsQueue:Array/*API_Message*/ = [];
		private var serverStateMiror:ObjectDictionary;
		public function SinglePlayerEmulator(graphics:MovieClip) {
			super(graphics,true, DEFAULT_LOCALCONNECTION_PREFIX,true);			
		}
		private function updateUserIds(userIdsToUpdate:Array/*int*/,userIdsToAdd:Array/*int*/):Boolean{
			var updated:Boolean = false;
			for (var i80:Number=0; i80<userIdsToAdd.length; i80++) { var id:Number = userIdsToAdd[i80]; 
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
			for (var i117:Number=0; i117<revealEntries.length; i117++) { var revealEntry:RevealEntry = revealEntries[i117]; 
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
				newServerEntries.unshift(ServerEntry.create(currentKey,null,-1,[],getTimer()));
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
			for (var i161:Number=0; i161<userEntries.length; i161++) { var userEntry:UserEntry = userEntries[i161]; 
				switch(storePrefrence){
					case 1:serverEntry = ServerEntry.create(userEntry.key, userEntry.value,curUserId,userEntry.isSecret ? [curUserId] : null, getTimer()); break;
					case 2:serverEntry = ServerEntry.create(userEntry.key, userEntry.value,-1,userEntry.isSecret ? [] : null, getTimer()); break;
					case 3:serverEntry = ServerEntry.create(userEntry.key, userEntry.value,-1,userEntry.isSecret ? [] : null, getTimer()); break;
				}
				
				serverStateMiror.addEntry(serverEntry);
				
				if((userEntry.isSecret) && (storePrefrence!=1)){
					var secretServerEntry:ServerEntry = ServerEntry.create(serverEntry.key,null,serverEntry.storedByUserId,serverEntry.visibleToUserIds,serverEntry.changedTimeInMilliSeconds);
					serverEntries.push(secretServerEntry); 
				}else{
					serverEntries.push(serverEntry); 
				}
				
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
				for (var i202:Number=0; i202<transaction.messages.length; i202++) { var innerMsg:API_Message = transaction.messages[i202]; 
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
				var newlyFinishedUserIds:Array = [];
				var t:T = new T();
				t.add( T.i18n("Game is over for:\n") );
				for (var i270:Number=0; i270<endMatch.finishedPlayers.length; i270++) { var matchOver:PlayerMatchOver = endMatch.finishedPlayers[i270]; 
					var playerId:Number = matchOver.playerId;
					newlyFinishedUserIds.push( playerId );
					finishedUserIds.push( playerId );
					t.add( T.i18nReplace("$name$ score is $score$, and he will win $percent$ percent of the gambling pot.\n", {name: getUserName(playerId), score: matchOver.score, percent: matchOver.potPercentage }) );
				}				 
				queueSendMessage( API_GotMatchEnded.create(++messageNum,newlyFinishedUserIds) );
				if (finishedUserIds.length==NUM_OF_PLAYERS) {
					t.add( T.i18n("A new game will start in 5 seconds...\n") );
					// game is completely over for all players
					AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendNewMatch), START_NEW_GAME_AFTER_MILLISECONDS);
				}
				AS3_vs_AS2.showMessage(t.join(),"gameOver");
			} else if (msg instanceof API_DoRegisterOnServer) {
				doRegisterOnServer();
			} else if (msg instanceof API_DoAllRequestStateCalculation) { 
				var requestStateCalculationMsg:API_DoAllRequestStateCalculation = API_DoAllRequestStateCalculation(msg);
				for (var i287:Number=0; i287<requestStateCalculationMsg.keys.length; i287++) { var key:Object = requestStateCalculationMsg.keys[i287]; 
					var entry:ServerEntry = ServerEntry(serverStateMiror.getValue(key));
					if(entry!= null)
						serverEntries.push(entry)
					else
						trace(JSON.stringify(key))
				}
				queueSendMessage(API_GotRequestStateCalculation.create(1,serverEntries))
        	} else if (msg instanceof API_DoAllSetTurn) {
        		var setTurn:API_DoAllSetTurn = API_DoAllSetTurn(msg);
        		if (setTurn.userId!=curUserId) {
        			// we switch users by ending and loading the match
        			var userId:Number = setTurn.userId;
					AS3_vs_AS2.showMessage( T.i18nReplace("The turn of $name$ is starting.\n", {name: getUserName(userId)}) , "newTurn");
					
        			var ongoingIds:Array/*int*/ = StaticFunctions.subtractArray(getPlayerIds(),finishedUserIds);
					queueSendMessage( API_GotMatchEnded.create(++messageNum,ongoingIds) );
					setCurUserId(userId);
					queueSendMessage( API_GotMatchStarted.create(++messageNum,getPlayerIds(), finishedUserIds, serverStateMiror.getValues() ) );
        		}
        		
			} else if (msg instanceof API_DoFinishedCallback) {
				if (apiMsgsQueue.length==0) throwError("Game sent too many DoFinishedCallback");
				apiMsgsQueue.shift();
				if (apiMsgsQueue.length>0) sendTopQueue();
			}	
			return [];	
		}
		
		private function setCurUserId(id:Number):Void {
			curUserId = id;
			queueSendMessage(API_GotCustomInfo.create([ InfoEntry.create(API_Message.CUSTOM_INFO_KEY_myUserId,curUserId) ]));
		}
		private function getUserName(id:Number):String {
			return T.getUserValue(id,API_Message.USER_INFO_KEY_name,"Player "+id).toString();
		}
        /*override*/ public function gotMessage(msg:API_Message):Void {        	
			messageHandler(msg);			
  		}
  		private function doRegisterOnServer():Void {
  			queueSendMessage(API_GotCustomInfo.create(DEFAULT_CUSTOM_INFO.concat(OVERRIDING_CUSTOM_INFO)) );
  			
  			if (DEFAULT_USERS_INFO.length>0) {
	  			var pos:Number = 0;
	  			for (var i331:Number=0; i331<getPlayerIds().length; i331++) { var curUserId:Number = getPlayerIds()[i331]; 
	  				queueSendMessage(API_GotUserInfo.create(curUserId, pos<DEFAULT_USERS_INFO.length ? DEFAULT_USERS_INFO[pos++] : DEFAULT_USERS_INFO[pos-1]) );
				}
	  		}
	  		sendNewMatch();
	  	}	  	
	  	private function sendNewMatch():Void {
	  		setCurUserId( getFirstPlayerId() );
	  		
  			serverStateMiror = new ObjectDictionary();	
  			for (var i341:Number=0; i341<DEFAULT_MATCH_STATE.length; i341++) { var serverEntry:ServerEntry = DEFAULT_MATCH_STATE[i341]; 
  				serverStateMiror.addEntry(serverEntry);
			}
			finishedUserIds = DEFAULT_FINISHED_USER_IDS.concat(); // to create a copy
  			queueSendMessage(API_GotMatchStarted.create(++messageNum,getPlayerIds(), finishedUserIds, serverStateMiror.getValues() ) );
  			for (var i346:Number=0; i346<EXTRA_CALLBACKS.length; i346++) { var extraCallback:API_Message = EXTRA_CALLBACKS[i346]; 
  				trace("Passing extraCallback="+extraCallback);
  				queueSendMessage( extraCallback );
  			}  				
  			//checkExtraCallbacks();	 	
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
