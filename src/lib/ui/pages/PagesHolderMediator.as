package lib.ui.pages {
	
	import flash.display.MovieClip;
	import lib.controllers.events.ConfirmEvent;
	import lib.controllers.events.PagesEvent;
	import lib.core.IPage;
	import lib.models.AppModel;
	import lib.ui.confirm.ConfirmView;
	import lib.ui.pages.clock.PageClockView;
	import lib.ui.pages.graph.PageGraphView;
	import lib.ui.pages.items.PageTextItemView;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	import com.krasimirtsonev.display.DisplayHelper;
	
	public class PagesHolderMediator extends Mediator {
		
		[Inject] public var view:PagesHolderView;
		[Inject] public var appModel:AppModel;
		
		private var _currentPage:IPage;
		private var _confirm:ConfirmView;
		
		private function get className():String {
			return "PagesHolderMediator";
		}
		public override function onRegister():void {
			eventMap.mapListener(eventDispatcher, PagesEvent.SHOW_PAGE_CLOCK, showPage, PagesEvent);
			eventMap.mapListener(eventDispatcher, PagesEvent.SHOW_PAGE_GRAPH, showPage, PagesEvent);
			eventMap.mapListener(eventDispatcher, PagesEvent.SHOW_PAGE_TEXT_ITEM, showPage, PagesEvent);
			eventMap.mapListener(eventDispatcher, ConfirmEvent.CONFIRM, showConfirm, ConfirmEvent);
			eventMap.mapListener(eventDispatcher, ConfirmEvent.NO, hideConfirm, ConfirmEvent);
			eventMap.mapListener(eventDispatcher, ConfirmEvent.YES, hideConfirm, ConfirmEvent);
		}
		private function showPage(e:PagesEvent):void {
			Debug.echo(className + " showPage type=" + e.type);
			
			var newPage:IPage;
			switch (e.type) {
				case PagesEvent.SHOW_PAGE_GRAPH:
					newPage = new PageGraphView(appModel.config.data.mainPageGraph.graphItem);
				break;
				case PagesEvent.SHOW_PAGE_TEXT_ITEM:
					newPage = new PageTextItemView(e.data);
				break;
				case PagesEvent.SHOW_PAGE_CLOCK:
					newPage = new PageClockView(e.data);
				break;
			}
			
			if(_currentPage) {
				_currentPage.hidePage();
				DisplayHelper.removeAllChildren(_currentPage as MovieClip);
			}
			DisplayHelper.removeAllChildren(view);
			view.addChild(newPage as MovieClip);
			_currentPage = newPage;
			_currentPage.showPage();

		}
		private function showConfirm(e:ConfirmEvent):void {
			_confirm = new ConfirmView(e.data);
			view.addChild(_confirm);
		}
		private function hideConfirm(e:ConfirmEvent):void {
			if(_confirm && view.contains(_confirm)) {
				view.removeChild(_confirm);
			}
		}
		
	}

}