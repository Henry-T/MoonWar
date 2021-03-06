package;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.events.Event;

class BallBat{
	private static var pathStart:String = "http://localhost";
	private static var pathPalse:String = "http://localhost";
	private static var pathErrorReport:String = "http://localhost";

	private static var gameName:String = "NoNameGame";
	private static var gameVersion:String = "0.01";
	private static var gameSessionId:String = "0";
	private static var clientType:String = "";
	private static var clientSID:String = "";

	private static var enableGAE:Bool;
	private static var enableLoggly:Bool;

	private static var logglyKey;
	/**
	 * pass in an empty string if you don't need any log system
	 */
	public static function Initial(remoteBase:String="", logKey:String=""){
		if(logglyKey==null || logglyKey=="")
			enableLoggly = false;
		else
			enableLoggly = true;

		if(remoteBase==null || remoteBase=="")
			enableGAE = false;
		else
			enableGAE = true;
		logglyKey = logKey;

		pathStart = remoteBase + "/game/start";
		pathPalse = remoteBase + "/game/palse";
		pathErrorReport = remoteBase += "/game/errorReport";
		#if flash
		clientType = "flash";
		#elseif html5
		clientType = "html5";
		#elseif neko
		clientType = "neko";
		#else
		clientType = Sys.systemName();
		#end

		clientSID = uuid();
	}

	/**
	 * Call this when game started, an event handler will get triggered when get response from server
	 */
	public static function StartSession(gName:String, gVersion:String){
		gameName = gName;
		gameVersion = gVersion;

		var request : URLRequest = new URLRequest(pathStart);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables(
			"gameName="+gameName+
			"&gameVersion="+gameVersion+
			"&client="+clientType+
			"&clientSID"+clientSID);

		var loader : URLLoader = new URLLoader();  
		loader.addEventListener(Event.COMPLETE, function(event:Event){
			var retLoader:URLLoader = cast(event.target, URLLoader);
			var datas:Array<String> = retLoader.data.split('&');
			for (d in datas) {
				var keyValPair:Array<String> = d.split('=');
				if(keyValPair[0] == "sid"){
					gameSessionId = keyValPair[1];
				}
			}
		});
		loader.load(request);

		var lgyData:Dynamic = { 
			gameName:gameName,
			gameVersion:gameVersion,
			client:clientType,
			clientSID:clientSID
		};
		Loggly.addLog(logglyKey, lgyData);
	}

	/**
	 * Call this in game at a time interval, I don't know what's the best interval.request
	 * Maybe 5 seconds
	 */
	public static function Palse(curState:String, curExtra:String){
		var request : URLRequest = new URLRequest(pathPalse);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables("sessionId="+gameSessionId+"&state="+curState+"&extra="+curExtra);

		var loader : URLLoader = new URLLoader();
		loader.load(request);
	}

	public static function ReportError(info:String){
		var request : URLRequest = new URLRequest(pathErrorReport);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables("sessionId="+gameSessionId+"&info="+info);

		var loader : URLLoader = new URLLoader();
		loader.load(request);
	}

	// GUID Stuff
	// from : https://groups.google.com/forum/?hl=zh-CN#!topic/haxelang/N03kf5WSrTU
	inline public static function randomIntegerWithinRange(min:Int, max:Int):Int {
		return Math.floor(Math.random() * (1 + max - min) + min);
	} 

	public static function createRandomIdentifier(length:Int, radix:Int = 61):String {
		var characters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
		var id:Array<String> = new Array<String>();
		radix = (radix > 61) ? 61 : radix;
		while (length-- > 0) {
			id.push(characters[GUID.randomIntegerWithinRange(0, radix)]);
		}
		return id.join('');
	} 

	public static function uuid():String {
		var specialChars = ['8', '9', 'A', 'B'];
		return GUID.createRandomIdentifier(8, 15) + '-' + 
		    GUID.createRandomIdentifier(4, 15) + '-4' + 
		    GUID.createRandomIdentifier(3, 15) + '-' + 
		    specialChars[GUID.randomIntegerWithinRange(0, 3)] + 
		    GUID.createRandomIdentifier(3, 15) + '-' + 
		    GUID.createRandomIdentifier(12, 15);
	} 
	// GUID Stuff End
}