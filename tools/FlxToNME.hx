package;

import neko.FileSystem;
import neko.Lib;
import neko.Sys;

using StringTools;
using FlxToNME;

class FlxToNME
{
	var from:String = "from";
	var sysargs:Array<String>;

	var files:Array<String>;
	var images:Hash<String>;

	var importMap:Hash<String>;

	static function main()
	{
		new FlxToNME();

		// create import map 
		//importMap.set();
	}

	public function new()
	{
		images = new Hash<String>();

		files = [];
		var fromDir = FileSystem.readDirectory(from);

		// Take image path
		for (i in fromDir) {
			var s = from + "/" + i;
			trace(s);
			var content = neko.io.File.getContent(s);
			var r1:EReg = new EReg("\\[ *(Embed)(.|\\r|\\n)*?(Class) *;", "g");
			if(r1.match(content))
			{
				trace(r1.matched(0));
				var image:String = r1.matched(0);
				var r2:EReg = ~/((?<=("))|(?<=(source=")))(.*?)(?=\s*")/;
				r2.match(image);
				trace(r2.matched(0));
				var imgPath:String = r2.matched(0);
				var r3:EReg = ~/(?<=\s)(\S*)(?=:\s*Class)/;
				r3.match(image);
				trace(r3.matched(0));
				var imgName:String = r3.matched(0);

				imgPath = '"' + imgPath.replace("..", "assets") + '"';

				images.set(imgName, imgPath);
			}
		}

		// replace all ref to IMG with the path
		for(i in fromDir){
			var s = from + "/" + i;
			var c2 = neko.io.File.getContent(s);
			for(key in images.keys())
			{
				// remove embed
				var r5:EReg = new EReg("\\[ *(Embed)(.|\\r|\\n)*?(Class) *;","g");
				c2 = r5.replace(c2, "");

				var r4:EReg = new EReg(key, "g");
				if(r4.match(c2))
				{
					trace(i+ " : " + images.get(key));
				}
				c2 = r4.replace(c2, images.get(key));
				if(r4.match(c2))
				{
					trace(i+ " : " + images.get(key));
				}
			}
			var o = neko.io.File.write("to" + "/" + i, true);
			o.writeString(c2);
			o.close();

		}
	}
}