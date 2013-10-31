package;

import flash.Lib;
import flash.events.Event;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flixel.FlxGame;
import flixel.FlxG;
	
class MWGame extends FlxGame
{	
	var palseTimer:Timer;

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

		#if feedback
		BallBat.Initial("https://rulerbat.appspot.com");
		//BallBat.Initial("http://localhost:8080");
		BallBat.StartSession(GameStatic.GameName, GameStatic.GameVersion);

		palseTimer = new Timer(5000, 0);
		palseTimer.addEventListener("timer", function(param:Dynamic){
			BallBat.Palse(GameStatic.CurStateName, GameStatic.ExtraStr);
		});
		palseTimer.start();
		#end

		GameStatic.Initial();
		GameStatic.Load();
		#if debug
		GameStatic.ProcLvl = GameStatic.AllLevelCnt-1;
		#end

		FlxG.framerate = 30;
		FlxG.flashFramerate = 30;
		#if !FLX_NO_MOUSE
		flash.ui.Mouse.show();
		#end

		// preload all sound for android
		#if android
		FlxG.sound.add("birth1");
		FlxG.sound.add("explo1");
		FlxG.sound.add("hit1");
		FlxG.sound.add("hit2");
		FlxG.sound.add("jump2");
		FlxG.sound.add("sel1");
		FlxG.sound.add("shoot");
		FlxG.sound.add("shoot1");
		#end
	}
}
