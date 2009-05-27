package come2play_as3.api.auto_copied
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public final class AS3_GATracker
	{				
		//For each visit (user session), a maximum of approximately 500 combined GATC requests (both events and page views) can be tracked.
		public static var MAX_EVENTS:int = 100;
		public static var MAX_LABEL_LEN:int = 900;
		
		static private var ANALYTIC_LOG:Logger = new Logger("Analytic",30);
		static private var ANALYTIC_ERRORS_LOG:Logger = new Logger("AnalyticError",10);
		public static var COME2PLAY_TRACKER:AS3_GATracker = new AS3_GATracker(null,"UA-154580-30");
		public static function trackWarning(action:String,label:String=null,value:Number=1):void {
			COME2PLAY_TRACKER.trackEvent("Warning",action,label,value);
		}
		
		private var realGATracker:Object;
		private var pausedEvents:Array = new Array();
		private var uniqueEvents:Dictionary = new Dictionary();
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
			
			sendTrackEvent(catagory,action,label,value);	
		}
		
		private function sendTrackEvent(catagory:String,action:String,label:String,value:Number):void {			
			catagory = StaticFunctions.cutString(catagory,MAX_LABEL_LEN);
			action = StaticFunctions.cutString(action,MAX_LABEL_LEN);
			label = StaticFunctions.cutString(label,MAX_LABEL_LEN);
			
			var uniqueKey:String = catagory+"--"+action+"--"+label;
			if (uniqueEvents[uniqueKey]==true) {
				ANALYTIC_ERRORS_LOG.log("Already used key=",uniqueKey);
				return;
			}
			uniqueEvents[uniqueKey] = true;
			
			eventsSent++;
			
			
			if (eventsSent>=MAX_EVENTS) {
				if (eventsSent==MAX_EVENTS) {
					realGATracker.trackEvent("Errors","Sent too many google events","",getTimer());
					ANALYTIC_ERRORS_LOG.log("ERROR!!! Sent too many events");
				}
				return;				
			}
			realGATracker.trackEvent(catagory,action,label,value);			
		}


	}
}