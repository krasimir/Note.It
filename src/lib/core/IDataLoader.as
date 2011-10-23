package lib.core {
	
	import flash.filesystem.File;
	import lib.core.IResponder;
	import lib.models.vos.FileVO;
	
	public interface IDataLoader {
		
		function writeFile(vo:FileVO):Boolean;
		function readFile(vo:FileVO, responder:IResponder = null):Boolean;
		
	}

}