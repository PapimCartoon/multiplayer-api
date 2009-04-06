// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/MyTimeout.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public final class MyTimeout 
	{
		private var timeout_id:Object = null;
		public var name:String;
		public function MyTimeout(name:String)	{
			this.name = name;
		}
		public function toString():String {
			return name;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function start(func:Function, milliseconds:int):void {
			clear();
			var thisObj:MyTimeout = this; // for AS2
			timeout_id = ErrorHandler.myTimeout(name, function ():void {
				thisObj.clearId();
				func();				
			}, milliseconds);
		}
		private function clearId():void {
			timeout_id = null;			

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public function clear():void {
			if (timeout_id!=null) {
				ErrorHandler.myClearTimeout(name, timeout_id);
				clearId()
			}	
		}
	}
}
