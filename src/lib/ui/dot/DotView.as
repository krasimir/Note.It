package lib.ui.dot {
	
	import com.krasimirtsonev.display.DisplayHelper;
	import com.krasimirtsonev.managers.tween.TweenManager;
	import com.krasimirtsonev.utils.Debug;
	import com.krasimirtsonev.utils.Delegate;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import lib.controllers.events.GraphEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import lib.ui.actions.icon.ActionIconView;
	import com.krasimirtsonev.display.DisplayHelper;
	
	public class DotView extends MovieClip {
		
		private var _dotClip:MovieClip;
		private var _onMouseDownPosition:Point;
		private var _draggable:Boolean;
		private var _actions:Object;
		private var _actionsIcons:Array;
		private var _data:Object;
		private var _initialPos:Point;
		
		protected var _text:String = "";
		protected var _color:uint = 0x999999;
		
		public function DotView(data:Object, draggable:Boolean = true) {
			
			_data = data;
			x = Number(data.x);
			y = Number(data.y);
			_initialPos = new Point(x, y);
			
			_color = DisplayHelper.colorStringToHex(data.color);
			_actions = data.actions;
			_draggable = draggable;
			
			_dotClip = new A_Dot();
			_dotClip.expand.visible = _data.actions && _data.actions.expand == "no" ? true : false;
			_dotClip.point.pointInner.scaleX = _dotClip.point.pointInner.scaleY = 0;
			addChild(_dotClip);			
			
			var scaleRect:Rectangle = new Rectangle(6, 5, 42, 14);
			_dotClip.back.scale9Grid = scaleRect;
			
			if(_draggable) {
				buttonMode = true;
				mouseChildren = false;
				doubleClickEnabled = true;
				addEventListener(MouseEvent.MOUSE_DOWN, onDotMouseDown);
				addEventListener(MouseEvent.MOUSE_OVER, onDotMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT, onDotMouseOut);
				addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			}
			
			text = data.title as String;
			
		}
		public function set text(t:String):void {
			_dotClip.field.autoSize = TextFieldAutoSize.LEFT;
			_dotClip.field.htmlText = _text = t;
			_dotClip.field.x = - _dotClip.field.width / 2;
			updateVisuals();
		}
		public function set color(c:uint):void {
			_color = c;
			updateVisuals();
		}
		public function get actions():Object {
			return _actions;
		}
		public function get id():String {
			return _data.id as String;
		}
		public function get parentId():String {
			return _data.parent as String;
		}
		public function get expand():Boolean {
			if(_data.actions) {
				return _data.actions.expand == "yes" ? true : false;
			} else {
				return true;
			}
		}
		public function get title():String {
			return _data.title;
		}
		public function get initialPos():Point {
			return _initialPos;
		}
		public function setPosition(xPos:Number, yPos:Number):void {
			_data.x = x = xPos;
			_data.y = y = yPos;
		}
		public function updateInitialPoint():void {
			_initialPos = new Point(x, y);
		}
		private function get className():String {
			return "DotView";
		}
		private function updateVisuals():void {
			
			_dotClip.back.width = _dotClip.field.width + 20;
			_dotClip.back.x = _dotClip.field.x - 10;
			
			_dotClip.expand.x = (_dotClip.back.width / 2) - 10;
			_dotClip.expand.y = -25;
			
			var ct:ColorTransform = new ColorTransform();
			ct.color = _color;
			_dotClip.back.transform.colorTransform = ct;
			_dotClip.arrow.transform.colorTransform = ct;
			
		}
		private function onDotMouseDown(e:MouseEvent):void {
			_onMouseDownPosition = new Point(x, y);
			startDrag(false);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDotMouseUp);
			stage.addEventListener(Event.ENTER_FRAME, dotLoop);
		}
		private function onDotMouseUp(e:MouseEvent):void {
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDotMouseUp);
			stage.removeEventListener(Event.ENTER_FRAME, dotLoop);
			if(_onMouseDownPosition.x != x || _onMouseDownPosition.y != y) {
				dispatchEvent(new GraphEvent(GraphEvent.GRAPH_POSITION_CHANGED));
			} else {
				onDotClick();
			}
		}
		private function onDotMouseOver(e:MouseEvent):void {
			TweenManager.tween(
				_dotClip.point.pointInner,
				{
					scaleX:{end:1, mtd:TweenManager.TYPE_OUT_QUAD, steps:10},
					scaleY:{end:1, mtd:TweenManager.TYPE_OUT_QUAD, steps:10}
				}
			);
		}
		private function onDotMouseOut(e:MouseEvent):void {
			TweenManager.tween(
				_dotClip.point.pointInner,
				{
					scaleX:{end:0, mtd:TweenManager.TYPE_OUT_QUAD, steps:10},
					scaleY:{end:0, mtd:TweenManager.TYPE_OUT_QUAD, steps:10}
				}
			);
			hideActions();
		}
		private function onDotClick():void {
			dispatchEvent(new GraphEvent(GraphEvent.GRAPH_DOT_CLICKED));
		}
		private function onDoubleClick(e:MouseEvent):void {
			dispatchEvent(new GraphEvent(GraphEvent.ACTION_ICON_CLICK, {dot:this, action:"editItem"}));
		}
		private function dotLoop(e:Event):void {
			_data.x	= x;
			_data.y	= y;
			dispatchEvent(new GraphEvent(GraphEvent.UPDATE_LINES, {diffX: _onMouseDownPosition.x - x, diffY: _onMouseDownPosition.y - y}));
			if(_onMouseDownPosition.x != x || _onMouseDownPosition.y != y) {
				dispatchEvent(new GraphEvent(GraphEvent.HIDE_ACTIONS_HOLDER, true));
			} 
		}
		// actions
		public function showActions():void {
			dispatchEvent(new GraphEvent(GraphEvent.SHOW_ACTIONS_HOLDER, this));
		}
		public function hideActions():void {
			dispatchEvent(new GraphEvent(GraphEvent.HIDE_ACTIONS_HOLDER, false));
		}
		
	}

}