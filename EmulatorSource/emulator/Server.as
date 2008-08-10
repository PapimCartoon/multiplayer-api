package emulator {
	import fl.controls.*;
	import fl.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;

	public class Server extends MovieClip {
		//Private variables
		private var isTurnBasedGame:Boolean = false;
		private var lcFramework:LocalConnection;
		private var aUsers:Array;
		private var aKeys:Array;
		private var aData:Array;
		private var aDataUsers:Array;
		private var bGameStarted:Boolean = false;
		private var bGameEnded:Boolean = false;
		private var extra_match_info:Object;
		private var match_started_time:int;
		private var sCurMessageType:String;
		private var aMessages:Array;
		private var iMessages:int = 0;
		private var tbsPanel:TabDialog;
		private var pnlLog:MovieClip;
		private var pnlCommands:MovieClip;
		private var aFilters:Array;
		private var aConditions:Array;
		private var btnSend:Button;
		private var aParams:Array;
		private var aPlayers:Array;
		private var aNextPlayers:Array;
		private var aServerKeys:Array;
		private var aServerDatas:Array;
		private var txtLog:TextArea;
		private var tblLog:DataGrid;
		private var btnSearch:Button;
		private var btnClear:Button;
		private var btnFullLog:Button;
		private var btnLog:SimpleButton;
		private var btnCommands:SimpleButton;
		private var btnGeneralInfo:SimpleButton;
		private var btnUserInfo:SimpleButton;
		private var btnMatchState:SimpleButton;
		private var btnMatchOver:SimpleButton;
		private var btnSavedGames:SimpleButton;
		private var btnNewGame:Button;
		private var btnLoadGame:Button;
		private var btnSaveGame:Button;
		private var btnCancelGame:Button;
		private var btnQuestion:MovieClip;
		private var txtExtraMatchInfo:TextField;
		private var txtMatchStartedTime:TextField;
		private var txtTooltipExtraMatchInfo:TextField;
		private var txtTooltipMatchStartedTime:TextField;
		private var cmbCommand:ComboBox;
		private var cmbTarget:ComboBox;
		private var sPrefix:String;
		private var txtTooltip:TextField;
		private var startWidth:Number;
		private var startHeight:Number;
		private var pnlSave:MovieClip;
		private var txtSaveName:TextField;
		private var btnSaveOK:Button;
		private var pnlLoad:MovieClip;
		private var cmbLoadName:ComboBox;
		private var btnLoadOK:Button;
		private var btnLoadDelete:Button;
		private var shrSavedGames:SharedObject;
		private var shrParams:SharedObject;
		private var iCurTurn:int;
		private var MsgBox:MessageBox;
		private var tmrResize:Timer;
		private var lblServer:Label;
		private var txtLabelSearch:TextField;
		private var txtLabelLog:TextField;
		private var txtLabelDetails:TextField;
		private var aMatchOvers:Array;
		private var tblInfo:DataGrid;
		private var txtInfo:TextArea;
		private var pnlInfo:MovieClip;
		private var txtInfoDetails:TextField;
		private var iInfoMode:int;
		
		//Constructor
		public function Server() {
			this.stop();
			
			tbsPanel = new TabDialog();
			tbsPanel.x = 3;
			tbsPanel.y = 52;
			this.addChild(tbsPanel);
			
			pnlCommands = new MovieClip;
			pnlCommands.y = 5;
			pnlCommands.x = 5;
			pnlCommands.visible = false;
			tbsPanel.addChild(pnlCommands);
			
			cmbCommand = new ComboBox();
			cmbCommand.setSize(150, 22);
			cmbCommand.prompt = "Select command";
			for each (var command_name:String in Commands.getCommandNames(true)) {
				cmbCommand.addItem( { label:command_name, data:command_name } );
			}
			cmbCommand.addEventListener(Event.CHANGE, changeCommand);
			pnlCommands.addChild(cmbCommand);
			
			cmbTarget = new ComboBox();
			cmbTarget.setSize(150, 22);
			cmbTarget.x = 160;
			cmbTarget.prompt = "Select target";
			cmbTarget.addItem( { label:"All", data:-1 } );	
			pnlCommands.addChild(cmbTarget);
			
			txtTooltip = new TextField();
			txtTooltip.y = 35;
			txtTooltip.autoSize = TextFieldAutoSize.LEFT;
			pnlCommands.addChild(txtTooltip);
			
			btnSend = new Button();
			btnSend.label = "Send";
			btnSend.visible = false;
			btnSend.addEventListener(MouseEvent.CLICK, btnSendClick);
			pnlCommands.addChild(btnSend);
			
			pnlLog = new MovieClip;
			pnlLog.y = 5;
			pnlLog.x = 5;
			tbsPanel.addChild(pnlLog);
			
			txtLabelSearch = new TextField();
			txtLabelSearch.htmlText = "<b>Search:</b>";
			pnlLog.addChild(txtLabelSearch);
			
			var txt:TextField;
			aFilters = new Array(5);
			aConditions = new Array(5);
			for (i = 0; i < 5; i++) {
				txt = new TextField();
				txt.type = TextFieldType.INPUT;
				txt.border = true;
				txt.borderColor = 0x888888;
				txt.background = true;
				txt.backgroundColor = 0xF8F8F8;
				txt.y = 20;
				txt.height = 20;
				txt.addEventListener(KeyboardEvent.KEY_DOWN, filterKeyDown);
				aFilters[i] = txt;
				aConditions[i] = "";
				pnlLog.addChild(txt);
			}
			aFilters[0].width = 35;
			aFilters[0].x = 0;
			aFilters[1].width = 50;
			aFilters[1].x = 35;
			aFilters[2].width = 120;
			aFilters[2].x = 85;
			aFilters[3].width = 255;
			aFilters[3].x = 205;
			aFilters[4].width = 60;
			aFilters[4].x = 460;
			
			btnSearch = new Button();
			btnSearch.label = "Search";
			btnSearch.x = 520-btnSearch.width;
			btnSearch.y = 45;
			btnSearch.addEventListener(MouseEvent.CLICK, searchClick);
			pnlLog.addChild(btnSearch);
			
			txtLabelLog = new TextField();
			txtLabelLog.htmlText = "<b>Log:</b>";
			txtLabelLog.y = 45;
			pnlLog.addChild(txtLabelLog);
			
			tblLog = new DataGrid();
			tblLog.y = 70;
			tblLog.width = 520;
			tblLog.height = 130;
			tblLog.columns = ["Num", "User", "FunctionName", "Arguments", "Time"];
			tblLog.columns[0].sortOptions = Array.NUMERIC;
			tblLog.columns[0].width = 35;
			tblLog.columns[1].width = 50;
			tblLog.columns[2].width = 120;
			tblLog.columns[4].width = 60;
			tblLog.addEventListener(DataGridEvent.COLUMN_STRETCH, resizeColumn);
			tblLog.addEventListener(Event.CHANGE, itemSelected);
			pnlLog.addChild(tblLog);
			
			txtLabelDetails = new TextField();
			txtLabelDetails.autoSize = TextFieldAutoSize.LEFT;
			txtLabelDetails.htmlText = "<b>Log details</b> (click on a log from the list to view it in the text area):";
			txtLabelDetails.y = 200;
			pnlLog.addChild(txtLabelDetails);
			
			txtLog = new TextArea();
			txtLog.setSize(520, 80);
			txtLog.y = 220;
			txtLog.editable = false;
			pnlLog.addChild(txtLog);
			
			btnClear = new Button();
			btnClear.label = "Clear log";
			btnClear.y = 303;
			btnClear.x = 520 - btnClear.width * 2 - 3;
			btnClear.addEventListener(MouseEvent.CLICK, clearLogClick);
			pnlLog.addChild(btnClear);
			
			btnFullLog = new Button();
			btnFullLog.y = 303;
			btnFullLog.x = 520 - btnClear.width;
			btnFullLog.label = "Full log";
			btnFullLog.addEventListener(MouseEvent.CLICK, fullLogClick);
			pnlLog.addChild(btnFullLog);
			
			pnlInfo = new MovieClip;
			pnlInfo.y = 5;
			pnlInfo.x = 5;
			pnlInfo.visible=false;
			tbsPanel.addChild(pnlInfo);
			
			tblInfo = new DataGrid();
			tblInfo.width = 515;
			tblInfo.height = 195;
			tblInfo.addEventListener(Event.CHANGE, infoItemSelected);
			pnlInfo.addChild(tblInfo);
			
			txtInfoDetails = new TextField();
			txtInfoDetails.autoSize = TextFieldAutoSize.LEFT;
			txtInfoDetails.htmlText = "<b>Details</b>:";
			txtInfoDetails.y = 200;
			pnlInfo.addChild(txtInfoDetails);
			
			txtInfo = new TextArea();
			txtInfo.setSize(515, 115);
			txtInfo.y = 220;
			txtInfo.editable = false;
			pnlInfo.addChild(txtInfo);
			
			btnLog = tbsPanel["_btnLog"];
			btnLog.addEventListener(MouseEvent.CLICK, btnLogClick);

			btnCommands = tbsPanel["_btnCommand"];
			btnCommands.addEventListener(MouseEvent.CLICK, btnCommandsClick);

			btnMatchState = tbsPanel["_btnMatchState"];
			btnMatchState.addEventListener(MouseEvent.CLICK, btnMatchStateClick);

			btnGeneralInfo = tbsPanel["_btnGeneralInfo"];
			btnGeneralInfo.addEventListener(MouseEvent.CLICK, btnGeneralInfoClick);

			btnUserInfo = tbsPanel["_btnUserInfo"];
			btnUserInfo.addEventListener(MouseEvent.CLICK, btnUserInfoClick);

			btnMatchOver = tbsPanel["_btnMatchOver"];
			btnMatchOver.addEventListener(MouseEvent.CLICK, btnMatchOverClick);

			btnSavedGames = tbsPanel["_btnSavedGames"];
			btnSavedGames.addEventListener(MouseEvent.CLICK, btnSavedGamesClick);
			
			btnNewGame = new Button();
			btnNewGame.x = 490;
			btnNewGame.width = 50;
			btnNewGame.label = "New";
			btnNewGame.addEventListener(MouseEvent.CLICK, btnNewGameClick);
			this.addChild(btnNewGame);
			
			btnCancelGame = new Button();
			btnCancelGame.x = 490;
			btnCancelGame.width = 50;
			btnCancelGame.visible = false;
			btnCancelGame.label = "Cancel";
			btnCancelGame.addEventListener(MouseEvent.CLICK, btnCancelGameClick);
			this.addChild(btnCancelGame);
			
			btnLoadGame = new Button();
			btnLoadGame.x = 150;
			btnLoadGame.width = 70;
			btnLoadGame.label = "Load game";
			btnLoadGame.addEventListener(MouseEvent.CLICK, btnLoadGameClick);
			this.addChild(btnLoadGame);
			
			btnSaveGame = new Button();
			btnSaveGame.x = 150;
			btnSaveGame.width = 70;
			btnSaveGame.visible = false;
			btnSaveGame.label = "Save game";
			btnSaveGame.addEventListener(MouseEvent.CLICK, btnSaveGameClick);
			this.addChild(btnSaveGame);
			
			btnQuestion = new QuestionOnWhite();
			btnQuestion.x = 230;
			btnQuestion.y = 10;
			btnQuestion.addEventListener(MouseEvent.CLICK, btnQuestionClick);
			this.addChild(btnQuestion);
			
			txtExtraMatchInfo = new TextField();
			txtExtraMatchInfo.border = true;
			txtExtraMatchInfo.width = 120;
			txtExtraMatchInfo.height = 20;
			txtExtraMatchInfo.x = 240;
			txtExtraMatchInfo.type = TextFieldType.INPUT;
			txtExtraMatchInfo.addEventListener(MouseEvent.MOUSE_OVER, extraMatchInfoOver);
			txtExtraMatchInfo.addEventListener(MouseEvent.MOUSE_OUT, extraMatchInfoOut);
			this.addChild(txtExtraMatchInfo);
			
			txtMatchStartedTime = new TextField();
			txtMatchStartedTime.border = true;
			txtMatchStartedTime.width = 120;
			txtMatchStartedTime.height = 20;
			txtMatchStartedTime.x = 365;
			txtMatchStartedTime.type = TextFieldType.INPUT;
			txtMatchStartedTime.addEventListener(MouseEvent.MOUSE_OVER, matchStartedTimeOver);
			txtMatchStartedTime.addEventListener(MouseEvent.MOUSE_OUT, matchStartedTimeOut);
			this.addChild(txtMatchStartedTime);
			
			pnlLoad = new MovieClip();
			pnlLoad.x = 150;
			pnlLoad.y = 22;
			pnlLoad.graphics.beginFill(0xEEEEEE);
			pnlLoad.graphics.lineStyle(1, 0xAAAAAA);
			pnlLoad.graphics.moveTo(0, 55);
			pnlLoad.graphics.lineTo(0, 0);
			pnlLoad.graphics.lineTo(200, 0);
			pnlLoad.graphics.lineStyle(1, 0x666666);
			pnlLoad.graphics.lineTo(200, 55);
			pnlLoad.graphics.lineTo(0, 55);
			pnlLoad.graphics.endFill();
			pnlLoad.visible = false;
			pnlLoad.addEventListener(FocusEvent.FOCUS_OUT, loadFocusOut);
			this.addChild(pnlLoad);
			
			cmbLoadName = new ComboBox();
			cmbLoadName.x=5
			cmbLoadName.y = 5;
			cmbLoadName.width = 190;
			cmbLoadName.prompt = "Select game";
			cmbLoadName.addEventListener(FocusEvent.FOCUS_OUT, loadFocusOut);
			pnlLoad.addChild(cmbLoadName);
			
			btnLoadOK = new Button();
			btnLoadOK.x = 5;
			btnLoadOK.y = 30;
			btnLoadOK.width = 93;
			btnLoadOK.label = "Load";
			btnLoadOK.addEventListener(MouseEvent.CLICK, loadOkClick);
			btnLoadOK.addEventListener(FocusEvent.FOCUS_OUT, loadFocusOut);
			pnlLoad.addChild(btnLoadOK);
			
			btnLoadDelete = new Button();
			btnLoadDelete.x = 103;
			btnLoadDelete.y = 30;
			btnLoadDelete.width = 93;
			btnLoadDelete.label = "Delete";
			btnLoadDelete.addEventListener(MouseEvent.CLICK, loadDeleteClick);
			btnLoadDelete.addEventListener(FocusEvent.FOCUS_OUT, loadFocusOut);
			pnlLoad.addChild(btnLoadDelete);
			
			pnlSave = new MovieClip();
			pnlSave.x = 150;
			pnlSave.y = 22;
			pnlSave.graphics.beginFill(0xEEEEEE);
			pnlSave.graphics.lineStyle(1, 0xAAAAAA);
			pnlSave.graphics.moveTo(0, 55);
			pnlSave.graphics.lineTo(0, 0);
			pnlSave.graphics.lineTo(200, 0);
			pnlSave.graphics.lineStyle(1, 0x666666);
			pnlSave.graphics.lineTo(200, 55);
			pnlSave.graphics.lineTo(0, 55);
			pnlSave.graphics.endFill();
			pnlSave.visible = false;
			pnlSave.addEventListener(FocusEvent.FOCUS_OUT, saveFocusOut);
			this.addChild(pnlSave);
			
			txtSaveName = new TextField();
			txtSaveName.type = TextFieldType.INPUT;
			txtSaveName.x = 5;
			txtSaveName.y = 5;
			txtSaveName.width = 190;
			txtSaveName.height = 20;
			txtSaveName.background = true;
			txtSaveName.border = true;
			txtSaveName.addEventListener(KeyboardEvent.KEY_DOWN, saveKeyDown);
			txtSaveName.addEventListener(FocusEvent.FOCUS_OUT, saveFocusOut);
			pnlSave.addChild(txtSaveName);
			
			btnSaveOK = new Button();
			btnSaveOK.x = 5;
			btnSaveOK.y = 30;
			btnSaveOK.width = 100;
			btnSaveOK.label = "Save";
			btnSaveOK.addEventListener(MouseEvent.CLICK, saveOkClick);
			btnSaveOK.addEventListener(FocusEvent.FOCUS_OUT, saveFocusOut);
			pnlSave.addChild(btnSaveOK);
			afterResize(null);
			
			lblServer = new Label();
			lblServer.x = 8;
			lblServer.y = 2;
			txt = new TextField();
			txt.textColor = 0xFFFFFF;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = "Logs & Commands";
			txt.x = 23;
			lblServer.addChild(txt);
			this.addChild(lblServer);
			
			txtTooltipExtraMatchInfo = new TextField;
			txtTooltipExtraMatchInfo.autoSize = TextFieldAutoSize.LEFT;
			txtTooltipExtraMatchInfo.background = true;
			txtTooltipExtraMatchInfo.text = "extra_match_info:Object";
			txtTooltipExtraMatchInfo.x = txtExtraMatchInfo.x;
			txtTooltipExtraMatchInfo.y = 22;
			txtTooltipExtraMatchInfo.visible = false;
			this.addChild(txtTooltipExtraMatchInfo);
			
			txtTooltipMatchStartedTime = new TextField;
			txtTooltipMatchStartedTime.autoSize = TextFieldAutoSize.LEFT;
			txtTooltipMatchStartedTime.background = true;
			txtTooltipMatchStartedTime.text = "match_started_time:long";
			txtTooltipMatchStartedTime.x = txtMatchStartedTime.x;
			txtTooltipMatchStartedTime.y = 22;
			txtTooltipMatchStartedTime.visible = false;
			this.addChild(txtTooltipMatchStartedTime);
			
			iInfoMode=0;
			
			MsgBox = new MessageBox();
			
			aParams = new Array(8);
			var prm:Param;
			for (var i:int = 0; i < aParams.length; i++) {
				prm = new Param(MsgBox);
				prm.visible = false;
				prm.y = i * 32+35;
				pnlCommands.addChild(prm);
				aParams[i] = prm;
			}
			
			tmrResize = new Timer(500, 1);
			tmrResize.addEventListener(TimerEvent.TIMER, afterResize);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.RESIZE, resizeStage);
			startWidth = stage.stageWidth;
			startHeight = stage.stageHeight;
			
			sCurMessageType = "";
			aMessages = new Array();
			
			aUsers = new Array();
			aData = new Array();
			aKeys = new Array();
			aDataUsers = new Array();
			aPlayers = new Array();
			aNextPlayers = new Array();
			aMatchOvers = new Array();
			iCurTurn = -1;
			
			this.addChild(MsgBox);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, MsgBox.keyDown);
			
			if (root.loaderInfo.parameters["prefix"] == null) {
				MsgBox.Show("Parameter 'prefix' must be passed in the url.","Error");
				return;
			}
			
			sPrefix = root.loaderInfo.parameters["prefix"];
			
			lcFramework = new LocalConnection();
			lcFramework.client = this;
			lcFramework.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcFramework.connect("FRAMEWORK_SWF" + sPrefix);
			
			try{
				User.PlayersNum = parseInt(root.loaderInfo.parameters["players_num"]);
				if (isNaN(User.PlayersNum)) {
					MsgBox.Show("Parameter 'players_num' must be passed in the url.","Error");
					return;
				}
			}catch (err:Error) {
				MsgBox.Show("Parameter 'players_num' must be passed in the url.","Error");
				return;
			}
			try{
				User.ViewersNum = parseInt(root.loaderInfo.parameters["viewers_num"]);
				if (isNaN(User.ViewersNum)) {
					MsgBox.Show("Parameter 'viewers_num' must be passed in the url.","Error");
					return;
				}
			}catch (err:Error) {
				MsgBox.Show("Parameter 'viewers_num' must be passed in the url.","Error");
				return;
			}
			
			aServerKeys = new Array();
			aServerDatas = new Array();
			if (root.loaderInfo.parameters["logo"]!=null && root.loaderInfo.parameters["logo"] != "") {
				aServerKeys.push("logo_swf_full_url");
				aServerDatas.push(root.loaderInfo.parameters["logo"]);
			}
			
			if (root.loaderInfo.parameters["game"] == null) {
				MsgBox.Show("Parameter 'game' must be passed in the url.","Error");
				return;
			}
			
			shrSavedGames = SharedObject.getLocal("SavedGames");
			if (shrSavedGames.data.savedGames!=null) {
				var gamesArr:Array = shrSavedGames.data.savedGames;
				for each (var gameObject:Object in gamesArr) {
					var game:SavedGame = new SavedGame();
					for (var fieldName:String in gameObject)
						game[fieldName] = gameObject[fieldName];
					allSavedGames.push(game);
				}
			}

			enableSavedGames();
			var arr:Array = [];
			for (var p:String in root.loaderInfo.parameters) {
				arr.push([p, root.loaderInfo.parameters[p]]);
			}
			shrParams = SharedObject.getLocal("Come2PlayParams","/");
			shrParams.data.params = arr;
			shrParams.flush();
		}
		
		

		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
			try{
				trace("localconnection_callback: methodName="+methodName);
				// only do_register_on_server
				var func:Function = this[methodName] as Function;
				func.apply(this, parameters);
			} catch (err:Error) { 
				MsgBox.Show(err.getStackTrace(), "Error");
			}  
		}
		public function got_user_localconnection_callback(user:User, methodName:String, parameters:Array/*Object*/):void {			
			try{
				if (methodName=="do_finished_callback") return;
				trace("got_user_localconnection_callback: user="+user.Name+" methodName="+methodName);
				addMessageLog(user.Name, methodName, methodAndParams2String(methodName, parameters) );
								
				if (!bGameStarted) {
					addMessageLog("Server", methodName, "Error: game not started");
					return;
				}
				if (bGameEnded) {
					addMessageLog("Server", methodName, "Error: game already end");
					return;
				}
				switch(methodName) {
				case "do_agree_on_match_over":
				case "do_start_my_turn":
				case "do_end_my_turn":
				case "do_client_protocol_error_with_description":
					var ongoing_ids:Array = getOngoingPlayerIds();
					if (ongoing_ids.indexOf(user.ID) == -1) {
						addMessageLog("Server", methodName, "Error: "+user.Name+" is viewer. Only players can call "+methodName+".");
						return;
					}
				}
				var func:Function = this[methodName] as Function;
				func.apply(this, [user].concat(parameters));
			} catch (err:Error) { 
				MsgBox.Show(err.getStackTrace(), "Error");
			}  
		}
		private function arrays2string(arrs:Array):String {
			// keys, values, secret_levels
			var res:Array = [];
			for each (var name_arr:Array in arrs) {
				var name:String = name_arr[0];
				var arr:Array = name_arr[1];
				if (arr!=null) {
					for (var i:int = 0; i<arr.length; i++) {
						res[i] = (res[i]==null ? "" : res[i]+", ") + name +"="+ JSON.stringify(arr[i]);
					}
				}
			}
			return res.length==0 ? "[]" : "[{"+res.join("}, {")+"}]";
		}
		private function methodAndParams2String(methodName:String, paramValues:Array/*Object*/):String {
			var parameters:Array = Commands.findCommand(methodName);
			var res:Array = [];
			var arr2str:Array = [];
			var combinedName:String = null;
			switch (methodName) {
			case "got_general_info": 
			case "got_user_info": 
			case "do_store_match_state": 
			case "got_stored_match_state": 
				combinedName = "entries";
				break;
			case "got_match_started": 
				combinedName = "match_state";
				break;
			case "do_agree_on_match_over": 
			case "do_juror_end_match": 
				combinedName = "finished_players";
				break;
			}

			for (var i:int=0; i<parameters.length; i++) {
				var param_name:String = parameters[i][0];
				var param_value:Object = paramValues[i];
				
				switch (param_name) {
				case "user_ids": 
				case "keys": 
				case "values": 
				case "secret_levels":
				case "finished_player_ids": 
				case "scores": 
				case "pot_percentages": 
					if (combinedName!=null) {
						var name_without_final_s:String = param_name.substring(0,param_name.length-1);
						arr2str.push( [name_without_final_s , param_value ] );
						break;
					}
				default:
					res.push(param_name+"="+JSON.stringify(param_value));
				}
			}
			if (combinedName!=null) res.push(combinedName+"="+arrays2string(arr2str));
			return res.join(", ");
		}
		private function sendOperation(connectionName:String, methodName:String, parameters:Array/*Object*/):void {
			try {
				lcFramework.send(connectionName, "localconnection_callback", methodName, parameters); 
				var name:String = null;
				var u:User;
				for each (u in aUsers) {
					if (u.GotChanel == connectionName) {
						name = u.Name;
						break;
					}
				}
				if (name == null) {
					return;
				}
				addMessageLog(name, methodName, methodAndParams2String(methodName, parameters) );
			}catch(err:Error) { 
				MsgBox.Show(err.getStackTrace(), "Error");
			}      	
        }
		
		private function getFinishedPlayerIds():Array/*int*/ {
			var finished_player_ids:Array/*int*/ = [];
			if (bGameEnded) {
				finished_player_ids = [aPlayers];
			}else {				
				for each (var over:MatchOver in aMatchOvers) {
					if (over.recieved_from.length == User.PlayersNum) {
						finished_player_ids = finished_player_ids.concat( over.user_ids );
					}
				}
			}
			return finished_player_ids;
		}
		private function getOngoingPlayerIds():Array/*int*/ {
			var res:Array = [];
			var finished_player_ids:Array = getFinishedPlayerIds();
			for each (var id:int in aPlayers) {
				var index:int = finished_player_ids.indexOf(id);
				if (index==-1) {
					res.push(id);
				} else {
					finished_player_ids.splice(index,1);
				}
			}
			if (finished_player_ids.length!=0) throw new Error("Internal error! Illegal player_ids="+finished_player_ids);
			return res;
		}			
		private function send_got_match_started(u:User):void {	
			var finished_player_ids:Array = getFinishedPlayerIds();
			u.Ended = finished_player_ids.indexOf(u.ID)!=-1;
			sendOperation(u.GotChanel, "got_match_started", [aPlayers, finished_player_ids, extra_match_info, match_started_time, aDataUsers, aKeys, aData, null]);
			//if (iCurTurn != -1) {
			//	sendOperation(u.GotChanel, "got_start_turn_of", [iCurTurn]);
			//}
		}
		public function do_register_on_server(chanel:int):void {
			addMessageLog("Server", "do_register_on_server", "chanel="+chanel);
		
			var u:User = new User(chanel, sPrefix, this);
			
			aUsers.push(u);
			
			sendOperation(u.GotChanel, "got_my_user_id", [u.ID]);
			sendOperation(u.GotChanel, "got_general_info", [aServerKeys, aServerDatas]);
				
			for each (var user:User in aUsers) {
				if(user.ID!=u.ID){
					sendOperation(u.GotChanel, "got_user_info", [user.ID,user.Keys,user.Params]);
					sendOperation(user.GotChanel, "got_user_info", [u.ID, u.Keys, u.Params]);
				}
			}
			
			sendOperation(u.GotChanel, "got_user_info", [u.ID, u.Keys, u.Params]);
			showUserInfo();
			cmbTarget.addItem( { label: u.Name, data:u.ID } );
			
			
			
			
			if (bGameStarted) send_got_match_started(u);
			
			
			
			if (aPlayers.length < User.PlayersNum) {
				aPlayers.push(u.ID);
				if (aPlayers.length == User.PlayersNum) {
					if (!getStartParams()) {
						return;
					}
					bGameStarted = true;
					bGameEnded = false;
					txtExtraMatchInfo.visible = false;
					txtMatchStartedTime.visible = false;
					txtTooltipExtraMatchInfo.visible = false;
					txtTooltipMatchStartedTime.visible = false;
					btnNewGame.visible = false;
					btnCancelGame.visible = true;
					btnSaveGame.visible = true;
					btnLoadGame.visible = false;

					for each (var usr:User in aUsers) {
						send_got_match_started(usr);
					}
				}
			}
			
		}
		
		public function addMessageLog(user:String, funcname:String, message:String):void {
			var msg:Message = new Message();
			msg.message = message.replace(/(\s)+/gm, " ");
			msg.sender = user;
			msg.funcname = funcname;
			msg.num = iMessages++;
			msg.time = new Date().toTimeString().substr(0,8);
			aMessages.push(msg);
			if ((aConditions[0]=="" || msg.num==aConditions[0]) && (aConditions[1]=="" || msg.sender.indexOf(aConditions[1])>-1) && (aConditions[2]=="" || msg.funcname.indexOf(aConditions[2])>-1) && (aConditions[3]=="" || msg.message.indexOf(aConditions[3])>-1) && (aConditions[4]=="" || msg.time.indexOf(aConditions[4])>-1)) {
				tblLog.addItem( { Num:msg.num, User:msg.sender, FunctionName:msg.funcname, Arguments:msg.message, Time:msg.time } );
				tblLog.verticalScrollPosition = tblLog.maxVerticalScrollPosition+30;
				setTimeout(resizeColumn,100,null);
			}
		}
		
		private function getStartParams():Boolean {
			try {
				if(txtExtraMatchInfo.text!=""){
					extra_match_info = JSON.parse(txtExtraMatchInfo.text);
				}else {
					extra_match_info = null;
				}
				if(txtMatchStartedTime.text!=""){
					match_started_time=JSON.parse(txtMatchStartedTime.text) as int;
					if (isNaN(match_started_time)) {
						MsgBox.Show("Can't convert match_started_time to int","Error");
						return false;
					}
				}
				else {
					match_started_time = getTimer();
				}
				txtMatchStartedTime.text = match_started_time.toString();
				return true;
			}catch (err:Error) {
				MsgBox.Show(err.getStackTrace(), "Error");
			}
			return false;
		}
		
		private function onConnectionStatus(evt:StatusEvent):void {
			switch(evt.level) {
				case "error":
					trace("There is a LocalConnection error. Please test your game only inside the Come2Play emulator.");
			}
		}
		
		private function loaderError(evt:IOErrorEvent):void {
			MsgBox.Show("Can't load XML file", "Error");
		}
		
		private function resizeStage(evt:Event):void {
			tmrResize.stop();
			tmrResize.start();
		}
		
		private function afterResize(evt:Event):void {
			if(tmrResize!=null){
				tmrResize.stop();
			}
			var back:MovieClip = tbsPanel["back"];
			if (startWidth == 0) {
				startWidth = stage.stageWidth;
			}
			if (startHeight == 0) {
				startHeight = stage.stageHeight;
			}
			
			var prev_width:Number=back.width;
			var prev_height:Number = back.height;
			if (Math.abs((stage.stageWidth / startWidth) * 531 - back.width) < 1 && Math.abs((stage.stageHeight / startHeight) * 531 - back.height) < 1) {
				return;
			}
			
			var _x:int, _y:int;
			_x = stage.stageWidth - 20;
			_y = stage.stageHeight - 20;
			back.width = _x-tbsPanel.x-1;
			back.height = _y - tbsPanel.y - 1;
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xb9baba);
			this.graphics.moveTo(2, 22);
			this.graphics.lineTo(2 + back.width+1, 22);
			this.graphics.lineTo(2 + back.width+1, 52+back.height);
			this.graphics.lineTo(2, 52+back.height);
			this.graphics.lineTo(2, 22);
			
			tblLog.width = (back.width/531)*520;
			txtLog.width = (back.width / 531) * 520;
			tblInfo.width=(back.width / 531) * 520;
			txtInfo.width = (back.width / 531) * 520;
			
			tblLog.height = 130 + (back.height - 345);
			tblInfo.height=195+(back.height - 345);
			
			txtLabelDetails.y = 210 + (back.height - 345);
			txtLog.y = 230 + (back.height - 345);
			btnClear.y = 313 + (back.height - 345);
			btnFullLog.y = 313 + (back.height - 345);
			txtInfoDetails.y=200+ (back.height - 345);
			txtInfo.y=220+(back.height - 345);
			
			btnSearch.x = (back.width/531)*520-btnSearch.width;
			btnFullLog.x = (back.width/531)*520-btnFullLog.width;
			btnClear.x = (back.width / 531) * 520 - btnClear.width * 2 - 3;
			
			setTimeout(resizeTable, 100);
		}
		
		private function resizeTable():void {
			tblLog.columns[0].width = aFilters[0].width = tblLog.width*(35/520);
			aFilters[0].x = 0;
			tblLog.columns[1].width = aFilters[1].width = tblLog.width*(50/520);
			aFilters[1].x = aFilters[0].x+aFilters[0].width;
			tblLog.columns[2].width = aFilters[2].width = tblLog.width*(120/520);
			aFilters[2].x = aFilters[1].x+aFilters[1].width;
			tblLog.columns[3].width = aFilters[3].width = tblLog.width*(255/520);
			aFilters[3].x = aFilters[2].x+aFilters[2].width;
			tblLog.columns[4].width = aFilters[4].width = tblLog.width*(60/520);
			aFilters[4].x = aFilters[3].x+aFilters[3].width;
			
			setTimeout(resizeColumn,100,null);
		}
		
		private function resizeColumn(evt:DataGridEvent):void {
			var sum:int = 0;
			for (var i:int = 0; i < 5; i++) {
				aFilters[i].width = tblLog.columns[i].width;
				aFilters[i].x = sum;
				sum += aFilters[i].width;
			}
		}
		
		private function itemSelected(evt:Event):void {
			txtLog.text = "Num: "+evt.target.selectedItem.Num+"\n"+"User: "+evt.target.selectedItem.User+"\n"+"Function name: "+evt.target.selectedItem.FunctionName+"\n"+"Arguments: "+evt.target.selectedItem.Arguments+"\n"+"Time: "+evt.target.selectedItem.Time;
		}
		
		private function infoItemSelected(evt:Event):void {
			switch(iInfoMode){
				case 1:
					txtInfo.text = "user_id: " + evt.target.selectedItem.user_id + "\n" + "key: " + evt.target.selectedItem.key + "\n" + "data: " + evt.target.selectedItem.data;
					break;
				case 2:
					txtInfo.text = "user_id: " + evt.target.selectedItem.user_id + "\n" + "key: " + evt.target.selectedItem.key + "\n" + "submition_time: " + evt.target.selectedItem.submition_time + "\n" + "expiration_time: " + evt.target.selectedItem.expiration_time + "\n" + "pass_back: " + evt.target.selectedItem.pass_back + "\n" + "pending: " + evt.target.selectedItem.pending;
					break;
				case 3:
					txtInfo.text = "key: " + evt.target.selectedItem.key + "\n" + "data: " + evt.target.selectedItem.data;
					break;
				case 4:
					txtInfo.text = "user_id: " + evt.target.selectedItem.user_id + "\n" + "key: " + evt.target.selectedItem.key + "\n" + "data: " + evt.target.selectedItem.data;
					break;
				case 5:
					txtInfo.text = "users_id: " + evt.target.selectedItem.users_id + "\n" + "score: " + evt.target.selectedItem.score + "\n" + "pot_percentage: " + evt.target.selectedItem.pot_percentage + "\n" + "called_by_user_ids: " + evt.target.selectedItem.called_by_user_ids;
					break;
				case 6:
					txtInfo.text = "name: " + evt.target.selectedItem.name + "\n" + 
						"number_of_players: " + evt.target.selectedItem.number_of_players + "\n" + 
						"user_ids_that_are_still_playing: " + evt.target.selectedItem.user_ids_that_are_still_playing + "\n" + 
						"next_turn_of_user_ids: " + evt.target.selectedItem.next_turn_of_user_ids + "\n" + 
						"match_state: " + evt.target.selectedItem.match_state + "\n" + 
						"match_started_time: " + evt.target.selectedItem.match_started_time + "\n" + "extra_match_info: " + evt.target.selectedItem.extra_match_info;
					break;
			}
		}
		
		private function searchClick(evt:MouseEvent):void {
			showResult();
		}
		
		private function clearLogClick(evt:MouseEvent):void {
			aMessages = new Array();
			iMessages = 0;
			showResult();
		}
		
		private function showResult():void {
			tblLog.removeAll();
			var msg:Message;
			var str:Array;
			for (var i:int = 0; i < 5; i++) {
				aFilters[i].text = aFilters[i].text.replace(/^\s+|\s+$/g, "");
				aConditions[i] = aFilters[i].text;
			}
			for each (msg in aMessages) {
				if ((aConditions[0]=="" || msg.num==aConditions[0]) && (aConditions[1]=="" || msg.sender.indexOf(aConditions[1])>-1) && (aConditions[2]=="" || msg.funcname.indexOf(aConditions[2])>-1) && (aConditions[3]=="" || msg.message.indexOf(aConditions[3])>-1) && (aConditions[4]=="" || msg.time.indexOf(aConditions[4])>-1)) {
					tblLog.addItem({Num:msg.num,User:msg.sender, FunctionName:msg.funcname, Arguments:msg.message, Time:msg.time});
					tblLog.verticalScrollPosition = tblLog.maxVerticalScrollPosition+30;
				}
			}
			if (tblLog.selectedIndex == -1) {
				txtLog.text = "";
			}
			setTimeout(resizeColumn,100,null);
		}
		
		private function changeCommand(evt:Event):void {
			var prm:Param;
			var i:int;
			for (i = 0; i < aParams.length; i++) {
				prm = aParams[i];
				prm.y = i * 32+35;
				prm.Value = "";
				prm.Tooltip = "";
				prm.visible = false;
			}
			btnSend.visible = false;
			txtTooltip.text = "";

			var command_name:String = cmbCommand.selectedItem.data;
			var parameters:Array = Commands.findCommand(command_name);
			for (i=0; i<parameters.length; i++) {
				var param_name:String = parameters[i][0];
				var param_type:String = parameters[i][1];
				prm = aParams[i];
				prm.Label = param_name+":"+param_type;
				prm.visible = true;
			}
			btnSend.y = 32 * parameters.length + 35;
			btnSend.visible = true;

			/*
			If I'll ever want a tooltip:
			var j:int;
			for (i = 0; i < xmlFunctions["func"].length(); i++) {
				if (xmlFunctions.func[i].name == cmbCommand.selectedItem.data) {
					txtTooltip.text = xmlFunctions.func[i].description;
					if(txtTooltip.text!=""){
						for (j = 0; j < aParams.length; j++) {
							prm = aParams[j];
							prm.y += txtTooltip.height+10;
						}
						btnSend.y += txtTooltip.height+10;
					}
					for (j = 0; j < xmlFunctions.func[i].param.length(); j++) {
						prm = aParams[j];
						prm.Label = xmlFunctions.func[i].param[j].name + ":" + xmlFunctions.func[i].param[j].type;
						prm.Value = xmlFunctions.func[i].param[j].defaultvalue;
						prm.Tooltip = xmlFunctions.func[i].param[j].description;
					}
					break;
				}
			}*/
		}
		
		private function btnLogClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("Log");
			pnlCommands.visible = false;
			pnlLog.visible = true;
			pnlInfo.visible=false;
			iInfoMode=0;
		}
		
		private function btnCommandsClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("Command");
			pnlCommands.visible = true;
			pnlLog.visible = false;
			pnlInfo.visible=false;
			iInfoMode=0;
		}
		
		private function btnMatchStateClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("MatchState");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=1){
				iInfoMode=1;
				
				tblInfo.columns=["user_id","key","data"];
				
				showMatchState();
			}
		}
		
		
		private function btnGeneralInfoClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("GeneralInfo");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=3){
				iInfoMode=3;
				
				tblInfo.columns=["key","data"];
				
				showGeneralInfo();
			}
		}
		
		private function btnUserInfoClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("UserInfo");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=4){
				iInfoMode=4;
				
				tblInfo.columns=["user_id","key","data"];
				
				showUserInfo();
			}
		}
		
		private function btnMatchOverClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("MatchOver");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=5){
				iInfoMode=5;
				
				tblInfo.columns=["users_id", "score" , "pot_percentage" , "called_by_user_ids"];
				
				showMatchOver();
			}
		}
		
		private function btnSavedGamesClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("SavedGames");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=6){
				iInfoMode=6;
				
				tblInfo.columns=["name", "number_of_players", "user_ids_that_are_still_playing", "next_turn_of_user_ids", "match_state", "match_started_time", "extra_match_info"];
				
				showSavedGames();
			}
		}
		
		private function showMatchState():void{
			if(iInfoMode==1){
				tblInfo.removeAll();
				
				for(var i:int=0;i<aKeys.length;i++){
					tblInfo.addItem({user_id:aDataUsers[i],key:aKeys[i],data:JSON.stringify(aData[i])});
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		
		
		private function showGeneralInfo():void{
			if(iInfoMode==3){
				tblInfo.removeAll();
				
				for(var i:int=0;i<aServerKeys.length;i++){
					tblInfo.addItem({key:aServerKeys[i],data:aServerDatas[i]});
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		
		private function showUserInfo():void{
			if(iInfoMode==4){
				tblInfo.removeAll();
				
				var usr:User;
				for each (usr in aUsers){
					for(var j:int=0;j<usr.Keys.length;j++){
						tblInfo.addItem({user_id:usr.ID,key:usr.Keys[j],data:usr.Params[j]});
						tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
					}
				}
				txtInfo.text="";				
			}
		}
		
		private function showMatchOver():void{
			if(iInfoMode==5){
				tblInfo.removeAll();
				
				for each (var match:MatchOver in aMatchOvers){
					tblInfo.addItem({users_id:match.user_ids, score:match.scores , pot_percentage:match.pot_percentages , called_by_user_ids:match.recieved_from});
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		
		private function showSavedGames():void{
			if(iInfoMode==6){
				tblInfo.removeAll();
				
				var arr1:Array;
				var savedGame:SavedGame;
				for each (savedGame in allSavedGames) {
					try{
						if (savedGame.playersNum == User.PlayersNum && savedGame.GameName==root.loaderInfo.parameters["game"]) {
							arr1=new Array();
							for(var j:int=0;j<savedGame.Keys.length;j++){
								arr1.push("{user_id: "+savedGame.Users[j]+", key: "+savedGame.Keys[j]+", data: "+JSON.stringify(savedGame.Datas[j])+"}");
							}
							tblInfo.addItem({name:savedGame.Name, number_of_players:savedGame.playersNum, 
									user_ids_that_are_still_playing:savedGame.Players , 
									next_turn_of_user_ids:savedGame.curTurn, match_state:arr1, match_started_time:savedGame.match_started_time, extra_match_info:JSON.stringify(savedGame.extra_match_info)});
							tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
						}
					}catch (err:Error) {
						MsgBox.Show(err.getStackTrace(), "Error");
					}
				}
				txtInfo.text="";
			}
		}
		
		private function fullLogClick(evt:MouseEvent):void {
			var str:String = "";
			for each (var msg:Message in aMessages) {
				str += msg.num + "\t" + msg.sender + "\t" + msg.funcname + "\t" + msg.message + "\t" + msg.time + "\n";
			}
			if(ExternalInterface.available){
				ExternalInterface.call("toClipboard", str);
			}else {
				MsgBox.Show("ExternalInterface doesn't available. Please, check your security settings.", "Security Error");
			}
		}
		
		private function filterKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 13) {
				searchClick(null);
			}
		}
		
		private function extraMatchInfoOver(evt:MouseEvent):void {
			txtTooltipExtraMatchInfo.visible = true;
		}
		
		private function extraMatchInfoOut(evt:MouseEvent):void {
			txtTooltipExtraMatchInfo.visible = false;
		}
		
		private function matchStartedTimeOver(evt:MouseEvent):void {
			txtTooltipMatchStartedTime.visible = true;
		}
		
		private function matchStartedTimeOut(evt:MouseEvent):void {
			txtTooltipMatchStartedTime.visible = false;
		}
		
		private function btnCancelGameClick(evt:MouseEvent):void {
			aNextPlayers=new Array();
			bGameEnded = true;
			txtMatchStartedTime.text = "";
			txtExtraMatchInfo.visible = true;
			txtMatchStartedTime.visible = true;
			btnNewGame.visible = true;
			btnCancelGame.visible = false;
			btnLoadGame.visible = true;
			btnSaveGame.visible = false;
			var usr:User;
			var arr:Array = new Array();
			for each (usr in aUsers) {
				if (aPlayers.indexOf(usr.ID) != -1 && !usr.Ended) {
					arr.push(usr.ID);
					usr.Ended = true;
				}
			}
			for each (usr in aUsers) {
				sendOperation(usr.GotChanel, "got_match_over", [arr]);
			}
		}
		
		private function btnQuestionClick(evt:MouseEvent):void {
			MsgBox.Show("When starting a new game, you should enter two values that will be passed in the callback got_match_started: extra_match_info of type Object and match_started_time of type int");
		}
		
		private function btnLoadGameClick(evt:MouseEvent):void {
			cmbLoadName.removeAll();
			for each (var savedGame:SavedGame in allSavedGames) {
				if (savedGame.playersNum == User.PlayersNum && savedGame.GameName==root.loaderInfo.parameters["game"]) {
					cmbLoadName.addItem( { label:savedGame.Name,data:savedGame } );
				}
			}
			pnlLoad.visible = true;
			this.stage.focus = cmbLoadName;
		}
		
		private function loadOkClick(evt:MouseEvent):void {
			if (cmbLoadName.selectedIndex == -1) {
				return;
			}
			var savedGame:SavedGame = cmbLoadName.selectedItem.data;
			aKeys = savedGame.Keys.slice();
			aDataUsers = savedGame.Users.slice();
			aData = savedGame.Datas.slice();
			extra_match_info=savedGame.extra_match_info;
			match_started_time = savedGame.match_started_time;
			if(extra_match_info!=null){
				txtExtraMatchInfo.text = JSON.stringify(extra_match_info);
			}else {
				txtExtraMatchInfo.text = "";
			}
			txtMatchStartedTime.text = match_started_time.toString();
			showMatchState();
			aNextPlayers = new Array();
			iCurTurn = savedGame.curTurn;
			aMatchOvers = new Array();


			// Yoav: I added a MatchOver for all the players that already finished playing
			if (savedGame.Players.length < savedGame.playersNum) {
				// some players have already finished playing
				var ongoing_player_ids:Array = savedGame.Players;
				var finished_player_ids:Array = [];
				var over:MatchOver = new MatchOver();
				over.user_ids = [];
				over.scores = [];
				over.pot_percentages = [];
				over.recieved_from = [];
				for (var user_id:int=1; user_id<=savedGame.playersNum; user_id++) {
					over.recieved_from.push(user_id);
					if (ongoing_player_ids.indexOf(user_id)==-1) {
						//getUser(user_id).Ended = true; // see send_got_match_started
						over.user_ids.push(user_id);
						over.scores.push(-1);
						over.pot_percentages.push(-1);
					}
				}
				aMatchOvers.push(over);
			}



			showMatchOver();
			if (aPlayers.length == User.PlayersNum) {
				bGameStarted = true;
				bGameEnded = false;
				txtExtraMatchInfo.visible = false;
				txtMatchStartedTime.visible = false;
				txtTooltipExtraMatchInfo.visible = false;
				txtTooltipMatchStartedTime.visible = false;
				btnNewGame.visible = false;
				btnCancelGame.visible = true;
				btnSaveGame.visible = true;
				btnLoadGame.visible = false;
				for each (var usr:User in aUsers) {
					send_got_match_started(usr);						
				}
			}
			pnlLoad.visible = false;
			MsgBox.Show("Saved game was loaded","Message");
		}
		
		private function enableSavedGames():void {
			var j:int = 0;
			for each (var savedGame:SavedGame in allSavedGames) {
				if (savedGame.playersNum == User.PlayersNum && savedGame.GameName == root.loaderInfo.parameters["game"]) {
					j++;
				}
			}
			btnLoadGame.enabled = j>0;
		}
		private function loadDeleteClick(evt:MouseEvent):void {
			if (cmbLoadName.selectedIndex == -1) {
				return;
			}
			var savedGame:SavedGame = cmbLoadName.selectedItem.data;
			allSavedGames.splice( allSavedGames.indexOf(savedGame), 1);
			saveToSharedObject();

			pnlLoad.visible = false;
			showSavedGames();
			MsgBox.Show("Saved game was deleted","Message");
			enableSavedGames();
		}
		
		private function loadFocusOut(evt:FocusEvent):void {
			if(evt.relatedObject!=btnLoadOK && evt.relatedObject!=cmbLoadName && evt.relatedObject!=btnLoadDelete){
				pnlLoad.visible = false;
			}
		}
		
		private function btnSaveGameClick(evt:MouseEvent):void {
			pnlSave.visible = true;
			this.stage.focus=txtSaveName;
		}
		
		private var allSavedGames:Array/*SavedGame*/ = [];
		private function saveToSharedObject():void {
			shrSavedGames.data.savedGames = allSavedGames;
			shrSavedGames.flush();
		}

		private function saveOkClick(evt:MouseEvent):void {
			if (txtSaveName.text == "") {
				return;
			}
			var game:SavedGame = new SavedGame();
			game.Keys = aKeys.slice();
			game.Datas = aData.slice();
			game.Users = aDataUsers.slice();
			game.playersNum = User.PlayersNum;
			game.Players = getOngoingPlayerIds();
			game.extra_match_info=extra_match_info;
			game.match_started_time=match_started_time;
			game.Name = txtSaveName.text;
			game.curTurn = iCurTurn;
			game.GameName = root.loaderInfo.parameters["game"];
			allSavedGames.push(game);
			saveToSharedObject();

			txtSaveName.text = "";
			pnlSave.visible = false;
			showSavedGames();
			MsgBox.Show("The game was saved", "Message");
			enableSavedGames();
		}
		
		private function saveKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 13) {
				saveOkClick(null);
			}
		}
		
		private function saveFocusOut(evt:FocusEvent):void {
			if(evt.relatedObject!=btnSaveOK && evt.relatedObject!=txtSaveName){
				pnlSave.visible = false;
			}
		}
		
		private function btnNewGameClick(evt:MouseEvent):void {
			if (aPlayers.length != User.PlayersNum) {
				return;
			}
			if (!getStartParams()) {
				return;
			}
			bGameStarted = true;
			bGameEnded = false;
			txtExtraMatchInfo.visible = false;
			txtMatchStartedTime.visible = false;
			txtTooltipExtraMatchInfo.visible = false;
			txtTooltipMatchStartedTime.visible = false;
			btnNewGame.visible = false;
			btnCancelGame.visible = true;
			btnSaveGame.visible = true;
			btnLoadGame.visible = false;
			iCurTurn=-1;
			aData = new Array();
			aKeys = new Array();
			aDataUsers = new Array();
			showMatchState();
			aNextPlayers = new Array();
			aMatchOvers = new Array();
			showMatchOver();
			var usr:User;
			for each (usr in aUsers) {
				send_got_match_started(usr);
			}
		}
		
		private function compareArrays(arr1:Array, arr2:Array):Boolean {
			if (arr1 == null) {
				if (arr2 == null) {
					return true;
				}
				return false;
			}
			if (arr2 == null) {
				return false;
			}
			if (arr1.length != arr2.length) {
				return false;
			}
			for (var i:int = 0; i < arr1.length; i++) {
				if (arr1[i] != arr2[i]) {
					return false;
				}
			}
			return true;
		}
		

		private function btnSendClick(evt:MouseEvent):void {
			try{
				if (cmbTarget.selectedItem == null) {
					throw new Error("Please, select target");
				}
				if (cmbCommand.selectedItem == null) {
					throw new Error("Please, select command");
				}
				var target:int = cmbTarget.selectedItem.data;
				var command_name:String = cmbCommand.selectedItem.data;
				var usr:User;
				var i:int;
				var args:Array = Commands.findCommand(command_name);
				var parameters:Array = [];
				for (i=0; i< args.length; i++) {
					var param:String = aParams[i].Value;
					var param_type:String = args[i][1];
					parameters.push( Commands.convertToType(param, param_type) );
				}

				for each (usr in aUsers) {
					if(usr.ID==target || target==-1){						
						sendOperation(usr.GotChanel, command_name, parameters);
					}
				}
				MsgBox.Show("Command was send", "Message");
			}catch (err:Error) {
				MsgBox.Show(err.getStackTrace(), "Error");
				addMessageLog("Server", "btnSendClick", "Error: " + err.getStackTrace());
			}
		}
		
		//Do functions
		public function do_start_my_turn(user:User):void {
			isTurnBasedGame = true;
			//if (aNextPlayers.length > 0 && aNextPlayers.indexOf(user.ID) == -1) {
			//	addMessageLog("Server", "do_start_my_turn", "Error: Can't start turn, user " + user.Name + " not exist in array next_turn_of_player_ids");
			//	return;
			//}
			if (user.Ended) {
				addMessageLog("Server", "do_start_my_turn", "Error: Can't start turn,  user " + user.Name + " already sends do_agree_on_match_over");
				return;
			}
			//if (iCurTurn != -1) {
			//	addMessageLog("Server", "do_start_my_turn", "Error: Can't start turn, previous player didn't end his turn");
			//	return;
			//}
			iCurTurn = user.ID;
			var usr:User;
			for each (usr in aUsers) {
				sendOperation(usr.GotChanel, "got_start_turn_of", [user.ID]);
			}
		}
		public function do_end_my_turn(user:User, next_turn_of_player_ids:Array):void {
			isTurnBasedGame = true;
			if (iCurTurn != user.ID) {
			//	addMessageLog("Server", "do_end_my_turn", "Warning: Can't end turn, user " + user.Name + " didn't start turn");
				return;
			}
			if (next_turn_of_player_ids != null) {
				for each (var next_id:int in next_turn_of_player_ids) {
					if (aPlayers.indexOf(next_id) == -1) {
						addMessageLog("Server", "do_end_my_turn", "Error: Player ID "+next_id+" doesn't exist.");
						return;
					}
				}
			}else {
				next_turn_of_player_ids = new Array();
			}
			iCurTurn = -1;
			aNextPlayers = next_turn_of_player_ids;
			var usr:User;
			for each (usr in aUsers) {
				sendOperation(usr.GotChanel, "got_end_turn_of", [user.ID]);
			}
		}
		public function do_store_match_state(user:User, keys:Array/*String*/, datas:Array/*Object*/):void {
			for (var i:int=0; i<keys.length; i++)
				do_store_one_match_state(user, keys[i], datas[i]);
			
			showMatchState();
			for each (var usr:User in aUsers) {
				sendOperation(usr.GotChanel, "got_stored_match_state", [user.ID,keys,datas]);
			}
		}
		private function do_store_one_match_state(user:User, key:String, data:Object):void {			
			if (key == "") {
				addMessageLog("Server", "do_store_match_state", "Error: Can't store match state, key is empty");
				return;
			}
			if (aKeys.length>=1000) {
				addMessageLog("Server", "do_store_match_state", "Error: you stored more than a 1000 keys!");
				return;
			}
			//todo: in the future, the developer should choose if he wants to be able to review the match (and if so, the number of calls to do_store_match_state can't exceed 1000)
			if (iCurTurn!=user.ID && isTurnBasedGame) {
				addMessageLog("Server", "do_store_match_state", "Warning: in a turn-based game, you should call do_store_match_state only during your turn");
			}

			var index:int = aKeys.indexOf(key);
			if (index!=-1) {
				if (aPlayers.indexOf(user.ID)==-1 && aDataUsers[index]==user.ID) {
					addMessageLog("Server", "do_store_match_state", "Error: a viewer cannot rewrite/delete other's data (not viewers nor players data)");
					return;
				}
				aKeys.splice(index,1);
				aData.splice(index,1);
				aDataUsers.splice(index,1);
			}
			if (data!=null && data!="") {
				aKeys.push(key);
				aData.push(data);
				aDataUsers.push(user.ID);
			}
		}
		public function do_agree_on_match_over(user:User, user_ids:Array, scores:Array, pot_percentages:Array):void {			
			if (user_ids.length==0) {
				addMessageLog("Server", "do_agree_on_match_over", "Error: Array user_ids can't be empty.");
				return;
			}
			for each (var u_id:int in user_ids) {
				if (aPlayers.indexOf(u_id) == -1) {
					addMessageLog("Server", "do_agree_on_match_over", "Error: Player with ID "+u_id+" doesn't exist.");
				return;
				}
			}
			if (scores.length != user_ids.length) {
				addMessageLog("Server", "do_agree_on_match_over", "Error: Length of user_ids doesn't equal to length of scores.");
				return;
			}
			if (pot_percentages!=null && pot_percentages.length != user_ids.length) {
				addMessageLog("Server", "do_agree_on_match_over", "Error: Length of user_ids doesn't equal to length of pot_percentages.");
				return;
			}
			if (pot_percentages != null) {
				for each (var percent:int in pot_percentages) {
					if (percent < -1 || percent > 100) {
						addMessageLog("Server", "do_agree_on_match_over", "Error: "+percent+" is out of range.");
						return;
					}
				}
			}
			var findMatchOver:MatchOver = null;
			var over:MatchOver;
			var usr:User;
			for each (over in aMatchOvers) {
				if (compareArrays(over.user_ids, user_ids)) {
					if(compareArrays(over.scores, scores) && compareArrays(over.pot_percentages, pot_percentages)) {
						findMatchOver = over; 
						break;
					}else {
						addMessageLog(user.Name, "do_agree_on_match_over", "Error: function parameters are different from previous call.");
						MsgBox.Show("do_agree_on_match_over: Function parameters are different from previous call.");
						aNextPlayers=new Array();
						bGameEnded = true;
						txtMatchStartedTime.text = "";
						txtExtraMatchInfo.visible = true;
						txtMatchStartedTime.visible = true;
						btnNewGame.visible = true;
						btnCancelGame.visible = false;
						btnLoadGame.visible = true;
						btnSaveGame.visible = false;
						var arr:Array = new Array();
						for each (usr in aUsers) {
							if (aPlayers.indexOf(usr.ID) != -1 && !usr.Ended) {
								arr.push(usr.ID);
								usr.Ended = true;
							}
						}
						for each (usr in aUsers) {
							sendOperation(usr.GotChanel, "got_match_over", [arr]);
						}
						showMatchOver();
						return;
					}
				}
			}
			over = findMatchOver;
			if (over==null) {
				over = new MatchOver();
				over.user_ids = user_ids;
				over.scores = scores;
				over.pot_percentages = pot_percentages;
				over.recieved_from = new Array();
				aMatchOvers.push(over);
				
				if (iCurTurn==-1 && isTurnBasedGame) {
					addMessageLog("Server", "do_agree_on_match_over", "Warning: in a turn-based game, the first call to do_agree_on_match_over should be during someone's turn");
				}
			}
			if (over.recieved_from.indexOf(user.ID) == -1) {
				over.recieved_from.push(user.ID);
				var all_agreed:Boolean = true;
				for each (usr in aUsers) {
					if (!usr.Ended && aPlayers.indexOf(usr.ID)!=-1 && over.recieved_from.indexOf(usr.ID) == -1) {
						all_agreed = false;
						break;
					}
				}
				if (all_agreed) {
					if (over.user_ids.indexOf(iCurTurn) != -1) {
						for each (usr in aUsers) {
							if (usr.ID == iCurTurn) {
								do_end_my_turn(usr, null);
								break;
							}
						}
					}
					var cur_players:int = 0;
					for each (usr in aUsers) {
						if (over.user_ids.indexOf(usr.ID) != -1) {
							usr.Ended = true;
						}
						if (aPlayers.indexOf(usr.ID)!=-1 && !usr.Ended) {
							cur_players++;
						}
						sendOperation(usr.GotChanel, "got_match_over",[over.user_ids]);
					}
					if (cur_players == 0) {     
						aNextPlayers=new Array();
						txtMatchStartedTime.text = "";
						bGameEnded = true;
						txtExtraMatchInfo.visible = true;
						txtMatchStartedTime.visible = true;
						btnNewGame.visible = true;
						btnCancelGame.visible = false;
						btnLoadGame.visible = true;
						btnSaveGame.visible = false;
					}
				}
			}
			showMatchOver();
		}
		public function do_store_trace(user:User, funcname:String,message:Object):void {
			//addMessageLog(user.Name, funcname, JSON.stringify(message));
		}
		public function do_client_protocol_error_with_description(user:User, error_description:Object):void {
			MsgBox.Show(JSON.stringify(error_description));
			aNextPlayers=new Array();
			bGameEnded = true;
			txtMatchStartedTime.text = "";
			txtExtraMatchInfo.visible = true;
			txtMatchStartedTime.visible = true;
			btnNewGame.visible = true;
			btnCancelGame.visible = false;
			btnLoadGame.visible = true;
			btnSaveGame.visible = false;
			var usr:User;
			var arr:Array = new Array();
			for each (usr in aUsers) {
				if (aPlayers.indexOf(usr.ID) != -1 && !usr.Ended) {
					arr.push(usr.ID);
					usr.Ended = true;
				}
			}
			for each (usr in aUsers) {
				sendOperation(usr.GotChanel, "got_match_over", [arr]);
			}
		}
		private function getAllUserIds():Array {
			var res:Array = [];
			for each (var usr:User in aUsers) 
				res.push(usr.ID);
			return res;
		}
		private function getUser(user_id:int):User {
			for each (var usr:User in aUsers) {
				if (usr.ID == user_id) return usr;
			}
			return null;
		}			
		public function do_finished_callback(user:User, methodName:String):void {
			// todo: make sure every call is eventaully ended, and that do_all are always as a result of getting match state
		}
		public function do_send_message(user:User, to_user_ids:Array, data:Object):void {
			
			for each (var u_id:int in to_user_ids) {
				if (getUser(u_id)==null) {
					addMessageLog("Server", "do_send_message", "Error: User ID "+u_id+"doesn't exist.");
					return;
				}
			}
			var usr:User;
			var arr:Array;
			if (to_user_ids == null || to_user_ids.length == 0) {
				arr = getAllUserIds();
			}else {
				arr = to_user_ids;
			}
			for each (usr in aUsers) {
				if(arr.indexOf(usr.ID)!=-1){
					sendOperation(usr.GotChanel, "got_message", [user.ID,data]);
				}
			}
		}
	}
}

import flash.display.*; 
import flash.net.LocalConnection;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.events.*;
import emulator.*;

class User {
	//Private variables
	private var lcData:LocalConnection;
	private var sServer:Server;
	private var iID:int;
	private var sName:String;
	private var sDoChanel:String;
	private var sGotChanel:String;
	public var Params:Array;
	public var Keys:Array;
	public var Ended:Boolean = false;
	public static var PlayersNum:int = 0;
	public static var ViewersNum:int = 0;
	
	private static var iNextId:int = 1;
	
	//Get/Set functions
	public function get ID():int {
		return iID;
	}
	public function get Name():String {
		return sName;
	}
	public function get GotChanel():String {
		return sGotChanel;
	}
	
	//Constructor
	public function User(chanel:int, prefix:String, _server:Server) {
		try{
			
			if (iNextId > PlayersNum + ViewersNum) {
				throw new Error("Too many users");
			}
			iID = iNextId++;
			sServer = _server;
			sName = sServer.root.loaderInfo.parameters["val" + (iID - 1) + "0"];
			sName = sName.replace( /^\s+|\s+$/g, "");
			if (sName==null || sName == "") {
				if(iID<=PlayersNum){
					sName = "Player" + (iID - 1);
				}else {
					sName = "Viewer" + (iID - PlayersNum - 1);
				}
			}
			
			Keys = new Array();
			Params = new Array();
			for (var i:int = 0; sServer.root.loaderInfo.parameters["col" + i] != null;i++ ) {
				Keys.push(sServer.root.loaderInfo.parameters["col" + i]);
				Params.push(sServer.root.loaderInfo.parameters["val" + (iID - 1) + i]);
			}
			
			Params[0] = sName;
			sDoChanel = "DO_CHANEL" + prefix+"_"+chanel;
			sGotChanel = "GOT_CHANEL" + prefix+"_"+chanel;
			
			lcData = new LocalConnection();
			lcData.client = this;
			
			lcData.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcData.connect(sDoChanel);
			
		}catch (err:Error) {
			sServer.addMessageLog("Server", "User", "Error: " + err.getStackTrace());
		}
	}
	
	public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
		sServer.got_user_localconnection_callback(this, methodName, parameters);
	}
	
	private function onConnectionStatus(evt:StatusEvent):void {
		switch(evt.level) {
			case "error":
				trace("There is a LocalConnection error. Please test your game only inside the Come2Play emulator.");
		}
	}
}


class Message {
	public var sender:String;
	public var funcname:String;
	public var message:String;
	public var time:String;
	public var num:int;
	public function Message() {
		
	}
}

class SavedGame {
	public var Keys:Array;
	public var Datas:Array;
	public var Users:Array;
	public var Players:Array;
	public var extra_match_info:Object;
	public var match_started_time:int;
	public var playersNum:int;
	public var curTurn:int;
	public var Name:String;
	public var GameName:String;
}

class MatchOver {
	public var user_ids:Array;
	public var scores:Array;
	public var pot_percentages:Array;
	public var recieved_from:Array;
}