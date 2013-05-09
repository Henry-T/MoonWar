package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import nme.events.Event;
	
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
		GameStatic.ProcLvl = 9;
		#end

		FlxG.framerate = 30;
		FlxG.flashFramerate = 30;
		nme.ui.Mouse.hide();
	}

	private override function onFocus(FlashEvent:Event = null):Void{

	}

	private override function onFocusLost(FlashEvent:Event = null):Void{

	}
}
