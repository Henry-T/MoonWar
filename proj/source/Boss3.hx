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
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.FlxTween;
import org.flixel.tweens.util.Ease;

class Boss3 extends Enemy
{
	public var timer1:FlxTimer;
	public var timer2:FlxTimer;
	public var timer3:FlxTimer;

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

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		game = cast(FlxG.state , Level8);
		
		timer1 = new FlxTimer();
		timer2 = new FlxTimer();
		timer3 = new FlxTimer();
		
		loadGraphic("assets/img/hm.png", true, true, 150);
		offset.x = 35;
		offset.y = 30;
		width = 80;
		height = 100;
		
		addAnimation("idle",[0],1,true);
		addAnimation("walk",[1,2,3,4,5,6,7,8],10,true);
		addAnimation("preJump",[11,12,13],3,false);
		addAnimation("jumping",[14],1,true);
		addAnimation("slash",[15,16,1,18,19],10,false);
		addAnimation("shot",[20,21,22,24,26],6,false);
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
		
		bossFire = new FlxSprite(-100, 0);
		bossFire.loadGraphic("assets/img/fire2.png", true, false, 64, 64);
		bossFire.addAnimation("idle", [0, 1, 2, 1, 0], 20, true);
		bossFire.addAnimation("off", [3, 4, 5, 6, 7, 8, 9, 10], 15, false);
		bossFire.addAnimation("on", [9, 8, 7, 6, 5, 4, 3], 15, false);
		bossFire.addAnimationCallback(function(name:String, frame:Int, index:Int){
			if(name == "on" && bossFire.finished)
				bossFire.play("idle");
			else if(name == "off" && bossFire.finished)
				FireOn = false;
		});
		bossFire.offset.make(32, 0);

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
		bossFire.updateAnimation();

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

	public function ChangeState(name:String):Void
	{
		if (name == "launching")
		{
			play("air");
			FireOn = true;
			bossFire.play("on");
			moveTween.setMotion(x, y, posSnap.x, posSnap.y, 2, Ease.quadInOut);
			moveTween.setObject(this);
			moveTween.complete = function(){
				enableFloat(true);
				timer1.start(0.5, 1, function(t:FlxTimer):Void {
					ChangeState("shoting");
				});
			}
			game.addTween(moveTween);
		}
		else if (name == "shoting")
		{
			shoting = true;
			timer1.start(5, 1, function(t:FlxTimer) {
				shoting = false;
				ChangeState("dashing");
			});
			timer2.start(0.9, 5, function(t:FlxTimer) {
				var bgb:BigGunBul = cast(game.boss3Buls.recycle(BigGunBul) , BigGunBul);
				bgb.loadGraphic("assets/img/bul4.png");
				bgb.reset(getMidpoint().x + ((facing==FlxObject.RIGHT)?10:-10), getMidpoint().y - 20);
				bgb.visible = true;
				var len = Math.sqrt(Math.pow(game.bot.y - bgb.y,2)+ Math.pow(game.bot.x-bgb.x, 2));
				bgb.velocity.x = (game.bot.x - bgb.x)/len * 500;
				bgb.velocity.y = (game.bot.y - bgb.y)/len * 500;
			});
		}
		else if (name == "dashing")
		{
			enableFloat(false);
			moveTween.setMotion(x, y, lastBcrRight?posBcrL.x:posBcrR.x, lastBcrRight?posBcrL.y:posBcrR.y, 1.5, Ease.quadInOut);
			moveTween.setObject(this);
			moveTween.complete = function(){enableFloat(true); timer1.start(0.5, 1, function(_){ChangeState("bouncing");});};
			game.addTween(moveTween);
		}
		else if (name == "bouncing")
		{
			enableFloat(true);
			timer1.start(5, 1, function(t:FlxTimer):Void {
				ChangeState("landing");
			});
			timer2.start(0.7, 1, function(t:FlxTimer):Void {
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
			bossFire.play("off");
			enableFloat(false);

			moveTween.setMotion(x, y, lastBcrRight?posMslL.x:posMslR.x, lastBcrRight?posMslL.y:posMslR.y, 1.5, Ease.quadInOut);
			moveTween.setObject(this);
			moveTween.complete = function(){
				timer1.start(1.5, 1, function(t:FlxTimer):Void {
					velocity.make(0, 0);
					ChangeState("misling");
				});
			};
			game.addTween(moveTween);
			lastBcrRight = !lastBcrRight;

			//var len:Float = FlxU.getDistance(mislPos, new FlxPoint(x, y));
			//var landTime = len / (dashSpeed * 0.5);
			
			//velocity.x = (mislPos.x - x) / len * (dashSpeed * 0.5);
			//velocity.y = (mislPos.y - y) / len * (dashSpeed * 0.5);
			
		}
		else if (name == "misling")
		{
			timer1.start(5, 1, function(t:FlxTimer):Void {
				velocity.make(0, 0);
				ChangeState("launching");
			});
			timer3.start(2, 1,function(_){play("idle");});
			timer2.start(1, 1, function(t:FlxTimer):Void {
				play("shot");
				for (i in 0...3) 
				{
					var msl:Missle = cast(cast(game , Level).missles.recycle(Missle) , Missle);
					msl.reset(getMidpoint().x, getMidpoint().y);
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