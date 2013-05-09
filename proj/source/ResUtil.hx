package ;
import org.flixel.FlxG;



class ResUtil 
{
	public static var FNT_Pixelex:String = "assets/fnt/pixelex.ttf";

	public static var IMG_ui_box_yellow = "assets/img/ui_box_y.png";
	public static var IMG_ui_box_act_yellow = "assets/img/ui_boxact_y.png";
	public static var IMG_ui_box_blue = "assets/img/ui_box_b.png";
	public static var IMG_ui_box_act_blue = "assets/img/ui_boxact_b.png";

	public static function playTitle() : Void
	{
		FlxG.playMusic("title");
	}

	public static function playGame1() : Void
	{
		FlxG.playMusic("game");
	}
}