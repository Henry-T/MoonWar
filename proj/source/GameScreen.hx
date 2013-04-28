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
		FlxG.mouse.show("assets/img/cur.png");	
	}
}