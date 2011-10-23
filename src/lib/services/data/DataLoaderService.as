package lib.services.data {
	
	// C:\Users\Krasimir\AppData\Roaming\Note.It\Local Store
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import lib.core.IResponder;
	import com.krasimirtsonev.utils.Debug;
	import lib.models.vos.FileVO;
	import lib.services.responders.ResponderXML;
	import lib.core.IDataLoader;
	
	public class DataLoaderService implements IDataLoader {
		
		[Inject] public var responderXML:ResponderXML;
		
		private var _stream:FileStream;
		
		public function DataLoaderService() {
			
		}
		private function get className():String {
			return "DataLoaderService";
		}
		public function writeFile(vo:FileVO):Boolean {
			// Debug.echo(className + " writeFile f=" + (vo.file ? vo.file.name : "null"));
			try {
				_stream = new FileStream();
				_stream.open(vo.file, FileMode.WRITE);
				_stream.writeUTFBytes(vo.content);
				_stream.close();
				return true;
			} catch (err:Error){
				Debug.echo(className + " createFile err=" + err.message);
			}
			return false;
		}
		public function readFile(vo:FileVO, responder:IResponder = null):Boolean {
			// Debug.echo(className + " readFile f=" + (vo.file ? vo.file.name : "null"));
			responder = responder ? responder : responderXML;
			if(vo.file.exists) {
				try {
					var str:String = "";
					_stream = new FileStream();
					_stream.open(vo.file, FileMode.READ);			
					str = _stream.readUTFBytes(_stream.bytesAvailable);
					_stream.close();
					responder.respond(str, vo.key);
					return true;
				} catch (err:Error){
					Debug.echo(className + " readFile err=" + err.message);
					return false;
				}
			}
			return false;
		}
		
	}

}