package;
import flixel.text.FlxText;
import flixel.FlxSprite;
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
		
		graphic = new FlxText(x + 5, y + 5, Math.round(width));
		graphic.text = text;
		graphic.setFormat(ResUtil.FNT_Pixelex, 8, 0x000000, "center");
		shown = true;
	}

	override public function draw():Void
	{
		if(shown)
		graphic.draw();
	}
}