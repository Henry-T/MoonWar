package;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Duck extends Enemy
{
	public var game:Level;

	public static var gOnDuck:Float = 40;
	public static var maxHealth = 1;

	public function new(x:Float=0, y:Float=0)
	{
		super(x,y,null);
		
		loadGraphic("assets/img/duck.png");
		acceleration.y = gOnDuck;
		health = maxHealth;
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		health = maxHealth;
	}

	override public function update():Void
	{
		super.update();
		
		// clear when out of stage
		if (x < FlxG.camera.scroll.x -20 || x > FlxG.camera.scroll.x + FlxG.width + 20 || y > FlxG.camera.scroll.y + FlxG.height+20)
		super.kill();
		
		// hack speed
		if (velocity.y == 0 || velocity.x == 0)
		{
		if (x > FlxG.camera.scroll.x + FlxG.width/2)
			velocity.x = -80;
		else
			velocity.x = 80;
		}
		
		// rotate to motion direction
		var agl:Float = Math.atan2(velocity.y, velocity.x);
		angle = agl * 180 / Math.PI + 90;
	}

	override public function kill():Void 
	{
		super.kill();
	}
}