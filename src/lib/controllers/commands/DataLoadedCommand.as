package lib.controllers.commands {
	
	import lib.controllers.events.DataEvent;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.controllers.events.PreloaderEvent;
	import lib.models.AppModel;
	import lib.models.vos.ConfigVO;
	import lib.ui.pages.graph.PageGraphView;
	import org.robotlegs.mvcs.Command;
	import com.krasimirtsonev.utils.Debug;
	
	public class DataLoadedCommand extends Command {
		
		[Inject] public var event:DataEvent;
		[Inject] public var appModel:AppModel;
		
		private function get className():String {
			return "DataLoadedCommand";
		}
		public override function execute():void {
			Debug.echo(className + " execute key=" + event.key);
			switch(event.key) {
				case appModel.config.key:
					appModel.config.data = event.data;
					dispatch(new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH));
				break;
				case appModel.clock.key:
					appModel.clock.data = event.data;
					dispatch(new GraphEvent(GraphEvent.CLOCK_TIME_LOADED));
				break;
			}
			dispatch(new PreloaderEvent(PreloaderEvent.HIDE_PRELOADER));
		}
		
	}

}