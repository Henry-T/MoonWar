package ;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets;

import flixel.ui.FlxAnalog;

class MyAnalog extends FlxAnalog {
	public function new(X:Float, Y:Float, Radius:Float = 0, FlxEase:Float = 0.25){
		super(X, Y, Radius, FlxEase);
	}

	private override function createBase():Void{
		base = new FlxSprite(x, y).loadGraphic(GameStatic.screenDensity==GameStatic.Density_S?"assets/img/tbBaseS.png":"assets/img/tbBaseM.png");
		base.cameras = [FlxG.camera];
		base.x += -base.width * .5;
		base.y += -base.height * .5;
		base.scrollFactor.x = base.scrollFactor.y = 0;
		base.solid = false;
		
		#if !FLX_NO_DEBUG
		base.ignoreDrawDebug = true;
		#end
		
		add(base);	
	}

	private override function createThumb():Void{
		thumb = new FlxSprite(x, y).loadGraphic(GameStatic.screenDensity==GameStatic.Density_S?"assets/img/tbStickS.png":"assets/img/tbStickM.png");
		thumb.cameras = [FlxG.camera];
		thumb.scrollFactor.x = thumb.scrollFactor.y = 0;
		thumb.solid = false;
		
		#if !FLX_NO_DEBUG
		thumb.ignoreDrawDebug = true;
		#end
		
		add(thumb);
	}
}