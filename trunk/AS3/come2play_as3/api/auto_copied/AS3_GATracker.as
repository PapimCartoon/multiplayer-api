package come2play_as3.api.auto_copied
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public final class AS3_GATracker
	{
		public static var MAX_EVENTS:int = 300;
		static private var ANALYTIC_LOG:Logger = new Logger("Analytic",30);
		static private var ANALYTIC_ERRORS_LOG:Logger = new Logger("AnalyticError",30);
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
		public function trackEvent(catagory:String,action:String,label:String=null,value:Number=0):void{
			ANALYTIC_LOG.log("trackEvent",catagory,action,label,value);
			if(realGATracker==null){
				if (pausedEvents.length>MAX_EVENTS)	return;
				pausedEvents.push({catagory:catagory,action:action,label:label,value:value})
				return;
			}
			
			var uniqueKey:String = catagory+"--"+action+"--"+label;
			if (uniqueEvents[uniqueKey]==true) {
				ANALYTIC_ERRORS_LOG.log("Already used key=",uniqueKey);
				return;
			}
			sendTrackEvent(catagory,action,label,value);	
		}
		
		private function sendTrackEvent(catagory:String,action:String,label:String,value:Number):void {
			eventsSent++;
			if (eventsSent>=MAX_EVENTS) {
				if (eventsSent==MAX_EVENTS)
					ANALYTIC_ERRORS_LOG.log("ERROR!!! Sent too many events");
				return;				
			}
			realGATracker.trackEvent(catagory,action,label,value);			
		}


	}
}