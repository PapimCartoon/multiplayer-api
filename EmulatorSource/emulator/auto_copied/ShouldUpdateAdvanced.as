// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/ShouldUpdateAdvanced.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public final class ShouldUpdateAdvanced extends ShouldUpdate
	{
		private var freeCount:int;
	    private var currCount:int;
	
	    public function ShouldUpdateAdvanced(everySeconds:int, freeCount:int) {
	        super(1000*everySeconds, false);
	        this.freeCount = freeCount;
	    }
	    override public function shouldUpdate():Boolean {

// This is a AUTOMATICALLY GENERATED! Do not change!

	        if (super.shouldUpdate()) {
	            currCount = 1;
	            return true;
	        } else {
	            return ++currCount<=freeCount;
	        }
	    }
	}
}
