package lib.ui.actions.icon {
	
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.controllers.events.ConfirmEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	
	public class ActionIconMediator extends Mediator {
		
		[Inject] public var view:ActionIconView;
		
		private function get className():String {
			return "ActionIconMediator";
		}
		public override function onRegister():void {
			eventMap.mapListener(view, GraphEvent.REQUEST_FOR_NEW_GRAPH_ITEM, dispatch, GraphEvent);
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_CLOCK, dispatch, PagesEvent);
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_GRAPH, dispatch, PagesEvent);
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_TEXT_ITEM, dispatch, PagesEvent);
			eventMap.mapListener(view, GraphEvent.SAVE_ITEM, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.START_CLOCK, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.CLOCK_POMODORO, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.CLOCK_INFO_WINDOW, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.STOP_CLOCK, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SHOW_CLOCK_PAGE, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SHOW_ITEM_TEXT_PAGE, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.DELETE_GRAPH_ITEM, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SAVE_GRAPH, dispatch, GraphEvent);
			eventMap.mapListener(view, ConfirmEvent.YES, dispatch, ConfirmEvent);
			eventMap.mapListener(view, ConfirmEvent.NO, dispatch, ConfirmEvent);
			eventMap.mapListener(view, ConfirmEvent.CONFIRM, dispatch, ConfirmEvent);
		}
	
	}

}