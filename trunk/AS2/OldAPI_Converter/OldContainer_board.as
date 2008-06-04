import mx.utils.Delegate;

class OldContainer_board extends ClientGameAPI{
	private var loaded:Boolean = false;
	private var registred:Boolean = false;
	private var ready:Boolean = false;
	private var movie:MovieClip;
	private var classObj:Game;
	private var mcl:MovieClipLoader;
	private var waitToStartMatch:Boolean=false;
	private var isMyTurn:Boolean = false;
	private var iStartTurnSended:Boolean = false;
	private var className;
	private var server;
	private var iColor:Number;
	private var bGameStarted:Boolean;
	private var players:Array;
	private var iID:Number;
	private var json:JSON_AS2;
	private var swfRoot:MovieClip;

	public function OldContainer_board(root:MovieClip) {
		super(root);
		swfRoot = root;
		json = new JSON_AS2();
		
		mcl = new MovieClipLoader();
		var lstn:Object = new Object();
		var obj:OldContainer_board = this;
		lstn.onLoadError = function(target_mc:MovieClip, errorCode:String, status:Number):Void  {
			obj.do_store_trace("Constructor","Error: "+errorCode);
		};
		lstn.onLoadInit = function(target_mc:MovieClip, status:Number):Void  {
			obj.loaded = true;
		};

		mcl.addListener(lstn);
		
		root._lockroot=true;
		
		movie = swfRoot["box"];
		mcl.loadClip(swfRoot["oldgame"], swfRoot["box"]);
	}
	//Override functions
	public function got_my_user_id(user_id:Number):Void {
		iID = user_id;
	}
	public function got_match_started(user_ids:Array, extra_match_info:Object, match_started_time:Number):Void {
		bGameStarted = true;
		iStartTurnSended = false;
		players = user_ids;
		iColor = -1;
		for (var i:Number = 0; i < user_ids.length; i++) {
			if (user_ids[i] == iID) {
				iColor = i;
				break;
			}
		}
		if(!registred){
			movie.gotoAndStop("Start_Game");
			classObj = new className(server, iColor, swfRoot);
			movie.gotoAndStop("Start_Game");
		}
		registred = true;
		waitToStartMatch = true;
	}
	public function got_stored_match_state(user_ids:Array, keys:Array, datas:Array):Void {
		var state:Object = null;
		var turn:Object = null;
		var i;
		for (i = 0; i < keys.length; i++) {
			if (keys[i] == "GameState") {
				break;
			}
		}
		if (i < keys.length) {
			state = datas[i];
		}
		for (i = 0; i < keys.length; i++) {
			if (keys[i] == "CurrTurn") {
				break;
			}
		}
		if (i < keys.length) {
			turn = datas[i];
		}
		for (i = 0; i < keys.length; i++) {
			if (keys[i] == "CurrColor") {
				break;
			}
		}
		if (i < keys.length) {
			if (datas[i][1] == iColor && !isMyTurn && !iStartTurnSended) {
				do_start_my_turn();
				iStartTurnSended = true;
			}
		}
		if (i < keys.length) {
			classObj.receivedSetTurn(datas[i][0],datas[i][1],datas[i][2]);
		}
		if (waitToStartMatch) {
			classObj.matchStarted(state);
			waitToStartMatch = false;
		}else {
			if (turn != null) {
				classObj.receivedBroadcast.apply(classObj,[(user_ids[0]-1)].concat(turn));
			}
		}
	}
	public function got_match_over(user_ids:Array):Void { 
		isMyTurn = false;
		bGameStarted = false;
		classObj.matchEnded();
	}
	public function got_message(user_id:Number, data:Object):Void {
		do_agree_on_match_over(data[0],data[1],data[2]);
	}
	public function got_start_turn_of(user_id:Number):Void {
		iStartTurnSended = false;
		if (user_id == iID) {
			isMyTurn = true;
		}
	}
	public function got_end_turn_of(user_id:Number):Void {
		if (user_id == iID) {
			isMyTurn = false;
		}
	}
	
	//Register game class
	public function registerClientAPI(_className, _obj):Void {
		do_store_trace("registerClientAPI","className="+json.stringify(_className)+", obj="+json.stringify(_obj));
		className=_className;
		swfRoot=_obj;
		server = new Object();
		server.sendBroadcast = Delegate.create(this, sendBroadcast);
		server.setTurn = Delegate.create(this, setTurn);
		server.sendMatchEnded = Delegate.create(this, sendMatchEnded);
		do_register_on_server();
	}
	//From OldAPI to NewAPI
	private function sendBroadcast():Void {
		do_store_trace("sendBroadCast","arguments="+json.stringify(arguments));
		if (!bGameStarted) {
			return;
		}
		do_store_match_state("CurrTurn", arguments);
		do_store_match_state("GameState", classObj.getSavedData());
	}
	private function setTurn(turnNumber:Number, currColor:Number, milliSeconds:Number):Void {
		do_store_trace("setTurn", "turnNumber=" + json.stringify(turnNumber) + ", currColor=" + json.stringify(currColor) + ", milliSeconds=" + json.stringify(milliSeconds));
		if (!bGameStarted) {
			return;
		}
		if (isMyTurn) {
			var i:Number;
			for (var j:Number = 0; j < players.length; j++) {
				if (players[j] != iID) {
					i = players[j];
					break;
				}
			}
			do_end_my_turn([i]);
		}
		do_store_match_state("CurrColor", [turnNumber, currColor, milliSeconds]);	
	}
	private function sendMatchEnded(winningColor:Number, whiteScore:Number, blackScore:Number, whiteTokenPercentage:Number):Void {
		do_store_trace("sendMatchEnded","winningColor="+json.stringify(winningColor)+", whiteScore="+json.stringify(whiteScore)+", blackScore="+json.stringify(blackScore)+", whiteTokenPercentage="+json.stringify(whiteTokenPercentage));
		if (!bGameStarted) {
			return;
		}
		if (iColor != -1) {
			var i:Number;
			for (var j:Number = 0; j < players.length; j++) {
				if (players[j] != iID) {
					i = players[j];
					break;
				}
			}
			var arr:Array ;
			if (iColor == 0) {
				arr = new Array(iID, i);
			}else{
				arr = new Array(i, iID);
			}
			var scores:Array = winningColor==0 ? [1, -1] : winningColor==1 ? [-1, 1] : [0,0];
			var pot_percentages:Array = winningColor==0 ? [100, 0] : winningColor==1 ? [0, 100] : null;
 
			if (whiteScore!=null && blackScore!=null && whiteScore!=undefined && blackScore!=undefined && ( winningColor==0 ? whiteScore>blackScore : winningColor==1 ? whiteScore<blackScore : whiteScore==blackScore ) ) {
				scores = [whiteScore, blackScore];
			}
			if (whiteTokenPercentage != null && whiteTokenPercentage!=undefined) {
				pot_percentages =  [ whiteTokenPercentage, 100 - whiteTokenPercentage];
			}
			do_agree_on_match_over(arr, scores, pot_percentages);
			do_send_message([i], [arr, scores, pot_percentages]);
		}
	}
}