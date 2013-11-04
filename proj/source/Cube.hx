package ;
import flixel.FlxSprite;
import org.flixel.tmx.TmxObject;


class Cube extends Enemy 
{
	public var group:Int;
	public var isBomb:Bool;

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null) 
	{
		super(X, Y, "assets/img/cube.png");
		immovable = true;
		isBomb = false;
	}

	public function make(o:TmxObject){
		reset(o.x, o.y);
		if(o.custom.resolve("type") == "death"){
			isBomb = true;
			loadGraphic("assets/img/cubeDeath.png");
		}
		else
			isBomb = false;

		group = Std.parseInt(o.custom.resolve("group"));
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		health = 3;
	}
}