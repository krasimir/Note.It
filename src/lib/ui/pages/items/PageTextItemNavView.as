package lib.ui.pages.items {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.ui.pages.graph.PageGraphView;
	import lib.ui.pages.NavView;
	import lib.controllers.events.ConfirmEvent;
	import com.krasimirtsonev.utils.Delegate;
	
	public class PageTextItemNavView extends NavView {
		
		public function PageTextItemNavView(id:String, isNewItem:Boolean):void {
			Debug.echo(isNewItem);
			
			_links = [];
			_links.push({action: "clock", events: [new GraphEvent(GraphEvent.SHOW_CLOCK_PAGE, {id: id})]});
			if(!isNewItem) {
				_links.push({action: "deleteItem", events: [new ConfirmEvent(ConfirmEvent.CONFIRM, {callback: Delegate.create(onDeleteItem, id)})]});
			}
			_links.push({action: "saveItem", events: [new GraphEvent(GraphEvent.SAVE_ITEM)]});
			_links.push({action: "cancel", events: [new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH)]});
			
			addIcons();
		}
		private function get className():String {
			return "PageTextItemNavView";
		}
		private function onDeleteItem(id:String):void {
			dispatchEvent(new GraphEvent(GraphEvent.DELETE_GRAPH_ITEM, id));
			dispatchEvent(new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH));
			dispatchEvent(new GraphEvent(GraphEvent.SAVE_GRAPH));
		}
	
	}

}