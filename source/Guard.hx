package ;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

class Guard extends Enemy 
{
	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y, null);
		loadGraphic("assets/img/guard.png", true, true);
		addAnimation("def", [0], 1, true);
		play("def");
		acceleration.y = 100;
		velocity.x = 100;
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		velocity.x = 100;
		health = 3;
	}

	override public function update():Void 
	{
		if(isTouching(FlxObject.LEFT))
			velocity.x = 100;
		if (isTouching(FlxObject.RIGHT))
			velocity.x = -100;
		
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