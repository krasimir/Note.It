package lib.ui.pages.items {
	
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.controllers.events.StageResizeEvent;
	import lib.models.AppModel;
	import lib.ui.pages.graph.PageGraphView;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	
	public class PageTextItemMediator extends Mediator {
	
		[Inject] public var view:PageTextItemView;
		[Inject] public var appModel:AppModel;
		
		private function get className():String {
			return "PageTextItemMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			eventMap.mapListener(eventDispatcher, StageResizeEvent.ON_APP_STAGE_RESIZE, onStageResize, StageResizeEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.SAVE_ITEM, onSaveItem, GraphEvent);
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_CLOCK, dispatch, PagesEvent);
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_GRAPH, dispatch, PagesEvent);
			eventMap.mapListener(view, PagesEvent.SHOW_PAGE_TEXT_ITEM, dispatch, PagesEvent);
			onStageResize();
		}
		private function onStageResize(e:StageResizeEvent = null):void {
			view.updateVisuals(appModel.appWidth, appModel.appHeight);
		}
		private function onSaveItem(e:GraphEvent):void {
			appModel.config.saveItem(view.data, view.newData);
			dispatch(new GraphEvent(GraphEvent.SAVE_GRAPH));
			dispatch(new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH));
		}
	
	}

}