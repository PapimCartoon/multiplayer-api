	import come2play_as2.auto_copied.TimeMeasure;
	
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.ShouldUpdate
	{
	    private var updatedOn:TimeMeasure = new TimeMeasure();
	    private var everyMilliSec:Number;
		public function ShouldUpdate(milli:Number, doNow:Boolean) {
	        everyMilliSec = milli;
	        if (!doNow) updatedOn.setTime();
	    }
	    public function toString():String {
	        return "ShouldUpdate updatedOn="+ (updatedOn)+" everyMilliSec="+everyMilliSec;
	    }	
	    public function shouldUpdate():Boolean {
	        if (!havePassed(everyMilliSec)) return false;
	        updatedOn.setTime();
	        return true;
	    }
	    public function havePassed(milli:Number):Boolean {
	        return updatedOn.havePassed(milli);
	    }
	}
