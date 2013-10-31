package;
import org.flixel.util.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxTimer;
import org.flixel.FlxObject;
import org.flixel.system.input.FlxTouch;
import org.flixel.util.FlxAngle;

class Bot extends FlxSprite
{
	public static var maxHealth:Int = 100;
	public var gunHand:FlxSprite;

	public var _jumpPower:Int;
	private var _aim:Int;
	private var _bullets:FlxGroup;

	public var On:Bool;
	public var lvl:Level;

	// vehicle
	public static var InVc:Bool = false;

	// logic rects
	public static var actorNowBodyRect:FlxRect = new FlxRect(0,0,0,0);
	public static var actorNowKillRect:FlxRect = new FlxRect(0,0,0,0);
	public static var marioKillRect:FlxRect = new FlxRect(2, 13, 14, 4);
	public static var marioBodyRect:FlxRect = new FlxRect(0, 0, 16, 13);

	//Z score
	public static var scores:Int = 0;

	// jump
	public static var maxJumpUpTime:Float = 300;
	public static var maxJumpHoldTime:Float = 200;
	public static var jumpDecTime:Float = 100;
	public static var jumpSpd:Float = 300;
	public static var fallSpd:Float = 300;
	public static var isActorOnLand:Bool = false;
	public static var isActorJumping:Bool = false;
	public static var isActorLanding:Bool = false;
	public static var jumpHoldTime:Float = 0;	// how long the player hold the key during a jump
	public static var jumpStartTime:Float = 0;

	// basic
	public static var isActorImmu:Bool = false;
	public static var isActorFaceRight:Bool = true;
	public static var cHSpd:Float = 200;
	public static var actorPos:FlxPoint = new FlxPoint(0,0);
	public static var actorSpd:FlxPoint = new FlxPoint(0,0);
	public static var actorImmuStartTime:Float = 0;
	public static var actorBirthStartTime:Float = 0;
	public static var deadTime:Float = 0;
	public static var maxImmuTime:Int = 2000;
	public static var birthMaxTime:Float = 5000;
	public var immuTimer:FlxTimer;

	// shoot gun
	public static var shootCold:Float = 0.200;
	public static var shootTimer:Float = 0;

	// energy
	public static var chargeEnergy:Float = 100;
	public static var maxChargeEnergy:Float = 100;
	public static var rechargeRate:Float = 2;

	// tbomb
	public static var tBombCostRate:Float = 20;
	public static var tBombStartTime:Float = 0;
	public static var tBombOn:Bool = false;

	// lift
	public static var isActorInLift:Bool = false;
	public static var actorLiftStartTime:Float = 0;
	public static var actorLiftBgn:FlxPoint = new FlxPoint(0,0);
	public static var actorLiftTgt:FlxPoint = new FlxPoint(0,0);

	// control
	public var moveLeftKey:String;
	public var moveRightKey:String;
	public var moveUpKey:String;
	public var moveDownKey:String;
	public var moveJumpKey:String;
	public var shootKey:String;
	public var superWeaponKey:String;
	public var actionKey:String;

	public var inUP:Bool;
	public var inDOWN:Bool;
	public var inLEFT:Bool;
	public var inRIGHT:Bool;
	public var inJUMP:Bool;
	public var inSHOOT:Bool;

	// 
	public static inline var g:Float = 350;

	public static var aimSustainTimeout:Float = 0.050;
	public var keyUpTimerLeft:Float;
	public var keyUpTimerRight:Float;
	public var keyUpTimerUp:Float;
	public var keyUpTimerDown:Float;
	public var keyLeftSustain:Bool;
	public var keyRightSustain:Bool;
	public var keyUpSustain:Bool;
	public var keyDownSustain:Bool;

	// Do not shoot when trigger something with shoot key
	private var gunJamed:Bool;

	public function new(X:Float, Y:Float, Bullets:FlxGroup)
	{
		super(X, Y, null);

		gunHand = new FlxSprite(-10,-10);
		gunHand.loadGraphic("assets/img/botGun.png", true, true, 26, 30);
		gunHand.addAnimation("front", [0], 1, false);
		gunHand.addAnimation("upfront", [1], 1, false);
		gunHand.addAnimation("downfront", [2], 1, false);
		gunHand.addAnimation("up", [3], 1, false);
		gunHand.addAnimation("down", [4], 1, false);
		gunHand.offset.x = 4;
		gunHand.width = 18;

		On = true;
		gunJamed = false;
		
		this.loadGraphic("assets/img/bot.png", true, true, 26, 30);
		
		immuTimer = new FlxTimer();
		
		addAnimation("idle",[0, 1, 2, 1],5,true);
		addAnimation("jump_up",[3],0,false);
		addAnimation("jump_down",[3],0,false);
		addAnimation("walk",[3,0,4,0],10,true);
		
		this.offset.x = 4;
		this.width = 18;
		
		maxVelocity.x = 150;
		maxVelocity.y = 200;
		acceleration.y = g;
		_jumpPower = 1000;
		drag.x = maxVelocity.x*4;
		
		this.play("idle");
		
		_bullets = Bullets;
		
		actionKey = "X";
		moveLeftKey = "LEFT";
		moveRightKey = "RIGHT";
		moveDownKey = "DOWN";
		moveUpKey = "UP";
		moveJumpKey = "Z";
		shootKey = "X";
		
		health = maxHealth;

		keyUpTimerLeft	= aimSustainTimeout;	// fix hand aim on the FIRST frame
		keyUpTimerRight	= aimSustainTimeout;
		keyUpTimerUp	= aimSustainTimeout;
		keyUpTimerDown	= aimSustainTimeout;
		keyLeftSustain	= false;
		keyRightSustain	= false;
		keyUpSustain	= false;
		keyDownSustain	= false;

		facing = FlxObject.RIGHT;

		lvl = cast(FlxG.state, Level);
	}

	override public function update():Void
	{
		// hack
		#if test
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.Q)
			hurt(99999);
		if (FlxG.keys.W)
		{
			if (lvl.boss1 != null)
				lvl.boss1.hurt(99999);
			if (lvl.boss3 != null)
				lvl.boss3.hurt(99999);
		}
		if(FlxG.keys.E)
		{
			for (bee in cast(FlxG.state, Level).Bees.members) {
				if(bee!=null && bee.alive)
					bee.kill();
			}
		}
		if(FlxG.keys.O)
		{
			cast(FlxG.state, Level).EndLevel();
		}
		#end
		#end

		// Cleanup
		inLEFT 	= false;
		inRIGHT = false;
		inUP 	= false;
		inDOWN 	= false;
		inJUMP 	= false;
		inSHOOT = false;

		//MOVEMENT
		acceleration.x = 0;
		if(On && !InVc && lvl.input.Left)
		{
			facing = FlxObject.LEFT;
			acceleration.x -= drag.x;
		}
		else if(On && !InVc && lvl.input.Right)
		{
			facing = FlxObject.RIGHT;
			acceleration.x += drag.x;
		}
		if(On && !InVc && lvl.input.JustDown_Jump && !lvl.input.Down && isTouching(FlxObject.DOWN))
		{
			velocity.y = -_jumpPower;
			FlxG.play("jump2");
		}
		if (On && !InVc && lvl.input.JustDown_Jump && lvl.input.Down && (velocity.y == 0))
		{
			cast(FlxG.state , Level).DisJS1Frame();
			//if (this.isTouching(FlxObject.FLOOR))
			//{
			//	y += 10;
			//	velocity.y = 10;
			//}
		}

	    // Input from keyboard
		if(lvl.input.Up 	&& On)	inUP = true;
		if(lvl.input.Left 	&& On)	inLEFT = true;
		if(lvl.input.Down 	&& On)	inDOWN = true;
		if(lvl.input.Right 	&& On)	inRIGHT = true;

		// Sustain Aiming
		keyUpTimerUp 	+= FlxG.elapsed;
		keyUpTimerDown 	+= FlxG.elapsed;
		keyUpTimerLeft 	+= FlxG.elapsed;
		keyUpTimerRight += FlxG.elapsed;

		if(On && !lvl.input.Up && !lvl.input.Left && !lvl.input.Down && !lvl.input.Right){
			if(!keyUpSustain && keyUpTimerUp < aimSustainTimeout)
				keyUpSustain = true;
			if(!keyDownSustain && keyUpTimerDown < aimSustainTimeout)
				keyDownSustain = true;
			if(!keyLeftSustain && keyUpTimerLeft < aimSustainTimeout)
				keyLeftSustain = true;
			if(!keyRightSustain && keyUpTimerRight < aimSustainTimeout)
				keyRightSustain = true;
		}
		else{
			keyUpSustain = false;
			keyDownSustain = false;
			keyLeftSustain = false;
			keyRightSustain = false;
		}

		if(On && lvl.input.JustUp_Up)
			keyUpTimerUp = 0;
		if(On && lvl.input.JustUp_Down)
			keyUpTimerDown = 0;
		if(On && lvl.input.JustUp_Left)
			keyUpTimerLeft = 0;
		if(On && lvl.input.JustUp_Right)
			keyUpTimerRight = 0;

		//AIMING
		if((inUP||keyUpSustain) && (inRIGHT||keyRightSustain)) {
			_aim = FlxObject.UP|FlxObject.RIGHT;
			gunHand.play("upfront");
		}
		else if((inUP||keyUpSustain) && (inLEFT||keyLeftSustain)){
			_aim = FlxObject.UP|FlxObject.LEFT;
			gunHand.play("upfront");
		}
		else if((inDOWN||keyDownSustain) && (inRIGHT||keyRightSustain)) {
			_aim = FlxObject.DOWN|FlxObject.RIGHT;
			gunHand.play("downfront");
		}
		else if((inDOWN||keyDownSustain) && (inLEFT||keyLeftSustain)){
			_aim = FlxObject.DOWN|FlxObject.LEFT;
			gunHand.play("downfront");
		}
		else if(inUP||keyUpSustain){
			_aim = FlxObject.UP;
			gunHand.play("up");
		}
		else if(inDOWN||keyDownSustain){
			_aim = FlxObject.DOWN;
			gunHand.play("down");
		}
		else if(inLEFT||keyLeftSustain){
			_aim = FlxObject.LEFT;
			gunHand.play("front");
		}
		else if(inRIGHT||keyRightSustain){
			_aim = FlxObject.RIGHT;
			gunHand.play("front");
		}
		else {
			_aim = FlxObject.RIGHT;
		}
		
		//ANIMATION
		if(velocity.y != 0)
		{
			if(_aim == FlxObject.UP) play("jump_up");
			else if(_aim == FlxObject.DOWN) play("jump_down");
			else play("jump_up");
		}
		else if(velocity.x == 0)
		{
			play("idle");
		}
		else
		{
			play("walk");
		}
		
		//SHOOTING

		// forbid more than one bullet in one frame
		shootTimer += FlxG.elapsed;
		while(shootTimer > shootCold){
			shootTimer = shootCold;
		}

		if(On && !gunJamed && lvl.input.Shoot){
			if(shootTimer >= shootCold){
				getMidpoint(_point);
				cast(_bullets.recycle(Bullet),Bullet).shoot(_point,_aim);
				shootTimer -= shootCold;
			}
		}

		super.update();

		// sync gun hand
		gunHand.facing = facing;

		if(health > maxHealth){
			health = maxHealth;
		}
	}

	public override function draw()
	{
		// sync gun hand
		gunHand.x = x; gunHand.y = y;
		gunHand.draw();
		super.draw();
	}

	public function EnableG(on:Bool)
	{
		if (on)
			this.acceleration.y = g;
		else 
			this.acceleration.y = 0;
	}

	override public function hurt(Damage:Float):Void 
	{
		if (!isActorImmu && !cast(FlxG.state, Level).isEnd)
		{
			super.hurt(Damage);
			isActorImmu = true;
			immuTimer.start(1.5, 1, function(t:FlxTimer) { isActorImmu = false; } );
			flicker(1.5);
		}
	}

	override public function kill():Void 
	{
		if(!cast(FlxG.state, Level).isEnd)
		{
			super.kill();
			cast(FlxG.state , Level).EndLevel(false);
		}
	}

	// prevent bot from shoot with a very very short period
	public function JamShoot():Void{
		gunJamed = true;
		TimerPool.Get().start(0.20, 1, function(t:FlxTimer){
			gunJamed = false;
		});
	}
}