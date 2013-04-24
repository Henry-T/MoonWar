package;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;

class Dumom extends FlxSprite
{
public var duckSpawnTime:Float;
public var DuckSpawnCold:Float;
public var SpawnPos:FlxPoint;
public var game:Level;

public function new(game:Level, x:Float=0, y:Float=0, Width:Float=0, Height:Float=0)
{
	super(x, y, null);
	this.width = Width;
	this.height= Height;
	duckSpawnTime = 0;
	DuckSpawnCold =  0.0001;// 200;
	SpawnPos = new FlxPoint(392, 400);
	this.game = game;
}

override public function update():Void
{
	if (duckSpawnTime > DuckSpawnCold)
	{
	//var duck:Duck = game.ducks.recycle(Duck) as Duck;
	var duck:Duck = cast(game.ducks.add(new Duck()) , Duck);
	duck.reset(SpawnPos.x, SpawnPos.y);
	duck.velocity.x = -1000 + FlxG.random() * 2000;
	duck.velocity.y = -100 + FlxG.random() * 200;
	duckSpawnTime = 0;
	}
	else
	{
	duckSpawnTime += FlxG.elapsed;
	}
}
}