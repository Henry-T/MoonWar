package;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

class HPBar extends FlxSprite{
	public var bg:SliceShape;
	public var hud:FlxSprite;
	public var bhBar:FlxSprite;
	public var bhCover:FlxSprite;

	public function new(){
		super();
		bg = new SliceShape(15, 6, 164, 30, "assets/img/ui_slice_b.png", SliceShape.MODE_BOX, 5);
		bg.scrollFactor.set(0,0);
		hud = new FlxSprite(-30,-5, "assets/img/hud.png");
		hud.scrollFactor = new FlxPoint(0,0);
		bhBar = new FlxSprite(19, 15, "assets/img/bhBar.png");
		bhBar.scrollFactor = new FlxPoint(0, 0); bhBar.origin = new FlxPoint(0, 0);
		bhCover = new FlxSprite(19, 15, "assets/img/bhCover.png");
		bhCover.scrollFactor = new FlxPoint(0, 0);
	}

	public override function update(){
		var bot:Bot = cast(FlxG.state, Level).bot;
		
		if (bot!=null)
		{
			var bhs:Float = (bot.health / 100 > 0)?(bot.health/100):0;
			bhBar.scale = new FlxPoint(bhs, 1);
		}
	}

	public override function draw(){
		super.draw();
		bg.draw();
		hud.draw();
		bhBar.draw();
		bhCover.draw();
	}


}