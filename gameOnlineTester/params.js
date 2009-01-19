function getRandomNum(){
	return Math.ceil(3000*Math.random())
}
function getRandomsupervisor(){
	var superLevel = Math.ceil(3*Math.random());
	return supervisorLevels[superLevel];
}
function getRandomTokens(){
	return "0:"+Math.ceil(1000*Math.random())+","+"1:"+Math.ceil(300*Math.random())
}
function getOldBoard(game){
	return "../../svn/as2_old_boards/OldBoardContainer.swf?oldboard_swf=../../svn/as2_old_boards/boards/"+game+"_board.swf&game_type="+game+"&variant_str=&"
}

var supervisorLevels = new Array("Admin","Supervisor","MiniSupervisor","NormalUser");
paramArr = new Array();

customInit = new Array();
customInit.push({tableName:"serverTable",key:"chatType",value:"FIXED"})
customInit.push({tableName:"serverTable",key:"ARTIFICIAL_TO_JAVA_DELAY",value:"'1000-2000'"})
customInit.push({tableName:"serverTable",key:"ARTIFICIAL_FROM_JAVA_DELAY",value:"'1000-2000'"})
customInit.push({tableName:"serverTable",key:"isWithTables",value:"true"})

customInit.push({tableName:"gameTable",key:"Board Width",value:"12"})
customInit.push({tableName:"gameTable",key:"Mine Amount",value:"20"})

/*
availabel params :
htmlName - the name at which the value will appear in the html
xmlName - the name at which the value will be placed in the xml
type - the type of the value(String,int,boolean)
defultValue - values which have a defualt value should have a check box with the id  "isDefault"+htmlName that will decide if the defualt value is used
isUser - is the value refers to a user

*/
paramArr.push( {htmlName:"isYoavContainer",type:"boolean"});
paramArr.push( {htmlName:"isOldBoard",type:"boolean",connectedTo:"gameSwf"});
paramArr.push( {htmlName:"isDefaultroomXML",type:"boolean",connectedTo:"roomXML"});
paramArr.push( {htmlName:"isDefaultgameXML",type:"boolean",connectedTo:"gameXML"});

paramArr.push( {htmlName:"PlayersNumSim",type:"int"});
paramArr.push( {htmlName:"AutoMatch",type:"boolean"});

paramArr.push( {htmlName:"MinPlayersNum",xmlName:"override_config.min_player_number",type:"int"});
paramArr.push( {htmlName:"MaxPlayersNum",xmlName:"override_config.max_player_number",type:"int",minValue:"MinPlayersNum"});
paramArr.push( {htmlName:"PlayersNum",xmlName:"override_config.players_number",type:"int",minValue:"MinPlayersNum"});
paramArr.push( {htmlName:"boardHeight",xmlName:"override_config.game_parameters.board_height",type:"int"});
paramArr.push( {htmlName:"boardWidth",xmlName:"override_config.game_parameters.board_width",type:"int"});
paramArr.push( {htmlName:"gameStageX",xmlName:"override_config.game_parameters.gameStageX",type:"int"});
paramArr.push( {htmlName:"gameStageY",xmlName:"override_config.game_parameters.gameStageY",type:"int"});

paramArr.push( {htmlName:"gameSwf",xmlName:"override_config.game_parameters.board_swf_url",type:"string"});


paramArr.push( {htmlName:"oldBoard",type:"string"});
paramArr.push( {htmlName:"swfWidth",type:"string"});
paramArr.push( {htmlName:"swfHeight",type:"string"});
paramArr.push( {htmlName:"roomXML",xmlName:"config_url",type:"string",defultValue:"XML/config2.xml"});
paramArr.push( {htmlName:"gameXML",xmlName:"config_url",type:"string",defultValue:"XML/config2.xml"});


paramArr.push( {htmlName:"isMale",xmlName:"override_config.user_info.params.is_male",type:"boolean",isUser:true,colName:"is Male"});
paramArr.push( {htmlName:"isGuest",xmlName:"override_config.user_info.params.is_guest",type:"boolean",isUser:true,colName:"is Guest"});
paramArr.push( {htmlName:"credibility",xmlName:"override_config.user_info.params.credibility",type:"int",isUser:true,callFunc:getRandomNum,colName:"Credibility"});
paramArr.push( {htmlName:"votes_sum",xmlName:"override_config.user_info.params.votes_sum",type:"int",isUser:true,callFunc:getRandomNum,colName:"Votes sum"});
paramArr.push( {htmlName:"votes_count",xmlName:"override_config.user_info.params.votes_count",type:"int",isUser:true,callFunc:getRandomNum,colName:"Votes count"});
paramArr.push( {htmlName:"avatar",xmlName:"override_config.user_info.params.avatar_url",type:"string",isUser:true,colName:"Avatar url"});
paramArr.push( {htmlName:"GameRating",xmlName:"override_config.user_info.params.game_rating",type:"int",isUser:true,callFunc:getRandomNum,colName:"Game rating"});
paramArr.push( {htmlName:"tokens",xmlName:"override_config.user_info.params.tokens",type:"string",isUser:true,callFunc:getRandomTokens,colName:"Tokens"});
paramArr.push( {htmlName:"supervisor",xmlName:"override_config.user_info.params.supervisor",type:"string",isUser:true,callFunc:getRandomsupervisor,colName:"Supervisor"});
paramArr.push( {htmlName:"name",xmlName:"override_config.user_info.params.name",type:"string",isUser:true,colName:"Name"});
paramArr.push( {htmlName:"id",xmlName:"override_config.extra_args.user_id",type:"int",isUser:true,colName:"ID"});

