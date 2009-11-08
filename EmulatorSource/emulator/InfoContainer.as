package emulator {
	import emulator.auto_generated.*;
	
	import fl.controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
	public class InfoContainer extends MovieClip {
		private var ldr:Loader;
		private var gameWidth:int
		private var gameHeight:int
		private var randomMod:int
		private var pnlInfo:MovieClip;
		private var txtTooltip:TextField;
		private var sInnerPrefix:String;
		private var sOuterPrefix:String;
		private var sInnerDoChanel:String;
		private var sInnerGotChanel:String;
		private var sOuterDoChanel:String;
		private var sOuterGotChanel:String;
		private var connectionToGame:LocalConnectionImplementation;
		private var connectionToServer:LocalConnectionImplementation;
		private var aUsers:Array;
		private var txtUsers:TextField;
		private var txtTurn:TextField;
		private var txtSize:TextField;
		private var pnlParams:MovieClip;
		private var loaded:Boolean = false;
		private var bStarted:Boolean = false;
		private var btnStart:Button;
		private var iMyID:int;
		private var MsgBox:MessageBox;
		private var pnlBackground:MovieClip;
		private var lblWait:TextField;
		private var ddsDoOperations:DelayDoSomething;
		private var ddsGotOperations:DelayDoSomething;
		private var frameSprite:Sprite;	
		private var isPlaying:Boolean;
		private var messageQueue:Array;
		private var delayConstructor:Timer;
		
		private var userVisualInfo:UserVisualInfo;	//ron
	
		public function constructInfoContainer():void{
			messageQueue = new Array();
			stage.addEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.RESIZE, resizeStage);
			
			if (!isNaN(parseInt(root.loaderInfo.parameters["fps"]))) {
				stage.frameRate = parseInt(root.loaderInfo.parameters["fps"]);
			}

			lblWait = new TextField();
			lblWait.selectable = false;
			lblWait.text = "Waiting for opponent\s and Calculators...";
			lblWait.visible = false;
			lblWait.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(lblWait);
			if((root.loaderInfo.parameters["width"] != null) &&  (root.loaderInfo.parameters["height"] != null)){
				gameWidth = Number(root.loaderInfo.parameters["width"])
				gameHeight =Number(root.loaderInfo.parameters["height"])
			}
			frameSprite = new Sprite();
			randomMod = Math.round(Math.random() *80);
			frameSprite.graphics.lineStyle(2,0x0000ff);
			frameSprite.graphics.drawRect(0,0,gameWidth,gameHeight);
			frameSprite.x = 80 + randomMod;
			frameSprite.y = 30 + randomMod;
			this.addChild(frameSprite);
			
			
			//ron
			userVisualInfo = new UserVisualInfo(1, 1);
			this.addChild(userVisualInfo);
			
			ldr = new Loader();
			ldr.x = 80 + randomMod;
			ldr.y = 30 + randomMod;	
			this.addChild(ldr);
			pnlBackground = new MovieClip();
			this.addChild(pnlBackground);
			
			txtTurn = new TextField();
			txtTurn.selectable = false;
			txtTurn.autoSize = TextFieldAutoSize.LEFT;
			txtTurn.width = 150;
			txtTurn.height = 22;
			txtTurn.x = 150;
			txtTurn.y = 2;
			txtTurn.textColor = 0xe31e69;
			this.addChild(txtTurn);
			
			txtSize = new TextField();
			txtSize.autoSize = TextFieldAutoSize.LEFT;
			txtSize.y = 2;
			txtSize.height = 22;
			txtSize.textColor = 0xb9baba;
			this.addChild(txtSize);
			
			pnlInfo = new MovieClip();
			pnlInfo.visible = false;
			this.addChild(pnlInfo);
			
			txtUsers = new TextField();
			txtUsers.autoSize = TextFieldAutoSize.LEFT;
			txtUsers.width = 150;
			txtUsers.height = 22;
			txtUsers.y = 25;
			txtUsers.x = 5;
			txtUsers.htmlText = "<b>Users:</b><br>";
			txtUsers.multiline = true;
			pnlInfo.addChild(txtUsers);
			
			pnlParams = new MovieClip();
			pnlParams.x = 5;
			pnlInfo.addChild(pnlParams);
			
			txtTooltip = new TextField();
			txtTooltip.autoSize = TextFieldAutoSize.LEFT;
			pnlParams.addChild(txtTooltip);
			
			MsgBox = new MessageBox();

			var hit:MovieClip = new MovieClip();
			hit.graphics.beginFill(0x000000);
			hit.graphics.drawRect(0, 0, 70, 18);
			
			btnStart = new Button();
			btnStart.label = "Start";
			btnStart.textField.selectable = false;
			
			this.addChild(MsgBox);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, MsgBox.keyDown);
			
			if (root.loaderInfo.parameters["game"] == null) {
				MsgBox.Show("Parameter 'game' must be passed in the url.","Error");
				return;
			}		
			
			if (root.loaderInfo.parameters["prefix"] == null) {
				MsgBox.Show("Parameter 'prefix' must be passed in the url.","Error");
				return;
			}
			
			aUsers = new Array();
			
			sOuterPrefix = root.loaderInfo.parameters["prefix"];
			sInnerPrefix = sOuterPrefix +Math.floor(Math.random() * 10000);
			connectionToGame = new LocalConnectionImplementation(this,true,sInnerPrefix);
			connectionToServer = new LocalConnectionImplementation(this,false,sOuterPrefix);
						
			var fromDelay:int = parseInt(root.loaderInfo.parameters["delay_from"]);
			var toDelay:int = parseInt(root.loaderInfo.parameters["delay_to"]);
			
			
			ddsDoOperations = new DelayDoSomething(function (msg:API_Message):void { doSomething(msg, true) }, fromDelay, toDelay);
			ddsGotOperations = new DelayDoSomething(function (msg:API_Message):void { doSomething(msg, false) }, fromDelay, toDelay);
			
			
			if(root.loaderInfo.parameters["calculatorsOn"] == "true" ){
				//lblClient.text = "Calculator";
				if(root.loaderInfo.parameters["oldgame"]=="0"){
					var rqst:URLRequest = new URLRequest(root.loaderInfo.parameters["game"] + "?prefix=" + sInnerPrefix);
				}else {
					if(root.loaderInfo.parameters["old_container"] == null){
						rqst = new URLRequest("OldContainer_board.swf?prefix=" + sInnerPrefix + "&oldgame=" + root.loaderInfo.parameters["game"]);
					}else {
						var url:String = root.loaderInfo.parameters["old_container"];
						rqst = new URLRequest(url+(url.indexOf('?')!=-1 ? '&' : '?')+"prefix=" + sInnerPrefix + "&oldgame=" + root.loaderInfo.parameters["game"]);
					}
				}
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				ldr.load(rqst);
			}else{
				btnStart.addEventListener(MouseEvent.CLICK, btnStartClick);
				this.addChild(btnStart);
			}
			resizeStage(null);	
		}
		private function reportKeyUp(event:KeyboardEvent):void {
			reportKey(false, event);
		}
		private function reportKeyDown(event:KeyboardEvent):void {
			reportKey(true, event);
		}		
		private function reportKey(is_key_down:Boolean,event:KeyboardEvent):void {
			if (pnlInfo.visible) return;
			if(!isPlaying) return;
			var gotKeyboardEvent:API_GotKeyboardEvent = new API_GotKeyboardEvent();
			gotKeyboardEvent.altKey = event.altKey;
			gotKeyboardEvent.charCode = event.charCode;
			gotKeyboardEvent.ctrlKey = event.ctrlKey;
			gotKeyboardEvent.isKeyDown = is_key_down;
			gotKeyboardEvent.keyCode = event.keyCode;
			gotKeyboardEvent.keyLocation = event.keyLocation;
			gotKeyboardEvent.shiftKey = event.shiftKey;
			sendGotOperation(gotKeyboardEvent);
			
		}
		public function doTrace(msg:API_Message):void {	
			var doTrace:API_DoTrace = msg as API_DoTrace;
			sendDoOperation(doTrace);
		}
		public function nextMessage():void{
			if(messageQueue.length > 0){
				var messageToSend:API_Message = messageQueue[0];
				connectionToGame.sendMessage(messageToSend);
			}
		}
		
		
		public function doSomething(msg:API_Message, isServer:Boolean):void {
			if(isServer){
				connectionToServer.sendMessage(msg);
				if(msg is API_Transaction){
					var apiTransaction:API_Transaction = msg as API_Transaction;
					if(apiTransaction.callback != null){
						messageQueue.shift();
						nextMessage();
					}
				}
				//send message to server 
			}else{
				messageQueue.push(msg);
				if (messageQueue.length == 1)	nextMessage();
			}
		}
		public function onConnectionStatus(evt:StatusEvent):void {
			switch(evt.level) {
				case "error":
					trace("There is a LocalConnection error. Please test your game only inside the Come2Play emulator.");
			}
		}
		
		
		private function btnStartClick(evt:Event):void {
			if (!btnStart.visible) return;
			btnStart.visible = false;
			lblWait.visible = true;
			if(root.loaderInfo.parameters["oldgame"]=="0"){
				var rqst:URLRequest = new URLRequest(root.loaderInfo.parameters["game"] + "?prefix=" + sInnerPrefix);
			}else {
				if(root.loaderInfo.parameters["old_container"] == null){
					rqst = new URLRequest("OldContainer_board.swf?prefix=" + sInnerPrefix + "&oldgame=" + root.loaderInfo.parameters["game"]);
				}else {
					var url:String = root.loaderInfo.parameters["old_container"];
					rqst = new URLRequest(url+(url.indexOf('?')!=-1 ? '&' : '?')+"prefix=" + sInnerPrefix + "&oldgame=" + root.loaderInfo.parameters["game"]);
				}
			}
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			ldr.load(rqst);
		}
		
		private function onLoadError(evt:IOErrorEvent):void {
			MsgBox.Show("Can't load game file", "Error");
		}
		
		private function onLoadComplete(evt:Event):void {
			loaded = true;			
		}
		
		private function centerGraphic(graphic:DisplayObject):void{
			graphic.x =(gameWidth -graphic.width)/2 + ldr.x ;
			graphic.y = (gameHeight- graphic.height)/2 + ldr.y ;
		}
		private function resizeStage(evt:Event):void {
			centerGraphic(btnStart);
			centerGraphic(lblWait);
			txtSize.text = "Game Size: " + Math.round(stage.stageWidth) + "x" + Math.round(stage.stageHeight);
			txtSize.x = stage.stageWidth - txtSize.width - 13;
		}
		
		
        public function gotMessage(msg:API_Message,isServer:Boolean):void{
        	try{	
        		if(msg is API_GotCustomInfo){
					var CustomMessage:API_GotCustomInfo = msg as API_GotCustomInfo
					for each(var infoEntry:InfoEntry in CustomMessage.infoEntries){
						if(infoEntry.key == API_Message.CUSTOM_INFO_KEY_myUserId){
							bStarted = true;
							iMyID = infoEntry.value as int;
							break;
						}
					}	
					sendGotOperation(msg);
					return;
				}
				if (msg is API_GotMatchStarted){
					gotMatchStarted(msg as API_GotMatchStarted);		
				}else if(msg is API_GotUserInfo){
					gotUserInfo(msg as API_GotUserInfo);
				}else if(msg is API_GotMatchEnded){
					gotMatchEnded(msg as API_GotMatchEnded);
				}else if(msg is API_Transaction){
					var msg_transaction:API_Transaction = msg as API_Transaction;
					for each(var apiMsg:API_Message in msg_transaction.messages){
						if(apiMsg is API_DoAllSetTurn)	doAllSetTurn(apiMsg as API_DoAllSetTurn)
					}	
				}

				if (isServer){
					sendDoOperation(msg);
				}else{ 
					sendGotOperation(msg);
				}
			} catch (err:Error) { 
				MsgBox.Show(err.message, "Error: "+ err.getStackTrace());
			}	
        }
        
		private function sendDoOperation(msg:API_Message):void {
			ddsDoOperations.doSomething(msg);
        }
		private function sendGotOperation(msg:API_Message):void {
        	ddsGotOperations.doSomething(msg);
        }
		
		//Got functions
		public function gotUserInfo(msg:API_GotUserInfo):void {
				var info:UserInfo = new UserInfo();
				info.userID = msg.userId;
				info.isPlayer = false;
				info.gameOver = false;
				for (var i:int = 0; i < msg.infoEntries.length; i++) {
					var tempInfoEntry:InfoEntry = msg.infoEntries[i];
					if ( tempInfoEntry.key == "name") { // see BaseGameAPI.USER_INFO_KEY_name
						info.userName = String(tempInfoEntry.value);
					}
					if (tempInfoEntry.key == "avatar_url") { // see BaseGameAPI.USER_INFO_KEY_avatar_url
						info.userPicture = String(tempInfoEntry.value);
					}
				}
				aUsers.push(info);
				var str:String = info.userName + "(user_id=" + info.userID+")";
				if(bStarted){
					str=info.userName+"(user_id="+info.userID+", viewer)";
				}
				if(info.userID==iMyID){
					//lblClient.text = info.userName;
					userVisualInfo.userId = info.userID;
					userVisualInfo.userName = info.userName
					userVisualInfo.load( info.userPicture );	//ron
				}
				txtUsers.htmlText+=str + "<br>";
		}
		public function gotMatchStarted(msg:API_GotMatchStarted):void { 
			isPlaying =true;
			txtTurn.text = "";
			lblWait.visible = false;
			txtUsers.htmlText = "<b>Users:</b><br>";
			var j:int,str:String,u:UserInfo;
			for (var i:int = 0; i < aUsers.length; i++) {
				u = aUsers[i];
				str = u.userName + "(user_id=" + u.userID+", ";
				if (msg.allPlayerIds.indexOf(u.userID) != -1) {
					str += "player";
					u.isPlayer = true;
					u.gameOver = false;
				}else {
					str += "viewer";
					u.isPlayer = false;
					u.gameOver = false;
				}
				str += ")";
				txtUsers.htmlText+=str + "<br>";
			}
			matchOverForIds(msg.finishedPlayerIds);
		}
		private function matchOverForIds(user_ids:Array):void { 
			if(user_ids.indexOf(iMyID)!=-1){
				isPlaying = false;
				txtTurn.text = "Game over";
			}
			var u:UserInfo;
			var inGame:int = 0;
			for (var i:int = 0; i < aUsers.length; i++) {
				u = aUsers[i];
				if (user_ids.indexOf(u.userID) != -1) {
					u.gameOver = true;
				}
				if (u.isPlayer && !u.gameOver) {
					inGame++;
				}
			}
			if (inGame == 0) {
				txtTurn.text = "Game over";
			}
		}
		public function doAllSetTurn(msg:API_DoAllSetTurn):void{
			userVisualInfo.setTurn(iMyID == msg.userId);
		}
		
		public function gotMatchEnded(msg:API_GotMatchEnded):void { 
			matchOverForIds(msg.finishedPlayerIds);
			userVisualInfo.setTurn(false);
			
		}
		
		//Do functions
		public function do_client_protocol_error_with_description(error_description:Object):void {
			MsgBox.Show(error_description.toString(), "Error");
		}
		
	}
}

import flash.net.*;
import emulator.*;
import flash.events.StatusEvent;
import emulator.auto_copied.LocalConnectionUser;
import emulator.auto_generated.API_Message;

class LocalConnectionImplementation extends LocalConnectionUser
{
	private var prefix:String;
	private var isServer:Boolean;
	private var infoContainer:InfoContainer;
	public function LocalConnectionImplementation(infoContainer:InfoContainer, isServer:Boolean, prefix:String) {
		this.isServer = isServer;
		this.prefix = prefix;
		this.infoContainer = infoContainer;
		super(infoContainer,isServer,prefix,false);		
	}
	override public function gotMessage(msg:API_Message):void{
		infoContainer.gotMessage(msg, isServer);
	}
	public function toString():String
	{
		return "prefix: "+prefix+" isServer : "+isServer
	}
        
}

	
	
