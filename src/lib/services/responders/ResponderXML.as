package lib.services.responders {
	
	import com.krasimirtsonev.data.helpers.XML2JSON;
	import lib.controllers.events.DataEvent;
	import org.robotlegs.mvcs.Actor;
	import com.krasimirtsonev.utils.Debug;
	import lib.core.IResponder;
	
	public class ResponderXML extends Actor implements IResponder {
		
		public function ResponderXML() {
			XML2JSON.arrays = [
				"graphItem",
				"time"
			];
		}
		private function get className():String {
			return "ResponderXML";
		}
		public function respond(dataStr:String, key:String):void {
			Debug.echo(className + " respond key=" + key + " dataStr=" + dataStr.substr(0, 300));
			var obj:Object = XML2JSON.parse(new XML(dataStr));
			eventDispatcher.dispatchEvent(new DataEvent(DataEvent.ON_DATA_LOADED, obj, key));
		}
		
	}

}