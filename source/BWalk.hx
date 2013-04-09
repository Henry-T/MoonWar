package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;



class BWalk extends FlxSprite 
{


public var walking:Bool;

public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null) 
{
	super(X, Y, SimpleGraphic);
	
	loadGraphic("assets/img/bWalk.png", true, true);
	addAnimation("def", [0], 1, true);
	play("def");
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	walking = false;
	acceleration.y = 500;
	health = 8;
}

override public function update():Void 
{
	if (!walking && isTouching(FlxObject.FLOOR))
	{
	velocity.x = (cast(FlxG.state , Level).bot.getMidpoint().x > getMidpoint().x)?40: -40;
	}
	
	if (walking && isTouching(FlxObject.LEFT))
	velocity.x = 40;
	if (walking && isTouching(FlxObject.RIGHT))
	velocity.x = -40;
	
	if (velocity.x > 0)
	facing = FlxObject.RIGHT;
	else 
	facing = FlxObject.LEFT;
	
	super.update();
}

override public function hurt(Damage:Float):Void 
{
	super.hurt(Damage);
}

override public function kill():Void 
{
	super.kill();
}

}