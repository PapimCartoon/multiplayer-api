// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_TimeTracker.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import emulator.auto_copied.AS3_GATracker;
	
	public class AS3_TimeTracker
	{
		private var buckets:Array;
		private var catagoryNamePrefix:String;
		public function AS3_TimeTracker(catagoryNamePrefix:String,buckets:Array=null)
		{
			this.buckets = buckets!=null?buckets:[100,200,300,400,500,1000,1500,2000,2500,5000];
			this.catagoryNamePrefix = catagoryNamePrefix;	

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		
		public function track(timeInMiliSeconds:int,action:String = "default"):void{
			var lastBucket:int = 0;
			for each(var testTime:int in buckets){
				if(timeInMiliSeconds < testTime)	break;
				lastBucket = testTime 
			}	
			var buketName:String = lastBucket == testTime?testTime+"+":lastBucket+" - "+(testTime-1);
			AS3_GATracker.COME2PLAY_TRACKER.trackEvent(catagoryNamePrefix+" TimeTacker",action,"Bucket : "+buketName,timeInMiliSeconds);

// This is a AUTOMATICALLY GENERATED! Do not change!

		}

	}
}
