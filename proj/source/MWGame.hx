package;
import org.flixel.FlxG;
import org.flixel.FlxGame;

class MWGame extends FlxGame
{
	public function new()
	{
		super(550,400,MainMenu,1);
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
		
		FlxG.framerate = 30;
		FlxG.flashFramerate = 30;
		GameStatic.Load();
	}
}