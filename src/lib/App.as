package lib {
	
	import com.krasimirtsonev.data.helpers.Storage;
	import com.krasimirtsonev.display.DisplayHelper;
	import com.krasimirtsonev.utils.Debug;
	import flash.display.MovieClip;
	import flash.events.Event;
	import lib.contexts.NoteItContext;
	import mx.core.UIComponent;
	import flash.utils.setTimeout;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.events.KeyboardEvent;
	
	public class App extends MovieClip {		
		
		private var _context:NoteItContext;
		
		public function App() {
			Debug.echo("----------------- Note.It version 1.0 | Project by Krasimir Tsonev -----------------");
			Storage.getSetting("root").addChild(DisplayHelper.wrapInUIComponent(this));
			setTimeout(setAIRDebug, 50);
		}
		private function setAIRDebug():void {
			
			_context = new NoteItContext(this);
			Debug.enableAIRDebug(this, 400, 400, 0.9, false, 0x000000);
			
			// debugger
			MonsterDebugger.initialize(this);
			
		}
		
	}
	
}