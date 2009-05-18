package come2play_as3.api.auto_copied
{
	import flash.display.DisplayObject;
	
	public final class AS3_GATracker
	{
		static private var ANALYTIC_LOG:Logger = new Logger("Analytic",30);
		private var realGATracker:Object;
		public function AS3_GATracker(disp:DisplayObject,id:String,isAS3:String="AS3",arg3:Boolean=false)
		{
			try{
				var c:Class = AS3_vs_AS2.getClassByName("com.google.analytics::GATracker");
				realGATracker = new c(disp,id,isAS3,arg3)
				ANALYTIC_LOG.log("successfully created analytics")
			}catch(err:Error){
				ANALYTIC_LOG.log("failed to create analytics")
			}
		}
		public function trackEvent(catagory:String,action:String,label:String=null,value:Number=0):void{
			ANALYTIC_LOG.log("trackEvent",catagory,action,label,value)
			if(realGATracker==null)	return;
			realGATracker.trackEvent(catagory,action,label,value)
		}


	}
}