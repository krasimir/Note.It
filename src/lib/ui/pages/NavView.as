package lib.ui.pages {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import lib.ui.actions.icon.ActionIconView;
	import com.krasimirtsonev.display.DisplayHelper;
	
	public class NavView extends MovieClip {
		
		protected var _links:Array;
		protected var _totalWidth:Number;
		
		public function NavView() {
			
		}
		private function get className():String {
			return "NavView";
		}
		protected function addIcons():void {
			var numOfLinks:int = _links.length;
			_totalWidth = 0;
			var iconWidth:int = 20;
			var iconDist:int = 5;
			for(var i:int=0; i<numOfLinks; i++) {
				var icon:ActionIconView = new ActionIconView(_links[i].action, _links[i].events);
				icon.x = _totalWidth;
				_totalWidth += iconWidth + iconDist;
				_links[i].icon = icon;
				addChild(icon);
			}
		}
		public function clear():void {
			var numOfLinks:int = _links.length;
			for(var i:int=0; i<numOfLinks; i++) {
				if(contains(_links[i].icon)) {
					removeChild(_links[i].icon);
				}
			}
		}
		
	}

}