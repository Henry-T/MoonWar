package ;
import org.flixel.FlxG;
import org.flixel.util.FlxAngle;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.util.FlxRect;
import org.flixel.tmx.TmxObject;

class BWalk extends Enemy 
{
	public var inAction:Bool;
	public var dirRight:Bool;
	public var sense:Float;

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
		acceleration.y = 5000;
		health = 8;
		inAction = false;
	}

	public function make(o:TmxObject){
		reset(o.x, o.y);
		var d:String = o.custom.resolve("dir");
		dirRight = (d!="left");
		sense = Std.parseFloat(o.custom.resolve("sense"));
		senseRect = new FlxRect(o.x, o.y, o.width + sense, o.height);
		if(!dirRight)
			senseRect.x -= sense;
	}

	private var senseRect:FlxRect;
	override public function update():Void 
	{
		if(!inAction){
			var bot:Bot = cast(FlxG.state, Level).bot;
			var botRect:FlxRect = new FlxRect(bot.x, bot.y, bot.width, bot.height);
			if(senseRect.overlaps(botRect)){
				inAction = true;
			}
		}

		// won't move in air
		if(!isTouching(FlxObject.FLOOR)){
			velocity.x = 0;
		}

		// killed when hit wall
		if(isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)){
			kill();
		}

		// sync facing with speed
		if (velocity.x > 0)
			facing = FlxObject.RIGHT;
		else 
			facing = FlxObject.LEFT;
		
		if (isTouching(FlxObject.FLOOR) && inAction && velocity.x == 0)
		{
			var botX:Float = cast(FlxG.state, Level).bot.getMidpoint().x;
			var midX:Float = getMidpoint().x;
			if(Math.abs(midX - botX) < 3)
				velocity.x = 0;
			else if(midX > botX)
				velocity.x = -60;
			else 
				velocity.x = 60;
		}

		super.update();
	}
}