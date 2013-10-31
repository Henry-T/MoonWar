package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

class TestBed extends Level
{
	public var Tile:FlxTilemap;
	public var sp:FlxSprite;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		
		FlxG.cameras.bgColor = 0xff005588;
		ResetTile();
		add(Tile); 
		Tile.follow();
		
		bullets = new FlxGroup();
		bot.x = 100; bot.y = 100;
		
		add(Tile);
		add(bot);
		add(bullets);
		add(bigGunBuls);
		add(Bees);
		
		sp = new FlxSprite(200, 200, Bee."assets/img/beeMonk.png");
		add(sp);
		
	}

	override public function update():Void 
	{
		super.update();
		
		FlxG.collide(bot, Tile);
		
		if (Bees.countLiving() <= 0)
		{
		var b:Bee = cast(Bees.recycle(Bee) , Bee);
		b.reset(0,0);
		b.resetMode(400, 100, "Bomb");
		b.target = bot;
		}
	}

	public function ResetTile():Void
	{
		var tile = new FlxTilemap();
		var data:Array = [
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
		tile.loadMap(FlxTilemap.arrayToCSV(data, 28), "assets/img/defTile.png", 20, 20);
		this.replace(Tile, tile);
		Tile = tile;
	}
}