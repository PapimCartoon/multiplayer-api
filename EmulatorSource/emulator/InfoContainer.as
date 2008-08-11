package emulator {
	import fl.controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;

	public class InfoContainer extends MovieClip {
		private var ldr:Loader;
		private var pnlInfo:MovieClip;
		private var cmbCommands:ComboBox;
		private var txtTooltip:TextField;
		private var sInnerPrefix:String;
		private var sOuterPrefix:String;
		private var sInnerDoChanel:String;
		private var sInnerGotChanel:String;
		private var sOuterDoChanel:String;
		private var sOuterGotChanel:String;
		private var lcInner:LocalConnection;
		private var lcOuter:LocalConnection;
		private var aUsers:Array;
		private var txtUsers:TextField;
		private var txtTurn:TextField;
		private var txtSize:TextField;
		private var aParams:Array;
		private var pnlParams:MovieClip;
		private var btnSend:Button;
		private var loaded:Boolean = false;
		private var bStarted:Boolean = false;
		private var btnStart:Button;
		private var iMyID:int;
		private var MsgBox:MessageBox;
		private var lblClient:Label;
		private var btnDown:SimpleButton;
		private var btnUp:SimpleButton;
		private var txtMyName:TextField;
		private var pnlBackground:MovieClip;
		private var lblWait:TextField;
		private var ddsDoOperations:DelayDoSomething;
		private var ddsGotOperations:DelayDoSomething;
		
		
		private function reportKeyUp(event:KeyboardEvent):void {
			reportKey(false, event);
		}
		private function reportKeyDown(event:KeyboardEvent):void {
			reportKey(true, event);
		}		
		private function reportKey(is_key_down:Boolean,event:KeyboardEvent):void {
			if (pnlInfo.visible) return;
			var charCode:int = event.charCode;
			var keyCode:int = event.keyCode;
			var keyLocation:int = event.keyLocation;
			var altKey:Boolean = event.altKey;
			var ctrlKey:Boolean = event.ctrlKey;
			var shiftKey:Boolean = event.shiftKey;
			sendGotOperation("got_keyboard_event",[is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey]);
			do_store_trace("got_keyboard_event", "is_key_down="+is_key_down+", charCode="+charCode+", keyCode="+keyCode+", keyLocation="+keyLocation+", altKey="+altKey+", ctrlKey="+ctrlKey+", shiftKey="+shiftKey);
		}
		public function do_store_trace(funcname:String, arg:String):void {
			sendDoOperation("do_store_trace", [funcname, arg]);
		}
		public function InfoContainer() {
			stage.addEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.RESIZE, resizeStage);
			
			if (!isNaN(parseInt(root.loaderInfo.parameters["fps"]))) {
				stage.frameRate = parseInt(root.loaderInfo.parameters["fps"]);
			}
			
			btnStart = new Button();
			btnStart.label = "Start";
			btnStart.addEventListener(MouseEvent.CLICK, btnStartClick);
			this.addChild(btnStart);
			
			lblWait = new TextField();
			lblWait.text = "Waiting for oponent...";
			lblWait.visible = false;
			lblWait.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(lblWait);
			
			ldr = new Loader();
			ldr.y = 23;
			ldr.x = 3;
			this.addChild(ldr);
			
			pnlBackground = new MovieClip();
			this.addChild(pnlBackground);
			
			txtTurn = new TextField();
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
			
			cmbCommands = new ComboBox();
			cmbCommands.setSize(150, 20);
			cmbCommands.x = 5;
			cmbCommands.prompt = "Send command";
			for each (var command_name:String in Commands.getCommandNames(false)) {
				cmbCommands.addItem( { label:command_name, data:command_name } );
			}
			cmbCommands.addEventListener(Event.CHANGE, onCommandSelect);
			pnlInfo.addChild(cmbCommands);
			
			pnlParams = new MovieClip();
			pnlParams.x = 5;
			pnlInfo.addChild(pnlParams);
			
			txtTooltip = new TextField();
			txtTooltip.autoSize = TextFieldAutoSize.LEFT;
			pnlParams.addChild(txtTooltip);
			
			MsgBox = new MessageBox();
			
			aParams = new Array(8);
			var prm:Param;
			for (var i:int = 0; i < aParams.length; i++) {
				prm = new Param(MsgBox,true);
				prm.visible = false;
				prm.y = i * 50+10;
				pnlParams.addChild(prm);
				aParams[i] = prm;
			}
			
			btnSend = new Button();
			btnSend.label = "Send";
			btnSend.visible = false;
			btnSend.addEventListener(MouseEvent.CLICK, btnSendClick);
			pnlParams.addChild(btnSend);
			
			lblClient = new Label();
			lblClient.x = 8;
			lblClient.y = 1;
			lblClient.height = 22;
			this.addChild(lblClient);
			
			var hit:MovieClip = new MovieClip();
			hit.graphics.beginFill(0x000000);
			hit.graphics.drawRect(0, 0, 70, 18);
			
			var mov:MovieClip = new MovieClip();
			var txt:TextField = new TextField();
			txt.textColor = 0x000000;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.htmlText = "<b>|</b> Open Info";
			txt.height = 22;
			txt.x = -15;
			txt.y = -3;
			mov.addChild(txt);
			var arr:MovieClip = new DownArrow();
			arr.x = 54;
			mov.addChild(arr);
			
			btnDown = new SimpleButton(mov, mov, mov, hit);
			btnDown.upState = mov;
			btnDown.hitTestState = hit;
			btnDown.y = 3;
			btnDown.x = 57;
			btnDown.addEventListener(MouseEvent.CLICK, btnDownClick);
			lblClient.addChild(btnDown);
			
			mov = new MovieClip();
			txt = new TextField();
			txt.textColor = 0x000000;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.htmlText = "<b>|</b> Close Info";
			txt.height = 22;
			txt.x = -15;
			txt.y = -3;
			mov.addChild(txt);
			arr = new UpArrow();
			arr.x = 54;
			mov.addChild(arr);
			
			btnUp = new SimpleButton(mov, mov, mov, hit);
			btnUp.upState = mov;
			btnUp.hitTestState = hit;
			btnUp.x = 57;
			btnUp.y = 3;
			btnUp.visible = false;
			btnUp.addEventListener(MouseEvent.CLICK, btnUpClick);
			lblClient.addChild(btnUp);
			
			txtMyName = new TextField();
			txtMyName.textColor = 0x000000;
			txtMyName.selectable = false;
			txtMyName.width = 55;
			txtMyName.height = 22;
			txtMyName.x = 3;
			lblClient.addChild(txtMyName);
			
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
			
						
			lcInner = new LocalConnection();
			lcInner.client = this;
			lcInner.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcOuter = new LocalConnection();
			lcOuter.client = this;
			lcOuter.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			
			sOuterDoChanel=Commands.getDoChanelString(sOuterPrefix);
			sOuterGotChanel=Commands.getGotChanelString(sOuterPrefix);
			lcOuter.connect(sOuterGotChanel);
			sInnerDoChanel=Commands.getDoChanelString(sInnerPrefix);
			sInnerGotChanel =Commands.getGotChanelString(sInnerPrefix);
			lcInner.connect(sInnerDoChanel);
			
			var fromDelay:int = parseInt(root.loaderInfo.parameters["delay_from"]);
			var toDelay:int = parseInt(root.loaderInfo.parameters["delay_to"]);
			
			ddsDoOperations = new DelayDoSomething(doSomething, fromDelay, toDelay);
			ddsGotOperations = new DelayDoSomething(doSomething, fromDelay, toDelay);
			
			resizeStage(null);
		}
		
		public function doSomething(obj:Object):void {
			var msg:MessageToSend = obj as MessageToSend;
			if (msg.channel!=null) lcInner.send(msg.channel, "localconnection_callback", msg.method, msg.args);
		}
		public function onConnectionStatus(evt:StatusEvent):void {
			switch(evt.level) {
				case "error":
					trace("There is a LocalConnection error. Please test your game only inside the Come2Play emulator.");
			}
		}
		
		private function btnDownClick(evt:MouseEvent):void {
			if(bStarted){
				btnDown.visible = false;
				btnUp.visible = true;
				pnlInfo.visible = true;
			}
		}
		
		private function btnUpClick(evt:MouseEvent):void {
			btnDown.visible = true;
			btnUp.visible = false;
			pnlInfo.visible = false;
		}
		
		private function btnStartClick(evt:Event):void {
			if (!btnStart.visible) {
				return;
			}
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
		
		private function onCommandSelect(evt:Event):void {
			btnSend.visible = false;
			txtTooltip.text = "";
			var prm:Param;
			for (var i:int = 0; i < aParams.length; i++) {
				prm = aParams[i];
				prm.Value = "";
				prm.y = i * 50+10;
				prm.visible = false;
				prm.Tooltip = "";
			}
			if(!loaded) {
				return;
			}

			var command_name:String = cmbCommands.selectedItem.data;
			var parameters:Array = Commands.findCommand(command_name);
			for (i=0; i<parameters.length; i++) {
				var param_name:String = parameters[i][0];
				var param_type:String = parameters[i][1];
				prm = aParams[i];
				prm.Label = param_name+":"+param_type;
				prm.visible = true;
			}
			btnSend.y = 50 * parameters.length + 10;
			btnSend.visible = true;

			/*
			tooltip code:
			var j:int;
			for (i = 0; i < xmlFunctions["func"].length(); i++) {
				if (xmlFunctions.func[i].name == cmbCommands.selectedItem.data) {
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
			}
			*/
		}
		
		private function resizeStage(evt:Event):void {
			var _x:int, _y:int;
			_x = stage.stageWidth - 20+2;
			_y = stage.stageHeight - 42+2;
			
			pnlBackground.graphics.clear();
			pnlBackground.graphics.beginFill(0xFFFFFF);
			pnlBackground.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			pnlBackground.graphics.lineStyle(1, 0xb9baba);
			pnlBackground.graphics.drawRect(2, 22, _x, _y);			
			pnlBackground.graphics.endFill();
			
			pnlInfo.graphics.clear();
			pnlInfo.graphics.lineStyle(1, 0x000000, 0);
			pnlInfo.graphics.beginFill(0x80BE40);
			pnlInfo.graphics.drawRect(2, 22,175,_y);
			pnlInfo.graphics.endFill();
			
			btnStart.x =(_x-btnStart.width)/2;
			btnStart.y = ((_y - 20) - btnStart.height) / 2 + 20;
            
			lblWait.x =(_x-lblWait.width)/2;
			lblWait.y = ((_y - 20) - lblWait.height) / 2 + 20;
			
			txtSize.text = "Game Size: " + Math.round(stage.stageWidth-20) + "x" + Math.round(stage.stageHeight-42);
			txtSize.x = stage.stageWidth - txtSize.width - 13;
		}
		
		
		private function btnSendClick(evt:MouseEvent):void {
			try{
				var prm:Param;
				var arr:Array,i:int;

				var command_name:String = cmbCommands.selectedItem.data;
				var args:Array = Commands.findCommand(command_name);
				var parameters:Array = [];
				for (i=0; i< args.length; i++) {
					var param:String = aParams[i].Value;
					var param_type:String = args[i][1];
					parameters.push( Commands.convertToType(param, param_type) );
				}
				sendDoOperation(command_name, parameters);

				MsgBox.Show("The command was send", "Message");
			}catch (err:Error) {
				MsgBox.Show(err.message, "Error");
				do_store_trace("btnSendClick", "Error: " + err.getStackTrace());
			}
		}
		
		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
			try{
				if (this.hasOwnProperty(methodName)) {
					var func:Function = this[methodName];
					func.apply(this, parameters);
				}

				if (methodName.substring(0,"got".length)=="got")
					sendGotOperation(methodName, parameters);
				else if (methodName.substring(0,"do".length)=="do") {
					sendDoOperation(methodName, parameters);
				} else throw Error("Illegal message prefix!");
				
				

			} catch (err:Error) { 
				MsgBox.Show(err.message, "Error: "+ err.getStackTrace());
			}
        }
		private function sendDoOperation(methodName:String, parameters:Array/*Object*/):void {
			ddsDoOperations.doSomething(new MessageToSend(sOuterDoChanel,methodName,parameters));
        }
		private function sendGotOperation(methodName:String, parameters:Array/*Object*/):void {
        	ddsGotOperations.doSomething(new MessageToSend(sInnerGotChanel,methodName,parameters));
        }
		
		//Got functions
		public function got_user_info(user_id:int, keys:Array, values:Array):void {
				var info:UserInfo = new UserInfo();
				info.userID = user_id;
				info.isPlayer = false;
				info.gameOver = false;
				for (var i:int = 0; i < keys.length; i++) {
					if (keys[i] == "name") { // see BaseGameAPI.USER_INFO_KEY_name
						info.userName = values[i];
					}
					if (keys[i] == "avatar_url") { // see BaseGameAPI.USER_INFO_KEY_avatar_url
						info.userPicture = values[i];
					}
				}
				aUsers.push(info);
				var str:String = info.userName + "(user_id=" + info.userID+")";
				if(bStarted){
					str=info.userName+"(user_id="+info.userID+", viewer)";
				}
				if(info.userID==iMyID){
					txtMyName.text = info.userName;
				}
				txtUsers.htmlText+=str + "<br>";
				cmbCommands.y = txtUsers.height + txtUsers.y + 5;
				pnlParams.y = cmbCommands.y + cmbCommands.height + 5;
		}
		public function got_my_user_id(my_user_id:int):void { 
				bStarted = true;
				iMyID = my_user_id;
		}
		public function 
				got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, 
				user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):void { 
				txtTurn.text = "";
				lblWait.visible = false;
				txtUsers.htmlText = "<b>Users:</b><br>";
				var j:int,str:String,u:UserInfo;
				for (var i:int = 0; i < aUsers.length; i++) {
					u = aUsers[i];
					str = u.userName + "(user_id=" + u.userID+", ";
					if (all_player_ids.indexOf(u.userID) != -1) {
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
				cmbCommands.y=txtUsers.height + txtUsers.y + 5;
				pnlParams.y = cmbCommands.y + cmbCommands.height + 5;
				
				matchOverForIds(finished_player_ids);
		}
		private function matchOverForIds(user_ids:Array):void { 
			if(user_ids.indexOf(iMyID)!=-1){
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
		public function got_match_over(user_ids:Array):void { 
			matchOverForIds(user_ids);
		}
		public function got_end_turn_of(user_id:int):void { 
			txtTurn.text = "";
		}
		public function got_start_turn_of(user_id:int):void { 
			var u:UserInfo = new UserInfo();
			for (var i:int = 0; i < aUsers.length; i++) {
				u = aUsers[i];
				if (u.userID == user_id) {
					txtTurn.text = u.userName + "'s turn";
				}
			}
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

class MessageToSend extends Object{
	public var channel:String;
	public var method:String;
	public var args:Array;
	
	public function MessageToSend(_channel:String,_method:String,_args:Array) {
		channel = _channel;
		method = _method;
		args = _args;
	}
}