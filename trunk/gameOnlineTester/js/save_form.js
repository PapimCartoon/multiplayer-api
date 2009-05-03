
function saveForm(myform) {
	var toSave = [];
	toSave.push(myform.innerHTML);

	for(i=0; i<myform.elements.length; i++) {
		var element = myform.elements[i];

		fieldType = element.type;				

		if(fieldType == 'password') { passValue = ''; }

		else if(fieldType == 'checkbox') { passValue = 'cb'+element.checked; }

		else if(fieldType == 'radio') { passValue = 'rb'+element.checked; }

		else if(fieldType == 'select-one') { passValue = 'select'+element.options.selectedIndex; }

		else { passValue = element.value; }

		toSave.push(passValue);

	}

	saveStr = '';
	for (i=0; i<toSave.length; i++) {
		saveStr = saveStr + (i==0 ? '' : '#cf#') + escape(toSave[i])
	}
	return saveStr;
}

function loadForm(myform, saveStr) {
	if(saveStr != null && saveStr!='') {
		var cookieArray = saveStr.split('#cf#');
		for(i=0; i<cookieArray.length; i++)
			cookieArray[i] = unescape(cookieArray[i]);

		myform.innerHTML = cookieArray[0];

		for(i=1; i<cookieArray.length; i++) {
			var val = cookieArray[i];
			var element = myform.elements[i-1];
			if (element==null) continue;

			if(val.substring(0,6) == 'select') { element.options.selectedIndex = val.substring(7, val.length-1); }

			else if((val == 'cbtrue') || (val == 'rbtrue')) { element.checked = true; }

			else if((val == 'cbfalse') || (val == 'rbfalse')) { element.checked = false; }

			else { element.value = (val) ? val : ''; }

		}

	}
}