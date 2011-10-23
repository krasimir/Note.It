package lib.ui.actions {
	
	import com.krasimirtsonev.display.DisplayHelper;
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.Event;
	import lib.controllers.events.GraphEvent;
	import lib.ui.dot.DotView;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import com.krasimirtsonev.managers.tween.TweenManager;
	import lib.ui.actions.icon.ActionIconView
	
	public class ActionsHolderView extends MovieClip {
		
		private static const HIDE_INTERVAL:int = 2000;
		private static const ACTIONS_TYPES:Array = ["changeParent", "editItem", "clock", "expand", "deleteItem", "newGraphItem", "saveItem", "cancel"];
		
		private var _holder:MovieClip;
		private var _actions:Object;
		private var _icons:Array;
		private var _dot:DotView;
		private var _hideInterval:uint;
		
		public function ActionsHolderView():void {
			visible = false;
			_holder = new MovieClip();
			addChild(_holder);
		}
		private function get className():String {
			return "ActionsHolderView";
		}
		public function show(e:GraphEvent):void {
			if(visible) {
				hideSetVisible();
				return;
			}
			_dot = e.data as DotView;
			_actions = _dot.actions;
			_holder.x = _dot.x;
			_holder.y = _dot.y;
			clearHideInterval();
			if(addIcons()) {
				visible = true;
				TweenManager.alpha(this, 0, 1, 0, 15);
			}
		}
		public function hide(e:GraphEvent):void {
			clearHideInterval();
			if(!e.data) {
				_hideInterval = setTimeout(hideSetVisible, HIDE_INTERVAL);
			} else {
				hideSetVisible();
			}
		}
		private function clearHideInterval(e:Event = null):void {
			clearTimeout(_hideInterval);
		}
		private function hideSetVisible():void {
			clearHideInterval();
			visible = false;
		}
		private function addIcons():Boolean {
			
			if(typeof _actions == "string") {
				return false;
			}
			
			// removing old icons
			DisplayHelper.removeAllChildren(_holder);
			
			// adding the new icons
			_icons = [];
			var isThereAnyActions:Boolean = false;
			var iconWidth:int = 20;
			var iconDist:int = 5;
			var totalWidth:Number = 0;
			var numOfActions:int = ACTIONS_TYPES.length;
			for(var i:int=0; i<numOfActions; i++) {
				if(_actions[ACTIONS_TYPES[i]]) {
					var action:String = ACTIONS_TYPES[i];
					var actionValue:String = _actions[ACTIONS_TYPES[i]];
					isThereAnyActions = true;
					var icon:ActionIconView = new ActionIconView(
						action,
						[
							new GraphEvent(GraphEvent.HIDE_ACTIONS_HOLDER, true),
							new GraphEvent(GraphEvent.ACTION_ICON_CLICK, action as String)
						],
						actionValue
					);
					icon.addEventListener(GraphEvent.ACTION_ICON_OVER, clearHideInterval);
					icon.addEventListener(GraphEvent.ACTION_ICON_OUT, hide);
					icon.addEventListener(GraphEvent.ACTION_ICON_CLICK, onIconClick);
					icon.addEventListener(GraphEvent.HIDE_ACTIONS_HOLDER, hide);
					icon.x = totalWidth;
					icon.y = -58;
					totalWidth += iconWidth + iconDist;
					_holder.addChild(icon);
					_icons.push(icon);
				}
			}
			totalWidth -= iconWidth + iconDist;
			
			// position the holder
			_holder.x -= totalWidth / 2;
			
			return isThereAnyActions;
			
		}
		private function onIconClick(e:GraphEvent):void {
			dispatchEvent(new GraphEvent(GraphEvent.ACTION_ICON_CLICK, {dot:_dot, action:e.data}));
		}
	
	}

}