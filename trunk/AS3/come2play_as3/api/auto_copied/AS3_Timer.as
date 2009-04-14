package come2play_as3.api.auto_copied
{
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * We use AS3_Timer instead of Timer because 
	 * this allows us to keep track of all ongoing timers.
	 */
	public final class AS3_Timer extends Timer
	{
		private static var ALL_TIMERS:Dictionary;
		
		private var name:String;
		public function AS3_Timer(name:String, delay:Number, repeatCount:int=0)
		{
			StaticFunctions.assert(delay>0, ["AS3_Timer: illegal delay=",delay," name=",name, " repeatCount=",repeatCount]);
			super(delay, repeatCount);
			this.name = name;
			if (ALL_TIMERS==null) {
				ALL_TIMERS = new Dictionary(true); // weak keys (to allow garbage-collection)
				StaticFunctions.alwaysTrace(["ALL_TIMERS=",ALL_TIMERS]);
			}
			ALL_TIMERS[this] = true;
		}
		override public function toString():String {
			return name+" x"+delay+
				(!running?" not running" : 
					" RUNNING"+ 
					(repeatCount==0 ? "" : " "+this.currentCount+"/"+repeatCount));
		}
	}
}