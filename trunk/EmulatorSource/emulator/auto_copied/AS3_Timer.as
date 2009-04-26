// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_Timer.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		private static var ALL_TIMERS:Dictionary/*AS3_Timer->Boolean*/;
		
		public static function getTimersLog():String {
			var res:Array/*String*/ = [];
			for (var t:Object in ALL_TIMERS)
				res.push(t.toString());
			res = StaticFunctions.sortAndCountOccurrences(res); 
			return "all timers info:\n\t\t\t" + res.join("\n\t\t\t");
		}
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		private var name:String;
		public function AS3_Timer(name:String, delay:Number, repeatCount:int=0)	{
			StaticFunctions.assert(delay>0, "AS3_Timer: illegal delay=",[delay," name=",name, " repeatCount=",repeatCount]);
			super(delay, repeatCount);
			this.name = name;
			if (ALL_TIMERS==null) {
				ALL_TIMERS = new Dictionary(true); // weak keys (to allow garbage-collection)
				ALL_LOG.log(new ForTraces());
			}
			ALL_TIMERS[this] = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

			LOG.log([name,"reset"]);
			super.reset();
		}
		override public function toString():String {
			return name+" every "+delay+" millis, "+ 
				(AS3_vs_AS2.myHasAnyEventListener(null,this) ? "WITH listeners" : "without listeners")+ 
				(!running?" not running" : 
					" RUNNING"+ 
					(repeatCount==0 ? "" : " "+this.currentCount+"/"+repeatCount));
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}

import emulator.auto_copied.AS3_Timer;
class ForTraces {
	public function toString():String {
		return AS3_Timer.getTimersLog();
	}
}
