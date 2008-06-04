import mx.controls.Button;

class TicTacToe_AS2board extends ClientGameAPI{
	private var json:JSON_AS2;
	private var swfRoot:MovieClip;
	private var btnPrev:Button;
	private var btnNext:Button;
	private var aGameState:Array;
	private var aBoardSquares:Array;
	private var iFilledNum:Number;
	private var bCanPress:Boolean;
	private var aPlayers:Array;
	private var aUsers:Array;
	private var aKeys:Array;
	private var aDatas:Array;
	private var iCurStep:Number;
	private var iCurTurn:Number;
	private var iColor:Number;
	private var iID:Number;
	private var bGameStarted:Boolean;
	private static var iSize:Number = 3;

	public function TicTacToe_AS2board(root:MovieClip) {
		super(root);
		
		swfRoot = root;
		json = new JSON_AS2();
		
		btnPrev = swfRoot["btnPrev"];
		btnPrev.onRelease=DelegateClass.create(this,btnPrevClick);
		btnPrev.visible = false;
		
		btnNext = swfRoot["btnNext"];
		btnNext.onRelease=DelegateClass.create(this,btnNextClick);
		btnNext.visible = false;
		
		initUser();
	}
	
	private function btnPrevClick():Void {
		iCurStep--;
		resetBoard();
		if (iCurStep > 0) {
			for (var i:Number = 0; i < iCurStep; i++) {
				saveState(aKeys[i], aDatas[i]);
			}
			showState();
		}else {
			btnPrev.visible = false;
		}
		btnNext.visible = true;
		setOnPress(false);
	}
	private function btnNextClick():Void {
		iCurStep++;
		resetBoard();
		for (var i:Number = 0; i < iCurStep; i++) {
			saveState(aKeys[i], aDatas[i]);
		}
		showState();
		btnPrev.visible = true;
		if (iCurStep == aKeys.length) {
			btnNext.visible = false;
			if (iCurTurn == iID) {
				setOnPress(true);
			}
		}
	}
	
	public function initUser():Void {
		try{
			do_register_on_server();
			iFilledNum = 0;
			iCurTurn = -1;
			bCanPress = false;
			
			aBoardSquares = new Array(iSize);
			aGameState = new Array(iSize);
			var _x:Number = 100;
			var _y:Number = 100;
			for(var i:Number=0; i<iSize; i++) {
				aBoardSquares[i] = new Array(iSize);
				aGameState[i] = new Array(iSize);
				for (var j:Number = 0; j < iSize; j++) {
					aGameState[i][j] = -1;
					aBoardSquares[i][j] = swfRoot["Square_" + i + "_" + j];
					aBoardSquares[i][j]._visible = false;
				}
			}
		}catch (err:Error) {
			do_store_trace("initUser", "Error: " + err.message);
		}
	}
	private function resetBoard():Void {
		try{
			iFilledNum = 0;
			for(var i:Number=0; i<iSize; i++){
				for (var j:Number = 0; j < iSize; j++) {
					aGameState[i][j] = -1;
					aBoardSquares[i][j]._visible = true;
					aBoardSquares[i][j].gotoAndStop("None");
				}
			}
		}catch (err:Error) {
			do_store_trace("resetBoard", "Error: " + err.message);
		}
	}
	private function doMove(i:Number, j:Number):Void {
		try{
			do_store_trace("doMove","i="+i+", j="+j);
			updateSquare(iColor, i,j);
			do_store_match_state("square"+i+j, {x:i,y:j,state:iColor});
			aGameState[i][j] = iColor;
			iFilledNum++;
			setOnPress(false);
			checkEndOfMatch();
			if (bGameStarted) {
				do_end_my_turn([aPlayers[1-iColor]]);   
			}
		}catch (err:Error) {
			do_store_trace("doMove", "Error: " + err.message);
		}
	}
	private function checkEndOfMatch():Void {
		try {
			if (iColor == -1) {
				return;
			}
			if (isGameOver()) {
				var arr:Array;
				var arr1:Array;
				if (aPlayers[iColor]==iID) {
					arr = new Array(0, 100);
					arr1 = new Array( -1, 1);
				}else {
					arr = new Array(100, 0);
					arr1 = new Array( 1, -1);
				}
				do_agree_on_match_over(aPlayers, arr1, arr);
				bGameStarted = false;
			}else if (isTie()) {
				do_agree_on_match_over(aPlayers, [0,0], null);
				bGameStarted = false;
			}
		}catch (err:Error) {
			do_store_trace("checkEndOfMatch", "Error: " + err.message);
		}
	}
	private function updateSquare(val:Number, i:Number, j:Number):Void {
		try{
			var keyframe:String = val==-1 ? 'None' : val==0 ? 'X' : 'O';
			aBoardSquares[i][j].gotoAndStop(keyframe);
		}catch (err:Error) {
			do_store_trace("updateSquare", "Error: " + err.message);
		}
	}
	private function setOnPress(isOn:Boolean):Void {
		try{
			bCanPress = isOn;
			do_store_trace("setOnPress","isOn="+isOn);
			for(var i:Number=0; i<iSize; i++) {
				for (var j:Number = 0; j < iSize; j++) {
					aBoardSquares[i][j].Btn_X_O.gotoAndStop(!isOn ? "Btn_None" : (getCurrentTurn()==0 ? "Btn_X" : "Btn_O") );
					aBoardSquares[i][j].Btn_X_O.btn.onPress = DelegateClass.create(this,this.doMove, i, j);
				}
			}
		}catch (err:Error) {
			do_store_trace("setOnPress", "Error: " + err.message);
		}
	}
	private function showState():Void {
		var j:Number, k:Number;
		iFilledNum = 0;
		for (j = 0; j < iSize; j++) {
			for (k = 0; k < iSize; k++) {
				updateSquare(aGameState[j][k],j, k);
				if (Number(aGameState[j][k]) != -1) {
					iFilledNum++;
				}
			}
		}
	}
	private function saveState(key:String, data:Object):Boolean {
		if (key.indexOf("square") == 0) {
			try {
				var x:Number = data["x"];
				var y:Number = data["y"];
				var state:Number = data["state"];
				if (x < 0 || x > (iSize-1)) {
					if(iColor!=-1){
						do_client_protocol_error_with_description("X is out of range");
					}
					return false;

				}
				if (y < 0 || y > (iSize-1)) {
					if(iColor!=-1){
						do_client_protocol_error_with_description("Y is out of range");
					}
					return false;

				}
				if (state != 0 && state != 1) {
					if (iColor != -1) {
						do_client_protocol_error_with_description("State is out of range");
					}
					return false;
				}
				if (aGameState[x][y] != -1 && aGameState[x][y]!=state) {
					if(iColor!=-1){
						do_client_protocol_error_with_description("Atempt to change state of previous turn");
					}
					return false;
				}
				aGameState[x][y] = state;
				return true;
			}catch (err:Error) { 
				do_client_protocol_error_with_description("Incorrect game state");
			}
		}else {
			if(iColor!=-1){
				do_client_protocol_error_with_description("Incorrect game state");
			}
		}
		return false;
	}
	
	private function getCurrentTurn():Number { 
		return iFilledNum % 2; 
	}
	private function isGameOver():Boolean {
		try{
			var ownedBy:Number;
			var i:Number,j:Number;
			for (i = 0; i < iSize; i++) {
				ownedBy = aGameState [i][0];
				for (j = 1; j < iSize; j++) {
					if (aGameState[i][j] != ownedBy) {
						break;
					}
				}
				if (j == iSize && ownedBy!=-1) {
					return true;
				}
				ownedBy = aGameState [0][i];
				for (j = 1; j < iSize; j++) {
					if (aGameState[j][i] != ownedBy) {
						break;
					}
				}
				if (j == iSize && ownedBy!=-1) {
					return true;
				}
			}
			ownedBy = aGameState [0][0];
			for (j = 1; j < iSize; j++) {
				if (aGameState[j][j] != ownedBy) {
					break;
				}
			}
			if (j == iSize && ownedBy!=-1) {
				return true;
			}
			ownedBy = aGameState [(iSize-1)][0];
			for (j = 1; j < iSize; j++) {
				if (aGameState[(iSize-1)-j][j] != ownedBy) {
					break;
				}
			}
			if (j == iSize && ownedBy!=-1) {
				return true;
			}
			return false;
		}catch (err:Error) {
			do_store_trace("isGameOver", "Error: " + err.message);
		}
		return false;
	}
	private function isTie():Boolean {
		return (iFilledNum == iSize*iSize);
	}
	
	//Got functions
	public function got_general_info(keys:Array, datas:Array):Void {
		do_store_trace("got_general_info", "keys=" + json.stringify(keys) + ", datas=" + json.stringify(datas));
		for (var i:Number = 0; i < keys.length; i++) {
			if (keys[i] == "logo_swf_full_url") {
				for(var k:Number=0; k<iSize; k++) {
					for (var j:Number = 0; j < iSize; j++) {
						aBoardSquares[k][j].back.loadMovie(datas[i]);
					}
				}
				return;
			}
		}
	}
	public function got_my_user_id(user_id:Number):Void {
		do_store_trace("got_my_user_id","user_id="+json.stringify(user_id));
		iID = user_id;
	}
	public function got_match_started(user_ids:Array, extra_match_info:Object, match_started_time:Number):Void { 
		do_store_trace("got_match_started", "user_ids=" + json.stringify(user_ids) + ", extra_match_info=" + json.stringify(extra_match_info) + ", match_started_time=" + json.stringify(match_started_time));
		if (user_ids.length != 2) {
			if(user_ids.indexOf(iID)!=-1){
				do_client_protocol_error_with_description("Illegal number of players");
			}
			return;
		}
		aPlayers = user_ids;
		resetBoard();
		bGameStarted = true;
		
		iFilledNum = 0;
		iCurTurn = -1;
		bCanPress = false;
		
		aUsers = new Array();
		aKeys = new Array();
		aDatas = new Array();
		
		for (var i:Number = 0; i < user_ids.length; i++) {
			if (user_ids[i] == iID) {
				iColor = i;
				return;
			}
		}
		iColor = -1;
	}
	public function got_stored_match_state(user_ids:Array, keys:Array, datas:Array):Void {
		do_store_trace("got_stored_match_state", "user_ids=" + json.stringify(user_ids) + ", keys=" + json.stringify(keys) + ", datas=" + json.stringify(datas));
		var k:Number,i:Number;
		if (iCurStep != aKeys.length) {
			resetBoard();
			for (i = 0; i < aKeys.length; i++) {
				saveState(aKeys[i], aDatas[i]);
			}
			showState();
		}
		for (k = 0; k < keys.length; k++) {
			if (aPlayers.indexOf(user_ids[k]) == -1) {
				if(iColor!=-1){
					do_client_protocol_error_with_description("User ID " + user_ids[k] + " isn't player in the match");
				}
				return;
			}
			if (aUsers.length!=0 && aUsers[aUsers.length - 1] == user_ids[k]) {
				if(iColor!=-1){
					do_client_protocol_error_with_description("Invalid order of turns");
				}
				return;
			}
			if(saveState(keys[k], datas[k])){
				aUsers.push(user_ids[k]);
				aKeys.push(keys[k]);
				aDatas.push(datas[k]);
			}
		}
		showState();
		iCurStep = iFilledNum;
		if(iCurStep>0){
			btnPrev.visible = true;
		}else {
			btnPrev.visible = false;
		}
		btnNext.visible = false;
		checkEndOfMatch();
		
		if (iCurTurn == -1 && iFilledNum==0 && iColor == 0) {
			do_start_my_turn();
		}
	}
	public function got_match_over(user_ids:Array):Void {
		do_store_trace("got_match_over", "user_ids=" + json.stringify(user_ids));
		setOnPress(false);
		iCurTurn = -1;
	}
	public function got_end_turn_of(user_id:Number):Void {
		do_store_trace("got_end_turn_of", "user_id=" + json.stringify(user_id));
		if (iColor != -1 && iCurTurn != iID && iColor != getCurrentTurn()) {
			do_client_protocol_error_with_description("Oponent didn't make his turn");
			return;
		}
		if (iColor == getCurrentTurn() && !isGameOver() && !isTie()) {
			do_start_my_turn();
		}
	}
	public function got_start_turn_of(user_id:Number):Void{
		do_store_trace("got_start_turn_of", "user_id=" + json.stringify(user_id));
		iCurTurn = user_id;
		if (user_id == iID) {
			setOnPress(true);
		}else {
			setOnPress(false);
		}
	}
}