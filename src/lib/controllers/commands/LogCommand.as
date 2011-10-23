package lib.controllers.commands {
	
	import lib.models.AppModel;
	import lib.core.IDataLoader;
	import org.robotlegs.mvcs.Command;
	import com.krasimirtsonev.utils.Debug;
	
	public class LogCommand extends Command {
		
		[Inject]
		public var dataLoaderService:IDataLoader;
		[Inject]
		public var appModel:AppModel;
		
		private function get className():String {
			return "LogCommand";
		}
		override public function execute():void {
			Debug.echo(className + " execute");
			appModel.log.content = Debug.allDebugText + "\nLog saved on " + new Date().toString();
			dataLoaderService.writeFile(appModel.log);
		}
		
	}

}