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
		private static const COL_changeNum:String = "Num";
		private static const COL_pot_percentages:String = "pot_percentages";
		private static const COL_total_pot_percentages:String = "total_pot_percentages";
		private static const COL_Parameters:String="Parameters";
		private static const COL_MethodName:String="Method_Name";
		private static const COL_UnverifiedPlayers:String="Unverified_Players";
		private static const COL_User:String="Sending_user_Id";
		private static const COL_Message:String="Message";
		private static const COL_key:String="key";
		private static const COL_data:String="data";
		private static const COL_name:String="Name";
		private static const COL_numberOfPlayers:String="Number_Of_Players";
		private static const COL_userIdThatAreStillPlaying:String="User_ids_that_are_still_playing";
		private static const COL_matchState:String="Match_state";
		private static const COL_serverEntries:String= "Server_Entries";
		private static const COL_TimeSent:String = "Time_Sent";
		//Private variables
		private var isTurnBasedGame:Boolean = false;
		private var bGameStarted:Boolean = false;
		private var bGameEnded:Boolean = false;
		
		private var lcFramework:LocalConnection;
		 
		private var aUsers:Array;
		private var aCalculators:Array;
		private var serverState:ObjectDictionary;
		private var deltaHistory:DeltaHistory;
		private var serverInfoEnteries:Array;/*InfoEntry*/ //extra server information
		private var aParams:Array;
		private var aPlayers:Array; //array of all the players
		private var afinishedPlayers:Array;/*PlayerMatchOver*/
		public var playByPlayTimer:Timer;
		
		private var matchStartTime:int;
		// queue related variables
		private var unverifiedQueue:Array;
		private var waitingQueue:MessagQueue;
		private var queueTimer:Timer;
		private var changedToDelta:int;
		private var calculatorQueue:Array;
		private var loadedServerEntries:ObjectDictionary;
		
		
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
		private var logingCheckBox:DisableLoging;

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
		private var btnUserCallQue:SimpleButton;
		private var goBackToHistory:Button;
		private var playByPlay:Button;
		
		private var btnNewGame:Button;
		private var btnLoadGame:Button;
		private var btnSaveGame:Button;
		private var btnCancelGame:Button;
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
		private var stateCalculationsID:int;
		
		private var constructorDelayer:Timer;
		public function showMsg(msg:String, title:String = ""):void {
			MsgBox.Show(msg, title);
		}
		public function Server ()
		{

		}

		public function constructServer():void {
			this.stop();
			stateCalculationsID = -42;
			afinishedPlayers=new Array();
			serverState = new ObjectDictionary();
			deltaHistory = new DeltaHistory();
			unverifiedQueue=new Array();
			queueTimer=new Timer(10000,0);
			queueTimer.addEventListener(TimerEvent.TIMER,queTimeoutError);
			
			playByPlayTimer=new Timer(1000,0);
			playByPlayTimer.addEventListener(TimerEvent.TIMER,doOneMove);		

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

			btnGeneralInfo = tbsPanel["_btnCustomInfo"];
			btnGeneralInfo.addEventListener(MouseEvent.CLICK, btnGeneralInfoClick);

			btnUserInfo = tbsPanel["_btnUserInfo"];
			btnUserInfo.addEventListener(MouseEvent.CLICK, btnUserInfoClick);
			
			btnUserCallQue= tbsPanel["_btnUserCallQue"];
			btnUserCallQue.addEventListener(MouseEvent.CLICK, btnUserCall);
			
			btnMatchOver = tbsPanel["_btnMatchOver"];
			btnMatchOver.addEventListener(MouseEvent.CLICK, btnMatchOverClick);

			btnSavedGames = tbsPanel["_btnSavedGames"];
			btnSavedGames.addEventListener(MouseEvent.CLICK, btnSavedGamesClick);

			btnSavedGames = tbsPanel["_btnHistory"];
			btnSavedGames.addEventListener(MouseEvent.CLICK, btnHistoryClick);
			
			goBackToHistory = new Button()
			goBackToHistory.x = 410;
			goBackToHistory.y = 306;
			goBackToHistory.width = 60;
			goBackToHistory.label ="Revert"
			goBackToHistory.addEventListener(MouseEvent.CLICK, doGoBack);
			goBackToHistory.visible = false;
			this.addChild(goBackToHistory);
			
			playByPlay = new Button
			playByPlay.x = 480;
			playByPlay.y = 306;
			playByPlay.width = 60;
			playByPlay.label ="Replay"
			playByPlay.addEventListener(MouseEvent.CLICK, doPlayByPlay);
			playByPlay.visible = false;
			this.addChild(playByPlay);
			

			
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
						
			logingCheckBox = new DisableLoging();
			logingCheckBox.isLoging.label = "Log calls";
			logingCheckBox.isLoging.selected = true;
			logingCheckBox.x = 10
			logingCheckBox.y = 420;
			logingCheckBox.isLoging.addEventListener(MouseEvent.CLICK,handleLoging)
			this.addChild(logingCheckBox);
			
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
				var u:User = new User(sPrefix+user_index, this,true);			
				aUsers.push(u);
			}
			
			if(root.loaderInfo.parameters["calculatorsOn"] == "true")
			{
				aCalculators = new Array();
				calculatorQueue = new Array();
				for (user_index=total_users; user_index<(total_users+3); user_index++) {
					u = new User(sPrefix+user_index, this,false);			
					aCalculators.push(u);
				}			
			}
			serverInfoEnteries=new Array();
			if(root.loaderInfo.parameters["custom_param_num"]!=null)
			{
				var count:int = int(root.loaderInfo.parameters["custom_param_num"])
				for(i=1;i<count;i++)
				{
					var key:String = root.loaderInfo.parameters["paramNum_"+i]
					var infoEntry:InfoEntry = InfoEntry.create(key,JSON.parse(root.loaderInfo.parameters[key]));				
					serverInfoEnteries.push(infoEntry);
				}
			}
			if (root.loaderInfo.parameters["game"] == null) {
				showMsg("Parameter 'game' must be passed in the url.","Error");
				return;
			}
			if(root.loaderInfo.parameters["serverEntries"].length > 50)
				loadedServerEntries = SerializableClass.deserialize(JSON.parse( root.loaderInfo.parameters["serverEntries"] ) ) as ObjectDictionary;
			//trace(JSON.stringify())
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
		private var isLoging:Boolean = true;
		private function handleLoging(ev:MouseEvent):void
		{
			if(isLoging)
			{
				isLoging=false;	
			}
			else
			{
				isLoging = true;	
			}
		}
		private function queTimeoutError(ev:TimerEvent):void
		{
			
			
			if (waitingQueue.length() > 1)
			{
				var queueEntry:QueueEntry = waitingQueue.getStuckMessage();
				errorHandler(queueEntry.transaction.toString()+" Timed out");
				gameOver();
			}		
		}
		private function revealEntryToPlayers(serverEntryMold:ServerEntry,revealEntry:RevealEntry):ServerEntry
		{
			var serverEntry:ServerEntry = ServerEntry.create(serverEntryMold.key,serverEntryMold.value,serverEntryMold.storedByUserId,serverEntryMold.visibleToUserIds,serverEntryMold.changedTimeInMilliSeconds);
			var valueChanged:Boolean = false;
			var playerExist:Boolean;
			if(revealEntry.userIds == null)
			{
				if(serverEntry.visibleToUserIds != null)
				{
					valueChanged  = true;
					serverEntry.visibleToUserIds = null;
				}
				
			}
			else if(serverEntry.visibleToUserIds != null)
			{
				for each(var revealPlayer:int in revealEntry.userIds)
				{
					playerExist=false;
					for each(var serverPlayer:int in serverEntry.visibleToUserIds)
					{
						if(serverPlayer == revealPlayer)
							playerExist=true;
					}
					if(!playerExist)
					{
						valueChanged = true;
						serverEntry.visibleToUserIds.push(revealPlayer);
					}
				}
			}
			
			if(valueChanged)
			{
				doStoreOneState(serverEntry);
				serverEntry.storedByUserId = -1;
				return serverEntry;
			}
			else
				return null;
		}
		private var isProcessingCallback:Boolean = false;
		public function errorHandler(msg:String):void
		{
			if(MsgBox != null)
				showMsg(msg,"Error");
			if(tblLog != null)
				addMessageLog("Server","Error",msg);
			throw new Error(msg);
		}
		public function got_user_localconnection_callback(user:User, msg:API_Message):void {
			if(msg is API_DoTrace)
			{
				var traceMsg:API_DoTrace=msg as API_DoTrace;
				addMessageLog(String(user.ID),"doTrace",traceMsg.getParametersAsString());
				trace("***** doTrace on: "+traceMsg.getParametersAsString())
			}
			else if(msg is API_DoRegisterOnServer)
			{
				doRegisterOnServer(user);
			}
			else if(msg is API_DoAllFoundHacker)
			{
				var foundHackerMsg:API_DoAllFoundHacker=msg as API_DoAllFoundHacker;
				doFoundHacker(user,foundHackerMsg);
			}
			else if(msg is API_DoStoreState)
			{
				if(playByPlayTimer.running)
					return;
				addMessageLog(user.Name, msg.getMethodName(), msg.toString());	
				waitingQueue.push(new QueueEntry(user,new Transaction([msg]),getTimer()-matchStartTime));
				queueTimer.start();
				processQueue(waitingQueue,false);
				showWaitingFunctionQue();
			}
			else if(msg is API_Transaction)
			{
				var transMsg:API_Transaction = 	msg as API_Transaction;	
				var isCallback:Boolean = false;
				var finishedCallbackMsg:API_DoFinishedCallback = transMsg.callback;
				if(finishedCallbackMsg != null)
				{
					isCallback = true;
					if(finishedCallbackMsg.callbackName != "gotKeyboardEvent")
					{
						addMessageLog(user.Name, finishedCallbackMsg.getMethodName(), finishedCallbackMsg.toString());
						verefyAction(user);
						//user.do_finished_callback(finishedCallbackMsg.callbackName)
					}
				}
				if(playByPlayTimer.running )
					return;
					
					
				if(!isPlayer(user.ID))
				{
					var storeStateMessage:API_Message = transMsg.messages[0]					
					if(storeStateMessage is API_DoAllStoreStateCalculation) 
					{
						var storeStateCalculation:API_DoAllStoreStateCalculation=storeStateMessage as API_DoAllStoreStateCalculation;
						var lastMessageIndex:int = -1;
						var myMessageIndex:int = -1;
						for (var i:int = 0;i<3;i++)
						{
						if(calculatorQueue[i] == storeStateCalculation.requestId)
								myMessageIndex = i;
							if(calculatorQueue[i] is API_DoAllStoreStateCalculation)
								lastMessageIndex = i;
						}
						if(myMessageIndex == -1) errorHandler("calculator sent wrong requestId");
						if(lastMessageIndex == -1)
							calculatorQueue[myMessageIndex] = storeStateCalculation;
						else
						{
							var lastStateCalculation:API_DoAllStoreStateCalculation = calculatorQueue[lastMessageIndex];
							if(!ObjectDictionary.areEqual(lastStateCalculation.userEntries,storeStateCalculation.userEntries)) errorHandler("calculators gave diffrent values");
							var serverEntries:Array/*ServerEntry*/ = doAllStoreStateCalculation(storeStateCalculation);
							deltaHistory.addDelta(getOngoingPlayerIds(),serverEntries,getTimer()-matchStartTime);
							sendStateChanged(serverEntries);
							storeServerEntries(serverEntries);
							calculatorQueue = new Array();
						}
					}
					
					return
				}				
					
				if(transMsg.messages.length == 0) 
				{
					if(isCallback)
						return;
					else
						errorHandler("Transaction cannot be empty");
				}
				if (!bGameStarted) {
					errorHandler("can't do "+ msg.getMethodName()+" game not started");
					return;
				}
				if (bGameEnded) {
					errorHandler("can't do "+ msg.getMethodName()+" game ended");
					return;
				}
				
				//addMessageLog("id : "+user.ID,"Transaction","length "+transMsg.messages.length);
				
				for each(msg in transMsg.messages)
					addMessageLog(user.Name, msg.getMethodName(), msg.toString());	
				waitingQueue.push(new QueueEntry(user,new Transaction(transMsg.messages),getTimer()-matchStartTime));
				queueTimer.start();
				processQueue(waitingQueue,false);
				showWaitingFunctionQue();
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
		private function processMessage(msg:API_Message):Array/*ServerEntry*/
		{
			var serverEntries:Array = new Array();
			var saved:Boolean = false;
			if(msg is API_DoAllSetTurn)
			{
				var setTurnMessage:API_DoAllSetTurn=msg as API_DoAllSetTurn;
				doAllSetTurn(setTurnMessage);
			}
			else if(msg is API_DoAllShuffleState)
			{
				var shuffleStateMessage:API_DoAllShuffleState=msg as API_DoAllShuffleState;
				serverEntries = doAllShuffleState(shuffleStateMessage);	
			}
			else if(msg is API_DoAllEndMatch)
			{
				var endMatchMessage:API_DoAllEndMatch=msg as API_DoAllEndMatch;	
				doAllEndMatch(endMatchMessage);
			}
			else if(msg is API_DoAllRequestRandomState)
			{
				var randomStateMessage:API_DoAllRequestRandomState=msg as API_DoAllRequestRandomState;	
				serverEntries = doAllRequestRandomState(randomStateMessage);
			}
			else if(msg is API_DoAllRevealState) 
			{
				var revealStateMessage:API_DoAllRevealState=msg as API_DoAllRevealState;
				saved = true;	
				serverEntries = doAllRevealState(revealStateMessage);
			}
			else if(msg is API_DoAllRequestStateCalculation) 
			{
				var requestStateCalculation:API_DoAllRequestStateCalculation=msg as API_DoAllRequestStateCalculation;	
				doAllRequestStateCalculation(requestStateCalculation);
			}
			else if(msg is API_DoAllStoreState)
			{
				var storeState:API_DoAllStoreState = msg as API_DoAllStoreState;
				serverEntries = doAllStoreState(storeState);
			}
			if((serverEntries.length > 0) &&(!saved))
				storeServerEntries(serverEntries);
			return serverEntries;
		}

		private function processQueue(processedwaitingQueue:MessagQueue,isTransaction:Boolean):Array/*ServerEntry*/
		{
			var msg:API_Message;
			var serverEntries:Array = new Array();
			if (processedwaitingQueue.waitingDoStore())
			{
				var queueEntry:QueueEntry = processedwaitingQueue.shiftDoStore();
				for each(msg in queueEntry.transaction.messageArray)
					serverEntries = serverEntries.concat(doStoreState(msg as API_DoStoreState,queueEntry.user.ID));
				addToQue(queueEntry);
				storeServerEntries(serverEntries);
			}
			else if(processedwaitingQueue.waitingDoAll())
			{
				var doAll:Array/*QueueEntry*/ = processedwaitingQueue.shiftDoAll();
				var len:int = 0;
				for each (var queuEntry:QueueEntry in doAll)
					if(len < queuEntry.transaction.length)
						len = queuEntry.transaction.length;
				if(len > 1)
				{
					var ongoingPlayers:Array = getOngoingPlayerIds()
					var tempWaitingQueue:MessagQueue = new MessagQueue(ongoingPlayers.length,ongoingPlayers);
					for (var i:int = 0;i<doAll.length;i++)
					{
						queueEntry = doAll[i];
						for each (msg in queueEntry.transaction.messageArray)
						{
							tempWaitingQueue.push(new QueueEntry(queueEntry.user,new Transaction([msg]),queueEntry.timeRecived));
						}	
					}
					serverEntries = processQueue(tempWaitingQueue,true);
				}
				else if(len == 1)
				{
					if((!checkDoAlls(doAll)) || bGameEnded) return [];
					serverEntries =	processMessage(queuEntry.transaction.messageArray[0]);
					if(!isTransaction)
						addToQue(queuEntry);
				}
				else
				{
					return [];
				}
			}
			else 
			{
				if(!isTransaction)
					queueTimer.reset();
				return [];
			}
			queueTimer.reset();
			queueTimer.start();
			if(serverEntries.length > 0)
			{
				if(isTransaction)
				{
					 
					return serverEntries.concat(processQueue(processedwaitingQueue,isTransaction));
				}
				else
				{
					sendStateChanged(serverEntries);
					deltaHistory.addDelta(getOngoingPlayerIds(),serverEntries,getTimer()-matchStartTime);
					showHistory();
				}		

			}
			showWaitingFunctionQue();
			if(isTransaction)
				return processQueue(processedwaitingQueue,isTransaction);	
			else
				processQueue(processedwaitingQueue,isTransaction);		
			return [];

		}
		private function addToQue(queueEntry:QueueEntry):void
		{
			for each(var msg:API_Message in queueEntry.transaction.messageArray)
			{
				if (!((msg is API_DoAllSetTurn) || (msg is API_DoAllRequestStateCalculation) ))
				{
					var waitingFunction:WaitingFunction = new WaitingFunction(queueEntry.user,msg,getOngoingPlayerIds())
					unverifiedQueue.push(waitingFunction);
					showUnverifiedQue();
				}
			}	
		}
		private function verefyAction(user:User):void
		{
			for each(var unverifiedFunction:WaitingFunction in unverifiedQueue)
			{
				var userIndex:int = unverifiedFunction.unverifiedUsers.indexOf(user.ID);
				if(userIndex != -1)
				{
					unverifiedFunction.unverifiedUsers.splice(userIndex,1);	
					if(unverifiedFunction.unverifiedUsers.length == 0)	
						actionVerefied();
					return;
				}
			}	
		}
		private function actionVerefied():void
		{
			
			var waitingFunction:WaitingFunction=unverifiedQueue.shift();
			showUnverifiedQue();
			processQueue(waitingQueue,false);	
		}
		private function checkDoAlls(doAllArray:Array/*QueueEntry*/):Boolean
		{

			var queueEntry:QueueEntry = doAllArray[0];
			var msg:API_Message = queueEntry.transaction.messageArray[0];
			
			var checkedMsg:API_Message;
			for each(var checkedQueueEntry:QueueEntry in doAllArray)
			{
				checkedMsg = checkedQueueEntry.transaction.messageArray[0];
				if(checkedMsg.getMethodName() != msg.getMethodName())		
				{
					errorHandler(checkedQueueEntry.user.Name + " : called " + checkedMsg.getMethodName() + "\n while " + queueEntry.user.Name+" : called  "+ msg.getMethodName())
					gameOver();
					return false;
				}
				
				if(!ObjectDictionary.areEqual(checkedMsg.getMethodParameters(),msg.getMethodParameters()))
				{
					errorHandler(checkedMsg.getMethodName()+" : "+checkedMsg.getMethodParameters()+" is diffrent then "+msg.getMethodName()+" : "+msg.getMethodParameters());
					gameOver();
					return false
				}
			}
			return true;
		}
		private function doShuffleOn(serverEntryArray:Array/*ServerEntry*/,key:Object):ServerEntry
		{
			var serverEntryCopy:ServerEntry = serverEntryArray[0] as ServerEntry;
			var serverEntry:ServerEntry = ServerEntry.create(key,serverEntryCopy.value,-1,[],serverEntryCopy.changedTimeInMilliSeconds);
			return serverEntry;
		}
		//do all function's
		private function doAllStoreState(msg:API_DoAllStoreState):Array/*ServerEntry*/
		{
			var serverEntries:Array =/*ServerEntry*/ new Array();
			if (msg.userEntries.length == 0)
			{
				errorHandler("doAllStoreState must get at least 1 UserEntry");
				gameOver();
				return [];
			}
			for each(var userEntry:UserEntry in msg.userEntries)
			{
				if(userEntry.isSecret)
					serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,-1,[],getTimer()-matchStartTime));
				else
					serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,-1,null,getTimer()-matchStartTime));
			}
			return serverEntries;
		}
		private function doAllStoreStateCalculation(msg:API_DoAllStoreStateCalculation):Array/*ServerEntry*/
		{
			var serverEntries:Array =/*ServerEntry*/ new Array();
			if (msg.userEntries.length == 0)
			{
				errorHandler("doAllStoreStateCalculation must get at least 1 UserEntry");
				gameOver();
				return [];
			}
			
			for each(var userEntry:UserEntry in msg.userEntries)
			{
				if(userEntry.isSecret)
					serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,-1,[],getTimer()-matchStartTime));
				else
					serverEntries.push(ServerEntry.create(userEntry.key,userEntry.value,-1,null,getTimer()-matchStartTime));
			}
			return serverEntries;
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
					errorHandler("Key " + key + " does not exist");
					gameOver();
					return;
				}
			}
			// todo : send only to calculators
			if(calculatorQueue == null) errorHandler("To call doAllRequestStateCalculations you must enable calculators");
			var execptCalculator:int = Math.random()*3
			for(var i:int=0;i<3;i++)
			{
				if(i!=execptCalculator)
				{
					if ( calculatorQueue[i] != null) errorHandler("can't call a new calculation before finishing the first");
					var user:User = aCalculators[i];
					calculatorQueue[i] = stateCalculationsID;
					user.sendMessage(API_GotRequestStateCalculation.create(stateCalculationsID++,serverEntries));
				}
			}
			//broadcast(API_GotRequestStateCalculation.create(stateCalculationsID++,serverEntries));
		}
		private function doAllShuffleState(msg:API_DoAllShuffleState):Array/*ServerEntry*/
		{
			if (msg.keys.length < 2)
			{
				errorHandler("doAllShuffleState must get at least 2 keys");
				gameOver();
				return [];
			}
			
			
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
					errorHandler("Can't shuffle " + JSON.stringify(key) + " key does not exist");
					gameOver();
					return [];		
				}
			}			

			var serverEntry:ServerEntry;
			var serverEntries:Array =new Array/*ServerEntry*/
			var shuffleIndex:int;
			while(serverStateValues.length > 0)
			{
				shuffleIndex=Math.floor(Math.random()*serverStateValues.length)
				serverEntry=doShuffleOn(serverStateValues.splice(shuffleIndex,1),serverStateKeys.shift());
				serverEntries.push(serverEntry);
			}
			return serverEntries;

		}
		private function doAllRevealState(msg:API_DoAllRevealState):Array/*ServerEntry*/
		{
			if (msg.revealEntries.length == 0)
			{	
				errorHandler("doAllRevealState must get at least 1 RevealEntry");
				gameOver();
				return [];
			}
			
			var stateData:ServerEntry;
			var serverEntries:Array=new Array();
			var serverEntry:ServerEntry;
			var key:Object;
			var tempServerEntry:ServerEntry
			for each(var revealEntry:RevealEntry in msg.revealEntries)
			{
				key=revealEntry.key
				for(var i:int=0;i<=revealEntry.depth;i++)	
				{			
					if(serverState.hasKey(key))	
					{
						stateData = serverState.getValue(key) as ServerEntry;
						if(revealEntry.depth > i)
						{	
							if(serverState.hasKey(stateData.value))
							{
								tempServerEntry = revealEntryToPlayers(stateData,revealEntry);
								if(tempServerEntry != null)
									serverEntries.push(tempServerEntry);
								key = stateData.value;
							}
						}
						else
						{
							tempServerEntry = revealEntryToPlayers(stateData,revealEntry);
							if(tempServerEntry != null)
								serverEntries.push(tempServerEntry);
						}
					}
					else
					{
						errorHandler("Can't reveal " + JSON.stringify(key) + " key does not exist");
						gameOver();
						return [];		
					}
				}
			}				
			return serverEntries;
		}
		private function doAllRequestRandomState(msg:API_DoAllRequestRandomState):Array/*ServerEntry*/
		{
			var serverEntry:ServerEntry = new ServerEntry();
			var randomSeed:int=int.MAX_VALUE*Math.random();	
			if(msg.isSecret)
				serverEntry = ServerEntry.create(msg.key,randomSeed,-1,[],getTimer()-matchStartTime);
			else
				serverEntry = ServerEntry.create(msg.key,randomSeed,-1,null,getTimer()-matchStartTime);
			return [serverEntry];
		}
		private function doAllEndMatch(msg:API_DoAllEndMatch):void
		{
			if (msg.finishedPlayers.length == 0)
			{
				
				errorHandler("doAllEndMatch must get at least 1 PlayerMatchOver");
				gameOver();
				return;
			}		
			var tempFinishedPlayersIds:Array=new Array();
			var finishedPlayers:Array = msg.finishedPlayers;
			var finishedPart:FinishHistory=new FinishHistory();
			var percentageOfPot:Number=0;
			
			for each(var palyerMatchOver:PlayerMatchOver in finishedPlayers)
			{
				FinishHistory.totalFinishingPlayers++;
				tempFinishedPlayersIds.push(palyerMatchOver.playerId);
				waitingQueue.removePlayer(palyerMatchOver.playerId);
				percentageOfPot+=palyerMatchOver.potPercentage;
				finishedPart.finishedPlayers.push(palyerMatchOver)	
			}
			finishedPart.pot=FinishHistory.wholePot;
			FinishHistory.wholePot-=(FinishHistory.wholePot*percentageOfPot)/100;
			afinishedPlayers.push(finishedPart);
			deltaHistory.addPlayerMatchOver(getOngoingPlayerIds(),finishedPart,getTimer()-matchStartTime);
			broadcast(API_GotMatchEnded.create(tempFinishedPlayersIds));
			if (aPlayers.length == FinishHistory.totalFinishingPlayers)
				gameOver();
			showMatchOver();
			showHistory();
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
		public function getOngoingPlayerIds():Array/*int*/ {
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
				else if(tempServerState.visibleToUserIds.indexOf(u.ID) != -1)
					serverEntry = ServerEntry.create(tempServerState.key,tempServerState.value,tempServerState.storedByUserId,tempServerState.visibleToUserIds,tempServerState.changedTimeInMilliSeconds);				
				else
					serverEntry = ServerEntry.create(tempServerState.key,null,tempServerState.storedByUserId,tempServerState.visibleToUserIds,tempServerState.changedTimeInMilliSeconds);
				stateEntries.push(serverEntry);
			}
	
			u.sendOperation(API_GotMatchStarted.create(aPlayers,finished_player_ids,stateEntries));			
		}
		
		public function addMessageLog(user:String, funcname:String, message:String):void {
			
			if(isLoging)
			{
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
			
		}
		
		private function onConnectionStatus(evt:StatusEvent):void {
			switch(evt.level) {
				case "error":
					errorHandler("There is a LocalConnection error. Please test your game only inside the Come2Play emulator.");
			}
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
						"match_state: " + evt.target.selectedItem[COL_matchState];

				break;
				case 7:
				txtInfo.text = "Sending user Id : " + evt.target.selectedItem[COL_User]+ "\n" +
				" Method Name : " + evt.target.selectedItem[COL_MethodName] + "\n" +
				"Parameters : " + evt.target.selectedItem[COL_Parameters];
							
				break;
				case 8:
					if(!playByPlayTimer.running)
						changedToDelta = evt.target.selectedItem[COL_changeNum];
					txtInfo.text = "num: " + evt.target.selectedItem[COL_changeNum] + "\n" +
						"State Change time :"+ evt.target.selectedItem[COL_TimeSent] + "\n" +
						"Player_ID's: " + evt.target.selectedItem[COL_player_ids] + "\n" + 
						"Server Entries: " + evt.target.selectedItem[COL_serverEntries];
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
		
		private function btnLogClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("Log");
			pnlCommands.visible = false;
			goBackToHistory.visible = false;
			playByPlay.visible = false;
			logingCheckBox.visible = true;
			pnlLog.visible = true;
			pnlInfo.visible=false;
			iInfoMode=0;
		}
		
		private function btnCommandsClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("Command");
			pnlCommands.visible = true;
			logingCheckBox.visible = false;
			playByPlay.visible = false;
			goBackToHistory.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=false;
			iInfoMode=0;
		}


		private function btnMatchStateClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("MatchState");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			playByPlay.visible = false;
			goBackToHistory.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=1){
				iInfoMode=1;
				
				tblInfo.columns=[COL_player_ids,COL_key,COL_data];
				
				showMatchState();
			}
		}
		
		
		private function btnGeneralInfoClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("CustomInfo");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			goBackToHistory.visible = false;
			playByPlay.visible = false;
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
			goBackToHistory.visible = false;
			playByPlay.visible = false;
			logingCheckBox.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=7){
				iInfoMode=7;
				
				tblInfo.columns=[COL_User,COL_MethodName,COL_Parameters];
				
				showUnverifiedQue();
			}
		}
		private function btnUserCall(ev:MouseEvent):void
		{
			tbsPanel.gotoAndStop("UserCallQueue");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			playByPlay.visible = false;
			goBackToHistory.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=2){
				iInfoMode=2;
				
				tblInfo.columns=[COL_User,COL_Message];
				showWaitingFunctionQue();
			}
		}
		
		private function btnUserInfoClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("UserInfo");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			playByPlay.visible = false;
			goBackToHistory.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=4){
				iInfoMode=4;
				
				tblInfo.columns=[COL_player_ids,COL_key,COL_data];
				
				showUserInfo();
			}
		}
		

		private function btnMatchOverClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("MatchOver");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			playByPlay.visible = false;
			goBackToHistory.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=5){
				iInfoMode=5;
				
				tblInfo.columns=[COL_player_ids, COL_scores , COL_pot_percentages,COL_total_pot_percentages];
				
				showMatchOver();
			}
		}
		
		private function btnSavedGamesClick(ev:MouseEvent):void {
			tbsPanel.gotoAndStop("SavedGames");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			goBackToHistory.visible = false;
			playByPlay.visible = false;
			pnlLog.visible = false;
			pnlInfo.visible=true;
			if(iInfoMode!=6){
				iInfoMode=6;	
				tblInfo.columns=[COL_name,COL_numberOfPlayers, COL_userIdThatAreStillPlaying,COL_matchState];
				showSavedGames();
			}
		}
		private function btnHistoryClick(ev:MouseEvent):void
		{
			tbsPanel.gotoAndStop("History");
			pnlCommands.visible = false;
			logingCheckBox.visible = false;
			playByPlay.visible = true;
			pnlLog.visible = false;
			goBackToHistory.visible = true;
			pnlInfo.visible=true;
			if(iInfoMode!=8){
				changedToDelta = -1;
				iInfoMode=8;	
				tblInfo.columns=[COL_changeNum,COL_TimeSent,COL_player_ids,COL_serverEntries];
				showHistory();
			}	
		}

		private function startGame():void
		{	
			matchStartTime=getTimer();		
			bGameStarted = true;
			bGameEnded = false;
			btnNewGame.visible = false;
			btnCancelGame.visible = true;
			btnSaveGame.visible = true;
			btnLoadGame.visible = false;
			unverifiedQueue=new Array();
			FinishHistory.totalFinishingPlayers=0;
			FinishHistory.wholePot=100;
			iCurTurn=-1;
			waitingQueue = new MessagQueue(aPlayers.length,getOngoingPlayerIds());
			if(loadedServerEntries != null)
			{
				serverState = loadedServerEntries;
				loadedServerEntries = null
			}
			for each (var usr:User in aUsers) {
				send_got_match_started(usr);						
			}
			
		}
		private function stopPlayByPlayTimer():void
		{
			if(changedToDelta == deltaHistory.gameTurns.length)
				changedToDelta--; 
			playByPlayTimer.stop();
			playByPlay.label = "Replay";
			goBackToHistory.enabled = true;
		}
		
		
		private function doOneMove(ev:TimerEvent):void
		{
			var finishedPlayerIds:Array/*int*/ = new Array;
			var finishedPlayer:PlayerMatchOver
			if(changedToDelta < deltaHistory.gameTurns.length)
			{
				tblInfo.selectedIndex = changedToDelta;
				var playerDelta:PlayerDelta = deltaHistory.getDelta(changedToDelta);
				if (playerDelta.serverEntries.length > 0)
				{
					var serverEntries:Array/*ServerEntry*/ = playerDelta.serverEntries;
					storeServerEntries(serverEntries);
					sendStateChanged(serverEntries);
				}
				else if (playerDelta.finishHistory != null)
				{
					FinishHistory.wholePot -= playerDelta.finishHistory.pot;
					for each(finishedPlayer in playerDelta.finishHistory.finishedPlayers)
					{
						waitingQueue.removePlayer(finishedPlayer.playerId);
						finishedPlayerIds.push(finishedPlayer.playerId);
						FinishHistory.totalFinishingPlayers ++;
					}
					afinishedPlayers.push(playerDelta.finishHistory);
					broadcast(API_GotMatchEnded.create(finishedPlayerIds));
				}
				changeTimerTime();
				changedToDelta++;
			}
			else
				stopPlayByPlayTimer();
		}
		
		private function changeTimerTime():void
		{
			var nextTime:int = deltaHistory.getDeltaTime(changedToDelta+1) ;
			if(nextTime < 0)
			{
				stopPlayByPlayTimer();
				return;
			}
			nextTime -= (getTimer()-matchStartTime);
			if(nextTime > 0) 
			{
				playByPlayTimer.reset();
				playByPlayTimer.delay = nextTime;
				playByPlayTimer.start();
				
			}
			else
			{
				playByPlayTimer.reset();
				playByPlayTimer.delay = 25;
				playByPlayTimer.start();
			}

		}
		
		private function doPlayByPlay(ev:MouseEvent):void
		{
			if(changedToDelta == -1) return;
			if (playByPlayTimer.running)
			{
				stopPlayByPlayTimer();
			}
			else
			{	 
				goBackToHistory.enabled = false;			
				playByPlay.label = "Pause";
				if(!bGameEnded)
					gameOver();
				loadToDelta(changedToDelta);
				startGame();
				matchStartTime -= deltaHistory.getDeltaTime(changedToDelta);
				changeTimerTime();
				changedToDelta++;
				playByPlayTimer.start();
				
			}
		}
		
		public function loadToDelta(delta:int):void
		{
			/*
			the reason we save the endmatches as well is because we want to have the pot data
			*/
			var serverEntries:Array/*ServerEntry*/ = deltaHistory.getServerEntries(delta);
			afinishedPlayers = deltaHistory.getFinishedGames(delta); 
			aPlayers = deltaHistory.getPlayers(0)	
			FinishHistory.wholePot = 100;
			FinishHistory.totalFinishingPlayers = 0;
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
					
			serverState = new ObjectDictionary();
			for each(var severEntry:ServerEntry in serverEntries)
			{
				if(severEntry.value == null)
					serverState.remove(severEntry.key)
				else
					serverState.put(severEntry.key,severEntry);
			}	
		}

		private function doGoBack(ev:MouseEvent):void
		{	
			if(changedToDelta!=-1)
			{
				//general game state
				if(!bGameEnded)
					gameOver();
				loadToDelta(changedToDelta);
				startGame();
				pnlLoad.visible = false;
				pnlLoad.visible = false;
			//showMsg("History was restored","Message");
			}
		}
		private function showHistory():void
		{
			if(iInfoMode==8){
				tblInfo.removeAll();
				var itemObj:Object;
				
				var counter:int = 0;
				for each(var palyerDelta:PlayerDelta in deltaHistory.gameTurns)
				{
					itemObj=new Object();
					itemObj[COL_changeNum] =counter;
					itemObj[COL_TimeSent] = palyerDelta.changedTime;
					itemObj[COL_player_ids]=palyerDelta.playerIds;
					if(palyerDelta.serverEntries.length > 0 )
						itemObj[COL_serverEntries]=palyerDelta.serverEntries;
					else
						itemObj[COL_serverEntries]=palyerDelta.finishHistory;			
					tblInfo.addItem(itemObj);
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
					counter++;	
				}
				txtInfo.text="";
			}		
		}
		private function showUnverifiedQue():void
		{
			//todo : this should show stored queue and not unverefied queue
			if(iInfoMode==7){
				tblInfo.removeAll();
				var itemObj:Object;
				for each(var unverifiedFunction:WaitingFunction in unverifiedQueue)
				{
					itemObj=new Object();
					itemObj[COL_User]=unverifiedFunction.user.ID;
					itemObj[COL_MethodName]=unverifiedFunction.msg.getMethodName();
					itemObj[COL_Parameters]=unverifiedFunction.msg.getParametersAsString();
					tblInfo.addItem(itemObj);
					tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
				}
				txtInfo.text="";
			}
		}
		private function showWaitingFunctionQue():void
		{
			if(iInfoMode==2){
				tblInfo.removeAll();
				var itemObj:Object;
				for each(var waitingFunction:WaitingFunction in  waitingQueue)
				{
					itemObj=new Object();
					itemObj[COL_User] = waitingFunction.unverifiedUsers;
					itemObj[COL_Message] = waitingFunction.msg.toString();
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
					itemObj[COL_key]=JSON.stringify(tempServerEntry.key);
					itemObj[COL_data]=tempServerEntry.getParametersAsString();
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
				
				//var serverEntryOutput:Array;
				var serverStateKeys:Array;
				for each (var savedGame:SavedGame in allSavedGames) {
					try{
						if (savedGame.players.length <= User.PlayersNum && savedGame.gameName==root.loaderInfo.parameters["game"]) {
							var itemObj:Object;
							//serverEntryOutput=new Array();
							serverStateKeys = savedGame.serverState.getKeys();
							/*for each(var key:Object in serverStateKeys)
							{
								var tempServerEntry:ServerEntry = savedGame.serverState.getValue(key) as ServerEntry;
								serverEntryOutput.push(tempServerEntry)
							}*/
							itemObj=new Object();
							itemObj[COL_name]=savedGame.name;
							itemObj[COL_userIdThatAreStillPlaying]=savedGame.players;
							itemObj[COL_matchState]=savedGame.serverState.toString();
							tblInfo.addItem(itemObj);
							tblInfo.verticalScrollPosition = tblInfo.maxVerticalScrollPosition+30;
						}
					}catch (err:Error) {
						errorHandler(err.getStackTrace());
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
				errorHandler("Security Error ExternalInterface doesn't available. Please, check your security settings.");
			}
		}
		
		private function filterKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 13) {
				searchClick(null);
			}
		}
		
		private function btnCancelGameClick(evt:MouseEvent):void {
			gameOver();
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
			deltaHistory = savedGame.deltaHistory;
			afinishedPlayers = savedGame.finishedGames.concat();
			//aPlayers = savedGame.players.concat();
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
			showMatchState();
			showMatchOver();
			if (aPlayers.length >= savedGame.players.length) {
				startGame()
			}
			pnlLoad.visible = false;
			showMsg("Saved game was loaded","Message");
		}
		
		private function enableSavedGames():void {
			
		try{		
			var j:int = 0;			
			for each (var savedGame:SavedGame in allSavedGames) {
				if (savedGame.players.length <= User.PlayersNum && savedGame.gameName == root.loaderInfo.parameters["game"]) {
					j++;
				}
			}
			btnLoadGame.enabled = j>0;
			}catch(err:Error) {
				errorHandler("Contact come2Play")
				shrSavedGames.data.savedGames = [];	//this deletes all saved games
			}
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
			

			var game:SavedGame = SavedGame.create(serverState,aPlayers,afinishedPlayers,txtSaveName.text,root.loaderInfo.parameters["game"],deltaHistory);
			var transferByteArray:ByteArray = new ByteArray();
			transferByteArray.writeObject(game);
			transferByteArray.position = 0;
			var tempSaveGame:SavedGame = SerializableClass.deserialize(transferByteArray.readObject()) as SavedGame
			allSavedGames.push(tempSaveGame);
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
			/*if (aPlayers.length > User.PlayersNum) {
				return;
			}*/
			afinishedPlayers=new Array();
			serverState= new ObjectDictionary();
			deltaHistory = new DeltaHistory();
			showMatchState();
			showMatchOver();
			startGame();
		}
		//Do functions
		private function broadcast(msg:API_Message):void {
			if(bGameEnded) return;
			for each (var user:User in aUsers) {
				user.sendOperation(msg);
			}
		}	
		public function doRegisterOnServer(u:User):void {
			if (u.wasRegistered) errorHandler("User "+u.Name+" called do_register_on_server twice!");
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
			
			if (bGameStarted) 
			{
				send_got_match_started(u);
				return;
			}
			
			if(u.isPlayer)
				aPlayers.push(u.ID);
			if (aPlayers.length != User.PlayersNum) return;
		
			if(aCalculators == null)
					startGame();
			else if(calculatorsConnected())
					startGame();		
		}
		public function calculatorsConnected():Boolean
		{
			for each(var user:User in aCalculators)
			{
				if(!user.wasRegistered)
					return false;
			}
			return true;
		}
		public function storeServerEntries(serverEntries:Array/*ServerEntry*/):void
		{
			for each(var serverEntry:ServerEntry in serverEntries)
				doStoreOneState(serverEntry);
		}
		public function sendStateChanged(oldServerEntries:Array/*ServerEntry*/):void
		{
			var serverEntries:Array/*ServerEntry*/ = new Array
			var dicArray:Array = new Array();
			for(var i:int = (oldServerEntries.length -1);i>=0;i--)
			{
				var serverEntry:ServerEntry = oldServerEntries[i];
				if(dicArray[JSON.stringify(serverEntry.key)] == null)
				{
					dicArray[JSON.stringify(serverEntry.key)] = true;
					serverEntries.unshift(serverEntry);
				}
			}
			
			var tempServerEntries:Array/*ServerEntry*/;
			for each(var tempUser:User in aUsers)
			{
				tempServerEntries = new Array();
				for each(serverEntry in serverEntries)
				{
					if(serverEntry.visibleToUserIds == null)
						tempServerEntries.push(serverEntry);
					else if(serverEntry.visibleToUserIds.indexOf(tempUser.ID)!=-1)
						tempServerEntries.push(serverEntry);
					else
						tempServerEntries.push(ServerEntry.create(serverEntry.key,null,serverEntry.storedByUserId,serverEntry.visibleToUserIds,serverEntry.changedTimeInMilliSeconds));
					
				}
				tempUser.sendOperation(API_GotStateChanged.create(tempServerEntries));
			}
		}
		
		
		public function doStoreState(msg:API_DoStoreState,userId:int):Array/*ServerEntries*/{
			if (msg.userEntries.length == 0)
			{	
				errorHandler("doStoreState must get at least 1 UserEntry");
				gameOver();
				return null;
			}
			
			var serverEntries:Array=new Array();
			var serverEntry:ServerEntry;
			for each (var userEntry:UserEntry in msg.userEntries)
			{			
				if(userEntry.isSecret)
					serverEntry = ServerEntry.create(userEntry.key,userEntry.value,userId,[userId],getTimer()-matchStartTime);
				else
					serverEntry = ServerEntry.create(userEntry.key,userEntry.value,userId,null,getTimer()-matchStartTime);
				serverEntries.push(serverEntry);
			}
			return serverEntries;			
		}
		private function doStoreOneState(stateEntery:ServerEntry):void {		
			if (stateEntery.key == null) {
				errorHandler("Error: Can't store match state, key is empty");
				return;
			}
			if (serverState.size()>=1000) {
				errorHandler("Error: you stored more than a 1000 keys!");
				return;
			}
			//if(serverState.hasKey(stateEntery.key))
			//	serverState.remove(stateEntery.key);
			if(stateEntery.value == null)
				serverState.remove(stateEntery.key);
			else
				serverState.put(stateEntery.key,stateEntery);
			showMatchState();
		}
		public function doFoundHacker(user:User, msg:API_DoAllFoundHacker):void {
			showMsg(user.Name+" claimed he found a hacker:"+ msg.toString());
			addMessageLog("Server","doAllFoundHacker",user.Name+" claimed he found a hacker:"+ msg.toString());
			gameOver()
		}

		
		public function gameOver():void
		{
			queueTimer.stop();
			var tempPlayerIds:Array = getOngoingPlayerIds();
			for each (var usr:User in aUsers) {
				if (aPlayers.indexOf(usr.ID) != -1 && !usr.Ended) {;
					usr.Ended = true;
				}
			}


			if(tempPlayerIds.length > 0)
				broadcast(API_GotMatchEnded.create(tempPlayerIds));
			bGameEnded = true;
			btnNewGame.visible = true;
			btnCancelGame.visible = false;
			btnLoadGame.visible = true;
			btnSaveGame.visible = false;
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
				//user.do_finished_callback(methodName);
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
import emulator.auto_generated.API_DoStoreState;

class User extends LocalConnectionUser {
	//Private variables
	private var sServer:Server;
	private var iID:int;
	public var isPlayer:Boolean;
	private var sName:String;
	//private var actionQueue:Array/*WaitingFunction*/;
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
	public function User(prefix:int, _server:Server,isUser:Boolean) {
		try{
			var someMovieClip:MovieClip = _server; 
			sServer = _server;
			super(someMovieClip, true, String(prefix) ); 
			entries=new Array();
			if(!isUser)
			{
				sName = "Calculator"
				return;
			}
		
			if (iNextId > PlayersNum + ViewersNum) {
				sServer.errorHandler("Too many users");
			}
			var tempMod:int = iNextId++;
			iID = int(sServer.root.loaderInfo.parameters["val_" + (tempMod - 1)+"_0"]);		
			isPlayer = (sServer.root.loaderInfo.parameters["player_" +(tempMod-1)] == "true"	)
			sName = sServer.root.loaderInfo.parameters["val_" + (tempMod - 1)+"_1"];
			sName = sName.replace( /^\s+|\s+$/g, "");
			if (sName==null || sName == "") {
				if(isPlayer){
					sName = "Player" + (tempMod - 1);
				}else {
					sName = "Viewer" + (tempMod - PlayersNum - 1);
				}
			}
			
			var tempEntery:InfoEntry;
			tempEntery=new InfoEntry();
			tempEntery.key = "name";
			if(tempEntery.value !="")
				tempEntery.value = JSON.parse(sName);
			entries[0]=tempEntery;
			for (var i:int = 2; sServer.root.loaderInfo.parameters["col_" + i] != null;i++ ) {
				if(sServer.root.loaderInfo.parameters["val_" + (tempMod - 1)+"_"+ i] == "") continue;
				tempEntery=new InfoEntry();
				tempEntery.key = sServer.root.loaderInfo.parameters["col_" + i];
				tempEntery.value = JSON.parse(sServer.root.loaderInfo.parameters["val_" + (tempMod - 1)+"_"+ i]);	
				entries.push(tempEntery);
			}
			

			
		}catch (err:Error) {
			var msg:String = "Error: " + err.getStackTrace();
			if (sServer==null) 
				StaticFunctions.showError(msg);
			else
				sServer.errorHandler( msg);
		}
	}
	public function sendOperation(msg:API_Message):void {
		if (!wasRegistered) return;
		try {
    		sendMessage(msg);
			sServer.addMessageLog(sName, msg.getMethodName(), msg.getParametersAsString());	
		}catch(err:Error) { 
			sServer.errorHandler(err.getStackTrace());
		}  
    }
    override public function gotMessage(msg:API_Message):void {
		sServer.got_user_localconnection_callback(this, msg);
	}
	
	private function onConnectionStatus(evt:StatusEvent):void {
		switch(evt.level) {
			case "error":
				sServer.errorHandler("There is a LocalConnection error. Please test your game only inside the Come2Play emulator.");
		}
	}
}
class MessagQueue
{
	private var allPlayerMessages:Array/*Array*/;
	private var allPlayers:Array;
	private var serverPointer:Server;
	public function MessagQueue(playersNum:int,allPlayers:Array)
	{
		this.allPlayers = allPlayers.concat();
		allPlayerMessages = new Array();
		for (var i:int=0;i <playersNum;i++)
			allPlayerMessages[i] = new Array			
	}
	public function length():int
	{
		var longestQueue:int = 0;
		for each (var arr:Array in allPlayerMessages)
		{
			if(longestQueue < arr.length)
				longestQueue = arr.length;
		}
		return longestQueue;
	}
	public function getStuckMessage():QueueEntry
	{
		var stuckMessage:int = 0;
		var stuckMessageQueue:int = 0;
		for( var i:int;i<allPlayerMessages.length;i++)
		{
			var arr:Array = allPlayerMessages[i];
			if(stuckMessage < arr.length)
			{
				stuckMessage = arr.length;
				stuckMessageQueue = i;
			}
		}
		arr = allPlayerMessages[stuckMessageQueue];
		return arr.pop();
	}
	public function toString():String
	{
		var str:String ="";
		for each(var playerMessages:Array in allPlayerMessages)
		{
			for each(var queueEntry:QueueEntry in playerMessages)
			{
				str+="player :"+queueEntry.user.ID+"\n ";
				for each(var message:API_Message in queueEntry.transaction.messageArray)
				{
					str+=message.toString()+"\n ";
				}
			}
		}
		
		return str;
	}
	
	public function push(message:QueueEntry):void
	{
		var playerMessages:Array = allPlayerMessages[allPlayers.indexOf(message.user.ID)];
		if (playerMessages != null)
			playerMessages.push(message);
	}
	public function removePlayer(playerId:int):void
	{
		var pos:int = allPlayers.indexOf(playerId);
		allPlayers.splice(pos,1);
		allPlayerMessages.splice(pos,1);
	}
	public function unshift(message:QueueEntry):void
	{
		var playerMessages:Array = allPlayerMessages[allPlayers.indexOf(message.user.ID)];
		playerMessages.unshift(message);
	}
	public function shiftDoAll():Array
	{
		var doAllMessages:Array = new Array;
		//var ongoingPlayers:Array = serverPointer.getOngoingPlayerIds();
		for each (var playerMessages:Array in allPlayerMessages)
		{
			var tempQueueEntry:QueueEntry = playerMessages.shift();
			if(tempQueueEntry != null)
				doAllMessages.push(tempQueueEntry);
		}
		return doAllMessages;
	}
	public function head(userId:int):QueueEntry
	{
		var playerMessages:Array = allPlayerMessages[allPlayers.indexOf(userId)];
		return playerMessages[0];
	}
	public function shiftDoStore():QueueEntry
	{
		var firstIndex:int = 0;
		var tempQueueEntry:QueueEntry
		var firstQueueEntry:QueueEntry
		var playerMessages:Array/*QueueEntry*/;
		for(var i:int=0;i<allPlayerMessages.length;i++)
		{
			playerMessages = allPlayerMessages[i];
			tempQueueEntry = playerMessages[0];
			if(tempQueueEntry == null) continue;
			if(tempQueueEntry.transaction.containsDoAll) continue;
			if( (firstQueueEntry == null) || (firstQueueEntry.timeRecived > tempQueueEntry.timeRecived) )
			{
				firstQueueEntry = tempQueueEntry;
				firstIndex = i;
			}
		}
		playerMessages = allPlayerMessages[firstIndex];
		return playerMessages.shift();
	}
	public function waitingDoAll():Boolean
	{
		for each (var playerMessages:Array/*QueueEntry*/ in allPlayerMessages)	
		{
			var tempQueueEntry:QueueEntry = playerMessages[0];
			if(tempQueueEntry == null) 
				return false;
		}
		return true
	}
	public function waitingDoStore():Boolean
	{
		for each (var playerMessages:Array/*QueueEntry*/ in allPlayerMessages)	
		{
			var tempQueueEntry:QueueEntry = playerMessages[0];
			if(tempQueueEntry == null) continue;
			if(!tempQueueEntry.transaction.containsDoAll)
				return true;
		}
		return false;
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
	public var user:User;
	public var transaction:Transaction;
	public var timeRecived:int;
	public function QueueEntry(user:User,transaction:Transaction,timeRecived:int)
	{
		this.timeRecived = timeRecived;
		this.user = user;
		this.transaction = transaction;	
	}
	public function toString():String
	{
		return user.ID + " : " + transaction.toString();
	}
}
class Transaction
{
	public var messageArray:Array/*API_Message*/ = new Array;
	public var containsDoAll:Boolean;
	public function Transaction(messageArray:Array/*API_Message*/ )
	{
		containsDoAll = false;
		this.messageArray = messageArray;
		for each(var msg:API_Message in messageArray)
		{
			if(!(msg is API_DoStoreState))
			{
				containsDoAll = true;
			}
		}
	}
	public function get length():int
	{
		return messageArray.length;
	}
	public function toString():String
	{
		var str:String = "";
		for each(var msg:API_Message in messageArray)
		{
			str +="\n"+ msg.toString();
		}
		return str;
	}
}
class WaitingFunction{
	public var user:User;
	public var msg:API_Message;
	public var unverifiedUsers:Array;
	public function WaitingFunction(user:User,msg:API_Message,unverifiedUsers:Array)
	{
		this.user = user;
		this.msg = msg;
		this.unverifiedUsers = unverifiedUsers;
	}
}