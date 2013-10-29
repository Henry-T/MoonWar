package;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.util.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.util.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;
import org.flixel.addons.FlxBackdrop;

class Level1 extends Level
{
	public var warnObj : FlxObject;
	public var fightArea : FlxObject;
	public var beePosAry : Array<FlxPoint>;
	public var guardPosAry : Array<FlxPoint>;
	public var theGuard : FlxSprite;
	public var inFight : Bool;
	public var fightOver : Bool;
	public var camPos1:FlxPoint;

	public function new()
	{
		super();
		
		tileXML = openfl.Assets.getText("assets/dat/level1.tmx");

		lines1 = [
			new Line(0, "CubeBot, it will be battle field soon outside the laboratory."),
			new Line(0, "We will have some test to ensure you are in good condition."),
			new Line(0, "Open each computer with x key"),
			new Line(0, "You will receive a tip to follow like this ..."),
		];

		lines2 = [
			new Line(1, "Get it")
		];

		lines3 = [
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
			else if(td.name == "cam1"){
				camPos1 = new FlxPoint(td.x + td.width * 0.5, td.y + td.height * 0.5);
			}
		}
		
		bd1 = new FlxBackdrop("assets/img/metal.png", 0.2, 0.2, true, true);

		// Initial
		GameStatic.CurLvl = 0;
		bot.x = start.x; bot.y = start.y; bot.On = false;
		FlxG.camera.follow(bot);
		inFight = false;
		fightOver = false;
		AddAll();
		TimerPool.Get().start(2, 1, function(t:FlxTimer){
			lineMgr.Start(lines1, function(){
				tipManager.ShowTip(TipManager.Tip_InterCom, function(){
					lineMgr.Start(lines2, function() {
						// Hack Well force fix
						TimerPool.Get().start(0.2, 1, function(t:FlxTimer){
							bot.On = true;
							hpBar.visible = true;
						});
					});
				}); 
			});
		});
		ShowSceneName("1 - Moon Laboratory");
	}

	override public function update():Void
	{
		super.update();
		if((confirm.visible&&confirm.isModel) || FlxG.paused || endPause)	return;

		FlxG.overlap(bot, end, function(b:FlxObject, e:FlxObject) { 
			if(!isEnd){
				EndLevel(true);
			}
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

					FlxG.camera.follow(null);
					TweenCamera(camPos1.x ,camPos1.y, 2, true, function(){
						lineMgr.Start(lines3, function(){
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
				TimerPool.Get().start(1, 1, function(t:FlxTimer){
					tipManager.ShowTip(TipManager.Tip_UpShoot);
				});
			}

			if(bot.x < fightArea.x)
				bot.x = fightArea.x;
			else if(bot.x > fightArea.x + fightArea.width - bot.width)
				bot.x = fightArea.x + fightArea.width - bot.width;

			if(Bees.countLiving() == 0 && guards.countLiving() == 0)
			{
				inFight = false;
				fightOver = true;
				FlxG.camera.follow(bot, 0 ,null, 5);
			}
		}
	}

	public function showTip(bot:Bot, tip:Tip1):Void
	{
		tip.shown = true;
	}
}