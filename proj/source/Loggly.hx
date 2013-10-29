package;

import haxe.Json;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;

// Usage
// key - logging instance id from loggly.com 
// log - your log info in json format 
// call: Loggly.addLog(key, log);

// API Doc
// http://loggly.com/support/advanced/api-event-submission/

class Loggly{
	public var key:String;

	public function new(key:String){
		this.key = key;
	}

	public function log(data:Dynamic):Void{
		Loggly.addLog(key, data);
	}

	public static function addLog(key:String, data:Dynamic){
		var dataStr:String = "";
		if(!Std.is(data, String)){
			try {
				dataStr = Json.stringify(data);
			}
			catch(e:Dynamic){}
		}
		else
			dataStr = data;
		var tStr:String = Date.now().toString();

		var loader : URLLoader = new URLLoader();
		var request : URLRequest = new URLRequest("http://logs.loggly.com/inputs/"+key+".gif");
		request.method = URLRequestMethod.GET;
		request.data = new URLVariables(
			"PLAINTEXT="+dataStr+
			"&DT="+tStr);
		loader.load(request);
	}
}