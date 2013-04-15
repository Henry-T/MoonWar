package;


import nme.Lib;
import org.flixel.FlxGame;
	
class ProjectClass extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 550;//640
		var ratioY:Float = stageHeight / 400;//480
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MainMenu, ratio, 30, 30);
		GameStatic.Load();
		// GameStatic.ProcLvl = 9;
	}
}
