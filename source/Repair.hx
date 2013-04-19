package;
import org.flixel.FlxSprite;

class Repair extends FlxSprite
{
	public function new(x:Float=0, y:Float=0, simpleGraphics:Dynamic=null)
	{
		super(x, y, simpleGraphics);
		loadGraphic("assets/img/hp.png");
	}

	public override function update()
	{

	}

	public override function draw()
	{
		// super.draw();
		super.draw();
	}
}