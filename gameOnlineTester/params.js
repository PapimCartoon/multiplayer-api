function getRandomNum(){
	return Math.ceil(3000*Math.random())
}
function getRandomsupervisor(){
	var superLevel = Math.ceil(4*Math.random()-1);
	return supervisorLevels[superLevel];
}
function getRandomTokens(){
	return "0:"+Math.ceil(1000*Math.random())+","+"1:"+Math.ceil(300*Math.random())
}
function getOldBoard(game){
	return "../../svn/as3_old_boards/OldBoardContainer.swf?oldboard_swf=../../svn/as3_old_boards/boards/"+game+"_board.swf&game_type="+game+"&variant_str=&"
}
function getPlayerName(){
	var playerInit = Math.ceil(5*Math.random()-1);
	return playerInitial[playerInit];
}
function getPlayerId(){
	return Math.ceil(Math.random()*10000000);
}
function getPlayerAvatar(){
	return "images/Avatar_"+Math.ceil(Math.random()*4)+".gif";
}




var supervisorLevels = new Array("Admin","Supervisor","MiniSupervisor","NormalUser");
var playerInitial = new Array("player","שחקן","播放器","usuário","Hráč")
var oldBoardValues = new Array();
oldBoardValues.push({type:"gameName",gameName:"Sudoku"})
oldBoardValues.push({type:"variant",gameName:"Sudoku",variant:"9_Easy"})
oldBoardValues.push({type:"variant",gameName:"Sudoku",variant:"9_Normal"})
oldBoardValues.push({type:"variant",gameName:"Sudoku",variant:"9_Hard"})
oldBoardValues.push({type:"variant",gameName:"Sudoku",variant:"9_Extreme"})     

//oldBoardValues.push({type:"gameName",gameName:"FindWord"})
//oldBoardValues.push({type:"variant",gameName:"FindWord",variant:"hebrew"})
//oldBoardValues.push({type:"variant",gameName:"FindWord",variant:"english"})

//oldBoardValues.push({type:"gameName",gameName:"Puzzle"})
//oldBoardValues.push({type:"variant",gameName:"Puzzle",variant:"3_WorldTravel"})
//oldBoardValues.push({type:"variant",gameName:"Puzzle",variant:"5_ArtEntert"})
//oldBoardValues.push({type:"variant",gameName:"Puzzle",variant:"10_Food"})

oldBoardValues.push({type:"gameName",gameName:"Checkers"})
oldBoardValues.push({type:"variant",gameName:"Checkers",variant:"Israeli"})
oldBoardValues.push({type:"variant",gameName:"Checkers",variant:"International"})
oldBoardValues.push({type:"variant",gameName:"Checkers",variant:"Israeli_randomX70"})

oldBoardValues.push({type:"gameName",gameName:"BackGammon"})
oldBoardValues.push({type:"variant",gameName:"BackGammon",variant:"Original"})
oldBoardValues.push({type:"variant",gameName:"BackGammon",variant:"tapa"})
oldBoardValues.push({type:"variant",gameName:"BackGammon",variant:"Nackgammon"})

oldBoardValues.push({type:"gameName",gameName:"Go"})
oldBoardValues.push({type:"variant",gameName:"Go",variant:"9_5"})
oldBoardValues.push({type:"variant",gameName:"Go",variant:"9_6"})
oldBoardValues.push({type:"variant",gameName:"Go",variant:"13_5"})
oldBoardValues.push({type:"variant",gameName:"Go",variant:"13_6"})  
oldBoardValues.push({type:"variant",gameName:"Go",variant:"19_5"})  
oldBoardValues.push({type:"variant",gameName:"Go",variant:"19_6"})  
oldBoardValues.push({type:"variant",gameName:"Go",variant:"9_5_randomX70"})  

oldBoardValues.push({type:"gameName",gameName:"Chess"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Original"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Chess256"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Chess960"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Chess960x2"})  
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"ShuffleChess"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"CornerChess"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Dice"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Extintion"}) 
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Atomic"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"ThreeChecks"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Dice"})
oldBoardValues.push({type:"variant",gameName:"Chess",variant:"Dice_ThreeChecks_ShuffleChess_randomX70"})  

oldBoardValues.push({type:"gameName",gameName:"Reversi"})
oldBoardValues.push({type:"variant",gameName:"Reversi",variant:"Original"})
oldBoardValues.push({type:"variant",gameName:"Reversi",variant:"randomX70"})

//oldBoardValues.push({type:"gameName",gameName:"Simon"})
//oldBoardValues.push({type:"variant",gameName:"Simon",variant:"Original"})

oldBoardValues.push({type:"gameName",gameName:"Beatles"})
oldBoardValues.push({type:"variant",gameName:"Beatles",variant:"10_3"})
oldBoardValues.push({type:"variant",gameName:"Beatles",variant:"10_4"})

oldBoardValues.push({type:"gameName",gameName:"Blob"})
oldBoardValues.push({type:"variant",gameName:"Blob",variant:"Original"})
oldBoardValues.push({type:"variant",gameName:"Blob",variant:"randomX70"})

oldBoardValues.push({type:"gameName",gameName:"Connect4"})
oldBoardValues.push({type:"variant",gameName:"Connect4",variant:"Original"})
oldBoardValues.push({type:"variant",gameName:"Connect4",variant:"randomX70"})
       
var rewards = new Array();
rewards.push({oldStake:"1:",newStake:"1000001:",rewardInfoEntry:'{ $RewardInfo$ "id":1000001 , "name":"cool" , "imageURL":"Virtual_Drink_Martini.swf" , "value":111}'});
rewards.push({oldStake:"2:",newStake:"1000002:",rewardInfoEntry:'{ $RewardInfo$ "id":1000002 , "name":"cool" , "imageURL":"Virtual_Hat.swf" , "value":111}'});
rewards.push({oldStake:"3:",newStake:"1000003:",rewardInfoEntry:'{ $RewardInfo$ "id":1000003 , "name":"cool" , "imageURL":"Virtual_Ping.swf" , "value":111}'});
							



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
paramArr = new Array();
paramArr.push( {htmlName:"isYoavContainer",type:"boolean"});
//paramArr.push( {htmlName:"isOldBoard",type:"boolean"});
paramArr.push( {htmlName:"isDefaultroomXML",type:"boolean",connectedTo:"roomXML"});
paramArr.push( {htmlName:"isDefaultgameXML",type:"boolean",connectedTo:"gameXML"});

paramArr.push( {htmlName:"PlayersNumSim",type:"int"});
paramArr.push( {htmlName:"AutoMatch",type:"boolean"});
paramArr.push( {htmlName:"stake",xmlName:"override_config.game_parameters.FromTable.stakes",fromTable:"true",type:"string"});

paramArr.push( {htmlName:"MinPlayersNum",xmlName:"override_config.min_player_number",type:"int"});
paramArr.push( {htmlName:"MaxPlayersNum",xmlName:"override_config.max_player_number",type:"int",minValue:"MinPlayersNum"});
paramArr.push( {htmlName:"PlayersNum",xmlName:"override_config.players_number",type:"int",minValue:"MinPlayersNum"});
paramArr.push( {htmlName:"boardHeight",xmlName:"override_config.game_parameters.board_height",type:"int"});
paramArr.push( {htmlName:"boardWidth",xmlName:"override_config.game_parameters.board_width",type:"int"});
paramArr.push( {htmlName:"gameStageX",xmlName:"override_config.game_parameters.gameStageX",type:"int"});
paramArr.push( {htmlName:"gameStageY",xmlName:"override_config.game_parameters.gameStageY",type:"int"});

paramArr.push( {htmlName:"gameSwf",xmlName:"override_config.game_parameters.board_swf_url",type:"string"});


paramArr.push( {htmlName:"swfWidth",type:"string"});
paramArr.push( {htmlName:"swfHeight",type:"string"});
paramArr.push( {htmlName:"roomXML",xmlName:"config_url",type:"string",defultValue:"XML/config2.xml"});
paramArr.push( {htmlName:"gameXML",xmlName:"config_url",type:"string",defultValue:"XML/config2.xml"});


paramArr.push( {htmlName:"isVeteran",xmlName:"override_config.user_info.params.is_veteran_user",type:"boolean",isUser:true,colName:"is Veteran"});
paramArr.push( {htmlName:"isMale",xmlName:"override_config.user_info.params.is_male",type:"boolean",isUser:true,colName:"is Male"});
paramArr.push( {htmlName:"isGuest",xmlName:"override_config.user_info.params.is_guest",type:"boolean",isUser:true,colName:"is Guest"});
paramArr.push( {htmlName:"credibility",xmlName:"override_config.user_info.params.credibility",type:"int",isUser:true,callFunc:getRandomNum,colName:"Credibility"});
paramArr.push( {htmlName:"votes_sum",xmlName:"override_config.user_info.params.votes_sum",type:"int",isUser:true,callFunc:getRandomNum,colName:"Votes sum"});
paramArr.push( {htmlName:"votes_count",xmlName:"override_config.user_info.params.votes_count",type:"int",isUser:true,callFunc:getRandomNum,colName:"Votes count"});
paramArr.push( {htmlName:"avatar",xmlName:"override_config.user_info.params.avatar_url",type:"string",isUser:true,colName:"Avatar url",callFunc:getPlayerAvatar});
paramArr.push( {htmlName:"GameRating",xmlName:"override_config.user_info.params.game_rating",type:"int",isUser:true,callFunc:getRandomNum,colName:"Game rating"});
paramArr.push( {htmlName:"tokens",xmlName:"override_config.user_info.params.tokens",type:"string",isUser:true,callFunc:getRandomTokens,colName:"Tokens"});
paramArr.push( {htmlName:"supervisor",xmlName:"override_config.user_info.params.supervisor",type:"string",isUser:true,callFunc:getRandomsupervisor,colName:"Supervisor"});
paramArr.push( {htmlName:"name",xmlName:"override_config.user_info.params.name",type:"string",isUser:true,colName:"Name",callFunc:getPlayerName});
paramArr.push( {htmlName:"id",xmlName:"override_config.extra_args.user_id",type:"int",isUser:true,colName:"ID",callFunc:getPlayerId});

