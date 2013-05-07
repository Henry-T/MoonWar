package ;
import org.flixel.FlxG;
import org.flixel.FlxState;



class GameScreen extends MWState 
{
	public function new() 
	{
		super();
	}

	override public function create():Void 
	{
		super.create();
		#if !FLX_NO_MOUSE
		FlxG.mouse.show("assets/img/cur.png");
		#end
		ResUtil.playTitle();
	}
}