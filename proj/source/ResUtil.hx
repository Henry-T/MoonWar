package ;
import org.flixel.FlxG;



class ResUtil 
{
	public static function playTitle() : Void
	{
		FlxG.playMusic("assets/snd/DST-MrMagic.mp3");
	}

	public static function playGame1() : Void
	{
		FlxG.playMusic("assets/snd/DST-Assembly2.mp3");
	}
}