// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_GATracker.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public final class AS3_GATracker
	{				
		//For each visit (user session), a maximum of approximately 500 combined GATC requests (both events and page views) can be tracked.
		public static var MAX_EVENTS:int = 100;
		public static var MAX_LABEL_LEN:int = 900;
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		static private var ANALYTIC_LOG:Logger = new Logger("Analytic",30);
		static private var ANALYTIC_ERRORS_LOG:Logger = new Logger("AnalyticError",10);
		public static var COME2PLAY_TRACKER:AS3_GATracker = new AS3_GATracker(null,"UA-154580-30");
		public static function trackWarning(action:String,label:String=null,value:Number=1):void {
			COME2PLAY_TRACKER.trackEvent("Warning",action,label,value);
		}
		
		private var realGATracker:Object;
		private var pausedEvents:Array = new Array();
		private var uniqueEvents:Dictionary = new Dictionary();

// This is a AUTOMATICALLY GENERATED! Do not change!

		private var eventsSent:int = 0;
		public function AS3_GATracker(disp:DisplayObject,id:String,isAS3:String="AS3",arg3:Boolean=false)
		{
			reconstruct(disp,id,isAS3,arg3)
		}
		public function reconstruct(disp:DisplayObject,id:String,isAS3:String="AS3",arg3:Boolean=false):void{
			if(realGATracker!=null)	return;
			try{
				var c:Class = AS3_vs_AS2.getClassByName("com.google.analytics::GATracker");
				realGATracker = new c(disp,id,isAS3,arg3)

// This is a AUTOMATICALLY GENERATED! Do not change!

				for each(var obj:Object in pausedEvents){
					sendTrackEvent(obj.catagory,obj.action,obj.label,obj.value)
				}
				pausedEvents = [];
				ANALYTIC_LOG.log("successfully created analytics")
			}catch(err:Error){
				ANALYTIC_LOG.log("failed to create analytics")
			}
		}
		public function setVar(newVal:String):void{

// This is a AUTOMATICALLY GENERATED! Do not change!

			if(realGATracker == null)	return;
			realGATracker.setVar(newVal)	
		}
		public function trackEvent(catagory:String,action:String,label:String=null,value:Number=1):void{
			ANALYTIC_LOG.log("trackEvent",catagory,action,label,value);
			if(realGATracker==null){
				if (pausedEvents.length>MAX_EVENTS)	return;
				pausedEvents.push({catagory:catagory,action:action,label:label,value:value})
				return;
			}

// This is a AUTOMATICALLY GENERATED! Do not change!

			
			sendTrackEvent(catagory,action,label,value);	
		}
		
		private function sendTrackEvent(catagory:String,action:String,label:String,value:Number):void {			
			catagory = StaticFunctions.cutString(catagory,MAX_LABEL_LEN);
			action = StaticFunctions.cutString(action,MAX_LABEL_LEN);
			label = StaticFunctions.cutString(label,MAX_LABEL_LEN);
			
			var uniqueKey:String = catagory+"--"+action+"--"+label;

// This is a AUTOMATICALLY GENERATED! Do not change!

			if (uniqueEvents[uniqueKey]==true) {
				ANALYTIC_ERRORS_LOG.log("Already used key=",uniqueKey);
				return;
			}
			uniqueEvents[uniqueKey] = true;
			
			eventsSent++;
			
			
			if (eventsSent>=MAX_EVENTS) {

// This is a AUTOMATICALLY GENERATED! Do not change!

				if (eventsSent==MAX_EVENTS) {
					realGATracker.trackEvent("Errors","Sent too many google events","",getTimer());
					ANALYTIC_ERRORS_LOG.log("ERROR!!! Sent too many events");
				}
				return;				
			}
			realGATracker.trackEvent(catagory,action,label,value);			
		}



// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
