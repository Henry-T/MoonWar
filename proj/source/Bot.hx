package;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;
import org.flixel.FlxObject;
import org.flixel.system.input.FlxTouch;
import Level;
import org.flixel.FlxU;

class Bot extends FlxSprite
{
	public var gunHand:FlxSprite;

	public var _jumpPower:Int;
	private var _aim:Int;
	private var _bullets:FlxGroup;

	public var shooting:Bool;

	public var On:Bool;

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
	public static var shootCold:Float = 200;
	public static var lastShootTime:Float = 0;

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
		
		this.loadGraphic("assets/img/bot.png", true, true, 26, 30);
		
		immuTimer = new FlxTimer();
		
		addAnimation("idle",[0, 1, 2, 1],5,true);
		addAnimation("jump_up",[3],0,false);
		addAnimation("jump_down",[5],0,false);
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
		shooting = false;
		
		actionKey = "SPACE";
		moveLeftKey = "LEFT";
		moveRightKey = "RIGHT";
		moveDownKey = "DOWN";
		moveUpKey = "UP";
		moveJumpKey = "Z";
		shootKey = "X";
		
		health = 100;
	}

	override public function update():Void
	{
		inLEFT = false;
		inRIGHT = false;
		inUP = false;
		inDOWN = false;
		inJUMP = false;
		inSHOOT = false;

	    var touches:Array<FlxTouch> = FlxG.touchManager.touches;
	    var touch:FlxTouch;
	 
	    for(touch in touches)
	    {
	        if (touch.pressed())
	        {
	            var px:Int = touch.screenX;
	            var py:Int = touch.screenY;
	            var worldX:Float = touch.getWorldPosition().x;
	            var worldY:Float = touch.getWorldPosition().y;

	            trace("screen: " + px + "-" + py);
	            trace(" world: " + Std.int(worldX) + "-" + Std.int(worldY));
	            var lvl:Level = cast(FlxG.state, Level);
	            var r:FlxRect = lvl.btnRight._rect;
	            if(r.left < px && px < r.right && r.top < px && px < r.bottom)
	           		inRIGHT = true;
	        }

	        if(touch.justPressed())
	        {

	        }
	    }

		// hack
		if (FlxG.keys.Q)
			hurt(99999);
		if (FlxG.keys.W)
		{
			var lvl:Level = cast(FlxG.state , Level);
			if (lvl.boss1 != null)
				lvl.boss1.hurt(99999);
			if (lvl.boss2 != null)
				lvl.boss2.hurt(99999);
			if (lvl.boss3 != null)
				lvl.boss3.hurt(99999);
		}
		if(FlxG.keys.E)
		{
			for (bee in cast(FlxG.state, Level).Bees.members) {
				if(bee.alive)
					bee.kill();
			}
		}

		//MOVEMENT
		acceleration.x = 0;
		if(On && !InVc && FlxG.keys.LEFT)
		{
			facing = FlxObject.LEFT;
			acceleration.x -= drag.x;
		}
		else if(On && !InVc && FlxG.keys.RIGHT)
		{
			facing = FlxObject.RIGHT;
			acceleration.x += drag.x;
		}
		if(On && !InVc && FlxG.keys.justPressed("Z") && !FlxG.keys.DOWN && isTouching(FlxObject.DOWN))
		{
			velocity.y = -_jumpPower;
			FlxG.play("assets/snd/jump2.mp3");
		}
		if (On && !InVc && FlxG.keys.justPressed("Z") && FlxG.keys.DOWN && (velocity.y == 0))
		{
			cast(FlxG.state , Level).DisJS1Frame();
			//if (this.isTouching(FlxObject.FLOOR))
			//{
			//	y += 10;
			//	velocity.y = 10;
			//}
		}

		if(FlxG.keys.UP)inUP = true;
		if(FlxG.keys.LEFT)inLEFT = true;
		if(FlxG.keys.DOWN)inDOWN = true;
		if(FlxG.keys.RIGHT)inRIGHT = true;


		//AIMING
		if(inUP && inRIGHT) {
			_aim = FlxObject.UP|FlxObject.RIGHT;
			gunHand.play("upfront");
		}
		else if(inUP && FlxG.keys.LEFT){
			_aim = FlxObject.UP|FlxObject.LEFT;
			gunHand.play("upfront");
		}
		else if(inDOWN && inRIGHT) {
			_aim = FlxObject.DOWN|FlxObject.RIGHT;
			gunHand.play("downfront");
		}
		else if(inDOWN && inLEFT){
			_aim = FlxObject.DOWN|FlxObject.LEFT;
			gunHand.play("downfront");
		}
		else if(inUP){
			_aim = FlxObject.UP;
			gunHand.play("up");
		}
		else if(inDOWN){
			_aim = FlxObject.DOWN;
			gunHand.play("down");
		}
		else if(inLEFT){
			_aim = FlxObject.LEFT;
			gunHand.play("front");
		}
		else if(inRIGHT){
			_aim = FlxObject.RIGHT;
			gunHand.play("front");
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
		if(On && FlxG.keys.justPressed("X"))
		{
			getMidpoint(_point);
			cast(_bullets.recycle(Bullet),Bullet).shoot(_point,_aim);
			shooting = true;
		}
		else
		{
			shooting = false;
		}

		super.update();

		// sync gun hand
		gunHand.facing = facing;
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
		if (!isActorImmu)
		{
			super.hurt(Damage);
			isActorImmu = true;
			immuTimer.start(1.5, 1, function(t:FlxTimer) { isActorImmu = false; } );
			flicker(1.5);
		}
	}

	override public function kill():Void 
	{
		super.kill();
		cast(FlxG.state , Level).StartGV();
	}
}