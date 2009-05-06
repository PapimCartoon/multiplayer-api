// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_DateSerializable.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	public class AS3_DateSerializable extends AS3_NativeSerializable
	{
		//public var utcDate:String; //Tue Feb 1 00:00:00 2005 UTC
		public var millis:Number; //the number of milliseconds since midnight January 1, 1970, universal time
		public function AS3_DateSerializable(date:Date=null) {
			super("Date");
			//utcDate = date==null ? null : date.toUTCString();
			millis = date==null ? null : date.valueOf();
		}	
		override public function fromNative(obj:Object):AS3_NativeSerializable {

// This is a AUTOMATICALLY GENERATED! Do not change!

			return obj is Date ? new AS3_DateSerializable(obj as Date) : null;
		}
		override public function postDeserialize():Object {
			return new Date(millis); //millis<=0 ? utcDate : millis
		}	
	}
}
