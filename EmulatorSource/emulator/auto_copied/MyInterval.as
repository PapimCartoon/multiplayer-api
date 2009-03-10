// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/MyInterval.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public final class MyInterval 
	{
		private var timeout_id:int = -1;
		public var name:String;
		public function MyInterval(name:String)	{
			this.name = name;
		}
		public function toString():String {
			return name;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function start(func:Function, milliseconds:int):void {
			clear();
			timeout_id = ErrorHandler.myInterval(name, func, milliseconds);
		}
		public function clear():void {
			if (timeout_id!=-1) {
				ErrorHandler.myClearInterval(name, timeout_id);
				timeout_id = -1;
			}	
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
