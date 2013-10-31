package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;


// Generic Bullet!
class GecBul extends FlxSprite
{

public function new() 
{
	
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
}

override public function update():Void 
{
	
	super.update();
}

// Shot to target in stright line
public function LineShot(tgt:FlxPoint):Void {
	
}
}