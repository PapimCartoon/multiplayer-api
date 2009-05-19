package come2play_as3.api.auto_copied
{
	import flash.display.DisplayObject;
	
	public final class AS3_GATracker
	{
		static private var ANALYTIC_LOG:Logger = new Logger("Analytic",30);
		private var realGATracker:Object;
		private var pausedEvents:Array = new Array();
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
					realGATracker.trackEvent(obj.catagory,obj.action,obj.label,obj.value)
				}
				pausedEvents = [];
				ANALYTIC_LOG.log("successfully created analytics")
			}catch(err:Error){
				ANALYTIC_LOG.log("failed to create analytics")
			}
		}
		public function trackEvent(catagory:String,action:String,label:String=null,value:Number=0):void{
			ANALYTIC_LOG.log("trackEvent",catagory,action,label,value)
			if(realGATracker==null){
				if(pausedEvents.length > 100)	return;
				pausedEvents.push({catagory:catagory,action:action,label:label,value:value})
				return;
			}	
			realGATracker.trackEvent(catagory,action,label,value)
		}


	}
}