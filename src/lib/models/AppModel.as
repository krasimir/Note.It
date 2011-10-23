package lib.models {
	
	import flash.filesystem.File;
	import lib.controllers.events.DataEvent;
	import lib.models.vos.ClockVO;
	import lib.models.vos.ConfigVO;
	import lib.models.vos.DirectoriesVO;
	import com.krasimirtsonev.utils.Debug;
	import lib.models.vos.LogVO;
	import org.robotlegs.mvcs.Actor;
	import com.krasimirtsonev.data.helpers.Session;
	
	public class AppModel extends Actor {
		
		public var appWidth:int = 800;
		public var appHeight:int = 600;
		public var directories:DirectoriesVO;
		public var config:ConfigVO;
		public var log:LogVO;
		public var clock:ClockVO;
		
		public function AppModel():void {
			
			directories = new DirectoriesVO();
			config = new ConfigVO();
			log = new LogVO();
			clock = new ClockVO();
			
			if(Session.getSession("initialWidth") && Session.getSession("initialHeight")) {
				appWidth = Session.getSession("initialWidth");
				appHeight = Session.getSession("initialHeight");
			}
			
		}
		
	}

}