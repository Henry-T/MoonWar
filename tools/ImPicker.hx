package;

import EReg;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;


using ImPicker;

class ImPicker 
 {
 	static var clses:Hash<String>;	// use hash to prevent multi define
 	static var flixelPath:String = "/usr/lib/haxe/lib/flixel/1,09/org/flixel";
 	static var tmxPath:String = "/usr/lib/haxe/lib/tmx/0,1/com/tipfy/tmx";
 	static var libMap:Hash<String>;

 	static public function main() 
 	{
 		libMap = new Hash<String>();
 		clses = new Hash<String>();

 		// create mapping with lib files
 		LoadLibMap(tmxPath);
 		LoadLibMap(flixelPath);

 		for (lmkey in libMap.keys()) {
 			//trace(lmkey + ":" + libMap.get(lmkey));
 		}

 		trace("\nNow for the operte target\n");

 		// find reference in operation target files
		var files = FileSystem.readDirectory("from");
		for (f in files) {
			var p = "from/" + f;
			var conStr:String = neko.io.File.getContent(p);

 			// remove all 'import ... *;' first
 			var regImpStar:EReg = new EReg("import.*?\\*;(\\r|\\n)","g");// ~/import.*?\*;(\r|\n)/;
 			conStr = regImpStar.replace(conStr, "");

 			// fix package{} to package; because AS3toHaxe failed on some files
 			var regPackageAS:EReg = ~/package[ \r\n]*{/;
 			if(regPackageAS.match(conStr)){
 				conStr = regPackageAS.replace(conStr, "package;");
 				// remove the last
 				//var regPkgFix:EReg = ~/([\D\d]*)(?\})/;
 				//conStr = regPkgFix.replace(conStr, "$1");
 				trace("PKG fixed for " + p);
 			}

 			// fix new ClassName call to new ClassName()
 			var regNewFix:EReg = new EReg("(?<=new )([A-Za-z0-9]*?)(?=\\(\\))", "g"); 	//~/(?<=new )([A-Za-z0-9]*?)(?=\))/;
			if(regNewFix.match(conStr))
			{
				conStr = regNewFix.replace(conStr, "$1()");
				trace("find wrong new : " + p);
			}

			var insStrs:List<String> = new List<String>();

			for (k in libMap.keys()) {
				var reg2:EReg = new EReg("\\b"+k+"\\b","g");
				//trace("Regex Str : \b" + k + "\b");
				if(reg2.match(conStr))
				{
					var impStr:String = "import " + libMap.get(k) + "." + k + ";\n";
					var reg3:EReg = new EReg(impStr, "g");
					if(!reg3.match(conStr))
						insStrs.add(impStr);
				}
				else 
				{
					//trace("No matched class : " + k);
				}
			}
			// trace(insStrs);

			// insert point is after the package...;

			var pointReg:EReg = ~/(((\n|\r)package)|(^package)).*?;(\r|\n)/;
			if(pointReg.match(conStr))
			{
				var before:String  = pointReg.matchedLeft();
				var mc:String = pointReg.matched(0);
				var outStr:String  = before + mc;
				for (inss in insStrs) {
					outStr += inss;
				}
				outStr += pointReg.matchedRight();

				var eFile:FileOutput = File.write("to/"+f, false);
				eFile.writeString(outStr);
				eFile.close();
			}
			else 
				trace("Invalid file without package : " + p);

		}

		for (i in clses.keys()) {
			trace(i);
		}
 	}

 	public static function LoadLibMap(path:String)
 	{
 		var files = FileSystem.readDirectory(path);
 		for (f in files) 
 		{
 			var p:String = path + "/" + f;
 			if(FileSystem.isDirectory(p))
 				LoadLibMap(p);
 			else {
 				if(p.substr(p.lastIndexOf(".") + 1).toLowerCase() == "hx")
 				{
 					var content:String = neko.io.File.getContent(p);
 					var regClass:EReg = ~/(?<=(\n|\r)class ).*?(?= |\n|\r)/;
 					var regPackage:EReg = ~/((?<=(\n|\r)package )|(?<=^package )).*?(?=;)/;
 					if(regClass.match(content))
 					{
 						var cls:String = regClass.matched(0);
 						if(regPackage.match(content))
 						{
 							var pkg:String = regPackage.matched(0);
 							libMap.set(cls, pkg);
 							//trace("Find Class:" + cls + " Package:" + pkg);//+ " File:"+p);
 						}
 						else 
 							trace("Package not found for Class:"+cls + " in file:"+p);
 					}
 					else
 						trace("Class Not Found in: " + p);
 				}
 			}

 		}
 	}

 	// post a warning when type missing in import map

 	function new()
 	{
 	}
 }