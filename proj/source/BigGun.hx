package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxObject;

class BigGun extends Enemy
{
	public static var ColdDown:Float = 2.5;
	public var ShotTimer:Float = 0;

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y, null);
		
		loadGraphic("assets/img/bigGun.png", true, true, 60, 40);
		animation.add("idle", [0], 1, false);
		animation.play("idle");
		
		immovable = true;
		ShotTimer = 0;
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		health = 5;
		ShotTimer = 0;
	}

	override public function update():Void
	{
		if(this.onScreen())
		{
			ShotTimer += FlxG.elapsed;
			if(ShotTimer >= ColdDown)
			{
				var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
				bgb.reset(getMidpoint().x + (facing==FlxObject.RIGHT?20:-20), getMidpoint().y-13);
				bgb.velocity = new FlxPoint(facing==FlxObject.LEFT?-200:200, 0);
				ShotTimer -= ColdDown;
			}
		}
		super.update();
	}
}