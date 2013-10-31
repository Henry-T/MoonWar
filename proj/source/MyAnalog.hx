package ;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets;

import flixel.system.input.FlxAnalog;

class MyAnalog extends FlxAnalog {
	public function new(X:Float, Y:Float, Radius:Float = 0, FlxEase:Float = 0.25){
		super(X, Y, Radius, FlxEase);
	}

	private override function createBase():Void{
		_base = new FlxSprite(x, y).loadGraphic(GameStatic.screenDensity==GameStatic.Density_S?"assets/img/tbBaseS.png":"assets/img/tbBaseM.png");
		_base.cameras = [FlxG.camera];
		_base.x += -_base.width * .5;
		_base.y += -_base.height * .5;
		_base.scrollFactor.x = _base.scrollFactor.y = 0;
		_base.solid = false;
		
		#if !FLX_NO_DEBUG
		_base.ignoreDrawDebug = true;
		#end
		
		add(_base);	
	}

	private override function createThumb():Void{
		_stick = new FlxSprite(x, y).loadGraphic(GameStatic.screenDensity==GameStatic.Density_S?"assets/img/tbStickS.png":"assets/img/tbStickM.png");
		_stick.cameras = [FlxG.camera];
		_stick.scrollFactor.x = _stick.scrollFactor.y = 0;
		_stick.solid = false;
		
		#if !FLX_NO_DEBUG
		_stick.ignoreDrawDebug = true;
		#end
		
		add(_stick);
	}
}