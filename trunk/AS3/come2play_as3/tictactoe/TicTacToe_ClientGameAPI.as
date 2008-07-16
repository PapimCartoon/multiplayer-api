package come2play_as3.tictactoe
{
import come2play_as3.api.*;
public final class TicTacToe_ClientGameAPI extends ClientGameAPI
{
	private var tictactoe:TicTacToe_graphic;
	private var my_user_id:int;
	private var isMyTurn:Boolean;
	
	public function TicTacToe_ClientGameAPI(tictactoe:TicTacToe_graphic, parameters:Object) {
		trace("TicTacToe_ClientGameAPI parameters="+parameters);
		super(parameters);
		this.tictactoe = tictactoe;
		tictactoe.addEventListener(TraceEvent.TRACE_EVENT, traceEvent);
		tictactoe.addEventListener(MatchStateEvent.MATCH_STATE_EVENT, matchStateEvent);
		tictactoe.addEventListener(GameOverEvent.GAME_OVER_EVENT, gameOverEvent);
		tictactoe.addEventListener(TurnChangedEvent.TURN_CHANGED_EVENT, turnChangedEvent);
		do_register_on_server();
	}
	override public function got_error(in_function_name:String, err:Error):void {
		trace("got_error in_function_name="+in_function_name+" err="+err+" stacktraces="+err.getStackTrace());
		do_client_protocol_error_with_description("Got error in function "+in_function_name+" err="+err+" stacktraces="+err.getStackTrace());
	}
	override public function got_my_user_id(my_user_id:int):void {
		this.my_user_id = my_user_id; 
	}
	override public function got_match_started(player_ids:Array/*int[]*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/):void {
		isMyTurn = false;
		tictactoe.got_match_started(player_ids, my_user_id, match_state);
	}
	override public function got_match_over(player_ids:Array/*int[]*/):void {
		tictactoe.got_match_over(player_ids);
	}		
	override public function got_stored_match_state(user_entry:UserEntry):void {
		tictactoe.got_stored_match_state(user_entry);
	}
	
	private function traceEvent(event:TraceEvent):void {
		do_store_trace(event.key, event.args);
	}
	private function matchStateEvent(event:MatchStateEvent):void {
		do_store_match_state(event.entry);
	}
	private function gameOverEvent(event:GameOverEvent):void {
		do_agree_on_match_over(event.finished_players);
	}
	private function turnChangedEvent(event:TurnChangedEvent):void {
		if (my_user_id==event.turn_of_player_id) {
			isMyTurn = true;
			do_start_my_turn();
		} else if (isMyTurn)
			do_end_my_turn([event.turn_of_player_id]);
	}		
}
}