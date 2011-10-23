package lib.ui.pages.graph {
	
	import com.krasimirtsonev.utils.Debug;
	import com.krasimirtsonev.utils.Delegate;
	import flash.events.Event;
	import lib.controllers.events.ConfirmEvent;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.controllers.events.StageResizeEvent;
	import lib.controllers.events.SystemTrayEvent;
	import lib.models.AppModel;
	import lib.ui.pages.items.PageTextItemView;
	import org.robotlegs.mvcs.Mediator;
	import flash.utils.setTimeout;
	
	public class PageGraphMediator extends Mediator {
		
		[Inject] public var view:PageGraphView;
		[Inject] public var appModel:AppModel;
		
		private function get className():String {
			return "PageGraphMediator";
		}
		public override function onRegister():void {
			
			eventMap.mapListener(view, GraphEvent.SAVE_GRAPH, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.DELETE_GRAPH_ITEM, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.CHANGE_EXPAND, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SHOW_ITEM_TEXT_PAGE, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SHOW_CLOCK_PAGE, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.REQUEST_FOR_NEW_GRAPH_ITEM, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.HIDE_ACTIONS_HOLDER, dispatch, GraphEvent);
			eventMap.mapListener(view, ConfirmEvent.CONFIRM, dispatch, ConfirmEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.ACTION_ICON_CLICK, view.onActionIconClick, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.ADD_NEW_GRAPH_ITEM, view.addNewGraphItem, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.UPDATED_GRAPH_ITEMS_ARRAY, onUpdatedGraphItems, GraphEvent);
			eventMap.mapListener(eventDispatcher, StageResizeEvent.ON_APP_STAGE_RESIZE, onStageResize, StageResizeEvent);
			eventMap.mapListener(eventDispatcher, SystemTrayEvent.OPEN_FROM_TRAY, view.onOpenFromSystemTray, SystemTrayEvent);
			
			view.onStageAdded(appModel.config.data.mainPageGraph.x, appModel.config.data.mainPageGraph.y);
			view.updateVisuals(appModel.appWidth, appModel.appHeight);
			
		}
		private function onStageResize(e:StageResizeEvent = null):void {
			view.updateVisuals(appModel.appWidth, appModel.appHeight);
		}
		private function onUpdatedGraphItems(e:GraphEvent):void {
			view.graphItems = appModel.config.data.mainPageGraph.graphItem;
		}
		
	}

}