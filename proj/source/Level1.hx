package;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;

class Level1 extends Level
{
	public var warnObj : FlxObject;
	public var fightArea : FlxObject;
	public var beePosAry : Array<FlxPoint>;
	public var guardPosAry : Array<FlxPoint>;
	public var hpPos : FlxPoint;
	public var theGuard : FlxSprite;
	public var inFight : Bool;
	public var fightOver : Bool;

	public function new()
	{
		super();
		
		tileXML = nme.Assets.getText("assets/dat/level1.tmx");

		lines1 = [
		new Line(0, "CubeBot, it will be battle field soon outside the laboratory."),
		new Line(0, "We will have some test to ensure you are in good condition."),
		new Line(0, "Your tips are printed on screens, go for it now."),
		new Line(1, "OK.")
		];

		lines2 = [
		new Line(0, "Well, the war comes in advance."),
		new Line(1, "I can use them to warm up.")
		];

		beePosAry = new Array<FlxPoint>();
		guardPosAry = new Array<FlxPoint>();
	}

	override public function create():Void
	{
		super.create();

		// load fight data
		var fd:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (td in fd.objects) {
			if(td.name == "warn")
			{
				warnObj = new FlxObject(td.x, td.y, td.width, td.height);
			}
			else if(td.type == "posGuard")
			{
				guardPosAry.push(new FlxPoint(td.x, td.y));
			}
			else if(td.type == "posBee")
			{
				beePosAry.push(new FlxPoint(td.x, td.y));
			}
			else if(td.name == "fightArea")
			{
				fightArea = new FlxObject(td.x, td.y, td.width, td.height);
			}
			else if(td.name == "hp")
			{
				hpPos = new FlxPoint(td.x, td.y);
			}
		}
		
		// Initial
		GameStatic.CurLvl = 1;
		tile.follow();
		bot.x = 50; bot.y = 150; bot.On = false;
		FlxG.camera.follow(bot);
		inFight = false;
		fightOver = false;
		AddAll();
		timer1.start(2, 1, function(t:FlxTimer){
			lineMgr.Start(lines1, function(){
				bot.On = true;
			});
		});
	}

	override public function update():Void
	{
		FlxG.overlap(bot, end, function(b:FlxObject, e:FlxObject) { 
			FlxG.fade(0xff000000, 2, function() { 
				if (GameStatic.ProcLvl < 1) 
				GameStatic.ProcLvl = 1; 
				FlxG.switchState(new Win());
				});
			});

		if(!fightOver && !inFight)
		{
			FlxG.overlap(bot, warnObj, function(b:FlxObject, w:FlxObject) {
				// hack the bug of getting two guards!
				if (theGuard == null)
				{
					theGuard = new Guard();
					theGuard.reset(guardPosAry[0].x, guardPosAry[0].y - 350);
					theGuard.facing = FlxObject.LEFT;
					theGuard.velocity.x = 0;
					guards.add(theGuard);
					bot.On = false;
					inFight = true;
					timer1.start(2, 1, function(t:FlxTimer){
						lineMgr.Start(lines2, function(){
							bot.On = true;
							theGuard.velocity.x = -100;
						});
					});
				}
			});
		}

		if(inFight)
		{
			if(theGuard.alive == false && Bees.length == 0)
			{
				for (bp in beePosAry) {
					var bee:Bee = new Bee(bp.x, bp.y);
					bee.resetMode(bp.x, bp.y,"Monk");
					bee.target = bot;
					Bees.add(bee);
				}
			}

			if(bot.x < fightArea.x)
				bot.x = fightArea.x;
			else if(bot.x > fightArea.x + fightArea.width - bot.width)
				bot.x = fightArea.x + fightArea.width - bot.width;

			if(Bees.countLiving() == 0 && guards.countLiving() == 0)
			{
				inFight = false;
				fightOver = true;
				var rpr : Repair = new Repair(hpPos.x, hpPos.y);
				hps.add(rpr);
			}
		}

		super.update();
	}

	public function showTip(bot:Bot, tip:Tip1):Void
	{
		tip.shown = true;
	}
}