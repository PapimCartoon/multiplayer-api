package emulator {
	//import emulator.auto_generated.*;
	
	import emulator.auto_generated.ServerEntry;
	import emulator.auto_generated.UserEntry;
	
	import fl.controls.*;
	import fl.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;

	public class Server extends MovieClip {
		// to do: never use "]."
		
		private static const COL_player_ids:String = "player_ids";
		private static const COL_scores:String = "scores";
		private static const COL_pot_percentages:String = "pot_percentages";
		private static const COL_total_pot_percentages:String = "total_pot_percentages";
		private static const COL_Parameters:String="Parameters";
		private static const COL_MethodName:String="Method_Name";
		private static const COL_UnverifiedPlayers:String="Unverified_Players";
		private static const COL_User:String="User Id";
		private static const COL_Message:String="Message";
		private static const COL_key:String="key";
		private static const COL_data:String="data";
		private static const COL_name:String="Name";
		private static const COL_numberOfPlayers:String="Number_Of_Players";
		private static const COL_userIdThatAreStillPlaying:String="User_ids_that_are_still_playing";
		private static const COL_nextTurnOfUserIds:String="Next_turn_of_user_ids";
		private static const COL_matchState:String="Match_state";
		private static const COL_matchStartedTime:String="Match_started_time";
		private static const COL_extraMatchInfo:String= "Extra_match_info";
		
		//Private variables
		private var isTurnBasedGame:Boolean = false;
		private var bGameStarted:Boolean = false;
		private var bGameEnded:Boolean = false;
		
		private var lcFramework:LocalConnection;
		
		private var aUsers:Array;
		
		private var userStateEntrys:Array;/*UserStateEntry*/ //state information
		
		private var serverEntery:Array;/*Entery*/ //extra server information
		private var aParams:Array;
		private var aPlayers:Array; //array of all the players
		private var afinishedPlayers:Array;/*PlayerMatchOver*/

		// queue related variables
		private var unverifiedQueue:Array;
		private var waitingQueue:Array;
		private var queueTimer:Timer;
		
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
		
		private var btnStoreQue:SimpleButton;
		private var btnDoAllQue:SimpleButton;
		
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
		private var tblInfo:DataGrid;
		private var txtInfo:TextArea;
		private var pnlInfo:MovieClip;
		private var txtInfoDetails:TextField;
		private var iInfoMode:int;
		
		public function showMsg(msg:String, title:String = ""):void {
			MsgBox.Show(msg, title);
		}
		//Constructor
		public function Server() {
			this.stop();
			afinishedPlayers=new Array();
			userStateEntrys=new Array();
			unverifiedQueue=new Array();
			waitingQueue=new Array();
			queueTimer=new Timer(10000,0);
			queueTimer.addEventListener(TimerEvent.TIMER,queTimeoutError);
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
			
			btnStoreQue= tbsPanel["_btnStore"];
			btnStoreQue.addEventListener(MouseEvent.CLICK, btnStore);
			
			btnDoAllQue= tbsPanel["_btnDoAll"];
			btnDoAllQue.addEventListener(MouseEvent.CLICK, btnDoAll);
			
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
			txtTooltipExtraMatchInfo.text = "custom match info:Object";
			txtTooltipExtraMatchInfo.x = txtExtraMatchInfo.x;
			txtTooltipExtraMatchInfo.y = 22;
			txtTooltipExtraMatchInfo.visible = false;
			this.addChild(txtTooltipExtraMatchInfo);
			
			txtTooltipMatchStartedTime = new TextField;
			txtTooltipMatchStartedTime.autoSize = TextFieldAutoSize.LEFT;
			txtTooltipMatchStartedTime.background = true;
			txtTooltipMatchStartedTime.text = "match started time:long";
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

			aPlayers = new Array();
			//aMatchOvers = new Array();
			iCurTurn = -1;
			
			this.addChild(MsgBox);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, MsgBox.keyDown);
			
			if (root.loaderInfo.parameters["prefix"] == null) {
				showMsg("Parameter 'prefix' must be passed in the url.","Error");
				return;
			}
			
			try{
				User.PlayersNum = parseInt(root.loaderInfo.parameters["players_num"]);
				if (isNaN(User.PlayersNum)) {
					showMsg("Parameter 'players_num' must be passed in the url.","Error");
					return;
				}
			}catch (err:Error) {
				showMsg("Parameter 'players_num' must be passed in the url.","Error");
				return;
			}
			try{
				User.ViewersNum = parseInt(root.loaderInfo.parameters["viewers_num"]);
				if (isNaN(User.ViewersNum)) {
					showMsg("Parameter 'viewers_num' must be passed in the url.","Error");
					return;
				}
			}catch (err:Error) {
				showMsg("Parameter 'viewers_num' must be passed in the url.","Error");
				return;
			}
			
			
			var sPrefix:int = int(root.loaderInfo.parameters["prefix"]);
						
			var total_users:int = User.PlayersNum + User.ViewersNum;
			for (var user_index:int=0; user_index<total_users; user_index++) {
				var u:User = new User(sPrefix+user_index, this);			
				aUsers.push(u);
			}
			
			serverEntery=new Array();
			if (root.loaderInfo.parameters["logo"]!=null && root.loaderInfo.parameters["logo"] != "") {
				serverEntery.push(new Entry("logo_swf_full_url",root.loaderInfo.parameters["logo"]));
			}
			
			if (root.loaderInfo.parameters["game"] == null) {
				showMsg("Parameter 'game' must be passed in the url.","Error");
				return;
			}
			
			shrSavedGames = SharedObject.getLocal("SavedGames");
			if (shrSavedGames.data.savedGames!=null) {
				var gamesArr:Array = shrSavedGames.data.savedGames;
				for each (var gameObject:Object in gamesArr) {
					if (gameObject["classVersionNumberForSharedObject"]!=SavedGame.CLASS_VERSION_NUMBER) continue;
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
		/*
		*************************************************
					END OF CONSTRUCTOR
		*************************************************
		*/
		private function queTimeoutError(ev:TimerEvent):void
		{
			var unverefiedFunction:UnverifiedFunction = unverifiedQueue[0];
			showMsg(unverefiedFunction.msg.methodName+" Timed out by player/s:"+String(unverefiedFunction.unverifiedUsers),"Error");
			gameOver();
		}
		private var isProcessingCallback:Boolean = false;
		public function got_user_localconnection_callback(user:User, msg:API_Message):void {			
			try{
				if (isProcessingCallback) throw new Error("Concurrency problems in the server in the Emulator");
				isProcessingCallback = true;
				trace("got_user_localconnection_callback: user="+user.Name+" methodName="+msg.methodName);			
				
				if(msg is API_DoTrace)
				{
					var traceMsg:API_DoTrace=msg as API_DoTrace;
					addMessageLog(String(user.ID),"doTrace",traceMsg.getParametersAsString());
				}
				else if(msg is API_DoRegisterOnServer)
				{
					doRegisterOnServer(user);
				}
				else if(msg is API_DoFinishedCallback)
				{
					var finishedCallbackMsg:API_DoFinishedCallback = msg as API_DoFinishedCallback;
					verefyAction(user);
					user.do_finished_callback(finishedCallbackMsg.parameters[0])
				}
				else if(msg is API_DoAllFoundHacker)
				{
					var foundHackerMsg:API_DoAllFoundHacker=msg as API_DoAllFoundHacker;
					doFoundHacker(user,foundHackerMsg);
				}
				else
				{
					if (!bGameStarted) {
						addMessageLog("Server", msg.methodName, "Error: game not started");
						return;
					}
					if (bGameEnded) {
						addMessageLog("Server", msg.methodName, "Error: game already end");
						return;
					}
					if(!isPlayer(user.ID))
						return
					addMessageLog(user.Name, msg.methodName, msg.toString());
					var waitingFunction:WaitingFunction=new WaitingFunction(user,msg);
					waitingQueue.push(waitingFunction);
					if( (unverifiedQueue.length == 0) && (waitingQueue.length == 1) )
					{
						doNextInQueue();
					}
				}
			} catch (err:Error) { 
				showMsg(err.getStackTrace(), "Error");
			} finally {
				isProcessingCallback = false;
			} 
		}
		private function isPlayer(userId:int):Boolean
		{
			for(var i:int=0;i<aPlayers.length;i++)
			{
				if(aPlayers[i]==userId)
					return true;
			}
			return false;
		}
		private function doNextInQueue():void
		{
			var waitingFunction:WaitingFunction=waitingQueue.shift();
			if(waitingFunction.msg is API_DoStoreState)
			{
				doStoreState(waitingFunction.user,waitingFunction.msg as API_DoStoreState);
				unverifiedQueue.push(new UnverifiedFunction(waitingFunction,aPlayers.concat()));
			}
			else if(waitingFunction.msg is API_DoAllSetTurn)
			{
				var msg:API_DoAllSetTurn=checkDoAlls() as API_DoAllSetTurn;
				if(msg==null)
					return;
				unverifiedQueue.push(new UnverifiedFunction(waitingFunction,aPlayers.concat()));
				doAllSetTurn(msg);
			}
			
			
			/*
			
			
			*/
			queueTimer.reset();
			queueTimer.start();
			
		}
		private function verefyAction(user:User):void
		{
			for each(var unverifiedFunction:UnverifiedFunction in unverifiedQueue)
			{
				if(unverifiedFunction.removeUnverifiedUser(user.ID))
				{
					if(unverifiedFunction.length()==0)
						actionVerefied();
					return;
				}
			}
			addMessageLog(user.Name,"Error",user.ID+" can't verify nonexistent function");
			showMsg(user.ID+" can't verify nonexistent function", "Error");
		}
		private function actionVerefied():void
		{
			var waitingFunction:UnverifiedFunction=unverifiedQueue.shift();
			if(waitingFunction is API_DoStoreState)
			{
				var msg:API_DoStoreState = waitingFunction.msg as API_DoStoreState;
				var serverEntry:ServerEntry;
				for each (var userEntry:UserEntry in msg.stateEntries)
				{
					if(userEntry.isSecret)
					{
						//todo: fix changeTime
						serverEntry=new ServerEntry(userEntry.key,userEntry.value,waitingFunction.user.ID,[waitingFunction.user.ID],0);
					}
					else
					{
						serverEntry=new ServerEntry(userEntry.key,userEntry.value,waitingFunction.user.ID,null,0);
					}
					doStoreOneState(serverEntry);
				}	
			}
			queueTimer.reset();
			if(unverifiedQueue.length==0)
				doNextInQueue();	
		}
		
		private function spliceNum(arr:Array,value:Number):void
		{
			var tempLen:Number=arr.length;
			for(var i:Number=0;i<tempLen;i++)
			{
				if(arr[i]==value)
				{
				arr.splice(i,1);
				return;
				}
			}
		}
		private function isEquel(obj1:Object,obj2:Object)
		{ 
			for(var prop:String in obj1)
				if(typeof(obj1[prop])=="object")
				{
					if(!isEquel(obj1[prop],obj2[prop]))
						return false;
				}
				else
				{
					if(obj1[prop]!=obj2[prop])
						return false;
				}
			return true;
		}
		private function checkDoAlls():API_Message
		{
			var waitingFunction:WaitingFunction=waitingQueue[0]
			var originalMsg:API_Message = waitingFunction.msg;
			var playersNotCalled:Array=aPlayers.concat();
			for each(waitingFunction in waitingQueue)
			{
				if(originalMsg.methodName == waitingFunction.msg.methodName)
					spliceNum(playersNotCalled,waitingFunction.user.ID);
			}
			if(playersNotCalled.length == 0)
				return null;
			for(var i:int=0;i<waitingQueue.length;i++)
			{
				waitingFunction=waitingQueue[i];
				if(waitingFunction.msg.methodName == originalMsg.methodName)
				{
					if(!isEquel(waitingFunction.msg.parameters,originalMsg.parameters))
					{
						addMessageLog("Server","Error","Not all parameters for "+originalMsg.methodName+" are the same");
						showMsg("Not all parameters for "+originalMsg.methodName+" are the same","Error");
						gameOver();
						return null;
					}
					else
					{
						waitingQueue.splice(i,1);
						i--;
					}
				}
			}
			return originalMsg;
		}
		private function isKeyExist(testKey:int):int
		{
			for(var i:int=0;i<userStateEntrys.length;i++)
			{
				if(userStateEntrys[i].key==testKey)
					return i;	
			}
			return -1;	
		}
		private function doShuffleOn(index:int,newKey:String):void
		{
			userStateEntrys[index].key=newKey;
			userStateEntrys[index].authorizedUsersIds=new Array();
		}
		//do all function's
		private function doAllShuffleState(methodCalls:Array):void
		{
			var doShuffleCalls:Array=new Array();
			for each (var waitingDoAllCall:WaitingDoAll in methodCalls)
			{
				doShuffleCalls.push(waitingDoAllCall.msg as API_DoAllShuffleState);
			}
			var shuffleKeys:Array=doShuffleCalls[0].keys;
			for each(var doShuffleCall:API_DoAllShuffleState in doShuffleCalls)
			{
				if(doShuffleCall.keys.length!=shuffleKeys.length)
				{
					addMessageLog("Server","Error","Not all users agree on which keys to shuffle");
					gameOver();
					return;
				}
				for(var i:int=0;i<doShuffleCall.keys.length;i++)
					if(doShuffleCall.keys[i]!=shuffleKeys[i])
					{
						addMessageLog("Server","Error","Not all users agree on which keys to shuffle");
						gameOver();
						return;	
					}
			}
			var shuffleIndex:int;
			var shuffleIndexArr:Array=new Array();
			var shuffleMapKeys:Array=new Array();
			for(i=0;i<shuffleKeys.length;i++)
			{
				shuffleIndex=isKeyExist(shuffleKeys[i])
				if(shuffleIndex!=-1)	
				{
					shuffleIndexArr.push(shuffleIndex);
					 shuffleMapKeys.push(userStateEntrys[shuffleIndex].key);
				}
				else
				{
					addMessageLog("Server","Error","Can't shuffle a key that does not exist");
					gameOver();
					return;		

				}
			}
			var shuffleLen:int=shuffleIndexArr.length;
			for (i=0;i<shuffleLen;i++)
			{
				shuffleIndex=Math.floor(Math.random()*(shuffleIndexArr.length+1))
				doShuffleOn(shuffleIndexArr.splice(shuffleIndex,1),shuffleMapKeys.splice(shuffleIndex,1));
			}
		}
		private function doAllEndMatch(methodCalls:Array):void
		{
			var endMatchCalls:Array=new Array();
			for each (var waitingDoAllCall:WaitingDoAll in methodCalls)
			{
				endMatchCalls.push(waitingDoAllCall.msg as API_DoAllEndMatch);
			}
			var finishedPlayers:Array=endMatchCalls[0].finishedPlayers;
			for each (var waitingEndMatchCall:API_DoAllEndMatch in endMatchCalls)
			{
				for(var i:int=0;i<waitingEndMatchCall.finishedPlayers.length;i++)
				{
					if((waitingEndMatchCall.finishedPlayers[i].playerId!=finishedPlayers[i].playerId)||
					(waitingEndMatchCall.finishedPlayers[i].score!=finishedPlayers[i].score)||
					(waitingEndMatchCall.finishedPlayers[i].potPercentage!=finishedPlayers[i].potPercentage))
					{
						addMessageLog("Server","Error","Not all users agree on who finished game");
						gameOver();
						return;	
					}
				}
			}
			
			var finishedPart:FinishHistory=new FinishHistory();
			var percentageOfPot:Number=0;
			for(i=0;i<finishedPlayers.length;i++)
			{
				FinishHistory.totalFinishingPlayers++;
				percentageOfPot+=finishedPlayers[i].potPercentage;
				finishedPart.finishedPlayers.push(finishedPlayers[i])	
			}
			finishedPart.pot=FinishHistory.wholePot;
			FinishHistory.wholePot-=(FinishHistory.wholePot*percentageOfPot)/100;
			afinishedPlayers.push(finishedPart);
			if(FinishHistory.totalFinishingPlayers == aPlayers.length)
			{
				gameOver();
			}
			var tempFinishedPlayersIds:Array=new Array();
			for (i=0;i<finishedPlayers.length;i++)
			{
				tempFinishedPlayersIds.push(finishedPlayers[i].playerId);
			}
			var tempAction:WaitingFunction=new WaitingFunction();
			var gotEndMatch:API_GotMatchEnded=new API_GotMatchEnded(tempFinishedPlayersIds);
			tempAction.methodName=gotEndMatch.methodName;
			tempAction.parameters=gotEndMatch.parameters;
			tempAction.unverifiedPlayers=aPlayers.concat();
			unverifiedQue.push(tempAction);
			queTimer.start();
			broadcast(gotEndMatch);
			
		}
		
		private function doAllSetTurn(msg:API_DoAllSetTurn):void
		{
			iCurTurn=msg.userId;
			var gotTurnOf:API_GotTurnOf=new API_GotTurnOf(iCurTurn);
			broadcast(gotTurnOf);
		}
		/*
		private function commitDoAllEndMatch(calledMethodArr:Array):void
		{
			var tempLen:Number=calledMethodArr.length;
			for(var i:Number=1;i<tempLen;i++)
			{
				for(var j:Number=0;j<calledMethodArr[i].length;j++)
				{
					if(!calledMethodArr[0].parameters[0][j]==calledMethodArr[i].parameters[0][j])
						{
							//error
							return;
						}
				}
			}
			for each (var usr:User in aUsers)
			{
				if (usr.ID == iCurTurn) 
				{
					do_end_my_turn(usr, null);
					break;
				}
			}	
			calledMethodArr[0].unverifiedPlayers = aPlayers;
			unverifiedQue.push(calledMethodArr[0]);
			gameOver();
		}
		*/
		/*
		public function doAllEndMatch(user:User, user_ids:Array, scores:Array, pot_percentages:Array):void {			
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
						showMsg("do_agree_on_match_over: Function parameters are different from previous call.");
						gameOver()
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
					}
					

					
					broadcast(new API_GotMatchEnded(over.user_ids));
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
		*/

		
		private function getFinishedPlayerIds():Array/*int*/ {
			var finishedPlayerIds:Array/*int*/ = [];
			if (bGameEnded) {
				finishedPlayerIds = [aPlayers];
			}else {				
				for each (var finishedGame:FinishHistory in afinishedPlayers) {
					for(var i:int=0;i<finishedGame.finishedPlayers.length;i++)
					{
						finishedPlayerIds.push(finishedGame.finishedPlayers[i].playerId);
					}
				}
			}
			return finishedPlayerIds;
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
		private function isInArray(id:int,idArr:Array):Boolean
		{
			for(var i:int=0;i<idArr.length;i++)
				if(id==idArr[i])
					return true;
			return false;
		}		
		private function send_got_match_started(u:User):void {	
			var finished_player_ids:Array = getFinishedPlayerIds();
			u.Ended = finished_player_ids.indexOf(u.ID)!=-1;
			var stateEntries:Array=new Array();
			for each(var tempServerState:ServerStateEntry in userStateEntrys)
			{
				if(tempServerState.authorizedUsersIds==null)
					stateEntries.push(new StateEntry(tempServerState.key,tempServerState.value,false));
				else if(isInArray(u.ID,tempServerState.authorizedUsersIds))
					stateEntries.push(new StateEntry(tempServerState.key,tempServerState.value,true));
				else
					stateEntries.push(new StateEntry(tempServerState.key,null,true));
			}
			u.sendOperation(new API_GotMatchStarted(aPlayers, finished_player_ids, extra_match_info, match_started_time,stateEntries));			
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
						showMsg("Can't convert match_started_time to int","Error");
						return false;
					}
				}
				else {
					match_started_time = getTimer();
				}
				txtMatchStartedTime.text = match_started_time.toString();
				return true;
			}catch (err:Error) {
				showMsg(err.getStackTrace(), "Error");
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
			showMsg("Can't load XML file", "Error");
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
					txtInfo.text = "user_id: " + evt.target.selectedItem[COL_player_ids] + "\n" + "key: " + evt.target.selectedItem[COL_key] + "\n" + "data: " + evt.target.selectedItem[COL_data];
					break;
				case 2:
					txtInfo.text = "user_id: " + evt.target.selectedItem[COL_player_ids] + "\n" + "key: " + evt.target.selectedItem[COL_key] + "\n" + "submition_time: " + evt.target.selectedItem.submition_time + "\n" + "expiration_time: " + evt.target.selectedItem.expiration_time + "\n" + "pass_back: " + evt.target.selectedItem.pass_back + "\n" + "pending: " + evt.target.selectedItem.pending;
					break;
				case 3:
					txtInfo.text = "key: " + evt.target.selectedItem[COL_key] + "\n" + "data: " + evt.target.selectedItem[COL_data];
					break;
				case 4:
					txtInfo.text = "user_id: " + evt.target.selectedItem[COL_player_ids] + "\n" + "key: " + evt.target.selectedItem[COL_key] + "\n" + "data: " + evt.target.selectedItem[COL_data];
					break;
				case 5:
					txtInfo.text = "users_id: " + evt.target.selectedItem[COL_player_ids] + "\n" + "score: " + evt.target.selectedItem[COL_scores] + "\n" + "pot_percentage: " + evt.target.selectedItem[COL_pot_percentages];
					break;
				case 6:
					txtInfo.text = "name: " + evt.target.selectedItem[COL_name] + "\n" + 
						"user_ids_that_are_still_playing: " + evt.target.selectedItem[COL_userIdThatAreStillPlaying] + "\n" + 
						"next_turn_of_user_ids: " + evt.target.selectedItem[COL_nextTurnOfUserIds] + "\n" + 
						"match_state: " + evt.target.selectedItem[COL_matchState] + "\n" + 
						"match_started_time: " + evt.target.selectedItem[COL_matchStartedTime] + "\n" + "extra_match_info: " + evt.target.selectedItem[COL_extraMatchInfo];
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
				
				tblInfo.columns=[COL_player_ids,COL_key,COL_data];
				
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
				
				tblInfo.columns=[COL_key,COL_data];
				
				showGeneralInfo();
			}
		}

		private function btnStore(ev:MouseEvent):void
		{
			
			tbsPanel.gotoAndStop("Store");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=7){
				iInfoMode=7;
				
				tblInfo.columns=[COL_User,COL_MethodName,COL_Parameters,COL_UnverifiedPlayers];
				
				showStoreQue();
			}
		}
		private function btnDoAll(ev:MouseEvent):void
		{
			tbsPanel.gotoAndStop("DoAllQue");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=2){
				iInfoMode=2;
				
				tblInfo.columns=[COL_User,COL_Message];
				
				showDoAllQue();
			}
		}
		
		private function btnUserInfoClick(evt:MouseEvent):void {
			tbsPanel.gotoAndStop("UserInfo");
			pnlCommands.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=4){
				iInfoMode=4;
				
				tblInfo.columns=[COL_player_ids,COL_key,COL_data];
				
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
				
				tblInfo.columns=[COL_player_ids, COL_scores , COL_pot_percentages,COL_total_pot_percentages];
				
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
				tblInfo.columns=[COL_name,COL_numberOfPlayers, COL_userIdThatAreStillPlaying,COL_nextTurnOfUserIds,COL_matchState, COL_matchStartedTime, COL_extraMatchInfo];
				showSavedGames();
			}
		}
		private function showStoreQue():void
		{
			if(iInfoMode==7){
				tblInfo.removeAll();
				var itemObj:Object;
				
				for(var i:int=0;i<unverifiedQue.length;i++){
					itemObj=new Object();
					itemObj[COL_User]=unverifiedQue[i].userId;
					itemObj[COL_MethodName]=unverifiedQue[i].methodName
					itemObj[COL_Parameters]=unverifiedQue[i].parameters.toString();
					itemObj[COL_UnverifiedPlayers]=unverifiedQue[i].unverifiedPlayers.toString();
					tblInfo.addItem(itemObj);
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				
				txtInfo.text="";
			}
		}
		private function showDoAllQue():void
		{
			if(iInfoMode==2){
				tblInfo.removeAll();
				var itemObj:Object;
				for(var i:int=0;i<doAllQue.length;i++){
					itemObj=new Object();
					itemObj[COL_User]=doAllQue[i].user.ID;
					itemObj[COL_Message]=doAllQue[i].msg.toString();
					tblInfo.addItem(itemObj);
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		private function showMatchState():void{
			if(iInfoMode==1){
				tblInfo.removeAll();
				var itemObj:Object;
				for(var i:int=0;i<userStateEntrys.length;i++){
					itemObj=new Object();
					itemObj[COL_player_ids]=userStateEntrys[i].userId
					itemObj[COL_key]=userStateEntrys[i].key
					itemObj[COL_data]=userStateEntrys[i].getParametersAsString()
					tblInfo.addItem(itemObj);
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		
		
		private function showGeneralInfo():void{
			if(iInfoMode==3){
				tblInfo.removeAll();
				var itemObj:Object;
				for(var i:int=0;i<serverEntery.length;i++){
					itemObj=new Object();
					itemObj[COL_key]=serverEntery[i].key;
					itemObj[COL_data]=serverEntery[i].value;
					tblInfo.addItem(itemObj);
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		
		private function showUserInfo():void{
			if(iInfoMode==4){
				tblInfo.removeAll();
				
				var user:User;
				var itemObj:Object;
				for each (user in aUsers){
					//for(var j:int=0;j<user.Enterys.length;j++){
						//addMessageLog("Server","dataGetting","count: "+j);
						itemObj=new Object();
						itemObj[COL_player_ids]=user.ID;
						itemObj[COL_key]="Name";
						itemObj[COL_data]=user.Name;
						tblInfo.addItem(itemObj);
						tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
					//}
				}
				txtInfo.text="";				
			}
		}
		
		private function showMatchOver():void{
			if(iInfoMode==5){
				tblInfo.removeAll();
				
				//afinishedPlayers
				var itemObj:Object;
				var tempLen:int;
				for each (var matchOver:FinishHistory in afinishedPlayers){
					itemObj=new Object();
					itemObj[COL_player_ids] = "[";
					itemObj[COL_scores] = "[";
					itemObj[COL_pot_percentages] = "[";
					itemObj[COL_total_pot_percentages] = "[";
					tempLen=matchOver.finishedPlayers.length;
					for(var i:int=0;i<tempLen;i++)
					{
						itemObj[COL_player_ids] += matchOver.finishedPlayers[i].playerId;
						itemObj[COL_scores] += matchOver.finishedPlayers[i].score;
						itemObj[COL_pot_percentages] += matchOver.finishedPlayers[i].potPercentage;	
						itemObj[COL_total_pot_percentages] +=String(((matchOver.pot*matchOver.finishedPlayers[i].potPercentage)/100))
						if((tempLen) != (i+1))
						{
							itemObj[COL_player_ids] += ",";
							itemObj[COL_scores] += ",";
							itemObj[COL_pot_percentages] += ",";
							itemObj[COL_total_pot_percentages] += ","
						}
					}
					itemObj[COL_player_ids] += "]";
					itemObj[COL_scores] += "]";
					itemObj[COL_pot_percentages] += "]";
					itemObj[COL_total_pot_percentages] += "]"
					
					tblInfo.addItem(itemObj);
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
						if (savedGame.playersNum == User.PlayersNum && savedGame.gameName==root.loaderInfo.parameters["game"]) {
							var itemObj:Object;
							arr1=new Array();
							for(var j:int=0;j<savedGame.entries.length;j++){
								arr1.push("{user_id: "+savedGame.entries[j].userId+", key: "+savedGame.entries[j].key+", data: "+savedGame.entries[j].toString()+"}");
							}
							itemObj=new Object();
							itemObj[COL_name]=savedGame.name;
							itemObj[COL_numberOfPlayers]=savedGame.playersNum;
							itemObj[COL_userIdThatAreStillPlaying]=savedGame.players;
							itemObj[COL_nextTurnOfUserIds]=savedGame.curTurn;
							itemObj[COL_matchState]=arr1;
							itemObj[COL_matchStartedTime]=savedGame.match_started_time;
							itemObj[COL_extraMatchInfo]=JSON.stringify(savedGame.extra_match_info)
							tblInfo.addItem(itemObj);
							tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
						}
					}catch (err:Error) {
						showMsg(err.getStackTrace(), "Error");
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
				showMsg("ExternalInterface doesn't available. Please, check your security settings.", "Security Error");
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
			gameOver();
		}
		
		private function btnQuestionClick(evt:MouseEvent):void {
			showMsg("When starting a new game, you should enter two values that will be passed in the callback got_match_started: extra_match_info of type Object and match_started_time of type int");
		}
		
		private function btnLoadGameClick(evt:MouseEvent):void {
			cmbLoadName.removeAll();
			for each (var savedGame:SavedGame in allSavedGames) {
				if (savedGame.playersNum == User.PlayersNum && savedGame.gameName==root.loaderInfo.parameters["game"]) {
					cmbLoadName.addItem( { label:savedGame.name,data:savedGame } );
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
			userStateEntrys=savedGame.entries.concat();
			afinishedPlayers=savedGame.finishedGames.concat();
			extra_match_info=savedGame.extra_match_info;
			match_started_time = savedGame.match_started_time;
			if(extra_match_info!=null){
				txtExtraMatchInfo.text = JSON.stringify(extra_match_info);
			}else {
				txtExtraMatchInfo.text = "";
			}
			txtMatchStartedTime.text = match_started_time.toString();
			showMatchState();
			iCurTurn = savedGame.curTurn;
			//aMatchOvers = new Array();
			/*
			when debug information will be viewed
			
			*/
			// Yoav: I added a MatchOver for all the players that already finished playing
			if (savedGame.players.length < savedGame.playersNum) {
				// some players have already finished playing
				var ongoing_player_ids:Array = savedGame.players.concat();
				var finished_player_ids:Array = [];
			//	var over:MatchOver = new MatchOver();
				//over.user_ids = [];
				//over.scores = [];
				//over.pot_percentages = [];
				//over.recieved_from = [];
				for (var user_id:int=1; user_id<=savedGame.playersNum; user_id++) {
					//over.recieved_from.push(user_id);
					if (ongoing_player_ids.indexOf(user_id)==-1) {
						//getUser(user_id).Ended = true; // see send_got_match_started
						//over.user_ids.push(user_id);
						//over.scores.push(-1);
						//over.pot_percentages.push(-1);
					}
				}
			//	aMatchOvers.push(over);
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
			showMsg("Saved game was loaded","Message");
		}
		
		private function enableSavedGames():void {
			var j:int = 0;
			for each (var savedGame:SavedGame in allSavedGames) {
				if (savedGame.playersNum == User.PlayersNum && savedGame.gameName == root.loaderInfo.parameters["game"]) {
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
			showMsg("Saved game was deleted","Message");
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
			game.entries=userStateEntrys.concat();
			game.playersNum = User.PlayersNum;
			game.players = getOngoingPlayerIds();
			game.extra_match_info=extra_match_info;
			game.match_started_time=match_started_time;
			game.name = txtSaveName.text;
			game.finishedGames=afinishedPlayers.concat();
			game.curTurn = iCurTurn;
			game.gameName = root.loaderInfo.parameters["game"];
			allSavedGames.push(game);
			saveToSharedObject();

			txtSaveName.text = "";
			pnlSave.visible = false;
			showSavedGames();
			showMsg("The game was saved", "Message");
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
			afinishedPlayers=new Array();
			userStateEntrys=new Array();
			showMatchState();
			//aMatchOvers = new Array();
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
						usr.sendOperation(API_Message.createMessage(command_name, parameters));
					}
				}
				showMsg("Command was send", "Message");
			}catch (err:Error) {
				showMsg(err.getStackTrace(), "Error");
				addMessageLog("Server", "btnSendClick", "Error: " + err.getStackTrace());
			}
		}
		
		//Do functions
		
		private function broadcast(msg:API_Message):void {
			for each (var user:User in aUsers) {
				user.sendOperation(msg);
			}
		}	
		public function doRegisterOnServer(u:User):void {
			if (u.wasRegistered) throw new Error("User "+u.Name+" called do_register_on_server twice!");
			// send the info of "u" to all registered users (without user "u")
			
			broadcast(new API_GotUserInfo(u.ID, u.entries)); //note, this must be before you call u.wasRegistered = true 
			u.wasRegistered = true;		
			u.sendOperation(new API_GotMyUserId(u.ID));
			u.sendOperation(new API_GotCustomInfo(serverEntery));
				
			// important: note that this is not a broadcast!
			// send to "u" the info of all the registered users
			for each (var user:User in aUsers) {
				if (user.wasRegistered)
					u.sendOperation(new API_GotUserInfo(user.ID, user.entries));
			}		
				
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
		public function doStoreState(user:User, msg:API_DoStoreState):void {
			var serverEntries:Array;
			//todo: ask yoav about change time and about server.swc
			for each(var tempUser:User in aUsers)
			{
				serverEntries=new Array();
				for each (var userEntry:UserEntry in msg.stateEntries)
				{
					if(userEntry.isSecret)
					{
						if(user.ID == tempUser.ID)
							serverEntries.push(new ServerEntry(userEntry.key,userEntry.value,user.ID,[user.ID],0));
						else
							serverEntries.push(new ServerEntry(userEntry.key,null,user.ID,[user.ID],0));
					}
					else
						serverEntries.push(new ServerEntry(userEntry.key,userEntry.value,user.ID,null,0));
				}
				tempUser.sendOperation(new API_GotStoredState(user.ID,serverEntries));
			}
			showMatchState();
		}
		private function doStoreOneState(stateEntery:ServerEntry):void {			
			if (stateEntery.key == "") {
				addMessageLog("Server", "do_store_match_state", "Error: Can't store match state, key is empty");
				showMsg("Error: Can't store match state, key is empty","Error");
				return;
			}
			if (userStateEntrys.length>=1000) {
				addMessageLog("Server", "do_store_match_state", "Error: you stored more than a 1000 keys!");
				showMsg("Error: you stored more than a 1000 keys!","Error");
				return;
			}
			var isRewrite:Boolean=false;
			for(var index:int=0;index<userStateEntrys.length;index++)
			{
				if(userStateEntrys[index].key == stateEntery.key)
				{
					isRewrite=true;
					break;
				}
			}
			if (isRewrite) {
				userStateEntrys.splice(index,1);
			}
			if (stateEntery.value!=null && stateEntery.value!="") {
				userStateEntrys.push(stateEntery);
			}
		}
		public function doFoundHacker(user:User, msg:API_DoAllFoundHacker):void {
			addMessageLog("Server","Error","Someone claimed he found a hacker:"+ msg.toString());
			showMsg("Someone claimed he found a hacker:"+ msg.toString());
			gameOver()
		}

		
		public function gameOver():void
		{
			queTimer.stop();
			var usr:User;
			var arr:Array = new Array();
			for each (usr in aUsers) {
				if (aPlayers.indexOf(usr.ID) != -1 && !usr.Ended) {
					arr.push(usr.ID);
					usr.Ended = true;
				}
			}
			FinishHistory.totalFinishingPlayers=0;
			FinishHistory.wholePot=100;
			iCurTurn=-1;
			serverEntery=new Array;
			unverifiedQue=new Array;
			doAllQue=new Array;
			//afinishedPlayers=new Array();
			bGameEnded = true;
			txtMatchStartedTime.text = "";
			txtExtraMatchInfo.visible = true;
			txtMatchStartedTime.visible = true;
			btnNewGame.visible = true;
			btnCancelGame.visible = false;
			btnLoadGame.visible = true;
			btnSaveGame.visible = false;
			broadcast( new API_GotMatchEnded(arr) );
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
		public function do_finished_callback(user:User, methodName:String):void 
		{
			for(var i:Number;i<unverifiedQue.length;i++)
			{
				if(unverifiedQue.indexOf(user.ID)!=-1)
				{
					spliceNum(unverifiedQue[i].unverifiedPlayers,user.ID);
					if(unverifiedQue[i].unverifiedPlayers.length==0)
					{
						queTimer.reset();
						unverifiedQue.splice(i,1);
						if(unverifiedQue.length==0)
							checkDoAlls();
					}
					break;
				}	
			}
			
			user.do_finished_callback(methodName);
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
	private var actionQue:Array;
	public var entries:Array;/*enterys*/
	public var Ended:Boolean = false;
	public var wasRegistered:Boolean = false;
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
	public function User(prefix:int, _server:Server) {
		try{
			entries=new Array();
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
			
			actionQue = new Array();
			var tempEntery:Entry;
			for (var i:int = 0; sServer.root.loaderInfo.parameters["col" + i] != null;i++ ) {
				tempEntery=new Entry(sServer.root.loaderInfo.parameters["col" + i],sServer.root.loaderInfo.parameters["val" + (iID - 1) + i])
			}
			entries[0]=new Entry("name",sName);
			//Params[0] = sName;
			sDoChanel = Commands.getDoChanelString(""+prefix);
			sGotChanel = Commands.getGotChanelString(""+prefix);
			
			lcData = new LocalConnection();
			lcData.client = this;			
			lcData.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcData.connect(sDoChanel);
			
		}catch (err:Error) {
			sServer.addMessageLog("Server", "User", "Error: " + err.getStackTrace());
		}
	}
	
	public function sendOperation(msg:API_Message):void {
			if (!wasRegistered) return;
			actionQue.push(msg);
			if(actionQue.length==1)
				doSendOperation();	
    }
	public function do_finished_callback(methodName:String):void {
		if(methodName=="gotKeyboardEvent") return;
		if(actionQue.length==0) throw new Error("A Callback has been summoned with no corresponding do");
		var tempMsg:API_Message = actionQue.shift();
		if(methodName == tempMsg.methodName)
		{
			doSendOperation();
		}
		else
		{
				sServer.showMsg("Expected"+tempMsg.methodName+"to end,instead "+methodName+" ended", "Error");
				sServer.gameOver();
		}
	}
    private function doSendOperation(/*tempObj:Object*/):void
    {
    	try {
    		if(actionQue.length>0)
    		{
    			var tempMsg:API_Message = actionQue[0];
				lcData.send(sGotChanel, "localconnection_callback", tempMsg.methodName, tempMsg.parameters);
				sServer.addMessageLog(sName, tempMsg.methodName, tempMsg.toString());	
    		}
		}catch(err:Error) { 
			sServer.showMsg(err.getStackTrace(), "Error");
		}  	
    }
	
	public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
		sServer.got_user_localconnection_callback(this, API_Message.createMessage(methodName, parameters));
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
	public static const CLASS_VERSION_NUMBER:int = 3; 
	public var classVersionNumberForSharedObject:int = CLASS_VERSION_NUMBER;
	public var entries:Array;/*StateEntries*/
	public var players:Array;
	public var finishedGames:Array;/*FinishHistory*/
	public var extra_match_info:Object;
	public var match_started_time:int;
	public var playersNum:int;
	public var curTurn:int;
	public var name:String;
	public var gameName:String;
}
class UnverifiedFunction{
	public var unverifiedUsers:Array;
	public var user:User;
	public var msg:API_Message;
	public function UnverifiedFunction(waitingFunction:WaitingFunction,unverifiedUsers:Array)
	{
		this.unverifiedUsers=unverifiedUsers;
		this.user = waitingFunction.user;
		this.msg = waitingFunction.msg;	
	}
	public function removeUnverifiedUser(userId:int):Boolean
	{
		for(var i:int=0;i<unverifiedUsers.length;i++)
			if(unverifiedUsers[i] == userId)
			{
				unverifiedUsers.splice(i,1);
				true;
			}
		return false;
	}
	public function length():int
	{
		unverifiedUsers.length;
	}
}
class WaitingFunction{
	public var user:User;
	public var msg:API_Message;
	public function WaitingFunction(user:User,msg:API_Message)
	{
		this.user = user;
		this.msg = msg;
	}
}
class FinishHistory{
	public static var wholePot:Number=100;
	public static var totalFinishingPlayers:int=0;
	public var pot:int;
	public var finishedPlayers:Array=new Array/*PlayerMatchOver*/;
}