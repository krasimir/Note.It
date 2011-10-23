package lib.ui.pages.clock {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.ui.pages.graph.PageGraphView;
	import lib.ui.pages.NavView;
	
	public class PageClockOverNavView extends NavView {
		
		public function PageClockOverNavView():void {
			
			_links = [				
				{action: "cancel", events: [new GraphEvent(GraphEvent.STOP_CLOCK)]},
				{action: "pomodoro", events: [new GraphEvent(GraphEvent.CLOCK_POMODORO)]},
				{action: "clockInfo", events: [new GraphEvent(GraphEvent.CLOCK_INFO_WINDOW)]}
			];
			
			addIcons();
			
		}
		private function get className():String {
			return "PageClockNavView";
		}
	
	}

}