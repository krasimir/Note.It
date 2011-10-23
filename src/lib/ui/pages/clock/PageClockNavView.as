package lib.ui.pages.clock {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.ui.pages.graph.PageGraphView;
	import lib.ui.pages.NavView;
	import lib.controllers.events.ConfirmEvent;
	import com.krasimirtsonev.utils.Delegate;
	
	public class PageClockNavView extends NavView {
		
		public function PageClockNavView(id:String):void {
			
			_links = [				
				{action: "clock", events: [new GraphEvent(GraphEvent.START_CLOCK)]},
				{action: "deleteItem", events: [new ConfirmEvent(ConfirmEvent.CONFIRM, {callback: Delegate.create(onDeleteItem, id)})]},
				{action: "editItem", events: [new GraphEvent(GraphEvent.SHOW_ITEM_TEXT_PAGE, {id: id})]},
				{action: "cancel", events: [new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH)]}
			];
			
			addIcons();
			
		}
		private function get className():String {
			return "PageClockNavView";
		}
		private function onDeleteItem(id:String):void {
			dispatchEvent(new GraphEvent(GraphEvent.DELETE_GRAPH_ITEM, id));
			dispatchEvent(new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH));
			dispatchEvent(new GraphEvent(GraphEvent.SAVE_GRAPH));
		}
	
	}

}