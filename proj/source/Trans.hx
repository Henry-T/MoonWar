package;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;

class Trans extends FlxSprite
{

public var transLife:Float;

public function new(x:Float, y:Float, SimpleGraphic:Dynamic)
{
	super(x, y, SimpleGraphic);
	
	loadGraphic("assets/img/trans.png");
	offset = new FlxPoint(0,20);
	width = 175; height=60;
	transLife = 100;
	health = 100000;
	velocity.x = 300;
	this.allowCollisions = FlxObject.UP;	// only collide on top to lift the bot
	this.immovable = true;			// will not be affected by bot
}

override public function update():Void
{
	super.update();
	if(health <=0)
	this.kill();
}
}