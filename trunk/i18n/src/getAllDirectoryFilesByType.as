package
{
	import flash.filesystem.File;
	
	public class getAllDirectoryFilesByType
	{
		private var extension:String;
		public function getAllDirectoryFilesByType(_extension:String)
		{
			extension =_extension
		}
		public function getFiles(directory:File):Array
		{
			var tempExtensionFileArr:Array = new Array();
			var allFiles:Array = directory.getDirectoryListing()
			for each(var file:File in allFiles)
			{
				if(file.isDirectory)
					tempExtensionFileArr = tempExtensionFileArr.concat(getFiles(file));
				else
				{
					if(file.extension == extension)
						tempExtensionFileArr.push(file);
				}
			}
			return tempExtensionFileArr;
		}
	}
}