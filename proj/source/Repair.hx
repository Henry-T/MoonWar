package;
import flixel.FlxSprite;
import flixel.FlxG;

class Repair extends FlxSprite
{
	public static var waitCD:Float = 1.5;
	public var waitTimer:Float = 0;
	public var waitOn:Bool;

	public function new(x:Float=0, y:Float=0, simpleGraphics:Dynamic=null)
	{
		super(x, y, simpleGraphics);
		loadGraphic("assets/img/hp.png");
		waitOn = false;
	}

	public override function reset(X:Float, Y:Float){
		super.reset(X, Y);
		waitOn = false;
		waitTimer = 0;
	}

	public override function update()
	{
		super.update();
		if(waitOn){
			waitTimer += FlxG.elapsed;
			if(waitTimer > waitCD){
				waitOn = false;
			}
		}
	}

	public override function draw()
	{
		// super.draw();
		super.draw();
	}

	public function Wait(){
		waitOn = true;
		waitTimer = 0;
		flixel.util.FlxSpriteUtil.flicker(this, waitCD);
	}
}