package lib.helpers.factories {
	
	import flash.filesystem.File;
	import com.krasimirtsonev.utils.Debug;
	import lib.core.IDataLoader;
	import lib.models.vos.FileVO;
	
	public class FileSystemFactory {
		
		[Inject]
		public var dataLoaderService:IDataLoader;
		
		public function FileSystemFactory():void {
			
		}
		private function get className():String {
			return "FileSystemFactory";
		}
		public function getDirectory(parentDir:File, path:String):File {
			var dir:File = parentDir.resolvePath(path);
			if(!dir.exists) {
				try {
					Debug.echo(className + " getDirectory creating '" + dir.nativePath + "'");
					dir.createDirectory();
				} catch(err:Error) {
					throw new Error(className + " can't create directory " + dir.nativePath + " (" + err.message + ")");
				}
			}
			return dir;
		}
		public function getFile(parentDir:File, path:String, defaultContent:String = ""):File {
			var file:File = parentDir.resolvePath(path);
			if(!file.exists) {
				try {
					var vo:FileVO = new FileVO();
					vo.file = file;
					vo.content = defaultContent;
					if(dataLoaderService.writeFile(vo)) {
						Debug.echo(className + " getFile creating '" + file.nativePath + "'");
					} else {
						throw new Error(className + " can't create file '" + file.nativePath + "'");
					}
				} catch(err:Error) {
					throw new Error(className + " can't create file " + file.nativePath + " (" + err.message + ")");
				}
			}
			return file;
		}
		
	}

}