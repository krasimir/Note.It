package lib.ui.actions.changeparent {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.Event;
	import lib.controllers.events.GraphEvent;
	import lib.core.IAction;
	import lib.ui.dot.DotView;
	
	public class ChangeParentView extends MovieClip implements IAction {
		
		private var _holder:MovieClip;
		private var _child:DotView;
		
		public function ChangeParentView():void {
			_holder = new MovieClip();
			addChild(_holder);
		}
		public function action(child:DotView):void {
			Debug.echo(className + " action");
			_child = child;
			clear();
			startLoop();
		}
		public function connect(parent:DotView):void {
			clear();
			stopLoop();
			dispatchEvent(new GraphEvent(GraphEvent.ACTION_CHANGE_PARENT, {child: _child, parent: parent}));
		}
		private function get className():String {
			return "ChangeParentView";
		}
		private function clear():void {
			_holder.graphics.clear();
			_holder.graphics.lineStyle(5, 0x2CB11E, 1);
		}
		private function startLoop():void {
			addEventListener(Event.ENTER_FRAME, loop);
		}
		private function stopLoop():void {
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		private function loop(e:Event):void {
			clear();
			_holder.graphics.moveTo(_child.x, _child.y);
			_holder.graphics.lineTo(mouseX, mouseY);
		}
	
	}

}