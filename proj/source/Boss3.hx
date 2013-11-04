package ;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flash.geom.Point;
import org.flixel.tmx.TmxMap;
import org.flixel.tmx.TmxObjectGroup;
import flixel.tweens.motion.LinearMotion;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Boss3 extends Enemy
{
	public var missileTimer:FlxTimer;
	public var bulletTimer:FlxTimer;
	public var bouncerTimer:FlxTimer;

	public static var dashSpeed:Float = 800;
	public static var landSpeed:Float = 400;

	// state bool
	public var shoting:Bool;
	public var lastBcrRight:Bool;

	public var launchPos:FlxPoint;
	public var dashTgt:FlxPoint;
	public var fightRect:FlxRect;

	public var mislPos:FlxPoint;
	public var posSnap:FlxPoint;
	public var posBcrL:FlxPoint;
	public var posBcrR:FlxPoint;
	public var posMslL:FlxPoint;
	public var posMslR:FlxPoint;

	public var game:Level8;

	public static var maxLife:Float = 200;

	public var bossFire:FlxSprite;
	public var FireOn:Bool;

	public var realPosInAir:FlxPoint;
	public var floatTimer:Float;
	public var floating:Bool;

	public var moveTween:LinearMotion;
	public var deathPingTween:LinearMotion;

	public var immu:Bool;

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		game = cast(FlxG.state , Level8);
		
		missileTimer = TimerPool.Get();
		bulletTimer = TimerPool.Get();
		bouncerTimer = TimerPool.Get();
		
		loadGraphic("assets/img/hm_red.png", true, true, 150);
		offset.x = 35;
		offset.y = 30;
		width = 80;
		height = 100;
		
		animation.add("idle",[0],1,true);
		animation.add("walk",[1,2,3,4,5,6,7,8],10,true);
		animation.add("preJump",[11,12,13],3,false);
		animation.add("jumping",[14],1,true);
		animation.add("slash",[15,16,1,18,19],10,false);
		animation.add("shot",[20,21,22,24,26],6,false);
		animation.add("air",[28,27],1,false);
		animation.add("airShot",[29,30,31,32,33,34,35],3,false);
		animation.add("airDash",[36,37],2,false);
		animation.add("airDashEnd",[38],1,false);
		animation.add("zPre",[39,40],4,false);
		animation.add("zIdle",[40],1,false);
		animation.add("zWalk",[41,42,43,44,45,46,47,48],20,true);
		animation.add("zEnd",[51],2,false);
		animation.add("fall",[52,53,54,55,56,57],2,false);
		animation.add("airDeath", [58, 59, 60, 60, 62, 63], 2, false);
		
		bossFire = new FlxSprite(-100, 0);
		bossFire.loadGraphic("assets/img/fire2.png", true, false, 64, 64);
		bossFire.animation.add("idle", [0, 1, 2, 1, 0], 20, true);
		bossFire.animation.add("off", [3, 4, 5, 6, 7, 8, 9, 10], 15, false);
		bossFire.animation.add("on", [9, 8, 7, 6, 5, 4, 3], 15, false);
		bossFire.animation.callback = function(name:String, frame:Int, index:Int){
			if(name == "on" && bossFire.animation.finished)
				bossFire.animation.play("idle");
			else if(name == "off" && bossFire.animation.finished)
				FireOn = false;
		};
		bossFire.offset.set(32, 0);

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
			else if (to.name == "posSnap")
				posSnap = new FlxPoint(to.x, to.y);
			else if (to.name == "posMslL")
				posMslL = new FlxPoint(to.x, to.y);
			else if (to.name == "posMslR")
				posMslR = new FlxPoint(to.x, to.y);
			else if (to.name == "posBcrL")
				posBcrL = new FlxPoint(to.x, to.y);
			else if (to.name == "posBcrR")
				posBcrR = new FlxPoint(to.x, to.y);
		}
		
		// initial
		facing = FlxObject.LEFT;
		health = maxLife;
		FireOn = false;
		moveTween = new LinearMotion(null, FlxTween.ONESHOT);
		moveTween.setObject(this);
		lastBcrRight = false;
		realKill = false;
		immu = true;
	}

	override public function update():Void 
	{
		// handle float
		if(floating){
			floatTimer += FlxG.elapsed;
			var addY:Float = Math.sin(floatTimer * 3) * 8;
			y = realPosInAir.y + addY;
			x = realPosInAir.x;
		}

		bossFire.x = getMidpoint().x;
		bossFire.y = getMidpoint().y + 20;
		bossFire.animation.update();

		// facing 
		if(game.bot.getMidpoint().x < x)
			facing = FlxObject.LEFT;
		else if(game.bot.getMidpoint().x > x + width)
			facing = FlxObject.RIGHT;

		super.update();
	}

	override public function draw(){
		if(FireOn)
			bossFire.draw();
		super.draw();
	}

	private var realKill:Bool;
	override public function kill(){
		if(!realKill){
			// kill all bullets of boss3
			game.bouncers.kill();
			game.missles.kill();
			game.boss3Buls.kill();

			// stop tracked timers!
			bulletTimer.abort();
			missileTimer.abort();
			bouncerTimer.abort();

			// clear tween
			moveTween.cancel();
			deathPingTween = new LinearMotion(null, FlxTween.PINGPONG);
			deathPingTween.setMotion(x-3, y, x + 3, y, 0.6, FlxEase.cubeInOut);
			deathPingTween.setObject(this);
			game.addTween(deathPingTween);

			// schedule explosion
			TimerPool.Get().run(0.7, function(t:FlxTimer){
				game.AddExp(x + Math.random() * width, y + Math.random() * height);
				game.AddExp(x + Math.random() * width, y + Math.random() * height);
				TimerPool.Get().run(0.1, function(t:FlxTimer){
					TimerPool.Get().run(0.5, function(t:FlxTimer){FlxG.camera.flash(0xffffffff, 0.3);},2);
					TimerPool.Get().run(1, function(t:FlxTimer){realKill = true;kill();});
				});
			},7);
			TimerPool.Get().run(2.2, function(t:FlxTimer){
				game.AddHugeExplo(x + Math.random() * width, y + Math.random() * height);
			},2);
		}
		else 
			super.kill();
	}

	public function ChangeState(name:String):Void
	{
		if (name == "launching")
		{
			animation.play("air");
			FireOn = true;
			bossFire.animation.play("on");
			moveTween.setMotion(x, y, posSnap.x, posSnap.y, 2, FlxEase.quadInOut);
			moveTween.setObject(this);
			moveTween.complete = function(t:FlxTween){
				enableFloat(true);
				TimerPool.Get().run(0.5, function(t:FlxTimer):Void {
					ChangeState("shoting");
				});
			}
			game.addTween(moveTween);
		}
		else if (name == "shoting")
		{
			shoting = true;
			TimerPool.Get().run(5, function(t:FlxTimer) {
				shoting = false;
				ChangeState("dashing");
			});
			bulletTimer.run(0.9, function(t:FlxTimer) {
				var bgb:BigGunBul = cast(game.boss3Buls.recycle(BigGunBul) , BigGunBul);
				bgb.loadGraphic("assets/img/bul4.png");
				bgb.reset(getMidpoint().x + ((facing==FlxObject.RIGHT)?10:-10), getMidpoint().y - 20);
				bgb.visible = true;
				var len = Math.sqrt(Math.pow(game.bot.y - bgb.y,2)+ Math.pow(game.bot.x-bgb.x, 2));
				bgb.velocity.x = (game.bot.x - bgb.x)/len * 300;
				bgb.velocity.y = (game.bot.y - bgb.y)/len * 300;
			},5);
		}
		else if (name == "dashing")
		{
			enableFloat(false);
			moveTween.setMotion(x, y, lastBcrRight?posBcrL.x:posBcrR.x, lastBcrRight?posBcrL.y:posBcrR.y, 1.5, FlxEase.quadInOut);
			moveTween.setObject(this);
			moveTween.complete = function(t:FlxTween){enableFloat(true); TimerPool.Get().run(0.5, function(_){ChangeState("bouncing");});};
			game.addTween(moveTween);
		}
		else if (name == "bouncing")
		{
			enableFloat(true);
			TimerPool.Get().run(5, function(t:FlxTimer):Void {
				ChangeState("landing");
			});
			bouncerTimer.run(0.7, function(t:FlxTimer):Void {
				for (i in 0...8) 
				{
					var bcr:Bouncer = cast(cast(game , Level).bouncers.recycle(Bouncer) , Bouncer);
					bcr.reset(getMidpoint().x, getMidpoint().y);
					var ang:Float = (45 * i + 22.5) * Math.PI / 180;
					bcr.velocity.x = Math.cos(ang) * 200;
					bcr.velocity.y = Math.sin(ang) * 200;
				}
			});
		}
		else if (name == "landing")
		{
			bossFire.animation.play("off");
			enableFloat(false);

			moveTween.setMotion(x, y, lastBcrRight?posMslL.x:posMslR.x, lastBcrRight?posMslL.y:posMslR.y, 1.5, FlxEase.quadInOut);
			moveTween.setObject(this);
			moveTween.complete = function(tween:FlxTween){
				TimerPool.Get().run(1.5, function(t:FlxTimer):Void {
					velocity.set(0, 0);
					ChangeState("misling");
				});
			};
			game.addTween(moveTween);
			lastBcrRight = !lastBcrRight;

			//var len:Float = FlxMath.getDistance(mislPos, new FlxPoint(x, y));
			//var landTime = len / (dashSpeed * 0.5);
			
			//velocity.x = (mislPos.x - x) / len * (dashSpeed * 0.5);
			//velocity.y = (mislPos.y - y) / len * (dashSpeed * 0.5);
			
		}
		else if (name == "misling")
		{
			TimerPool.Get().run(5, function(t:FlxTimer):Void {
				velocity.set(0, 0);
				ChangeState("launching");
			});
			TimerPool.Get().run(2,function(_){animation.play("idle");});
			missileTimer.run(1, function(t:FlxTimer):Void {
				animation.play("shot");
				for (i in 0...3) 
				{
					var msl:Missle = cast(cast(game , Level).missles.recycle(Missle) , Missle);
					msl.reset(getMidpoint().x, getMidpoint().y);
					msl.tgt = game.bot;
					//var len:Float = FlxMath.getDistance(new FlxPoint(msl.x, msl.y), new FlxPoint(game.bot.x, game.bot.y));
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

	public function enableFloat(enable:Bool){
		if(enable){
			floating = true;
			floatTimer = 0;
			realPosInAir = new FlxPoint(x, y);
		}
		else
			floating = false;
	}
}