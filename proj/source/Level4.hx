package ;
import org.flixel.system.FlxTile;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import flash.geom.Point;
import org.flixel.FlxTimer;
import org.flixel.FlxSprite;
import org.flixel.tmx.TmxObjectGroup;

class Level4 extends Level 
{
	public static var camLefting:Bool = false;
	public static var camLeftLen:Float = 8 * 20;
	public var camLeftStart:Float;
	public static var camDowning:Bool = false;
	public static var camDownLen:Float = 23 * 20;
	public var camDownStart:Float;
	public static var camRighting:Bool = false;
	public static var camRightLen:Float = 8 * 20;
	public var camRightStart:Float;

	public var bossP1:FlxPoint;
	public var bossP2:FlxPoint;
	public var bossP3:FlxPoint;
	public var bossRighting:Bool;

	public function new()
	{
		super();
		tileXML = nme.Assets.getText("assets/dat/level4.tmx");

		lines1 = [
			new Line(1,"Enemy spotted."),
			new Line(0,"RageMetal's force is dispersing in tunnel."),
			new Line(1,"Then I can handle them one by one."),
		];

		lines2 = [
			new Line(1,"The lift is broken."),
			new Line(0,"We can take the spare path, it is a little far throuth.")
		];

		//lines2 = [
		//	new Line(2,"Look, you don't have a lift anymore. See you!")
		//];

		//lines3 = [
		//	new Line(1,"It fled."),
		//	new Line(0,"We can take the spare path, it is a little far throuth.")
		///];
	}

	override public function create():Void 
	{
		super.create();
		
		GameStatic.CurLvl = 4;
		
		var os:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (to in os.objects)
		{
			if (to.name == "door2")
			{
				door2Up = new LDoor(to.x, to.y, false);
				door2Down = new LDoor(to.x, to.y, true);
				bInLift2 = new FlxSprite(to.x - 10, to.y - 6, "assets/img/bInLift.png");
			}
			else if (to.name == "comOut")
			{
				var com:Com = cast(coms.recycle(Com), Com);
				com.make(to);
				com.onTig = function(){door2Down.Unlock();};
			}
			else if (to.name == "hmPos1")
				bossP1 = new FlxPoint(to.x, to.y);
			else if (to.name == "hmPos2")
				bossP2 = new FlxPoint(to.x, to.y);
			else if (to.name == "hmPos3")
				bossP3 = new FlxPoint(to.x, to.y);
		}
		
		tileLand = GetTile("land", FlxObject.ANY); 
		tileLand2 = GetTile("land2", FlxObject.ANY); 
		
		boss2 = new Boss2(100, 800);
		bot.x = start.x; bot.y = start.y;
		
		AddAll();
		
		// initial
		tile.follow();
		FlxG.camera.follow(bot);
		ResUtil.playGame2();
		bot.On = false;
		timer1.start(1, 1, function(t:FlxTimer){
			lineMgr.Start(lines1, function(){
				bot.On = true;
			});
		});
	}


	public var coverOpen:Bool;
	override public function update():Void
	{
		if(!coverOpen)
			FlxG.collide(bot, tileCover);

		// End of Level
		if (FlxG.overlap(door2Up, bot) && door2Down.open && FlxG.keys.justPressed(bot.actionKey))
		{
			bot.On = false;
			timer1.start(2, 1, function(t:FlxTimer){
				lineMgr.Start(lines2, function(){
					coverOpen = true;
					tileCover.visible = false;

				});
			});
		}
		if(bot.x > end.x)
		{
			FlxG.fade(0xff000000, 2, function():Void {
				if (GameStatic.ProcLvl < 4) GameStatic.ProcLvl = 4;
				FlxG.switchState(new Level5());
			});
		}
		super.update();
	}
}