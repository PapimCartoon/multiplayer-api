package {
	import flash.display.*;
    import flash.utils.*;
	import flash.events.*;
	
	public class TicTacToe_board extends MovieClip {
		private var api:TicTacToe_API;
		private var interval_id:uint;
		
		public function TicTacToe_board() {
			this.stop();
			api = new TicTacToe_API(this);
			// this.stage is currently null, therefore we must wait until flash sets the stage.
			interval_id = setInterval(init, 100); 
		}
		private function init() {
			if (stage!=null) {
				clearInterval(interval_id);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, api.reportKeyDown);
			}
		}

	}
}
import flash.display.*;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.events.*;
import flash.net.LocalConnection;
import flash.net.URLRequest;
import fl.controls.*;
import flash.text.*;
	
class TicTacToe_API extends ClientGameAPI {
	//Private variables
	private var aGameState:Array;
	private var aBoardSquares:Array;
	private var iFilledNum:int;
	private var bCanPress:Boolean;
	private var aPlayers:Array;
	private var aUsers:Array;
	private var aKeys:Array;
	private var aDatas:Array;
	private var btnPrev:Button;
	private var btnNext:Button;
	private var iCurStep:int;
	private var iCurTurn:int;
	private var ldrLogo:Loader;
	private var iColor:int;
	private var iID:int;
	private var root:MovieClip;
	private var bGameStarted:Boolean;
    
	private const iSize:int = 3;
	
	//Constructor
	public function TicTacToe_API(_root:MovieClip ) {
		try {
			trace('TicTacToe_API!');
			super(_root.loaderInfo.parameters);
		
			root = _root;			

			trace('initUser!');
			initUser();
			
			btnPrev = new Button();
			btnPrev.label = "<<";
			btnPrev.width = 50;
			btnPrev.y = 335;
			btnPrev.x = 25 + 150 - 50 - 5;
			btnPrev.addEventListener(MouseEvent.CLICK, btnPrevClick);
			btnPrev.visible = false;
			root.addChild(btnPrev);
			
			btnNext = new Button();
			btnNext.label = ">>";
			btnNext.width = 50;
			btnNext.y = 335;
			btnNext.x = 25 + 150 + 5;
			btnNext.addEventListener(MouseEvent.CLICK, btnNextClick);
			btnNext.visible = false;
			root.addChild(btnNext);
		} catch (err:Error) { 
			trace('ERRROR: '+err+" stacktraces="+err.getStackTrace());
			var msg:TextField = new TextField();
			msg.autoSize = TextFieldAutoSize.LEFT;
			msg.text = ''+err+" prefix="+_root.loaderInfo.parameters.prefix;
			_root.addChild(msg);
		}
	}
	public function reportKeyDown(event:KeyboardEvent):void {
		if (!bGameStarted) return;
		var charCode:int = event.charCode;
		do_store_trace("KeyboardEvent", "charCode="+charCode);
		var delta:int = charCode - '1'.charCodeAt(0)
		if (delta>=0 && delta<9) {
			var i:int =  2-int(delta/3);
			var j:int =  delta%3;
			do_store_trace("KeyboardEvent", "delta="+delta+" i="+i+" j="+j);
			if (aGameState[i][j]!=-1) return; // not empty
			if (getCurrentTurn()!=iColor) return; // not my turn
			doMove(i, j);
		}
	}	
	private function btnPrevClick(evt:MouseEvent):void {
		iCurStep--;
		resetBoard();
		if (iCurStep > 0) {
			for (var i:int = 0; i < iCurStep; i++) {
				saveState(aKeys[i], aDatas[i]);
			}
			showState();
		}else {
			btnPrev.visible = false;
		}
		btnNext.visible = true;
		setOnPress(false);
	}
	private function btnNextClick(evt:MouseEvent):void {
		iCurStep++;
		resetBoard();
		for (var i:int = 0; i < iCurStep; i++) {
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
	
	public function initUser():void {
		try{
			do_register_on_server();
			iFilledNum = 0;
			iCurTurn = -1;
			bCanPress = false;
			
			aBoardSquares = new Array(iSize);
			aGameState = new Array(iSize);
			var sqr:Square;
			var _x:int = 100;
			var _y:int = 100;
			for(var i:int=0; i<iSize; i++) {
				aBoardSquares[i] = new Array(iSize);
				aGameState[i] = new Array(iSize);
				for (var j:int = 0; j < iSize; j++) {
					aGameState[i][j] = -1;
					
					sqr = new Square(_x, _y,i,j);
					sqr.x = j * _x+25;
					sqr.y = i * _y + 25;
					sqr.visible = false;
					root.addChild(sqr);
					aBoardSquares[i][j] = sqr;
				}
			}
		}catch (err:Error) {
			do_store_trace("initUser", "Error: " + err.message);
		}
	}
	private function onLogoLoaded(evt:Event):void {
		try{
			var bmpdata:BitmapData = new BitmapData(100, 100, true, 0xFFFFFF);
			bmpdata.draw(Bitmap(ldrLogo.content), new Matrix);
			
			var sqr:Square;
			for(var i:int=0; i<iSize; i++) {
				for (var j:int = 0; j < iSize; j++) {				
					sqr = aBoardSquares[i][j];
					sqr.addLogo(bmpdata);
				}
			}
		}catch(err:Error){ 
			do_store_trace("onLogoLoaded","Error: " + err.message);
		}
	}
	private function onLogoError(evt:IOErrorEvent):void {
		do_store_trace("got_general_info", "Error: Logo file doesn't exist");
	}
	private function resetBoard():void {
		 try{
			iFilledNum = 0;
			var sqr:Square;
			for(var i:int=0; i<iSize; i++){
				for (var j:int = 0; j < iSize; j++) {
					aGameState[i][j] = -1;
					sqr = aBoardSquares[i][j];
					sqr.visible = true;
					sqr.renew(false, -1);
				}
			}
		}catch (err:Error) {
				do_store_trace("resetBoard", "Error: " + err.message);
		}
	}
	private function doMove(i:int, j:int):void {
		try{
			do_store_trace("doMove","i="+i+", j="+j);
			var currTurn:int = getCurrentTurn();
			updateSquare(currTurn, i,j);
			do_store_match_state("square"+i+j, {x:i,y:j,state:currTurn});
			aGameState[i][j] = currTurn;
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
	private function checkEndOfMatch():void {
		try{
			if (iColor == -1) {
				return;
			}
			if (isGameOver()) {
				var arr:Array;
				var arr1:Array;
				if ((iColor==1 && iCurTurn==iID) || (iColor==0 && iCurTurn!=iID)) {
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
	private function updateSquare(val:int, i:int, j:int):void {
		try{
			var sqr:Square = aBoardSquares[i][j];
			var chk:Boolean = false;
			if (val != -1) {
				chk = true;
			}
			sqr.renew(chk, val);
		}catch (err:Error) {
			do_store_trace("updateSquare", "Error: " + err.message);
		}
	}
	private function setOnPress(isOn:Boolean):void {
		try{
			bCanPress = isOn;
			var sqr:Square;
			do_store_trace("setOnPress","isOn="+isOn);
			for(var i:int=0; i<iSize; i++) {
				for (var j:int = 0; j < iSize; j++) {
					sqr = aBoardSquares[i][j];
					if(bCanPress && !sqr.Checked){
						sqr.addEventListener(MouseEvent.MOUSE_MOVE, onSquareEnter);
						sqr.addEventListener(MouseEvent.MOUSE_OUT, onSquareLeave);
						sqr.addEventListener(MouseEvent.CLICK, onSquareClick);
					}else {
						sqr.removeEventListener(MouseEvent.MOUSE_MOVE, onSquareEnter);
						sqr.removeEventListener(MouseEvent.MOUSE_OUT, onSquareLeave);
						sqr.removeEventListener(MouseEvent.CLICK, onSquareClick);
					}
				}
			}
		}catch (err:Error) {
			do_store_trace("setOnPress", "Error: " + err.message);
		}
	}
	private function showState():void {
		var j:int, k:int;
		iFilledNum = 0;
		for (j = 0; j < iSize; j++) {
			for (k = 0; k < iSize; k++) {
				updateSquare(aGameState[j][k],j, k);
				if (int(aGameState[j][k]) != -1) {
					iFilledNum++;
				}
			}
		}
	}
	private function saveState(key:String, data:Object):Boolean {
		if (key.indexOf("square") == 0) {
			try {
				var x:int = data["x"];
				var y:int = data["y"];
				var state:int = data["state"];
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
	private function onSquareEnter(evt:MouseEvent):void {
		if(evt.target is Square){
			var sqr:Square = Square(evt.target);
			if(!sqr.Checked){
				sqr.renew(false, iColor);
			}
		}
	}		
	private function onSquareLeave(evt:MouseEvent):void {
		if(evt.target is Square){
			var sqr:Square = Square(evt.target);
			if(!sqr.Checked){
				sqr.renew(false, -1);
			}
		}
	}
	private function onSquareClick(evt:MouseEvent):void {
		if(evt.target is Square){
			var sqr:Square = Square(evt.target);
			if (!sqr.Checked) {
				doMove(sqr.I, sqr.J);
			}
		}
	}
	private function getCurrentTurn():int { 
		return iFilledNum % 2; 
	}
	private function isGameOver():Boolean {
		try{
			var ownedBy:int;
			var i:int,j:int;
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
	public override function got_general_info(keys:Array, datas:Array):void {
		for (var i:int = 0; i < keys.length; i++) {
			if (keys[i] == "logo_swf_full_url") {
				ldrLogo = new Loader();
				ldrLogo.contentLoaderInfo.addEventListener(Event.COMPLETE, onLogoLoaded);
				ldrLogo.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLogoError);
				ldrLogo.load(new URLRequest(datas[i]));
				return;
			}
		}
	}
	public override function got_my_user_id(user_id:int):void {
		iID = user_id;
	}
	public override function got_match_started(user_ids:Array, extra_match_info:Object, match_started_time:int):void { 
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
		
		iColor = user_ids.indexOf(iID);
	}
	public override function got_stored_match_state(user_ids:Array, keys:Array, datas:Array):void {
		var k:int,i:int;
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
		if (iColor != -1 && bGameStarted) {
			checkEndOfMatch();
		}
		if (iCurTurn == -1 && iFilledNum==0 && iColor == 0) {
			do_start_my_turn();
		}
	}
	public override function got_match_over(user_ids:Array):void {
		setOnPress(false);
		iCurTurn = -1;
	}
	public override function got_end_turn_of(user_id:int):void {
		if (iColor != -1 && iCurTurn != iID && iColor != getCurrentTurn()) {
			do_client_protocol_error_with_description("Oponent didn't make his turn");
			return;
		}
		if (iColor == getCurrentTurn() && !isGameOver() && !isTie()) {
			do_start_my_turn();
		}
	}
	public override function got_start_turn_of(user_id:int):void{
		iCurTurn = user_id;
		if (user_id == iID) {
			setOnPress(true);
		}else {
			setOnPress(false);
		}
	}
	
	public override function got_error(in_function_name:String, err:Error):void {		
		do_client_protocol_error_with_description("got_error in function "+in_function_name+" err="+err);
	}
}