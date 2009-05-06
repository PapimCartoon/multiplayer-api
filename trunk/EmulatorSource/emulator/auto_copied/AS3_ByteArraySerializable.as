// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_ByteArraySerializable.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.utils.ByteArray;
	
	public class AS3_ByteArraySerializable extends AS3_NativeSerializable
	{
		public var arr:Array/*int*/;
		public function AS3_ByteArraySerializable(byteArr:ByteArray=null) {
			super("ByteArray");
			arr = byteArr==null ? null : byteArr2Arr(byteArr);
		}	
		override public function fromNative(obj:Object):AS3_NativeSerializable {

// This is a AUTOMATICALLY GENERATED! Do not change!

			return obj is ByteArray ? new AS3_ByteArraySerializable(obj as ByteArray) : null;
		}
		public static function byteArr2Arr(byteArr:ByteArray):Array {
			var bytes:Array = [];
			var oldPosition:int = byteArr.position;
			byteArr.position = 0;
			for (var i:int=0; i<byteArr.length; i++)
				bytes.push(byteArr.readByte());
			byteArr.position = oldPosition;
			return bytes;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function postDeserialize():Object {
			var res:ByteArray = new ByteArray();
			for each (var i:int in arr)
				res.writeByte(i);
			res.position = 0; 
			return res;
		}	
		
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
