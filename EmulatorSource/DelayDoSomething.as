package
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
	public final class DelayDoSomething implements DoSomethingI
	{
		private var passTo:DoSomethingI;
		private var delay_from_milliseconds:int;
		private var delay_to_milliseconds:int;
		private var queue:Array = new Array();
		
		public function DelayDoSomething(passTo:DoSomethingI, 
					delay_from_milliseconds:int, delay_to_milliseconds:int)	{
			this.passTo = passTo;
			this.delay_from_milliseconds = delay_from_milliseconds;
			this.delay_to_milliseconds = delay_to_milliseconds;			
		}
		public function doSomething(obj:Object):void {
			queue.push(obj);
			if (queue.length==1) {
				setRandomDelay();				
			}
		} 
		public static function random(fromInclusive:int, toExclusive:int):int {
			var delta:int = toExclusive - fromInclusive;
			return Math.floor( delta * Math.random() ) + fromInclusive;
		}
		private function setRandomDelay():void {
			var delay_milliseconds:int = random(delay_from_milliseconds, delay_to_milliseconds);
			setTimeout(passEvent, delay_milliseconds);		
		}
		private function doOneEvent():void {			
			if (queue.length==0) throw new Error("Internal DelayDoSomething error!");
			var topObj:Object = queue.shift();
			passTo.doSomething(topObj);
		}
		private function passEvent():void {
			doOneEvent();
			if (true) {
				// events are batched together. very similar to the real server (however we do not consider network delay)
				while (queue.length>0) {
					doOneEvent();
				}
			} else {
				// events are queued. 
				if (queue.length>0) setRandomDelay();
			}
		}
		
		public static function doTest():void {
			var d:DoSomethingI = new DelayDoSomething( new TestDelayDoSomething(), 500, 1000);
			d.doSomething("event1");
			d.doSomething("event2");
			d.doSomething("event3");
			d.doSomething("event4");			
		}
	}
}
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	class TestDelayDoSomething implements DoSomethingI {
		public function doSomething(obj:Object):void {
			trace("Got obj="+obj+" time="+getTimer());
		}		
	}