package lib.ui.pages.clock {
	
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.controllers.events.ConfirmEvent;
	
	public class PageClockNavMediator extends Mediator {
	
		[Inject] public var view:PageClockNavView;
		
		private function get className():String {
			return "PageClockNavMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_GRAPH, dispatch, PagesEvent);
			eventMap.mapListener(view, GraphEvent.DELETE_GRAPH_ITEM, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SAVE_GRAPH, dispatch, GraphEvent);
	
		}
	
	}

}