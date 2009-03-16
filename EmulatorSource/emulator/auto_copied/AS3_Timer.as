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
		private static var ALL_TIMERS:Dictionary;
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		private var name:String;
		public function AS3_Timer(name:String, delay:Number, repeatCount:int=0)
		{
			super(delay, repeatCount);
			this.name = name;
			if (ALL_TIMERS==null) {
				ALL_TIMERS = new Dictionary(true); // weak keys (to allow garbage-collection)
				StaticFunctions.alwaysTrace(["ALL_TIMERS=",ALL_TIMERS]);
			}
			ALL_TIMERS[this] = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function toString():String {
			return name+" x"+delay+
				(!running?" not running" : 
					" RUNNING"+ 
					(repeatCount==0 ? "" : " "+this.currentCount+"/"+repeatCount));
		}
	}
}
