package emulator
{
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * Causes an delay in doing some actions.
	 * We use this class to simulate network delay in the Come2Play emulator
	 * The delay is between delay_from_milliseconds and delay_to_milliseconds
	 * The order between events is kept!
	 * The implementation uses a queue and dispatches the events at a random interval.
	 */
	public final class DelayDoSomething 
	{
		private var passTo:Function;
		private var delay_from_milliseconds:int;
		private var delay_to_milliseconds:int;
		private var queue:Array = new Array();
		
		public function DelayDoSomething(passTo:Function, 
					delay_from_milliseconds:int, delay_to_milliseconds:int)	{
			this.passTo = passTo;
			this.delay_from_milliseconds = delay_from_milliseconds;
			this.delay_to_milliseconds = delay_to_milliseconds;			
		}
		public function doSomething(obj:Object):void {
			queue.push(obj);
			var delay_milliseconds:int = random(delay_from_milliseconds, delay_to_milliseconds);
			setTimeout(doOneEvent, delay_milliseconds);
		} 
		public static function random(fromInclusive:int, toExclusive:int):int {
			var delta:int = toExclusive - fromInclusive;
			return Math.floor( delta * Math.random() ) + fromInclusive;
		}
		private function doOneEvent():void {			
			if (queue.length==0) throw new Error("Internal DelayDoSomething error!");
			var topObj:Object = queue.shift();
			passTo(topObj);
		}
		
		public static function doTest():void {
			var d:DelayDoSomething = new DelayDoSomething(doSomething, 500, 1000);
			d.doSomething("event1");
			d.doSomething("event2");
			d.doSomething("event3");
			d.doSomething("event4");			
		}
		public static function doSomething(obj:Object):void {
			trace("Got obj="+obj+" time="+getTimer());
		}	
	}
}