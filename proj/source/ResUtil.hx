package ;
import org.flixel.FlxG;



class ResUtil 
{
	public static function playTitle() : Void
	{
		FlxG.playMusic("title");
	}

	public static function playGame1() : Void
	{
		FlxG.playMusic("game");
	}
}