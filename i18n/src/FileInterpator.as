package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.controls.DataGrid;
	//reflection
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
		
		static public var forbiddenTypes:String = "MovieClip Stage Logger Function DisplayObjectContainer";		
		static private var staticVarReg1:RegExp = new RegExp('public\\s+static\\s+var\\s+(\\w+)\\s*:\\s*(\\w+)',"g");
		static private var staticVarReg2:RegExp = new RegExp('static\\s+public\\s+var\\s+(\\w+)\\s*:\\s*(\\w+)',"g");		
		static private var staticFolderReg:RegExp = new RegExp('package\\s+((\\w|\\s|[.])+)');
		static private var errorCollection:Array = new Array();
		
		static public function getCustom(file:File,xmlCustom:XML,xmli18n:XML,xmlreflection:XML,errorView:DataGrid):void
		{

			var newErrors:Array = new Array();
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			var str:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			var fileName:String = file.name;		
			var customValues:Dictionary = runRegExp(str,firstTcustomReg,secondTcustomReg,newErrors,fileName);	
			var i18nValues:Dictionary = runRegExp(str,firstI18nReg,secondI18nReg,newErrors,fileName)		
			var i18nReplaceValues:Dictionary =runRegExp(str,firstI18nReplaceReg,secondI18nReplaceReg,newErrors,fileName)	
			var reflectionsArr:Array = getReflections(str);
			if(reflectionsArr.length > 1)
				reflectionArray2XML(reflectionsArr,str,file.name,xmlreflection)
			array2XML(customValues,xmlCustom,"default custom value");
			array2XML(i18nValues,xmli18n,"default i18n value");
			array2XML(i18nReplaceValues,xmli18n,"default i18nReplace value");
			newErrors.sortOn("Line");
			errorCollection = errorCollection.concat(newErrors);
			errorView.dataProvider =errorCollection;

		}
		static private function getReflections(str:String):Array
		{
			var staticVars:Array = new Array();
			var res:Object
			while ( (res= staticVarReg1.exec(str) ) != null) {
				if(forbiddenTypes.indexOf(res[2]) == -1)
				 staticVars.push({varName:res[1],varType:res[2]})
			}
			while ( (res= staticVarReg2.exec(str) ) != null) {
				if(forbiddenTypes.indexOf(res[2]) == -1)
				 staticVars.push({varName:res[1],varType:res[2]})
			}
			return staticVars;
		}
		static private function reflectionArray2XML(reflectionsArr:Array/*Object*/,str:String,fileName:String,xmlreflection:XML):void
		{
			var res:Object = staticFolderReg.exec(str)
			var packge:String="";
			if(res != null)
				if(res[1] != null)
					packge = String(res[1]).replace(new RegExp("\\s","g"),"");
			var fileParts:Array = fileName.split(".");
			if(packge!="")
				packge += "::" + fileParts[0];
			else
				packge = fileParts[0];
			for each(var reflection:Object in reflectionsArr)
			{	
				var entry:XML = <entry/>;
				entry.en = packge+"."+reflection.varName;
				entry.local = "default reflection value";
				entry.comment = reflection.varType
				xmlreflection.appendChild(entry)
			}
			
		}
		static private function array2XML(dic:Dictionary/*Array*/,xml:XML,defaultText:String):void
		{
			var customArr:Array
			for(var key:String in dic)
			{
				customArr = dic[key]
				//if(customArr[0]!="") customArr[0]="<!--"+customArr[0]+"-->";
				//if(customArr[2]!="") customArr[2]="<!--"+customArr[2]+"-->";
				var entry:XML = <entry/>;
				if(customArr[0]!="")
					entry.comment =customArr[0]+"\n";
				
				entry.local=defaultText;
				entry.en = customArr[1];
				
				entry.comment +=customArr[2];
				//customArr[0]+"<key>"++"</key><value>"++"</value>"+customArr[2]
				xml.appendChild(entry)			
				//xml.appendChild(new XML( "<entry>"+customArr[0]+"<key>"+customArr[1]+"</key><value>"+defaultText+"</value>"+customArr[2]+"</entry>"))
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
		static private function runRegExp(str:String,firstReg:RegExp,secondReg:RegExp,errorCollection:Array,fileName:String):Dictionary
		{
			var res:Object;
			var oldRes:Object;
			var tempArr:Array = new Array();
			var goodDic:Dictionary = new Dictionary();
			while ( (res= firstReg.exec(str) ) != null) {
				tempArr[res.index] = res;
			}
			var newRes:Array
			while ( (res= secondReg.exec(str) ) != null) {
				oldRes = tempArr[res.index];
				if(isOk(res,"'"))
					newRes = getWrapLines(res.index,str,res[2])//goodArr.push(getWrapLines(res.index,str,res[2]));
				else if(isOk(oldRes,'"'))
					newRes = getWrapLines(res.index,str,oldRes[2])//goodArr.push(getWrapLines(res.index,str,oldRes[2]));
				else			
					addError(str,errorCollection,res.index,fileName); 
				if(newRes!=null)goodDic[newRes[1]] = newRes;
				newRes = null			
			}

			return goodDic;
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