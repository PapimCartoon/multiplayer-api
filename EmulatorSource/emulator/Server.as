package emulator {
	import emulator.auto_copied.*;
	import emulator.auto_generated.*;
	
	import fl.controls.*;
	import fl.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	public class Server extends MovieClip {
			 
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
		//private var userStateEntrys:Array;/*UserStateEntry*/ //state information
		private var serverState:ObjectDictionary;
		private var serverInfoEnteries:Array;/*InfoEntry*/ //extra server information
		private var aParams:Array;
		private var aPlayers:Array; //array of all the players
		private var afinishedPlayers:Array;/*PlayerMatchOver*/

		private var matchStartTime:int;
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
		
		private var constructorDelayer:Timer;
		public function showMsg(msg:String, title:String = ""):void {
			MsgBox.Show(msg, title);
		}
		public function Server ()
		{
			/*
			constructorDelayer = new Timer(100,0)
			constructorDelayer.addEventListener(TimerEvent.TIMER,delayConstructor);	
			constructorDelayer.start();
			*/
		}
		/*
		public function delayConstructor (ev:TimerEvent):void
		{
			if(stage != null)
			{
				constructorDelayer.stop();
				constructServer();
			}	
		}
		*/
		//Constructor
		public function constructServer():void {
			this.stop();
			afinishedPlayers=new Array();
			serverState = new ObjectDictionary();
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
			//for each (var command_name:String in Commands.getCommandNames(true)) {
			//	cmbCommand.addItem( { label:command_name, data:command_name } );
			//}
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
			var textField1:TextField = aFilters[0]; 
			textField1.width = 35;
			textField1.x = 0;
			var textField2:TextField = aFilters[1];
			textField2.width = 50;
			textField2.x = 35;
			var textField3:TextField = aFilters[2];
			textField3.width = 120;
			textField3.x = 85;
			var textField4:TextField = aFilters[3];
			textField4.width = 255;
			textField4.x = 205;
			var textField5:TextField = aFilters[4];
			textField5.width = 60;
			textField5.x = 460;
			
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
			
			serverInfoEnteries=new Array();
			if(root.loaderInfo.parameters["custom_param_num"]!=null)
			{
				var count:int = int(root.loaderInfo.parameters["custom_param_num"])
				for(i=1;i<count;i++)
				{
					var key:String = root.loaderInfo.parameters["paramNum_"+i]
					var infoEntry:InfoEntry = InfoEntry.create(key,root.loaderInfo.parameters[key]);
					trace(key+"*********"+root.loaderInfo.parameters[key])
					serverInfoEnteries.push(infoEntry);
				}
			}
			if (root.loaderInfo.parameters["game"] == null) {
				showMsg("Parameter 'game' must be passed in the url.","Error");
				return;
			}
			loadSavedGames();

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
			var unverefiedFunction:QueueEntry = unverifiedQueue[0];
			if(unverefiedFunction != null)
			{
				if(unverefiedFunction.length()>1)
				{
					showMsg(unverefiedFunction.msg.getMethodName()+" Timed out by player/s:"+String(unverefiedFunction.unverifiedUsers),"Error");
					gameOver();
				}
			}
		}
		private function revealEntryToPlayers(serverEntry:ServerEntry,revealEntry:RevealEntry):void
		{
			var playerExist:Boolean;
			for each(var revealPlayer:int in revealEntry.userIds)
			{
				playerExist=false;
				for each(var serverPlayer:int in serverEntry.visibleToUserIds)
				{
					if(serverPlayer == revealPlayer)
						playerExist=true;
				}
				if(!playerExist)
					serverEntry.visibleToUserIds.push(revealPlayer);
			}
		}
		private var isProcessingCallback:Boolean = false;
		public function got_user_localconnection_callback(user:User, msg:API_Message):void {			
			try{
				if (isProcessingCallback) throw new Error("Concurrency problems in the server in the Emulator");
				isProcessingCallback = true;
				trace("got_user_localconnection_callback: user="+user.Name+" methodName="+msg.getMethodName());			
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
					if(finishedCallbackMsg.callbackName != "gotKeyboardEvent")
					{
						addMessageLog(user.Name, msg.getMethodName(), msg.toString());
						verefyAction(user);
						user.do_finished_callback(finishedCallbackMsg.callbackName)
					}
				}
				else if(msg is API_DoAllFoundHacker)
				{
					var foundHackerMsg:API_DoAllFoundHacker=msg as API_DoAllFoundHacker;
					doFoundHacker(user,foundHackerMsg);
				}
				else
				{
					if (!bGameStarted) {
						addMessageLog("Server", msg.getMethodName(), "Error: game not started");
						return;
					}
					if (bGameEnded) {
						addMessageLog("Server", msg.getMethodName(), "Error: game already end");
						return;
					}
					if(!isPlayer(user.ID))
						return
					var entry:QueueEntry;
          			var isNewEntry:Boolean = true
          			
					if(msg is API_DoStoreState)	
						entry = new QueueEntry(user,msg,[]);	
					else
					{
						entry = waitingQueue[0];
						if(entry == null)
						{
							entry = new QueueEntry(user,msg,getOngoingPlayerIds());
							entry.removeUnverifiedUser(user.ID)
						}
						else
						{
							
						 	if(checkDoAlls(msg,user))//search if message exists
						    	isNewEntry = false
						    else
						    {
						    	entry = new QueueEntry(user,msg,getOngoingPlayerIds())	
						    	entry.removeUnverifiedUser(user.ID)
						    }
						    
						}
							
					}			
          			if (isNewEntry) {
            			waitingQueue.push(entry)
         			 }
					addMessageLog(user.Name, msg.getMethodName(), msg.toString());
					doNextInQueue();
					
				}
			} catch (err:Error) { 
				showMsg(err.getStackTrace(), "Error");
			} finally {
				isProcessingCallback = false;
			} 
		}
		private function isPlayer(userId:int):Boolean
		{
			var finishedPlayers:Array = getFinishedPlayerIds();
			if((aPlayers.indexOf(userId) != -1) && (finishedPlayers.indexOf(userId) == -1))
				return true;
			else
				return false;
		}
		private function processMessage(msg:API_Message):void
		{
			if(msg is API_DoAllSetTurn)
			{
				var setTurnMessage:API_DoAllSetTurn=msg as API_DoAllSetTurn;
				doAllSetTurn(setTurnMessage);
			}
			else if(msg is API_DoAllShuffleState)
			{
				var shuffleStateMessage:API_DoAllShuffleState=msg as API_DoAllShuffleState;
				doAllShuffleState(shuffleStateMessage);	
			}
			else if(msg is API_DoAllEndMatch)
			{
				var endMatchMessage:API_DoAllEndMatch=msg as API_DoAllEndMatch;	
				doAllEndMatch(endMatchMessage);
			}
			else if(msg is API_DoAllRequestRandomState)
			{
				var randomStateMessage:API_DoAllRequestRandomState=msg as API_DoAllRequestRandomState;	
				doAllRequestRandomState(randomStateMessage);
			}
			else if(msg is API_DoAllRevealState)
			{
				var revealStateMessage:API_DoAllRevealState=msg as API_DoAllRevealState;	
				doAllRevealState(revealStateMessage);
			}
			else if(msg is API_DoAllRequestStateCalculation)
			{
				var requestStateCalculation:API_DoAllRequestStateCalculation=msg as API_DoAllRequestStateCalculation;	
				doAllRequestStateCalculation(requestStateCalculation);
			}
			else if(msg is API_DoAllStoreStateCalculation)
			{
				var storeStateCalculation:API_DoAllStoreStateCalculation=msg as API_DoAllStoreStateCalculation;	
				doAllStoreStateCalculation(storeStateCalculation);
			}
			else if(msg is API_DoAllStoreState)
			{
				var storeState:API_DoAllStoreState = msg as API_DoAllStoreState;
				doAllStoreState(storeState);
			}
		}
		private function doNextInQueue():void
		{
			if(waitingQueue.length == 0) return;
			var waitingFunction:QueueEntry=waitingQueue[0];
			
			if(waitingFunction.msg is API_DoStoreState)
				doStoreState(waitingFunction);
			else
			{
				if(unverifiedQueue.length != 0) return;
				if(waitingFunction.length() != 0) return ;
				processMessage(waitingFunction.msg);
			}
			waitingQueue.shift();
			if (!((waitingFunction.msg is API_DoAllSetTurn) || (waitingFunction.msg is API_DoAllRequestStateCalculation) ))
			{
				waitingFunction.unverifiedUsers =getOngoingPlayerIds();
				unverifiedQueue.push(waitingFunction);
			}
			queueTimer.reset();
			queueTimer.start();
			doNextInQueue();
		}
		private function verefyAction(user:User):void
		{
			for each(var unverifiedFunction:QueueEntry in unverifiedQueue)
			{
					if(unverifiedFunction.removeUnverifiedUser(user.ID))
					{
						if(unverifiedFunction.length() == 0)
						{
							actionVerefied();	
						}
						return;
					}
			}
			
		}
		private function actionVerefied():void
		{
			
			var waitingFunction:QueueEntry=unverifiedQueue.shift();
			queueTimer.reset();
			doNextInQueue();	
		}
		
		private function spliceNum(arr:Array,value:Number):int
		{
			var tempLen:Number=arr.length;
			for(var i:Number=0;i<tempLen;i++)
			{
				if(arr[i]==value)
				{
				arr.splice(i,1);
				return i;
				}
			}
			return -1;
		}
		private function isEquel(obj1:Object,obj2:Object):Boolean
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
		private function checkDoAlls(newMsg:API_Message,user:User):Boolean
		{
			for each(var entry:QueueEntry in waitingQueue)
			{
				if(!(entry.msg is API_DoStoreState))
				{
					if(newMsg.getMethodName() == entry.msg.getMethodName())
					{
						if(!isEquel(newMsg.getMethodParameters(),entry.msg.getMethodParameters()))
						{
							gameOver();
							addMessageLog("Server","Error","Not all parameters for "+newMsg.getMethodName()+" are the same new Mesaage = "+newMsg.getMethodParameters()+" from player : "+user.ID+" and old Message :"+entry.msg.getMethodParameters()+"from player : "+entry.user.ID);
							showMsg("Not all parameters for "+newMsg.getMethodName()+" are the same","Error");
							return false;
						}	
						else
						{
							entry.removeUnverifiedUser(user.ID);
							return true;
						}
					}
				}
			}
			return false;
		}
		/*private function isKeyExist(testKey:String):int
		{
			for(var i:int=0;i<userStateEntrys.length;i++)
			{
				var testedServerEntry:ServerEntry = userStateEntrys[i];
				if(testedServerEntry.key==testKey)
					return i;	
			}
			return -1;	
		}*/
		private function doShuffleOn(serverEntryArray:Array/*ServerEntry*/,key:Object):ServerEntry
		{
			var serverEntry:ServerEntry = serverEntryArray[0] as ServerEntry;
			serverEntry.visibleToUserIds = new Array();
			serverEntry.key = key;
			serverEntry.storedByUserId = -1;
			serverState.put(key,serverEntry);
			var newServerState:ServerEntry = serverState.getValue(key) as ServerEntry
			
			return serverEntry;
		}
		//do all function's
		private function doAllStoreState(msg:API_DoAllStoreState):void
		{
			var serverEntries:Array =/*ServerEntry*/ new Array();
			for each(var userEntry:UserEntry in msg.userEntries)
			{
				if(userEntry.isSecret)
				{
					serverEntries.push(ServerEntry.create(userEntry.key,null,-1,[],getTimer()-matchStartTime));
					doStoreOneState(ServerEntry.create(userEntry.key,userEntry.value,-1,[],getTimer()-matchStartTime));
				}
				else
				{
					serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,-1,null,getTimer()-matchStartTime));
					doStoreOneState(ServerEntry.create(userEntry.key,userEntry.value,-1,null,getTimer()-matchStartTime));	
				}
			}	
			broadcast(API_GotStateChanged.create(serverEntries));
		}
		private function doAllStoreStateCalculation(msg:API_DoAllStoreStateCalculation):void
		{
			var serverEntries:Array =/*ServerEntry*/ new Array();
			for each(var userEntry:UserEntry in msg.userEntries)
			{
				if(userEntry.isSecret)
				{
					serverEntries.push(ServerEntry.create(userEntry.key,null,-1,[],getTimer()-matchStartTime));
					doStoreOneState(ServerEntry.create(userEntry.key,userEntry.value,-1,[],getTimer()-matchStartTime));
				}
				else
				{
					var serverEntry:ServerEntry = ServerEntry.create(userEntry.key,userEntry.value,-1,null,getTimer()-matchStartTime)
					serverEntries.push(serverEntry);
					doStoreOneState(serverEntry);	
				}
			}	
			broadcast(API_GotStateChanged.create(serverEntries));	
		}
		private function doAllRequestStateCalculation(msg:API_DoAllRequestStateCalculation):void
		{
			var serverEntries:Array =/*ServerEntry*/ new Array();
			for each(var key:Object in msg.keys)
			{
				var keyExist:Boolean=serverState.hasKey(key);
				if(keyExist)
					serverEntries.push(serverState.getValue(key));
				else
				{
					showMsg("Key " + key + " does not exist","Error");
					addMessageLog("Server","Error","Key " + key + " does not exist")
					gameOver();
					return;
				}
			}
			broadcast(API_GotRequestStateCalculation.create(serverEntries));
		}
		private function doAllShuffleState(msg:API_DoAllShuffleState):void
		{
			
			var serverStateKeys:Array/*Object*/ = new Array();
			var serverStateValues:Array/*ServerEntry*/ = new Array();
			var tempServerEntry:ServerEntry;
			
			for each(var key:Object in msg.keys)
			{
				if(serverState.hasKey(key))	
				{
					tempServerEntry = serverState.getValue(key) as ServerEntry;
					serverStateValues.push(tempServerEntry);
					serverStateKeys.push(key);
				}
				else
				{
					addMessageLog("Server","Error","Can't shuffle " + JSON.stringify(key) + " key does not exist");
					showMsg("Can't shuffle " + JSON.stringify(key) + " key does not exist","Error");
					gameOver();
					return;		

				}
			}			

			var serverEntry:ServerEntry;
			var serverEntries:Array =new Array/*ServerEntry*/
			var shuffleIndex:int;
			trace("***************" + serverStateValues.length + "**********************")
			while(serverStateValues.length > 0)
			{
				shuffleIndex=Math.floor(Math.random()*serverStateValues.length)
				serverEntry=doShuffleOn(serverStateValues.splice(shuffleIndex,1),serverStateKeys.shift());
				tempServerEntry = new ServerEntry();
				tempServerEntry.key =serverEntry.key; 
				tempServerEntry.value = null;
				tempServerEntry.visibleToUserIds = [];
				tempServerEntry.storedByUserId = -1;
				tempServerEntry.changedTimeInMilliSeconds = serverEntry.changedTimeInMilliSeconds;
				serverEntries.push(tempServerEntry);
			}
			broadcast(API_GotStateChanged.create(serverEntries));
		}
		private function doAllRevealState(msg:API_DoAllRevealState):void
		{
			var stateData:ServerEntry;
			var serverEnries:Array=new Array();
			var serverEntry:ServerEntry;
			var key:Object;
			for each(var revealEntry:RevealEntry in msg.revealEntries)
			{
				key=revealEntry.key
				for(var i:int=0;i<=revealEntry.depth;i++)	
				{			
					if(!serverState.hasKey(key))	
					{
						addMessageLog("Server","Error","Can't reveal " + key + " key does not exist");
						showMsg("Can't reveal " + key + " key does not exist","Error");
						gameOver();
						return;		
					}
					else
					{
						stateData= serverState.getValue(revealEntry.key) as ServerEntry;
						if(revealEntry.depth != i)
						{
							if(serverState.hasKey(stateData.value))
								key = stateData.value;
						}
						else
						{
							serverEntry = serverState.getValue(key) as ServerEntry;
							if(revealEntry.userIds == null)
								serverEntry.visibleToUserIds = null;			
							else
								revealEntryToPlayers(serverEntry,revealEntry);
							serverEnries.push(serverEntry);
						}
					}
				}
			}		
			var tempServerEnries:Array;
			for each(var user:User in aUsers)
			{
				tempServerEnries = new Array();
				for each(serverEntry in serverEnries)
				{
					serverEntry.storedByUserId = -1;
					if(serverEntry.visibleToUserIds == null)
						tempServerEnries.push(serverEntry);
					else
					{
						if(serverEntry.visibleToUserIds.indexOf(user.ID)!=-1)
							tempServerEnries.push(serverEntry);
						else
							tempServerEnries.push(ServerEntry.create(serverEntry.key,null,serverEntry.storedByUserId,serverEntry.visibleToUserIds,serverEntry.changedTimeInMilliSeconds));
					}
				}
				user.sendOperation(API_GotStateChanged.create(tempServerEnries))
			}
		}
		private function doAllRequestRandomState(msg:API_DoAllRequestRandomState):void
		{
			var serverEntry:ServerEntry = new ServerEntry();
			var randomSeed:int=1000*Math.random();	
			if(msg.isSecret)
			{
				serverEntry = ServerEntry.create(msg.key,null,-1,[],getTimer()-matchStartTime)
				doStoreOneState(ServerEntry.create(msg.key,randomSeed,-1,[],getTimer()-matchStartTime));
			}
			else
			{
				serverEntry = ServerEntry.create(msg.key,randomSeed,-1,null,getTimer()-matchStartTime);
				doStoreOneState(serverEntry);
			}
			
			broadcast(API_GotStateChanged.create([serverEntry]));
		}
		private function doAllEndMatch(msg:API_DoAllEndMatch):void
		{
			var tempFinishedPlayersIds:Array=new Array();
			var finishedPlayers:Array = msg.finishedPlayers;
			var finishedPart:FinishHistory=new FinishHistory();
			var percentageOfPot:Number=0;
			
			for each(var palyerMatchOver:PlayerMatchOver in finishedPlayers)
			{
				FinishHistory.totalFinishingPlayers++;
				tempFinishedPlayersIds.push(palyerMatchOver.playerId);
				percentageOfPot+=palyerMatchOver.potPercentage;
				finishedPart.finishedPlayers.push(palyerMatchOver)	
			}
			
			finishedPart.pot=FinishHistory.wholePot;
			FinishHistory.wholePot-=(FinishHistory.wholePot*percentageOfPot)/100;
			afinishedPlayers.push(finishedPart);
			
			if (aPlayers.length == FinishHistory.totalFinishingPlayers)
			{
				gameOver();
			}
			
			queueTimer.start();
			broadcast(API_GotMatchEnded.create(tempFinishedPlayersIds));
			
		}
		
		private function doAllSetTurn(msg:API_DoAllSetTurn):void
		{
			iCurTurn=msg.userId;
		}
		
		private function getFinishedPlayerIds():Array/*int*/ {
			var finishedPlayerIds:Array/*int*/ = [];
			if (bGameEnded) {
				finishedPlayerIds = [aPlayers];
			}else {				
				for each (var finishedGame:FinishHistory in afinishedPlayers) {
					for each (var playerMatchOver:PlayerMatchOver in finishedGame.finishedPlayers)
					{
						finishedPlayerIds.push(playerMatchOver.playerId);
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
			//if (finished_player_ids.length!=0) throw new Error("Internal error! Illegal player_ids="+finished_player_ids);
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
			var serverEntry:ServerEntry;
			var serverStateEntries:Array/*ServerEntry*/ = serverState.getValues();
			for each(var tempServerState:ServerEntry in serverStateEntries)
			{
				serverEntry=new ServerEntry();
				if(tempServerState.visibleToUserIds==null)
					serverEntry = ServerEntry.create(tempServerState.key,tempServerState.value,tempServerState.storedByUserId,null,tempServerState.changedTimeInMilliSeconds);
				else if(isInArray(u.ID,tempServerState.visibleToUserIds))
					serverEntry = ServerEntry.create(tempServerState.key,tempServerState.value,tempServerState.storedByUserId,tempServerState.visibleToUserIds,tempServerState.changedTimeInMilliSeconds);				
				else
					serverEntry = ServerEntry.create(tempServerState.key,null,tempServerState.storedByUserId,tempServerState.visibleToUserIds,tempServerState.changedTimeInMilliSeconds);
				stateEntries.push(serverEntry);
			}
			u.sendOperation(API_GotMatchStarted.create(aPlayers,finished_player_ids,extra_match_info,match_started_time,stateEntries));			
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
			var textField1:TextField = aFilters[0] 
			var textField2:TextField = aFilters[1]
			var textField3:TextField = aFilters[2]
			var textField4:TextField = aFilters[3]
			var textField5:TextField = aFilters[4]
			tblLog.columns[0].width = textField1.width = tblLog.width*(35/520);
			textField1.x = 0;
			tblLog.columns[1].width = textField2.width = tblLog.width*(50/520);
			textField2.x = textField1.x+textField1.width;
			tblLog.columns[2].width = textField3.width = tblLog.width*(120/520);
			textField3.x = textField2.x+textField2.width;
			tblLog.columns[3].width = textField4.width = tblLog.width*(255/520);
			textField4.x = textField3.x+textField3.width;
			tblLog.columns[4].width = textField5.width = tblLog.width*(60/520);
			textField5.x = textField4.x+textField4.width;
			
			setTimeout(resizeColumn,100,null);
		}
		
		private function resizeColumn(evt:DataGridEvent):void {
			var sum:int = 0;
			var tempTextField:TextField;
			for (var i:int = 0; i < 5; i++) {
				tempTextField = aFilters[i];
				tempTextField.width = tblLog.columns[i].width;
				tempTextField.x = sum;
				sum += tempTextField.width;
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
					txtInfo.text = "user_id: " + evt.target.selectedItem[COL_User] + "\n" + "Message: " + evt.target.selectedItem[COL_Message];
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
			var tempTextField:TextField;
			for (var i:int = 0; i < 5; i++) {
				tempTextField = aFilters[i];
				tempTextField.text = tempTextField.text.replace(/^\s+|\s+$/g, "");
				aConditions[i] = tempTextField.text;
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
			var parameters:Array = [] /*Commands.findCommand(command_name)*/;
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
				for each(var unverifiedFunction:QueueEntry in unverifiedQueue)
				{
					itemObj=new Object();
					itemObj[COL_User]=unverifiedFunction.user.ID;
					itemObj[COL_MethodName]=unverifiedFunction.msg.getMethodName();
					itemObj[COL_Parameters]=unverifiedFunction.msg.getParametersAsString();
					itemObj[COL_UnverifiedPlayers]=unverifiedFunction.unverifiedUsers.toString();
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
				for each(var waitingFunction:QueueEntry in  waitingQueue)
				{
					itemObj=new Object();
					itemObj[COL_User]=waitingFunction.unverifiedUsers;
					itemObj[COL_Message]=waitingFunction.msg.toString();
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
				var serverStateEntrys:Array/*ServerEntry*/ = serverState.getValues();
				for each(var tempServerEntry:ServerEntry in serverStateEntrys)
				{
					itemObj=new Object();
					itemObj[COL_player_ids]=tempServerEntry.storedByUserId;
					itemObj[COL_key]=tempServerEntry.key
					itemObj[COL_data]=tempServerEntry.getParametersAsString()
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
				for(var i:int=0;i<serverInfoEnteries.length;i++){
					itemObj=new Object();
					var tempServerInfo:InfoEntry = serverInfoEnteries[i];
					itemObj[COL_key]=tempServerInfo.key;
					itemObj[COL_data]=tempServerInfo.value;
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
						var playerMatchOver:PlayerMatchOver = matchOver.finishedPlayers[i];
						itemObj[COL_player_ids] += playerMatchOver.playerId;
						itemObj[COL_scores] += playerMatchOver.score;
						itemObj[COL_pot_percentages] += playerMatchOver.potPercentage;	
						itemObj[COL_total_pot_percentages] +=String(((matchOver.pot*playerMatchOver.potPercentage)/100))
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
				
				var serverEntryOutput:Array;
				var serverStateKeys:Array;
				for each (var savedGame:SavedGame in allSavedGames) {
					try{
						if (savedGame.players.length <= User.PlayersNum && savedGame.gameName==root.loaderInfo.parameters["game"]) {
							var itemObj:Object;
							serverEntryOutput=new Array();
							serverStateKeys = savedGame.serverState.getKeys();
							for each(var key:Object in serverStateKeys)
							{
								var tempServerEntry:ServerEntry = savedGame.serverState.getValue(key) as ServerEntry;
								serverEntryOutput.push("{user_id: "+tempServerEntry.storedByUserId+", key: "+tempServerEntry.key+", data: "+tempServerEntry.toString()+"}");
							}
							itemObj=new Object();
							itemObj[COL_name]=savedGame.name;
							itemObj[COL_userIdThatAreStillPlaying]=savedGame.players;
							itemObj[COL_matchState]=serverEntryOutput;
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
				if (savedGame.players.length <= User.PlayersNum && savedGame.gameName==root.loaderInfo.parameters["game"]) {
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
			var transferByteArray:ByteArray = new ByteArray()
			transferByteArray.writeObject(cmbLoadName.selectedItem.data);
			transferByteArray.position = 0;
			var savedGame:SavedGame = SerializableClass.deserialize(transferByteArray.readObject()) as SavedGame;
			serverState = savedGame.serverState;
			afinishedPlayers=savedGame.finishedGames.concat();
			aPlayers = savedGame.players.concat();
			for each(var savedFinishedPlayer:FinishHistory in afinishedPlayers)
			{
				var tempPotPercentage:Number = 0;
				for each(var playerMatchOver:PlayerMatchOver in savedFinishedPlayer.finishedPlayers)
				{
					tempPotPercentage += playerMatchOver.potPercentage
					FinishHistory.totalFinishingPlayers ++;
				}
				FinishHistory.wholePot -= FinishHistory.wholePot*tempPotPercentage / 100;
			}			
			extra_match_info=savedGame.extra_match_info;
			match_started_time = savedGame.match_started_time;
			if(extra_match_info!=null){
				txtExtraMatchInfo.text = JSON.stringify(extra_match_info);
			}else {
				txtExtraMatchInfo.text = "";
			}
			txtMatchStartedTime.text = match_started_time.toString();
			showMatchState();
			showMatchOver();
			if (aPlayers.length >= savedGame.players.length) {
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
				if (savedGame.players.length <= User.PlayersNum && savedGame.gameName == root.loaderInfo.parameters["game"]) {
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
		private var shrSavedGames:SharedObject;
		private function loadSavedGames():void {	
			try{		
			shrSavedGames = SharedObject.getLocal("SavedGames");
			//addMessageLog("Server","Debug",JSON.stringify(shrSavedGames.data.savedGames))
			//shrSavedGames.data.savedGames = [];
			
			if (shrSavedGames.data.savedGames!=null) {
				allSavedGames = SerializableClass.deserialize(shrSavedGames.data.savedGames) as Array;								
			}
			
			}catch(err:Error) {
				shrSavedGames.data.savedGames = [];	//this deletes all saved games
			}
		} 
		private function saveToSharedObject():void {
			shrSavedGames.data.savedGames = allSavedGames;
			shrSavedGames.flush();
		}

		private function saveOkClick(evt:MouseEvent):void {
			if (txtSaveName.text == "") {
				return;
			}
			var game:SavedGame = SavedGame.create(serverState,aPlayers,afinishedPlayers,extra_match_info,match_started_time,txtSaveName.text,root.loaderInfo.parameters["game"]);
			var transferByteArray:ByteArray = new ByteArray();
			transferByteArray.writeObject(game);
			transferByteArray.position = 0;
			allSavedGames.push(transferByteArray.readObject());
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
			serverState=new ObjectDictionary();
			showMatchState();
			showMatchOver();
			matchStartTime=getTimer();
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
		
		
		//Do functions
		
		private function broadcast(msg:API_Message):void {
			for each (var user:User in aUsers) {
				user.sendOperation(msg);
			}
		}	
		public function doRegisterOnServer(u:User):void {
			if (u.wasRegistered) throw new Error("User "+u.Name+" called do_register_on_server twice!");
			// send the info of "u" to all registered users (without user "u")
			broadcast(API_GotUserInfo.create(u.ID,u.entries)); //note, this must be before you call u.wasRegistered = true 
			u.wasRegistered = true;		
			u.sendOperation(API_GotMyUserId.create(u.ID));
			u.sendOperation(API_GotCustomInfo.create(serverInfoEnteries));
				
			// important: note that this is not a broadcast!
			// send to "u" the info of all the registered users
			for each (var user:User in aUsers) {
				if (user.wasRegistered)
				{
					u.sendOperation(API_GotUserInfo.create(user.ID,user.entries));
				}
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
		public function doStoreState(waitingFunction:QueueEntry):void {
			var msg:API_DoStoreState = waitingFunction.msg as API_DoStoreState;
			var serverEntries:Array;
			for each(var tempUser:User in aUsers)
			{
				serverEntries=new Array();
				for each (var userEntry:UserEntry in msg.userEntries)
				{
					if(!userEntry.isSecret)
					{
						serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,waitingFunction.user.ID,null,getTimer()-matchStartTime));	
						doStoreOneState(ServerEntry.create(userEntry.key,userEntry.value,waitingFunction.user.ID,null,getTimer()-matchStartTime));
					}
					else
					{
						if(waitingFunction.user.ID == tempUser.ID)
							serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,waitingFunction.user.ID,[waitingFunction.user.ID],getTimer()-matchStartTime));
						else
							serverEntries.push(ServerEntry.create(userEntry.key,null,waitingFunction.user.ID,[waitingFunction.user.ID],getTimer()-matchStartTime));
						doStoreOneState(ServerEntry.create(userEntry.key,userEntry.value,waitingFunction.user.ID,[waitingFunction.user.ID],getTimer()-matchStartTime));
					}
				}

				tempUser.sendOperation(API_GotStateChanged.create(serverEntries));
			}
			showMatchState();
			
		}
		private function doStoreOneState(stateEntery:ServerEntry):void {		
			if (stateEntery.key == "") {
				addMessageLog("Server", "do_store_match_state", "Error: Can't store match state, key is empty");
				showMsg("Error: Can't store match state, key is empty","Error");
				return;
			}
			if (serverState.size()>=1000) {
				addMessageLog("Server", "do_store_match_state", "Error: you stored more than a 1000 keys!");
				showMsg("Error: you stored more than a 1000 keys!","Error");
				return;
			}
			serverState.put(stateEntery.key,stateEntery);
		}
		public function doFoundHacker(user:User, msg:API_DoAllFoundHacker):void {
			addMessageLog("Server","doAllFoundHacker",user.Name+" claimed he found a hacker:"+ msg.toString());
			showMsg(user.Name+" claimed he found a hacker:"+ msg.toString());
			gameOver()
		}

		
		public function gameOver():void
		{
			queueTimer.stop();
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
			serverInfoEnteries=new Array;
			unverifiedQueue=new Array;
			waitingQueue=new Array;
			//afinishedPlayers=new Array();
			bGameEnded = true;
			txtMatchStartedTime.text = "";
			txtExtraMatchInfo.visible = true;
			txtMatchStartedTime.visible = true;
			btnNewGame.visible = true;
			btnCancelGame.visible = false;
			btnLoadGame.visible = true;
			btnSaveGame.visible = false;
			broadcast(API_GotMatchEnded.create(arr));
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
			if(methodName !="gotKeyboardEvent")
			{
				verefyAction(user)
				user.do_finished_callback(methodName);
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
import emulator.auto_copied.*;
import emulator.auto_generated.API_Message;
import emulator.auto_generated.InfoEntry;

class User extends LocalConnectionUser {
	//Private variables
	private var sServer:Server;
	private var iID:int;
	private var sName:String;
	private var actionQueue:Array/*WaitingFunction*/;
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
	
	//Constructor
	public function User(prefix:int, _server:Server) {
		try{
			var someMovieClip:MovieClip = _server; 
			super(someMovieClip, true, String(prefix) ); 
			entries=new Array();
			if (iNextId > PlayersNum + ViewersNum) {
				throw new Error("Too many users");
			}
			
			iID = iNextId++;
			sServer = _server;
			sName = sServer.root.loaderInfo.parameters["val_" + (iID - 1)+"_" + "0"];
			sName = sName.replace( /^\s+|\s+$/g, "");
			if (sName==null || sName == "") {
				if(iID<=PlayersNum){
					sName = "Player" + (iID - 1);
				}else {
					sName = "Viewer" + (iID - PlayersNum - 1);
				}
			}
			
			actionQueue = new Array();
			var tempEntery:InfoEntry;
			tempEntery=new InfoEntry();
			tempEntery.key = "name";
			tempEntery.value = sName;
			entries[0]=tempEntery;
			for (var i:int = 1; sServer.root.loaderInfo.parameters["col_" + i] != null;i++ ) {
				tempEntery=new InfoEntry();
				tempEntery.key = sServer.root.loaderInfo.parameters["col_" + i];
				tempEntery.value = sServer.root.loaderInfo.parameters["val_" + (iID - 1)+"_"+ i];	
				entries.push(tempEntery);
			}
			

			
		}catch (err:Error) {
			sServer.addMessageLog("Server", "User", "Error: " + err.getStackTrace());
		}
	}
	
	public function sendOperation(msg:API_Message):void {
			if (!wasRegistered) return;
			actionQueue.push(new WaitingFunction(this,msg));
			if(actionQueue.length==1)
			{
				doSendOperation();	
			}
    }
	public function do_finished_callback(methodName:String):void {
		if(methodName=="gotKeyboardEvent") return;
		if(actionQueue.length==0) throw new Error("A Callback has been summoned with no corresponding doALLFunction");
		var waitingFunction:WaitingFunction = actionQueue.shift();
		var tempMsg:API_Message = waitingFunction.msg;
		if(methodName == tempMsg.getMethodName())
		{
			doSendOperation();
		}
		else
		{
				sServer.showMsg("Expected "+tempMsg.getMethodName()+" to end,instead "+methodName+" ended", "Error");
				sServer.gameOver();
		}
	}
    private function doSendOperation(/*tempObj:Object*/):void
    {
    	try {
    		if(actionQueue.length>0)
    		{
    			var waitingFunction:WaitingFunction = actionQueue[0];
    			var tempMsg:API_Message = waitingFunction.msg;
    			sendMessage(tempMsg);
				sServer.addMessageLog(sName, tempMsg.getMethodName(), tempMsg.getParametersAsString());	
    		}
		}catch(err:Error) { 
			sServer.showMsg(err.getStackTrace(), "Error");
		}  	
    }
	
    override public function gotMessage(msg:API_Message):void {
		sServer.got_user_localconnection_callback(this, msg);
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
}

class QueueEntry{
	public var unverifiedUsers:Array;
	public var user:User;
	public var msg:API_Message;
	public function QueueEntry(user:User,msg:API_Message,unverifiedUsers:Array)
	{
		this.unverifiedUsers=unverifiedUsers;
		this.user = user;
		this.msg = msg;	
	}
	public function removeUnverifiedUser(userId:int):Boolean
	{
		for(var i:int=0;i<unverifiedUsers.length;i++)
			if(unverifiedUsers[i] == userId)
			{
				unverifiedUsers.splice(i,1);
				return true;
			}
		return false;
	}
	public function length():int
	{
		return unverifiedUsers.length;
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
