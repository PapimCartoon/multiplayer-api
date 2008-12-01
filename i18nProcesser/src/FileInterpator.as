package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.DataGrid;
	
	public class FileInterpator
	{
		static private var firstTcustomReg:RegExp = 
				new RegExp('T[.]custom[ \\t\\n]*[(]([ \\t\\n]*["](.*?[^\\\\])["][ \\t\\n]*[,])?',"g");
		static private var secondTcustomReg:RegExp = 
				new RegExp("T[.]custom[ \\t\\n]*[(]([ \\t\\n]*['](.*?[^\\\\])['][ \\t\\n]*[,])?","g");
		
		static private var firstI18nReg:RegExp= 
				new RegExp('T[.]i18n[ \\t\\n]*[(]([ \\t\\n]*["](.*?[^\\\\])["][ \\t\\n]*[)])?',"g");
				
		static private var secondI18nReg:RegExp=
				new RegExp("T[.]i18n[ \\t\\n]*[(]([ \\t\\n]*['](.*?[^\\\\])['][ \\t\\n]*[)])?","g");
		
		static private var firstI18nReplaceReg:RegExp=
				new RegExp('T[.]i18nReplace[ \\t\\n]*[(]([ \\t\\n]*["](.*?[^\\\\])["][ \\t\\n]*[,])?',"g");
		static private var secondI18nReplaceReg:RegExp=
				new RegExp("T[.]i18nReplace[ \\t\\n]*[(]([ \\t\\n]*['](.*?[^\\\\])['][ \\t\\n]*[,])?","g");
		
		static private var errorCollection:Array = new Array();
		
		static public function getCustom(file:File,xmlCustom:XML,xmli18n:XML,xmli18nReplace:XML,errorView:DataGrid):void
		{
			var newErrors:Array = new Array();
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			var str:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			var fileName:String = file.name;		
			var customValues:Array = runRegExp(str,firstTcustomReg,secondTcustomReg,newErrors,fileName);	
			var i18nValues:Array = runRegExp(str,firstI18nReg,secondI18nReg,newErrors,fileName)		
			var i18nReplaceValues:Array =runRegExp(str,firstI18nReplaceReg,secondI18nReplaceReg,newErrors,fileName)	
			array2XML(customValues,xmlCustom,"default custom value");
			array2XML(i18nValues,xmli18n,"default i18n value");
			array2XML(i18nReplaceValues,xmli18nReplace,"default i18nReplace value");
			newErrors.sortOn("Line");
			errorCollection = errorCollection.concat(newErrors);
			errorView.dataProvider =errorCollection;

		}

		static private function array2XML(arr:Array/*Array*/,xml:XML,defaultText:String):void
		{
			for each(var customArr:Array in arr)
			{
				if(customArr[0]!="") customArr[0]="<!--"+customArr[0]+"-->";
				if(customArr[2]!="") customArr[2]="<!--"+customArr[2]+"-->";
				xml.appendChild(new XML( "<entry>"+customArr[0]+"<en>"+customArr[1]+"</en><local>"+defaultText+"</local>"+customArr[2]+"</entry>"))
			}
		}
		static public function clearErrors():void
		{
			 errorCollection = new Array();
		}
		static private function isOk(res:Object,apo:String):Boolean
		{
			
			if((res[1] == null) || (res[2] == null))
				return false;
			if(res[2].indexOf(apo) != -1)
				return false
			return true;
		}
		static private function runRegExp(str:String,firstReg:RegExp,secondReg:RegExp,errorCollection:Array,fileName:String):Array
		{
			var res:Object;
			var oldRes:Object;
			var tempArr:Array = new Array();
			var goodArr:Array = new Array();
			while ( (res= firstReg.exec(str) ) != null) {
				tempArr[res.index] = res;
			}
			while ( (res= secondReg.exec(str) ) != null) {
				oldRes = tempArr[res.index];
				if(isOk(res,"'"))
					goodArr.push(getWrapLines(res.index,str,res[2]));
				else if(isOk(oldRes,'"'))
					goodArr.push(getWrapLines(res.index,str,oldRes[2]));
				else			
					addError(str,errorCollection,res.index,fileName); 			
			}

			return goodArr;
		}
		static private function getWrapLines(index:int,str:String,text:String):Array
		{
			var nextLine:String ="";
			var previousLine:String ="";
			var startIndex:int;
			var endIndex:int;
			//next line
			startIndex = str.indexOf("\n",index)+1;
			if(startIndex!= -1)
			{
				endIndex = str.indexOf("\n",startIndex);
				if(endIndex==-1)
				{
					var len:int = startIndex - str.length;
					nextLine = str.substr(startIndex,len);
				}
				else
				{
					if((endIndex - startIndex) > 2)
						nextLine = str.substring(startIndex,endIndex-1)
				}
			}
			
			//previous line
			var allPreviousLines:String = str.substr(0,index);
			endIndex = allPreviousLines.lastIndexOf("\n");
			if(endIndex != -1)
			{
				allPreviousLines =  str.substr(0,endIndex);
				startIndex = allPreviousLines.lastIndexOf("\n");
				if(startIndex==-1)
				{
					previousLine = str.substr(0,endIndex-1)
				}
				else
				{
					if((endIndex - startIndex) > 2)
						previousLine= str.substring(startIndex+1,endIndex-1);
				}						
			}
			return [previousLine,text,nextLine]
			
		}
		static private function addError(str:String,errorCollection:Array,index:int,fileName:String):void
		{
			var endErrorIndex:int = str.indexOf('\n',index);
    		var errorLines:String = str.substring(0,index);
   			var errorLineText:String = str.substring(index, endErrorIndex==-1 ? str.length : endErrorIndex);
   			var errorLineLine:int = (errorLines.split("\n").length)
   			var errorLinePosition:int = errorLines.lastIndexOf("\n")
   			if(errorLinePosition == -1)
   				errorLinePosition = index;
   			else
   				errorLinePosition = index - errorLinePosition;
   			if(errorLineText.indexOf("CUSTOM_INFO_KEY_")==-1 )
    			errorCollection.push({File:fileName,Line:errorLineLine,Position: errorLinePosition,Error:errorLineText});
		}
	}
}