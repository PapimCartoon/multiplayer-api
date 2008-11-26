	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends LocalConnectionUser 
	{        
		public static var ERROR_DO_ALL:String = "You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted, gotMatchEnded, or gotRequestStateCalculation.";
		
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var serverStateMiror:ObjectDictionary;
		private var currentCallback:API_Message = null;
		private var hackerUserId:Number = -1;
		private var runningAnimationsNumber:Number = 0;
		
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, getPrefixFromFlashVars(_someMovieClip),true);
			if (getPrefixFromFlashVars(_someMovieClip)==null) 
				new SinglePlayerEmulator(_someMovieClip);
			StaticFunctions.performReflectionFromFlashVars(_someMovieClip);	
		}

		/**
		 * If your overriding 'got' methods will throw an Error,
		 * 	then hackerUserId will be declared as a hacker.
		 * We automatically set hackerUserId to storedByUserId 
		 * 	whenever receiving gotStateChanged,
		 * 	however, when the state changes after doAllReveal then
		 * 	storedByUserId is -1, so your code should call setMaybeHackerUserId.
		 */
		public function setMaybeHackerUserId(hackerUserId:Number):Void {
			this.hackerUserId = hackerUserId;			
		}
		/**
		 * gotError is called whenever your overriding 'got' methods
		 * 	throw an Error.
		 */
		public function gotError(withObj:Object, err:Error):Void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, 
				"Got error withObj="+JSON.stringify(withObj)+
				" err="+AS3_vs_AS2.error2String(err)+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" currentCallback="+currentCallback+
				" msgsInTransaction="+JSON.stringify(msgsInTransaction)+
				" traces="+StaticFunctions.getTraces() ) );
		}
		/** 
		 * A transaction starts when the server calls
		 * 	a 'got' method (e.g., gotStateChanged).
		 * The transaction normally ends when your overriding 'got' method returns.
		 * However, if you start animations, 
		 * 	then the transaction continues until all the animation will end.
		 * A transaction must be ended after 10 seconds (see ProtocolVerifier.MAX_ANIMATION_MILLISECONDS),
		 * so make sure your animations are short (less than 5 seconds).
		 * 
		 * You may call doAll methods if and only if you are inside a transaction,
		 * and doStoreState if and only if you are not inside a transaction.
		 * 
		 * Animations may be displayed only inside a transaction
		 * 	that is either gotMatchStarted or gotMatchEnded or gotStateChanged.
		 * 
		 * About loading images:
		 * Flash caches loaded images, but only after loading is completed.
		 * So, if you want to use the same image in many places
		 * (e.g., place some custom image on all the pieces)
		 * then you should first call cacheImage,
		 * and only in the  onLoaded  function load the image to all the pieces.
		 * Function cacheImage starts an animation, and when the image is loaded 
		 * (or failed to load) then the animation is ended.
		 * The image will be stored in some 
		 * newly created invisible child in someMovieClip. 
		 * E.g.,
		 * cacheImage( imageUrl, someMovieClip, 
		 * 		function (isSuccess:Boolean):Void {
		 * 			if (isSuccess) {
		 * 				// load the image in all the pieces
		 * 			}
		 * 		});
		 */		 
        public function animationStarted():Void {
        	checkInsideTransaction();
			if (!canDoAnimations())
				throwError("You can do animations only when the server calls gotMatchStarted, gotMatchEnded, or gotStateChanged");
        	runningAnimationsNumber++;        	
        }
        public function animationEnded():Void {
        	checkInsideTransaction();
        	if (runningAnimationsNumber<=0)
        		throwError("Called animationEnded too many times!");
        	runningAnimationsNumber--;
        	sendFinishedCallback();        	        	
        }
        public function canDoAnimations():Boolean {
			return currentCallback instanceof API_GotCustomInfo || 
				currentCallback instanceof API_GotMatchStarted ||
				currentCallback instanceof API_GotMatchEnded || 
				currentCallback instanceof API_GotUserInfo ||
				currentCallback instanceof API_GotStateChanged;
		}
		public function cacheImage(imageUrl:String, someMovieClip:MovieClip,
					onLoaded:Function):Void {		
			animationStarted();
			var thisObj:BaseGameAPI = this; // for AS2
			var forCaching:MovieClip =
				AS3_vs_AS2.loadMovieIntoNewChild(someMovieClip, imageUrl, 
					function (isSucc:Boolean):Void {
						onLoaded(isSucc);
						thisObj.animationEnded();				
					});	
			AS3_vs_AS2.setVisible(forCaching, false);		
		}
		
		
		/****************************
		 * Below this line we only have private and overriding methods.
		 */
        private function isInTransaction():Boolean {
        	return msgsInTransaction!=null
        }
        private function checkInsideTransaction():Void {
        	if (!isInTransaction()) 
        		throwError("You can start/end an animation only when the server called some 'got' callback");
        }
        private function sendFinishedCallback():Void {
        	checkInsideTransaction();        	
        	if (runningAnimationsNumber>0) return;
       		super.sendMessage( API_Transaction.create(API_DoFinishedCallback.create(currentCallback.getMethodName()), msgsInTransaction) );
    		msgsInTransaction = null;
			currentCallback = null;
        }
        
        private function updateMirorServerState(serverEntries:Array/*ServerEntry*/):Void
        {
        	for (var i141:Number=0; i141<serverEntries.length; i141++) { var serverEntry:ServerEntry = serverEntries[i141]; 
        	    if (serverEntry.value == null)
					serverStateMiror.remove(serverEntry.key);
				else 
					serverStateMiror.put(serverEntry.key,serverEntry);	
        	}     	
        }
        public function getServerEntry(key:Object):ServerEntry
        {
        	return ServerEntry(serverStateMiror.getValue(key));
        }
        
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	try {
        		if (isInTransaction()) {					
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
				}
        		if (runningAnimationsNumber!=0 || currentCallback!=null)
        			throwError("Internal error! runningAnimationsNumber="+runningAnimationsNumber+" msgsInTransaction="+msgsInTransaction+" currentCallback="+currentCallback);
				msgsInTransaction = []; // we start a transaction
				currentCallback = msg;
				
        		hackerUserId = -1;
	    		if (msg instanceof API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			if (stateChanged.serverEntries.length >= 1) {
	    				updateMirorServerState(stateChanged.serverEntries);
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		} else if (msg instanceof API_GotMatchStarted) {
	    			serverStateMiror = new ObjectDictionary();
					var matchStarted:API_GotMatchStarted = API_GotMatchStarted(msg);
					updateMirorServerState(matchStarted.serverEntries);
	    		} else if (msg instanceof API_GotCustomInfo) {	 					    			
					var customInfo:API_GotCustomInfo = API_GotCustomInfo(msg);
					var i18nObj:Object = {};
					var customObj:Object = {};
					for (var i179:Number=0; i179<customInfo.infoEntries.length; i179++) { var entry:InfoEntry = customInfo.infoEntries[i179]; 
						var key:String = entry.key;
						var value:Object = entry.value;
						if (key=="i18n") {
							i18nObj = value;
						} else if (key=="CONTAINER_checkThrowingAnError" && value==true) {
							throw new Error("CONTAINER_checkThrowingAnError");
						} else {
							customObj[key] = value;
						}
					}		
					T.initI18n(i18nObj, customObj); // may be called several times because we may pass different 'secondsPerMatch' every time a game starts
					if (T.custom("CONTAINER_checkThrowingAnError",true))
					throw new Error("CONTAINER_checkThrowingAnError");
				}
				dispatchMessage(msg)

        	} catch (err:Error) {
        		try{				
        			showError(getErrorMessage(msg, err));
					gotError(msg, err);
				} catch (err2:Error) { 
					// to avoid an infinite loop, I can't call passError again.
					showError("Another error occurred when calling gotError. The new error is="+AS3_vs_AS2.error2String(err2));
				}
    		} finally {       
        		// we end a transaction
    			sendFinishedCallback(); 			
    		}        		   	
        }
        public function dispatchMessage(msg:API_Message):Void {
        	var methodName:String = msg.getMethodName();
			if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
			var func:Function = Function(this[methodName]);
			if (func==null) return;
			func.apply(this, msg.getMethodParameters());
        }
        /*override*/ public function sendMessage(doMsg:API_Message):Void {
        	if (ProtocolVerifier.isPassThrough(doMsg)) {
        		super.sendMessage(doMsg);
        		return;
        	}
        	if (doMsg instanceof API_DoStoreState) {
        		if (isInTransaction())
        			throwError("You can call doStoreState only when you are not inside a transaction! doMsg="+doMsg);        			
        		super.sendMessage(doMsg);
        		return;
        	}        	
			      	
			if (!isInTransaction()) 
				throwError(ERROR_DO_ALL);	
			
			msgsInTransaction.push(doMsg);			
        }
	}
