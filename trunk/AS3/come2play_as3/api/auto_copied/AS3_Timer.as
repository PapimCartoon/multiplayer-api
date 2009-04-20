package come2play_as3.api.auto_copied
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * We use AS3_Timer instead of Timer because 
	 * this allows us to keep track of all ongoing timers.
	 */
	public final class AS3_Timer extends Timer
	{
		private static var ALL_LOG:Logger = new Logger("ALL_TIMERS",5);
		private static var LOG:Logger = new Logger("TIMERS",50);
		private static var ALL_TIMERS:Dictionary;
		
		private var name:String;
		public function AS3_Timer(name:String, delay:Number, repeatCount:int=0)	{
			StaticFunctions.assert(delay>0, "AS3_Timer: illegal delay=",[delay," name=",name, " repeatCount=",repeatCount]);
			super(delay, repeatCount);
			this.name = name;
			if (ALL_TIMERS==null) {
				ALL_TIMERS = new Dictionary(true); // weak keys (to allow garbage-collection)
				ALL_LOG.log(ALL_TIMERS);
			}
			ALL_TIMERS[this] = true;
		}
		override public function start():void {
			LOG.log([name,"started"]);
			super.start();
		}
		override public function stop():void {
			LOG.log([name,"stoped"]);
			super.stop();
		}
		override public function reset():void {
			LOG.log([name,"reset"]);
			super.reset();
		}
		override public function toString():String {
			return name+" x"+delay+
				(!running?" not running" : 
					" RUNNING"+ 
					(repeatCount==0 ? "" : " "+this.currentCount+"/"+repeatCount));
		}
	}
}