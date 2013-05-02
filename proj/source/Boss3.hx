package ;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxU;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;
import flash.geom.Point;
import org.flixel.tmx.TmxMap;
import org.flixel.tmx.TmxObjectGroup;

class Boss3 extends Enemy
{
	public var timer1:FlxTimer;
	public var timer2:FlxTimer;

	public static var dashSpeed:Float = 800;
	public static var landSpeed:Float = 400;

	// state bool
	public var launching:Bool;
	public var shoting:Bool;
	public var dashing:Bool;
	public var bouncing:Bool;
	public var landing:Bool;
	public var misling:Bool;

	public var launchPos:FlxPoint;
	public var dashTgt:FlxPoint;
	public var fightRect:FlxRect;
	public var mislPos:FlxPoint;

	public var game:Level8;

	public static var maxLife:Float = 3000;

	public function new(x:Float, y:Float) 
	{
		//super(x+5+40, y+10+30+20);
		super(x, y);
		
		this.game = cast(FlxG.state , Level8);
		health = 3000;
		
		timer1 = new FlxTimer();
		timer2 = new FlxTimer();
		
		loadGraphic("assets/img/hm.png", true, true, 150);
		offset.x = 35;
		offset.y = 30;
		width = 80;
		height = 100;
		
		//fill(0x22222222);
		
		addAnimation("idle",[0],1,true);
		addAnimation("walk",[1,2,3,4,5,6,7,8],10,true);
		addAnimation("preJump",[11,12,13],3,false);
		addAnimation("jumping",[14],1,true);
		addAnimation("slash",[15,16,1,18,19],10,false);
		addAnimation("shot",[20,21,22,23,24,25,26],3,false);
		addAnimation("air",[28,27],1,false);
		addAnimation("airShot",[29,30,31,32,33,34,35],3,false);
		addAnimation("airDash",[36,37],2,false);
		addAnimation("airDashEnd",[38],1,false);
		addAnimation("zPre",[39,40],4,false);
		addAnimation("zIdle",[40],1,false);
		addAnimation("zWalk",[41,42,43,44,45,46,47,48],20,true);
		addAnimation("zEnd",[51],2,false);
		addAnimation("fall",[52,53,54,55,56,57],2,false);
		addAnimation("airDeath", [58, 59, 60, 60, 62, 63], 2, false);
		
		// load
		var os:TmxObjectGroup = cast(FlxG.state,Level8).tmx.getObjectGroup("misc");
		for(to in os.objects)
		{
		if(to.name=="bossLaunchMark")
			launchPos = new FlxPoint(to.x, to.y);
		else if (to.name == "fightArea")
			fightRect = new FlxRect(to.x, to.y, to.width, to.height);
		else if (to.name == "mislPos")
			mislPos = new FlxPoint(to.x, to.y);
		}
		facing = FlxObject.LEFT;
		
		// test
		//ChangeState("launching");
	}

	override public function update():Void 
	{
		super.update();
		
		if (launching)
		{
		if (y <= launchPos.y)
		{
			launching = false;
			velocity.y = 0;
			timer1.start(1, 1, function(t:FlxTimer):Void {
			ChangeState("shoting");
			});
		}
		}
	}

	public function ChangeState(name:String):Void
	{
		if (name == "launching")
		{
		launching = true;
		velocity.y = -30;
		play("air");
		}
		else if (name == "shoting")
		{
		shoting = true;
		timer1.start(5, 1, function(t:FlxTimer) {
			shoting = false;
			ChangeState("dashing");
		});
		timer2.start(0.9, 5, function(t:FlxTimer) {
			var bgb:BigGunBul = cast(game.bigGunBuls.recycle(BigGunBul) , BigGunBul);
			bgb.reset(x, y);
			bgb.visible = true;
			var len = Math.sqrt(Math.pow(game.bot.y - bgb.y,2)+ Math.pow(game.bot.x-bgb.x, 2));
			bgb.velocity.x = (game.bot.x - bgb.x)/len * 500;
			bgb.velocity.y = (game.bot.y - bgb.y)/len * 500;
		});
		}
		else if (name == "dashing")
		{
		dashing = true;
		dashTgt = new FlxPoint(game.bot.x, game.bot.y);
		if (dashTgt.x > fightRect.x + fightRect.width - width / 2)
			dashTgt.x = fightRect.x + fightRect.width - width / 2;
		if (dashTgt.x < fightRect.x + width / 2)
			dashTgt.x = fightRect.x + width / 2;
		if (dashTgt.y > fightRect.y + fightRect.height - height / 2)
			dashTgt.y = fightRect.y + fightRect.height - height / 2;
		if (dashTgt.y < fightRect.y + height / 2)
			dashTgt.y = fightRect.y + height / 2;
			
		var len:Float = FlxU.getDistance(dashTgt, new FlxPoint(x, y));
		var dashTime = len / dashSpeed;
		
		velocity.x = (dashTgt.x - x) / len * dashSpeed;
		velocity.y = (dashTgt.y - y) / len * dashSpeed;
		timer1.start(dashTime, 1, function(t:FlxTimer):Void {
			velocity.make(0, 0);
			dashing = false;
			ChangeState("bouncing");
		});
		}
		else if (name == "bouncing")
		{
		bouncing = true;
		timer1.start(5, 1, function(t:FlxTimer):Void {
			bouncing = false;
			ChangeState("landing");
		});
		timer2.start(0.7, 1, function(t:FlxTimer):Void {
			for (i in 0...8) 
			{
			var bcr:Bouncer = cast(cast(game , Level).bouncers.recycle(Bouncer) , Bouncer);
			bcr.reset(x, y);
			var ang:Float = (45 * i + 22.5) * Math.PI / 180;
			bcr.velocity.x = Math.cos(ang) * 200;
			bcr.velocity.y = Math.sin(ang) * 200;
			}
		});
		}
		else if (name == "landing")
		{
		landing = true;
		var len:Float = FlxU.getDistance(mislPos, new FlxPoint(x, y));
		var landTime = len / dashSpeed;
		
		velocity.x = (mislPos.x - x) / len * dashSpeed;
		velocity.y = (mislPos.y - y) / len * dashSpeed;
		timer1.start(landTime, 1, function(t:FlxTimer):Void {
			velocity.make(0, 0);
			landing = false;
			ChangeState("misling");
		});
		}
		else if (name == "misling")
		{
		misling = true;
		timer1.start(5, 1, function(t:FlxTimer):Void {
			velocity.make(0, 0);
			misling = false;
			ChangeState("launching");
		});
		timer2.start(1, 1, function(t:FlxTimer):Void {
			for (i in 0...3) 
			{
			var msl:Missle = cast(cast(game , Level).missles.recycle(Missle) , Missle);
			msl.reset(x, y);
			msl.tgt = game.bot;
			//var len:Float = FlxU.getDistance(new FlxPoint(msl.x, msl.y), new FlxPoint(game.bot.x, game.bot.y));
			//var ang:Float = 30 * (i - 1) * Math.PI / 180 + Math.acos((game.bot.x - msl.x) / (len));
			//if (game.bot.y -msl.y < 0)
			//	ang = -ang;
			//msl.curRad = ang;
			msl.curRad = 30 * (i - 1) * Math.PI / 180 - Math.PI / 2;
			msl.velocity.x = Math.cos(msl.curRad) * msl.speed;
			msl.velocity.y = Math.sin(msl.curRad) * msl.speed;
			}
		});
		}
	}
}