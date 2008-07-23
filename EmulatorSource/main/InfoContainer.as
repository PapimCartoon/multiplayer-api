package main{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*;
	import fl.controls.*;
	import flash.text.*;
	import flash.external.*;
	import main.*;
	import flash.utils.setTimeout;

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
		private var lcServer:LocalConnection;
		private var aUsers:Array;
		private var txtUsers:TextField;
		private var txtTurn:TextField;
		private var txtSize:TextField;
		private var aParams:Array;
		private var pnlParams:MovieClip;
		private var btnSend:Button;
		private var loaded:Boolean = false;
		private var bStarted:Boolean = false;
		private var xmlFunctions:XML;
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
			var charCode:int = event.charCode;
			var keyCode:int = event.keyCode;
			var keyLocation:int = event.keyLocation;
			var altKey:Boolean = event.altKey;
			var ctrlKey:Boolean = event.ctrlKey;
			var shiftKey:Boolean = event.shiftKey;
			sendGotOperation("got_keyboard_event",[is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey]);				
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
			cmbCommands.addItem( { label:"do_agree_on_match_over", data:"do_agree_on_match_over" } );
			cmbCommands.addItem( { label:"do_start_my_turn", data:"do_start_my_turn" } );
			cmbCommands.addItem( { label:"do_end_my_turn", data:"do_end_my_turn" } );
			cmbCommands.addItem( { label:"do_client_protocol_error_with_description", data:"do_client_protocol_error_with_description" } );
			cmbCommands.addItem( { label:"do_store_match_state", data:"do_store_match_state" } );
			cmbCommands.addItem( { label:"do_send_message", data:"do_send_message" } );
			cmbCommands.addItem( { label:"do_set_timer", data:"do_set_timer" } );
			cmbCommands.addItem( { label:"do_store_trace", data:"do_store_trace" } );
			cmbCommands.addEventListener(Event.CHANGE, onCommandSelect);
			pnlInfo.addChild(cmbCommands);
			
			pnlParams = new MovieClip();
			pnlParams.x = 5;
			pnlInfo.addChild(pnlParams);
			
			txtTooltip = new TextField();
			txtTooltip.autoSize = TextFieldAutoSize.LEFT;
			pnlParams.addChild(txtTooltip);
			
			MsgBox = new MessageBox();
			
			aParams = new Array(3);
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
			txt.textColor = 0xFFFFFF;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.htmlText = "<b>|</b> Open Info";
			txt.height = 22;
			txt.x = -5;
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
			txt.textColor = 0xFFFFFF;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.htmlText = "<b>|</b> Close Info";
			txt.height = 22;
			txt.x = -5;
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
			txtMyName.textColor = 0xFFFFFF;
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
			sInnerPrefix = sOuterPrefix +"_"+ Math.floor(Math.random() * 1000000);
			lcInner = new LocalConnection();
			lcInner.client = this;
			lcInner.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcOuter = new LocalConnection();
			lcOuter.client = this;
			lcOuter.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcServer = new LocalConnection();
			lcServer.client = this;
			lcServer.addEventListener(StatusEvent.STATUS, onConnectionStatus);
			lcServer.connect("FRAMEWORK_SWF" + sInnerPrefix);
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, loaderComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderError);
			loader.load(new URLRequest(root.loaderInfo.parameters["xml"]));
			
			var from:int = parseInt(root.loaderInfo.parameters["delay_from"]);
			var to:int = parseInt(root.loaderInfo.parameters["delay_to"]);
			
			var ds:DelaySending = new DelaySending();
			ddsDoOperations = new DelayDoSomething(ds, from, to);
			ddsGotOperations = new DelayDoSomething(ds, from, to);
			
			resizeStage(null);
		}
		
		private function onConnectionStatus(evt:StatusEvent):void {
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
					rqst = new URLRequest(root.loaderInfo.parameters["old_container"]+"?prefix=" + sInnerPrefix + "&oldgame=" + root.loaderInfo.parameters["game"]);
				}
			}
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			ldr.load(rqst);
		}
		
		private function loaderComplete(evt:Event):void {
			try {
				xmlFunctions = new XML(evt.target.data);
			}catch(err:Error){ 
				do_store_trace("loaderComplete","Error: " + err.getStackTrace());
			}
		}
		
		private function loaderError(evt:IOErrorEvent):void {
			MsgBox.Show("Can't load XML file", "Error");
		}
		
		private function onLoadError(evt:IOErrorEvent):void {
			MsgBox.Show("Can't load game file", "Error");
		}
		
		private function onLoadComplete(evt:Event):void {
			loaded = true;
		}
		
		public function doSomething(obj:Object):void {
			
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
			switch(cmbCommands.selectedItem.data) {
				case "do_agree_on_match_over":
					prm = aParams[0];
					prm.Label = "user_ids:int[ ]";
					prm.visible = true;
					prm = aParams[1];
					prm.Label = "scores:int[]";
					prm.visible = true;
					prm = aParams[2];
					prm.Label = "pot_percentages:int[ ]";
					prm.visible = true;
					btnSend.y = 50 * 3+10;
					btnSend.visible = true;
					break;
				case "do_start_my_turn":
					btnSend.y = 50 * 0+10;
					btnSend.visible = true;
					break;
				case "do_end_my_turn":
					prm = aParams[0];
					prm.Label = "next_turn_of_player_ids:int[ ]";
					prm.visible = true;
					btnSend.y = 50 * 1+10;
					btnSend.visible = true;
					break;
				case "do_client_protocol_error_with_description":
					prm = aParams[0];
					prm.Label = "error_description:Object";
					prm.visible = true;
					btnSend.y = 50 * 1+10;
					btnSend.visible = true;
					break;
				case "do_store_match_state":
					prm = aParams[0];
					prm.Label = "key:String";
					prm.visible = true;
					prm = aParams[1];
					prm.Label = "data:Object";
					prm.visible = true;
					btnSend.y = 50 * 2+10;
					btnSend.visible = true;
					break;
				case "do_send_message":
					prm = aParams[0];
					prm.Label = "to_user_ids:int[ ]";
					prm.visible = true;
					prm = aParams[1];
					prm.Label = "data:Object";
					prm.visible = true;
					btnSend.y = 50 * 2+10;
					btnSend.visible = true;
					break;
				case "do_set_timer":
					prm = aParams[0];
					prm.Label = "key:String";
					prm.visible = true;
					prm = aParams[1];
					prm.Label = "in_seconds:int";
					prm.visible = true;
					prm = aParams[2];
					prm.Label = "pass_back:Object";
					prm.visible = true;
					btnSend.y = 50 * 3+10;
					btnSend.visible = true;
					break;
				case "do_store_trace":
					prm = aParams[0];
					prm.Label = "funcname:String";
					prm.visible = true;
					prm = aParams[1];
					prm.Label = "message:String";
					prm.visible = true;
					btnSend.y = 50 * 2+10;
					btnSend.visible = true;
					break;
			}
			
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
				switch(cmbCommands.selectedItem.data) {
					case "do_agree_on_match_over":
						prm = aParams[0];
						var user_ids:Array = JSON.parse(prm.Value) as Array;
						if (user_ids == null) {
							throw new Error("Can't convert user_ids to Array");
						}
						for (i = 0; i < user_ids.length; i++) {
							if (! user_ids[i] is int) {
								throw new Error("Can't convert user_ids[" + i + "] to int");
							}
						}
						prm.Value = JSON.stringify(user_ids);
						prm = aParams[1];
						var scores:Array = JSON.parse(prm.Value) as Array;
						if (scores == null) {
							throw new Error("Can't convert scores to Array");
						}
						for (i = 0; i < scores.length; i++) {
							if (! scores[i] is int) {
								throw new Error("Can't convert scores[" + i + "] to int");
							}
						}
						prm.Value = JSON.stringify(scores);
						prm = aParams[2];
						var pot_percentages:Array = JSON.parse(prm.Value) as Array;
						if (pot_percentages != null && !(pot_percentages is Array)) {
							throw new Error("Can't convert pot_percentages to Array");
						}
						if(pot_percentages!=null){
							for (i = 0; i < pot_percentages.length; i++) {
								if (! pot_percentages[i] is int) {
									throw new Error("Can't convert pot_percentages[" + i + "] to int");
								}
							}
						}
						prm.Value = JSON.stringify(pot_percentages);
						sendDoOperation("do_agree_on_match_over",[user_ids,scores,pot_percentages]);
						break;
					case "do_start_my_turn":
						sendDoOperation("do_start_my_turn",[]);
						break;
					case "do_end_my_turn":
						prm = aParams[0];
						var next_turn_of_players_ids:Array=JSON.parse(prm.Value) as Array;
						if (next_turn_of_players_ids != null && !(next_turn_of_players_ids is Array)) {
							throw new Error("Can't convert next_turn_of_players_ids to Array");
						}
						if(next_turn_of_players_ids.length!=-1){
							for (i = 0; i < next_turn_of_players_ids.length; i++) {
								if (! next_turn_of_players_ids[i] is int) {
									throw new Error("Can't convert next_turn_of_players_ids[" + i + "] to int");
								}
							}
						}
						prm.Value = JSON.stringify(next_turn_of_players_ids);
						sendDoOperation("do_end_my_turn",[next_turn_of_players_ids]);
						break;
					case "do_client_protocol_error_with_description":
						prm = aParams[0];
						var error_description:Object = JSON.parse(prm.Value);
						prm.Value = JSON.stringify(error_description);
						sendDoOperation("do_client_protocol_error_with_description", [error_description]);
						break;
					case "do_send_message":
						prm = aParams[0];
						var to_user_ids:Array = JSON.parse(prm.Value) as Array;
						if (to_user_ids != null && !(to_user_ids is Array)) {
							throw new Error("Can't convert to_user_ids to Array");
						}
						if(to_user_ids!=null){
							for (i = 0; i < to_user_ids.length; i++) {
								if (! to_user_ids[i] is int) {
									throw new Error("Can't convert to_user_ids[" + i + "] to int");
								}
							}
						}
						prm.Value = JSON.stringify(to_user_ids);
						prm = aParams[1];
						var data:Object = JSON.parse(prm.Value);
						prm.Value = JSON.stringify(data);
						sendDoOperation("do_send_message", [to_user_ids, data]);
						break;
					case "do_store_match_state":
						prm = aParams[0];
						var key:String = JSON.parse(prm.Value) as String;
						if (key == null) {
							throw new Error("Can't convert key to String");
						}
						prm.Value = JSON.stringify(key);
						prm = aParams[1];
						data = JSON.parse(prm.Value);
						prm.Value = JSON.stringify(data);
						sendDoOperation("do_store_match_state", [key, data]);
						break;
					case "do_set_timer":
						prm = aParams[0];
						key = JSON.parse(prm.Value) as String;
						if (key == null) {
							throw new Error("Can't convert key to String");
						}
						prm.Value = JSON.stringify(key);
						prm = aParams[1];
						var in_seconds:int = JSON.parse(prm.Value) as int;
						if (isNaN(in_seconds)) {
							throw new Error("Can't convert in_seconds to int");
						}
						if ((in_seconds >= 0 && in_seconds < 2) || in_seconds > 24 * 60 * 60) {
							throw new Error("in_seconds out of range");
						}
						prm.Value = JSON.stringify(in_seconds);
						prm = aParams[2];
						var pass_back:Object = JSON.parse(prm.Value);
						prm.Value = JSON.stringify(pass_back);
						sendDoOperation("do_set_timer",[key,in_seconds,pass_back]);
						break;
					case "do_store_trace":
						prm = aParams[0];
						var funcname:String = JSON.parse(prm.Value) as String;
						if (funcname == null) {
							throw new Error("Can't convert funcname to String");
						}
						prm.Value = JSON.stringify(funcname);
						prm = aParams[1];
						var message:String = JSON.parse(prm.Value) as String;
						if (message == null) {
							throw new Error("Can't convert message to String");
						}
						prm.Value = JSON.stringify(message);
						sendDoOperation("do_store_trace",[funcname,message]);
						break;
					default:
						return;
				}
				MsgBox.Show("The command was send", "Message");
			}catch (err:Error) {
				MsgBox.Show(err.message, "Error");
				do_store_trace("btnSendClick", "Error: " + err.getStackTrace());
			}
		}
		
		public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
			try{
				switch (methodName) {
				case "got_general_info":
				case "got_user_info":
				case "got_my_user_id":
				case "got_match_started":
				case "got_match_over":
				case "got_start_turn_of":
				case "got_end_turn_of":
				case "got_stored_match_state":
				case "got_message":
				case "got_timer":
				case "do_register_on_server":
				case "do_agree_on_match_over":
				case "do_store_match_state":
				case "do_start_my_turn":
				case "do_end_my_turn":
				case "do_store_trace":
				case "do_client_protocol_error_with_description":
				case "do_send_message":
				case "do_set_timer":
					(this[methodName] as Function).apply(this, parameters);
				}
			} catch (err:Error) { 
				MsgBox.Show(err.message, "Error");
			}
        }
		private function sendDoOperation(methodName:String, parameters:Array/*Object*/):void {
			ddsDoOperations.doSomething(new MessageToSend(sOuterDoChanel,methodName,parameters));
        }
		private function sendGotOperation(methodName:String, parameters:Array/*Object*/):void {
        	ddsGotOperations.doSomething(new MessageToSend(sInnerGotChanel,methodName,parameters));
        }
		
		//Got functions
		public function got_general_info(keys:Array, datas:Array):void {
			try {
				sendGotOperation("got_general_info", arguments);
			}catch(err:Error) { 
				do_store_trace("got_general_info","Error: " + err.getStackTrace());
			}
		}
		public function got_user_info(user_id:int, keys:Array, values:Array):void {
			try {
				sendGotOperation("got_user_info", arguments);
				var info:UserInfo = new UserInfo();
				info.userID = user_id;
				info.isPlayer = false;
				info.gameOver = false;
				for (var i:int = 0; i < keys.length; i++) {
					if (keys[i] == "nick_name") {
						info.userName = values[i];
					}
					if (keys[i] == "avatar_full_url") {
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
			}catch (err:Error) { 
				do_store_trace("got_user_info","Error: " + err.getStackTrace());
			}
		}
		public function got_my_user_id(my_user_id:int):void { 
			try {
				bStarted = true;
				iMyID = my_user_id;
				sendGotOperation("got_my_user_id", arguments);
			}catch(err:Error) { 
				do_store_trace("got_my_user_id","Error: " + err.getStackTrace());
			}
		}
		public function got_match_started(players_user_id:Array, extra_match_info:Object, match_started_time:int):void { 
			try {
				sendGotOperation("got_match_started", arguments);
				txtTurn.text = "";
				lblWait.visible = false;
				txtUsers.htmlText = "<b>Users:</b><br>";
				var j:int,str:String,u:UserInfo;
				for (var i:int = 0; i < aUsers.length; i++) {
					u = aUsers[i];
					str = u.userName + "(user_id=" + u.userID+", ";
					if (players_user_id.indexOf(u.userID) != -1) {
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
			}catch(err:Error) { 
				do_store_trace("got_match_started","Error: " + err.getStackTrace());
			}
		}
		public function got_stored_match_state(user_ids:Array, keys:Array, datas:Array):void { 
			try{
				sendGotOperation("got_stored_match_state", arguments);
			}catch(err:Error) { 
				do_store_trace("got_stored_match_state","Error: " + err.getStackTrace());
			}
		}
		public function got_match_over(user_ids:Array):void { 
			try {
				sendGotOperation("got_match_over", arguments);
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
			}catch(err:Error) { 
				do_store_trace("got_match_over","Error: " + err.getStackTrace());
			}
		}
		public function got_end_turn_of(user_id:int):void { 
			try{
				sendGotOperation("got_end_turn_of", arguments);
				txtTurn.text = "";
			}catch(err:Error) { 
				do_store_trace("got_end_turn_of","Error: " + err.getStackTrace());
			}
		}
		public function got_start_turn_of(user_id:int):void { 
			try {
				sendGotOperation("got_start_turn_of", arguments);
				var u:UserInfo = new UserInfo();
				for (var i:int = 0; i < aUsers.length; i++) {
					u = aUsers[i];
					if (u.userID == user_id) {
						txtTurn.text = u.userName + "'s turn";
					}
				}
			}catch(err:Error) { 
				do_store_trace("got_start_turn_of","Error: " + err.getStackTrace());
			}
		}
		public function got_message(user_id:int, data:Object):void {
			try{
				sendGotOperation("got_message", arguments);
			}catch(err:Error) { 
				do_store_trace("got_message","Error: " + err.getStackTrace());
			}
		}
		public function got_timer(from_user_id:int, key:String, in_seconds:int, pass_back:Object):void {
			try{
				sendGotOperation("got_timer", arguments);
			}catch(err:Error) { 
				do_store_trace("got_timer","Error: " + err.getStackTrace());
			}
		}
		
		//Do functions
		public function do_register_on_server(iChanel:int):void {
			try {
				sOuterDoChanel="DO_CHANEL"+sOuterPrefix+"_" + iChanel;
				sOuterGotChanel="GOT_CHANEL"+sOuterPrefix+"_" + iChanel;
				lcOuter.connect(sOuterGotChanel);
				sInnerDoChanel="DO_CHANEL"+sInnerPrefix+"_" + iChanel;
				sInnerGotChanel = "GOT_CHANEL" + sInnerPrefix + "_" + iChanel;
				lcInner.connect(sInnerDoChanel);
				ddsDoOperations.doSomething(new MessageToSend("FRAMEWORK_SWF" + sOuterPrefix,"do_register_on_server",arguments));
			}catch(err:Error) { 
				do_store_trace("do_register_on_server","Error: " + err.getStackTrace());
			}
		}
		public function do_agree_on_match_over(user_ids:Array, scores:Array, pot_percentages:Array):void {
			try {
				sendDoOperation("do_agree_on_match_over", arguments);
			}catch(err:Error) { 
				do_store_trace("do_agree_on_match_over","Error: " + err.getStackTrace());
			}
		}
		public function do_store_match_state(key:String, data:Object):void {
			try{
				sendDoOperation("do_store_match_state", arguments);
			}catch(err:Error) { 
				do_store_trace("do_store_match_state","Error: " + err.getStackTrace());
			}
		}
		public function do_start_my_turn():void {
			try{
				sendDoOperation("do_start_my_turn",arguments);
			}catch(err:Error) { 
				do_store_trace("do_start_my_turn","Error: " + err.getStackTrace());
			}
		}
		public function do_end_my_turn(next_turn_of_player_ids:Array):void {
			try{
				sendDoOperation("do_end_my_turn", arguments);
			}catch(err:Error) { 
				do_store_trace("do_end_my_turn","Error: " + err.getStackTrace());
			}
		}
		public function do_store_trace(funcname:String, message:String):void {
			try{
				sendDoOperation("do_store_trace", arguments);
			}catch (err:Error) { 
				trace(err.getStackTrace());
			}
		}
		public function do_client_protocol_error_with_description(error_description:Object):void {
			try{
				sendDoOperation("do_client_protocol_error_with_description", arguments);
				MsgBox.Show(error_description.toString(), "Error");
			}catch(err:Error) { 
				do_store_trace("do_client_protocol_error_with_description","Error: " + err.getStackTrace());
			}
		}
		public function do_send_message(to_user_ids:Array, data:Object):void {
			try {
				sendDoOperation("do_send_message",arguments);
			}catch(err:Error) { 
				do_store_trace("do_send_message","Error: " + err.getStackTrace());
			}
		}
		public function do_set_timer(key:String, in_seconds:int, pass_back:Object):void {
			try{
				sendDoOperation("do_set_timer", arguments);
			}catch(err:Error) { 
				do_store_trace("do_set_timer","Error: " + err.getStackTrace());
			}
		}
	}
}

import flash.net.*;

class DelaySending implements DoSomethingI {
	private var lcSend:LocalConnection;
	
	public function DelaySending() {
		lcSend = new LocalConnection();
	}
	
	public function doSomething(obj:Object):void {
		var msg:MessageToSend = obj as MessageToSend;
		lcSend.send(msg.channel, "localconnection_callback", msg.method, msg.args);
	}
}

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