// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/ShouldUpdate.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import come2play_as3.auto_copied.TimeMeasure;
	
	public class ShouldUpdate
	{
	    private var updatedOn:TimeMeasure = new TimeMeasure();
	    private var everyMilliSec:int;
		public function ShouldUpdate(milli:int, doNow:Boolean) {
	        everyMilliSec = milli;
	        if (!doNow) updatedOn.setTime();
	    }

// This is a AUTOMATICALLY GENERATED! Do not change!

	    public function toString():String {
	        return "ShouldUpdate updatedOn="+ (updatedOn)+" everyMilliSec="+everyMilliSec;
	    }	
	    public function shouldUpdate():Boolean {
	        if (!havePassed(everyMilliSec)) return false;
	        updatedOn.setTime();
	        return true;
	    }
	    public function havePassed(milli:int):Boolean {
	        return updatedOn.havePassed(milli);

// This is a AUTOMATICALLY GENERATED! Do not change!

	    }
	}
}
