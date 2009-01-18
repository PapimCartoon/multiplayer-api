var width;
var divToDelete;
function dataSaved(){
	divToDelete.innerHTML ="";
}
function myResize() {
	if (document.all)
	{width = document.body.clientWidth;}
	else
	{width = window.innerWidth;}
}
function errorHandler(err){
	alert("An error happend in the flash \n"+err)
}
function getParamsInit(obj){
	divToDelete.innerHTML ="";
	getParams(obj);
}
function loadSharedObject(sharedObject,div){
	divToDelete =div;
	writeFlash(div,"GetParams.swf?sharedObject="+sharedObject+"&Save=false","600","500","","getParams");
}
function autoLoadSharedObject(sharedObject,div){
	divToDelete =div;
	writeFlash(div,"GetParams.swf?sharedObject="+sharedObject+"&Save=autoLoad","600","500","","getParams");
}
function saveSharedObject(sharedObject,div,saveData){
	divToDelete = div;
	writeFlash(div,"GetParams.swf?sharedObject="+sharedObject+"&Save=true&"+saveData,"600","500","","getParams");
}
function autoSaveSharedObject(sharedObject,div,saveData){
	divToDelete = div;
	writeFlash(div,"GetParams.swf?sharedObject="+sharedObject+"&Save=autoSave&"+saveData,"600","500","","getParams");
}