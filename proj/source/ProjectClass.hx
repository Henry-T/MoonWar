package;


import nme.Lib;
import org.flixel.FlxGame;
	
class ProjectClass extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = 1;//stageWidth / 800;//640
		var ratioY:Float = 1;//stageHeight / 480;//480
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MainMenu, ratio, 30, 30);
		GameStatic.Load();
		//#if debug
		GameStatic.ProcLvl = 9;
		//#end
	}
}
