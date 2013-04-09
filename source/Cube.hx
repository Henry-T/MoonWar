package ;
import org.flixel.FlxSprite;



class Cube extends FlxSprite 
{


public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null) 
{
	super(X, Y, "assets/img/cube.png");
	immovable = true;
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	health = 5;
}
}