package;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxTimer;
import org.flixel.FlxObject;

class Boss1 extends Enemy
{
	// appear1L appear1R moveUpLen appear2L appear2R
	// jumpLen

	// logic: appear(swingx1) -> prepShoot(moveHandx1) -> shoot -> 
	//		[StopShooting]	-> stoping(-moveHandx1)
	//		[JumpSword]1/2	-> prepJump(lowBody) -> jumpAttack(nLeg&swording) -> landing(lowBody2)
	//		turn back -> disappear;
	public static var STappear 	: Int = 0;
	public static var STpreShoot: Int = 1;
	public static var STshoot	: Int = 2;
	public static var STstopShot: Int = 3;
	public static var STpreJump	: Int = 4;
	public static var STjumpAtk	: Int = 5;
	public static inline var STdisappear : Int = 6;
	public static var STdefeat	: Int = 7;
	public static var STdefDisp	: Int = 8;

	public static var maxLife:Float = 100;
	public var state:Float;	// 0-appear 1-prepShoot 2-shoot 3-stopShoot 4-prepJump 5-jumpAttack 6-disappear 7-defeated 8-defDisp
	public var lastAppearLeft:Bool;
	public var appearLL:Float;
	public var appearLW:Float;
	public var appearRL:Float;
	public var appearRW:Float;
	public var appearY:Float;
	public var moveUpLen:Float;
	public var moveUpTime:Float;
	public var ashTime:Float;
	public var appearX:Float;
	public var collG:FlxGroup;
	public var cR:FlxSprite;

	public var timer:FlxTimer;
	public var timerPShot:FlxTimer;
	public var shotCnt:Int;
	public var perShotCnt:Int;

	public var slash:FlxSprite;

	public var game:Level2;

	// launch bow
	public static var bowPos:FlxPoint = new FlxPoint(0, -60);		// bow origin
	//public static var bowRotL:Float = 0.3;	// origin rot when facing left
	//public static var bowRotR:Float = -0.3;	// origin rot when facing right
	public static var bowRotL:Float = 0;	// origin rot when facing left
	public static var bowRotR:Float = 0;	// origin rot when facing right
	public static var bowArrawBaseRot = 0;	// the arraw angle in middle
	public static var bowArrawRotStep = 0.2;	// angle delta between arraws
	public static var bowStartLen = 70;
	public static var bowPower = 150;		// initial speed for bow
	public static var bowCold = 0.2;		// bow shoot cold down sync with the animation

	public var hurtBase:Bool;

	public var bossFire:FlxSprite;
	public var FireOn:Bool;

	public var realPosInAir:FlxPoint;
	public var floatTimer:Float;
	public var floating:Bool;

	public var landHeight:Float;

	public function new(x:Float, y:Float, game:Level2)
	{
		super(x, y, null);
		
		this.game = game;
		
		timer = new FlxTimer();
		timerPShot = new FlxTimer();
		
		this.loadGraphic("assets/img/hm.png", true, true, 150);
		this.width = 65;
		this.height = 95;
		this.offset.x = 42;
		this.offset.y = 30;

		landHeight = 400;
		
		addAnimation("idle",[0],1,true);
		addAnimation("walk",[1,2,3,4,5,6,7,8],10,true);
		addAnimation("preJump",[11,12,13],3,false);
		addAnimation("jumping",[14],1,true);
		addAnimation("slash",[15,16,1,18,19],10,false);
		addAnimation("shot",[20,21,22,23,24,25,26],3,false);
		addAnimation("air",[27],4,true);	// 27, 28
		addAnimation("airShot",[29,30,31,32,33,34,35],3,false);
		addAnimation("airDash",[36,37],2,false);
		addAnimation("airDashEnd",[38],1,false);
		addAnimation("zPre",[39,40],4,false);
		addAnimation("zIdle",[40],1,false);
		addAnimation("zWalk",[41,42,43,44,45,46,47,48],20,true);
		addAnimation("zEnd",[51],2,false);
		addAnimation("fall",[52,53,54,55,56,57],4,false);
		addAnimation("airDeath",[58,59,60,60,62,63],2,false);
		addAnimation("airShock", [57], 1, false);
		
		perShotCnt = 0;
		
		this.facing = FlxObject.LEFT;
		//this.play("walk");
		  
		lastAppearLeft = false;
		appearLL = 0;	// This value is set in level2 based on surface base position
		appearLW = 1;	//140
		appearRL = 0;	// 360
		appearRW = 1;
		appearY = 540;
		moveUpLen = 160;
		
		collG = new FlxGroup();
		cR = new FlxSprite(40, 26);
		cR.makeGraphic(72, 26, 0x44ffffff);
		//collG.add(cR);
		
		shotCnt = 0;
		
		slash = new FlxSprite(0,0);
		slash.loadGraphic("assets/img/slash.png", true, true, 160, 120);
		//slash.makeGraphic(160, 120, 0x88ffffff);
		slash.addAnimation("slash", [0,1,2,3,4,5,6,7], 10, false);
		
		health = maxLife;

		bossFire = new FlxSprite(-100, 0);
		bossFire.loadGraphic("assets/img/fire2.png", true, false, 64, 64);
		bossFire.addAnimation("idle", [0, 1, 2, 1, 0], 20, true);
		bossFire.addAnimation("off", [3, 4, 5, 6, 7, 8, 9, 10], 15, false);
		bossFire.offset.make(32, 0);
		bossFire.play("idle");

		FireOn = false;
	}

	override public function update():Void
	{
		//if(this.x < 0)
		//	this.x = 300;
		slash.facing = facing;
		
		if(facing == FlxObject.RIGHT){
			slash.x = this.x;
			slash.y = this.y;
		}
		else {
			slash.x = this.x - 90;
			slash.y = this.y;
		}
		//slash.update();
		slash.updateAnimation();
		if (slash.frame == 3 || slash.frame == 4 || slash.frame == 5 || slash.frame == 6)
		{
			FlxG.overlap(cast(FlxG.state , Level).bot, slash, function(bot:FlxObject, s:FlxObject) 
			{ 
				bot.hurt(30); 
			});
		}
		if (slash.frame == 4 && hurtBase==false)
		{
			game.sBase.hurt(10);
			hurtBase = true;
		}
		if (slash.finished)
		hurtBase = false;
		
		//timerPShot.update();
		cR.x = x;
		cR.y = y;
		collG.update();
		
		if(health <= 0 && state!=7 && state!=8)
		{
			switchState(7);
		}
		
		if(state == 0)
		{
			if(this.y <= landHeight-height)
			{
				this.y = landHeight-height;
				switchState(1);
			}
		}
		else if(state == 5)
		{
			if(this.y >= landHeight-height+1)
			{
				this.acceleration.y = 0;
				this.velocity.y = 50;
				this.velocity.x = 10;
			}
		}

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

		super.update();
	}

	public function enableFloat(enable:Bool){
		if(enable){
			floating = true;
			floatTimer = 0;
			realPosInAir = new FlxPoint(x, y);
		}
		else {
			floating = false;
		}
	}

	override public function kill():Void 
	{
		// block the normal kill
		//super.kill();
	}

	override public function draw():Void
	{
		if(FireOn)
			bossFire.draw();
		super.draw();
		// for debugging
		collG.draw();

		slash.draw();
	}

	public function switchState(state:Float):Void
	{
		this.state = state;
		if(state == STappear)
		{
			// find appear x
			if(lastAppearLeft)
			{
				appearX = FlxG.random() * appearRW + appearRL;
				facing = FlxObject.LEFT;
				slash.facing = FlxObject.LEFT;
			}
			else
			{
				appearX = FlxG.random() * appearLW + appearLL;
				facing = FlxObject.RIGHT;
				slash.facing = FlxObject.RIGHT;
			}
			lastAppearLeft = !lastAppearLeft;
			this.x = appearX - width/2;
			this.y = 500;
			this.velocity = new FlxPoint(0, -50);
			game.smokeEmt2.start(false, 0.5, 0.2, 15); 
			game.smokeEmt2.on = true;
		}
		else if(state == STpreShoot)
		{
			// wait
			play("idle", true);
			this.velocity = new FlxPoint(0,0);
			timer.start(3,1, function(t:FlxTimer){switchState(2);});
		}
		else if(state == STshoot)
		{
			// shoot
			play("shot", true);
			timerPShot.start(0.3, 3, perShot);
			shotCnt++;
			if(shotCnt < 2)
			{
				timer.start(3,1, function(t:FlxTimer){switchState(3);});
			}
			else
			{
				shotCnt = 0;
				timer.start(3,1, function(t:FlxTimer){switchState(4);});
			}
		}
		else if(state == STstopShot)
		{
			// turnEnd
			play("idle", true);
			timer.start(3,1, function(t:FlxTimer){switchState(6);});
		}
		else if(state == STpreJump)
		{
			// prepjump
			play("preJump", true);
			timer.start(1,1, function(t:FlxTimer){switchState(5);});
		}
		else if(state == STjumpAtk)
		{
			// jumpattack
			play("slash", true);
			if(facing == FlxObject.RIGHT)
				velocity = new FlxPoint(300, -500);
			else 
				velocity = new FlxPoint(-300, -500);
			acceleration.y = 1000;
			timer.start(3,1,function(t:FlxTimer):Void{switchState(6);});
			lastAppearLeft = !lastAppearLeft;		// change site!
			// jump over!!!!!
			// use second timer to produce an light
			slash.play("slash", true);
			// use third timer to produce damage box
		}
		else if(state == STdisappear)
		{
			// disappear
			play("idle", true);
			this.acceleration.y = 0;
			timer.start(4, 1, function(t:FlxTimer):Void{switchState(0);});
			this.velocity.y = 50;
			game.smokeEmt2.start(false, 0.5, 0.2, 15); 
			game.smokeEmt2.on = true;
		}
		else if(state == STdefeat)
		{
			velocity.x = 0;
			velocity.y = 30;
			acceleration = new FlxPoint(0,0);
			game.eExplo.visible = true;
			game.eExplo.play("expl", true);
			timer.start(3, 1, function(t:FlxTimer):Void{game.switchState(3);});
			// kill all ducks
			for (d in cast(FlxG.state, Level).ducks.members) {
				if(d.alive)
					d.kill();
			}
		}
		else if(state == STdefDisp)
		{
			velocity.x = 0;
			velocity.y = 30;
			acceleration = new FlxPoint(0,0);
			timer.start(2, 1, function(t:FlxTimer):Void{game.switchState(5);});
		}
	}

	public function perShot(t:FlxTimer):Void
	{
		var gOrg:FlxPoint = new FlxPoint(getMidpoint().x+bowPos.x, getMidpoint().y+bowPos.y);
		for (i in 0...3) 
		{
			var agl:Float = Math.PI / 2 + (facing==FlxObject.RIGHT?bowRotR:bowRotL) + (i-1)*bowArrawRotStep;
			var pos:FlxPoint = new FlxPoint(gOrg.x+Math.cos(agl)*bowStartLen, gOrg.y+Math.sin(agl)*bowStartLen);
			
			var d:Duck = cast(game.ducks.recycle(Duck) , Duck);
			d.reset(pos.x-d.width/2, pos.y-d.height/2);
			d.velocity = new FlxPoint(bowPower*Math.cos(agl) , -bowPower*Math.sin(agl));
		}
	}
}