package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.addons.editors.tiled.TiledObject;


class Mine extends Enemy 
{
	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null)
	{
		super(X, Y, "assets/img/mine.png");
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
	}

	public function make(o:TiledObject):Void
	{
		reset(o.x, o.y);
		offset = new FlxPoint(0, -10);
	}

	override public function update():Void 
	{
		super.update();
	}
}