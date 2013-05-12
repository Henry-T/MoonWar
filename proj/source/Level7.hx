package ;
import org.flixel.system.FlxTile;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.system.FlxTile;
import org.flixel.tmx.TmxObjectGroup;
import org.flixel.addons.FlxBackdrop;

class Level7 extends Level 
{
	public var downing:Bool;
	public var downing2:Bool;
	public var zBallCenter:FlxPoint;
	public var zBallRadius:Float;
	public var zBallAngle:Float;
	public var zBallSpeed:Float;
	public var lock1:Bool;
	public var lock2:Bool;
	public var lock3:Bool;
	public var lock4:Bool;
	public var lastCom:Com;
	public var warnObj:FlxObject;
	public var warned:Bool;


	public function new()
	{
		super();
		tileXML = nme.Assets.getText("assets/dat/level7.tmx");
		zBallSpeed = 1.0;
		zBallAngle = 0;

		lines1 = [
			new Line(0,"To enter Moon Core, you have to start four terminals."),
			new Line(0,"Watch out for the electric ball.")
		];
	}

	public override function create():Void
	{
		super.create();
		
		GameStatic.CurLvl = 7;
		
		var mG:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (o in mG.objects) 
		{
			if (o.name == "door1")
			{
				bot.x = o.x+10; bot.y = o.y;
				door1Up = new LDoor(o.x, o.y, true); 
			}
			else if (o.name == "door2")
			{
				bInLift2 = new FlxSprite(o.x - 10, o.y - 6, "assets/img/bInLift_r.png");
				door2Up = new LDoor(o.x, o.y, false);
				door2Down = new LDoor(o.x, o.y, true);
			}
			else if (o.type == "com")
			{
				var com:Com = cast(coms.recycle(Com), Com);
				com.make(o);
				if (com.name == "comOut")
				{
					lastCom = com;
					com.onTig = function() { if (lock1 && lock2 && lock3 && lock4) door2Down.Unlock();};
				}
				else if(com.name == "comLock1")
					com.onTig = function() { lock1 = true; };
				else if(com.name == "comLock2")
					com.onTig = function() { lock2 = true; };
				else if(com.name == "comLock3")
					com.onTig = function() { lock3 = true; };
				else if(com.name == "comLock4")
					com.onTig = function() { lock4 = true; };
			}
			else if (o.name == "zBallPath"){
				zBallRadius = o.width / 2;
				zBallCenter = new FlxPoint(o.x + zBallRadius, o.y + zBallRadius);
			}
			else if (o.name == "zBallSize"){
				zball = new FlxSprite(o.x, o.y);
				zball.loadGraphic("assets/img/eball.png");
			}
			else if(o.name == "warn"){
				warnObj = new FlxObject(o.x, o.y, o.width, o.height);
			}
		}
			
		// tile
		bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift_r.png");		
		
		bd1 = new FlxBackdrop("assets/img/metal.png", 0.2, 0.2, true, true);

		AddAll();
		add(warnObj);

		// initial scene
		warned = false;
		bot.On = false;
		bot.facing = FlxObject.RIGHT;

		bInLift.velocity.y = 30;
		downing = true;
		downing2 = false;

		FlxG.flash(0xff000000, 2);
		FlxG.camera.follow(bot);
		ResUtil.playGame1();
		lock1 = false;
		lock2 = false;
		lock3 = false;
		lock4 = false;
		
		ShowSceneName("GATE OF MOON CORE");
	}

	override public function update():Void 
	{
		super.update();
		
		if (!lock1 || !lock2 || !lock3 || !lock4)
			lastCom.SetOn(false);

		// update lock statuc info
		var lockCnt:Int = (lock1?0:1) + (lock2?0:1) + (lock3?0:1) + (lock4?0:1);
		cast(tips.members[0], Tip1).graphic.text = lockCnt + " Lock Left to Open the Door";
		
		// warn
		if(!warned){
			FlxG.overlap(bot, warnObj, function(b:FlxObject, w:FlxObject){
				bot.On = false;
				warned = true;
				lineMgr.Start(lines1, function(){
					bot.On = true;
				});
			});
		}

		// Start
		if (downing && bInLift.y > door1Up.y - 20)
		{
			bInLift.velocity.y = 0;
			door1Up.Unlock();
		}
		if (door1Up.open && downing)
		{
			downing = false;
			bot.On = true;
			hpBar.visible = true;
		}
		
		// End
		if (FlxG.overlap(door2Up, bot) && door2Down.open && input.JustDown_Action && bot.On)
		{
			if((bot.x > door2Down.x + 5) && (bot.x + bot.width < door2Down.x + door2Down.width - 5)){
				door2Up.Colse(bot);
				bot.On = false;
			}
		}
		if (!downing2 && door2Up.locked)
		{
			downing2 = true;
			bInLift2.velocity.y = 30;
		}
		if (!isEnd && bInLift2.y > end.y)
		{
			EndLevel(true);
		}
		
		// update zball
		zBallAngle += FlxG.elapsed * zBallSpeed;
		var newZBPos = new FlxPoint(zBallCenter.x + Math.cos(zBallAngle) * zBallRadius, zBallCenter.y + Math.sin(zBallAngle) * zBallRadius);
		zball.x = newZBPos.x - zball.width / 2;
		zball.y = newZBPos.y - zball.height / 2;
	}
}