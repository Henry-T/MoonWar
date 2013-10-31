package;
import openfl.Assets;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxSave;
import flixel.util.FlxAngle;
import flixel.util.FlxPath;

import flash.geom.Rectangle;
import flash.net.SharedObject;

class MenuState extends FlxState
{
	override public function create():Void
	{
		#if !neko
		FlxG.cameras.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}