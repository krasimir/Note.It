package lib.ui.pages.graph {
	
	import com.krasimirtsonev.display.DisplayHelper;
	import com.krasimirtsonev.utils.Delegate;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lib.controllers.events.ConfirmEvent;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.controllers.events.SystemTrayEvent;
	import lib.core.IPage;
	import com.krasimirtsonev.utils.Debug;
	import lib.models.vos.FileVO;
	import lib.ui.actions.ActionsHolderView;
	import lib.ui.actions.changeparent.ChangeParentView;
	import lib.ui.dot.DotView;
	import lib.ui.pages.items.PageTextItemView;
	
	public class PageGraphView extends MovieClip implements IPage {
		
		private static const ACTION_CHANGE_OPERATION:String = "ACTION_CHANGE_OPERATION";
		
		private var _currentAction:String = "";
		private var _graphItems:Array;
		private var _dots:Array;
		private var _dotsHolder:MovieClip;
		private var _linesHolder:MovieClip;
		private var _filter:MovieClip;
		private var _mouseDown:Boolean = false;
		private var _mouseDownPoint:Point;
		private var _dotsHolderPoint:Point;
		private var _actionsHolder:ActionsHolderView;
		private var _changeParentView:ChangeParentView;
		private var _nav:PageGraphNavView;
		private var _appWidth:Number = 0;
		private var _appHeight:Number = 0;
		
		public function PageGraphView(graphItems:Array) {
			
			_graphItems = graphItems;
			_linesHolder = new MovieClip();
			_dotsHolder = new MovieClip();
			_actionsHolder = new ActionsHolderView();
			_changeParentView = new ChangeParentView();
			_nav = new PageGraphNavView();
			_filter = new A_GraphPageFilter();
			
			addChild(_linesHolder);
			addChild(_changeParentView);
			addChild(_dotsHolder);
			addChild(_actionsHolder);
			addChild(_nav);
			addChild(_filter);
			
		}
		public function showPage():void {
			Debug.echo(className + " showPage");
			
			removeDots();
			_dots = [];
			
			var numOfItems:int = _graphItems.length;
			for(var i:int=0; i<numOfItems; i++) {
				addDotToStage(_graphItems[i]);
			}
			
			updateLines();
			stage.focus = _filter.field;
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
		}
		public function hidePage():void {
			Debug.echo(className + " hidePage");
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			if(_nav) {
				_nav.clear();
			}
		}
		public function set graphItems(arr:Array):void {
			_graphItems = arr;
		}
		public function updateVisuals(appWidth:Number, appHeight:Number):void {
			Debug.echo(className + " updateVisuals appWidth=" + appWidth + " appHeight=" + appHeight);
			_nav.x = appWidth - _nav.width;
			_nav.y = appHeight - 20;
			_appWidth = appWidth;
			_appHeight = appHeight;
			_filter.x = 10;
			_filter.y = appHeight - _filter.height - 10;
			_filter.field.width = 100;
		}
		private function get className():String {
			return "PageGraphView";
		}
		private function setXY(xValue:Number, yValue:Number):void {
			_linesHolder.x = xValue;
			_linesHolder.y = yValue;
			_dotsHolder.x = xValue;
			_dotsHolder.y = yValue;
			_actionsHolder.x = xValue;
			_actionsHolder.y = yValue;
			_changeParentView.x = xValue;
			_changeParentView.y = yValue;
		}
		// lines
		private function updateLines(e:GraphEvent = null):void {
			
			if(e) {
				updateChildsPosition(e.target.id, e.data);
			}
			
			_linesHolder.graphics.clear();
			_linesHolder.graphics.lineStyle(1, 0x2CB11E, 1);
			
			var rootElement:Object;
			var numOfDots:int = _dots.length;
			for(var i:int=0; i<numOfDots; i++) {
				if(_dots[i] && _dots[i].parentId != "0") {
					for(var j:int=0; j<numOfDots; j++) {
						if(i != j && _dots[i].parentId == _dots[j].id) {
							_dots[i].visible = getDotVisibility(_dots[j].id);
							if(_dots[i].visible) {
								_linesHolder.graphics.moveTo(Number(_dots[i].x), Number(_dots[i].y));
								_linesHolder.graphics.lineTo(Number(_dots[j].x), Number(_dots[j].y));
								if(!_dotsHolder.contains(_dots[i])) {
									_dotsHolder.addChild(_dots[i])
								}
							} else {
								if(_dotsHolder.contains(_dots[i])) {
									_dotsHolder.removeChild(_dots[i])
								}
							}
						}
					}
				}
			}
			
		}
		// graph
		private function saveGraph():void {
			dispatchEvent(new GraphEvent(GraphEvent.SAVE_GRAPH, {x:_dotsHolder.x, y:_dotsHolder.y}));
		}
		private function addDotToStage(data:Object):void {
			var dot:DotView = new DotView(data);
			dot.addEventListener(GraphEvent.GRAPH_POSITION_CHANGED, onGraphPositionChanged);
			dot.addEventListener(GraphEvent.UPDATE_LINES, updateLines);
			dot.addEventListener(GraphEvent.GRAPH_DOT_CLICKED, onGraphDotClick);
			_dotsHolder.addChild(dot);
			_dots.push(dot);
		}
		private function onGraphPositionChanged(e:Event):void {
			var numOfDots:int = _dots.length;
			for(var i:int=0; i<numOfDots; i++) {
				_dots[i].updateInitialPoint();
			}
		}
		private function onGraphDotClick(e:Event):void {
			Debug.echo(className + " onGraphDotClick _currentAction=" + _currentAction);
			var dot:DotView = e.target as DotView;
			switch (_currentAction) {
				case ACTION_CHANGE_OPERATION:
					clearCurrentAction();
					_changeParentView.connect(dot);
					saveGraph();
					showPage();
				break;
				default:
					dot.showActions();				
				break;
			}
		}
		private function removeDots():void {
			DisplayHelper.removeAllChildren(_dotsHolder);
		}
		private function getDotVisibility(parentId:String):Boolean {
			if(parentId == "0") {
				return true;
			}
			var numOfDots:int = _dots.length;
			for(var i:int=0; i<numOfDots; i++) {
				if(_dots[i].id == parentId) {
					if(!_dots[i].expand) {
						return false;
					} else {
						return getDotVisibility(_dots[i].parentId);
						i = numOfDots;
					}
				}
			}
			return true;
		}
		private function updateChildsPosition(parentId:Object, diff:Object):void {
			if(parentId == "0") { return; }
			var numOfDots:int = _dots.length;
			for(var i:int=0; i<numOfDots; i++) {
				if(_dots[i].parentId == parentId) {
					_dots[i].setPosition(_dots[i].initialPos.x - diff.diffX, _dots[i].initialPos.y - diff.diffY);
					updateChildsPosition(_dots[i].id, diff);
				}
			}
		}
		public function addNewGraphItem(e:GraphEvent):void {
			e.data.x = - _dotsHolder.x + _appWidth - 45;
			e.data.y = - _dotsHolder.y + _appHeight - 20;
			addDotToStage(e.data);
			saveGraph();
			dispatchEvent(new GraphEvent(GraphEvent.SHOW_ITEM_TEXT_PAGE, {id: e.data.id, isNewItem: true}));
		}
		public function deleteGraphItem(dot:DotView):void {
			var numOfDots:int = _dots ? _dots.length : 0;
			var newArr:Array = [];
			for(var i:int=0; i<numOfDots; i++) {
				if(dot == _dots[i]) {
					if(_dotsHolder.contains(dot)) {
						_dotsHolder.removeChild(dot);
					}
				} else {
					newArr.push(_dots[i]);
				}
			}
			_dots = newArr;
		}
		// dragging
		public function onStageAdded(initialX:Number, initialY:Number):void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			setXY(initialX, initialY);
		}
		private function onStageLoop(e:Event):void {
			setXY(_dotsHolderPoint.x + mouseX - _mouseDownPoint.x, _dotsHolderPoint.y + mouseY - _mouseDownPoint.y);
		}
		private function onStageMouseDown(e:MouseEvent):void {
			
			var isDotClicked:Boolean = false;
			var numOfDots:int = _dots.length;
			for(var i:int=0; i<numOfDots; i++) {
				var dot:MovieClip = _dots[i] as MovieClip;
				if(dot.hitTestPoint(mouseX, mouseY, true)) {
					isDotClicked = true;
					i = numOfDots;
				}
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			_mouseDownPoint = new Point(mouseX, mouseY);
			_dotsHolderPoint = new Point(_dotsHolder.x, _dotsHolder.y);
			
			if(!isDotClicked) {
				addEventListener(Event.ENTER_FRAME, onStageLoop);
			}
			
			
			
		}
		private function onStageMouseUp(e:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, onStageLoop);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			if(_mouseDownPoint && (_mouseDownPoint.x != mouseX ||_mouseDownPoint.y != mouseY)) {
				saveGraph();
			}
		}
		// keys
		private function onKeyUp(e:KeyboardEvent):void {
			switch (e.charCode) {
				case 27:
					_filter.field.text = "";
				break;
				case 110:
					if(e.controlKey) {
						dispatchEvent(new GraphEvent(GraphEvent.REQUEST_FOR_NEW_GRAPH_ITEM));
					}
				break;
			}
			onFilterChange();
		}
		// filter
		private function onFilterChange():void {
			var text:String = _filter.field.text.toLowerCase();
			var numOfDots:int = _dots.length;
			for(var i:int=0; i<numOfDots; i++) {
				var pos:int = String(_dots[i].title).toLowerCase().indexOf(text);
				if(text == "" || pos >= 0) {
					_dots[i].alpha = 1;
				} else {
					_dots[i].alpha = 0.2;
				}
			}
			if(text != "") {
				_linesHolder.alpha = 0.2;
			} else {
				_linesHolder.alpha = 1;
			}
		}
		// actions
		private function clearCurrentAction():void {
			_currentAction = "";
		}
		public function onActionIconClick(e:GraphEvent):void {
			Debug.echo(className + " onActionIconClick action=" + e.data.action + " dot=" + e.data.dot);
			
			switch (e.data.action) {
				case "changeParent":
					_currentAction = ACTION_CHANGE_OPERATION;
					_changeParentView.action(e.data.dot);
				break;
				case "deleteItem":
					dispatchEvent(new ConfirmEvent(ConfirmEvent.CONFIRM, {callback: Delegate.create(onDeleteItem, e.data.dot)}));
				break;
				case "editItem":
					dispatchEvent(new GraphEvent(GraphEvent.SHOW_ITEM_TEXT_PAGE, {id: e.data.dot.id}));
				break;
				case "expand":
					dispatchEvent(new GraphEvent(GraphEvent.CHANGE_EXPAND, e.data.dot.id));
					saveGraph();
					showPage();
				break;
				case "clock":
					dispatchEvent(new GraphEvent(GraphEvent.SHOW_CLOCK_PAGE, {id: e.data.dot.id, autoStart: true}));
				break;
			}
			
		}
		private function onDeleteItem(dot:DotView):void {
			deleteGraphItem(dot);
			dispatchEvent(new GraphEvent(GraphEvent.DELETE_GRAPH_ITEM, dot.id));
			saveGraph();
			updateLines();
		}
		// open from system tray
		public function onOpenFromSystemTray(e:SystemTrayEvent):void {
			if(stage && _filter) {
				stage.focus = _filter.field;
			}
		}
	}

}