package lib.ui.pages.graph {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.Event;
	import lib.controllers.events.GraphEvent;
	import lib.ui.pages.NavView;
	
	public class PageGraphNavView extends NavView {
		
		public function PageGraphNavView():void {
			
			_links = [
				{action: "newGraphItem", events: [new GraphEvent(GraphEvent.REQUEST_FOR_NEW_GRAPH_ITEM)]}
			];
			
			addIcons();
			
		}
	}

}