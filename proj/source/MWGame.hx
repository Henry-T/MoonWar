package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import nme.events.Event;
import org.flixel.system.input.FlxInputs;
	
class MWGame extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = 1;//stageWidth / 800;//640
		var ratioY:Float = 1;//stageHeight / 480;//480
		var ratio:Float = Math.min(ratioX, ratioY);

		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MainMenu, ratio, 30, 30);
		//super(550,400,IntroScreen,1);
		//super(550, 400,Tutorial,1);
		//super(550, 400,Level2,1);
		//super(550, 400, Level3, 1);
		//super(550, 400, Level4, 1);
		//super(550, 400, Level5, 1);
		//super(550, 400, Level6, 1);
		//super(550, 400, Level7, 1);
		
		//super(550, 400, Win, 1);
		//super(550, 400, GameOver, 1);
		
		//super(550,400,TestBed);

		GameStatic.Initial();
		GameStatic.Load();
		#if debug
		GameStatic.ProcLvl = GameStatic.AllLevelCnt-1;
		#end

		FlxG.framerate = 30;
		FlxG.flashFramerate = 30;
		nme.ui.Mouse.show();

		// preload all sound for android
		#if android
		FlxG.addSound("birth1");
		FlxG.addSound("explo1");
		FlxG.addSound("hit1");
		FlxG.addSound("hit2");
		FlxG.addSound("jump2");
		FlxG.addSound("sel1");
		FlxG.addSound("shoot");
		FlxG.addSound("shoot1");
		#end
	}

	private override function onFocus(FlashEvent:Event = null):Void{
		stage.frameRate = _flashFramerate;
		FlxG.resumeSounds();
		FlxInputs.onFocus();
		
		_state.onFocus();
	}

	private override function onFocusLost(FlashEvent:Event = null):Void{
		stage.frameRate = 10;
		FlxG.pauseSounds();
		FlxInputs.onFocusLost();
		
		_state.onFocusLost();
	}
}
