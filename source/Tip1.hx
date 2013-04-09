package;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import org.flixel.tmx.TmxObject;

class Tip1 extends FlxSprite
{
public var text:String;
public var graphic:FlxText;
public var shown:Bool;

public function new()
{
	super(0, 0, null);
}

public function make(o:TmxObject)
{
	reset(o.x, o.y);
	width = o.width;
	height = o.height;
	text = o.custom.resolve("text");
	
	graphic = new FlxText(x, y, 250);
	graphic.text = text;
	shown = true;
}

override public function draw():Void
{
	if(shown)
	graphic.draw();
}
}