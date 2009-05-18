// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_GATracker.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.display.DisplayObject;
	
	public final class AS3_GATracker
	{
		static private var ANALYTIC_LOG:Logger = new Logger("Analytic",30);
		private var realGATracker:Object;
		public function AS3_GATracker(disp:DisplayObject,id:String,isAS3:String="AS3",arg3:Boolean=false)
		{
			try{
				var c:Class = AS3_vs_AS2.getClassByName("com.google.analytics::GATracker");

// This is a AUTOMATICALLY GENERATED! Do not change!

				new c(disp,id,isAS3,arg3)
				ANALYTIC_LOG.log("successfully created analytics")
			}catch(err:Error){
				ANALYTIC_LOG.log("failed to create analytics")
			}
		}
		public function trackEvent(catagory:String,action:String,label:String=null,value:Number = null){
			trackEvent(catagory,action,label,value)
		}


// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
