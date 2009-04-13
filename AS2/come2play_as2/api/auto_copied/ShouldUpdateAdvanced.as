import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.ShouldUpdateAdvanced extends ShouldUpdate
	{
		private var freeCount:Number;
	    private var currCount:Number;
	
	    public function ShouldUpdateAdvanced(everySeconds:Number, freeCount:Number) {
	        super(1000*everySeconds, false);
	        this.freeCount = freeCount;
	    }
	    /*override*/ public function shouldUpdate():Boolean {
	        if (super.shouldUpdate()) {
	            currCount = 1;
	            return true;
	        } else {
	            return ++currCount<=freeCount;
	        }
	    }
	}
