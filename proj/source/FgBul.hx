package;
import flixel.FlxSprite;

class FgBul extends FlxSprite
{
	

public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null)
{
	super(X, Y, SimpleGraphic);
	
	loadGraphic("assets/img/fgBul.png");
}
}