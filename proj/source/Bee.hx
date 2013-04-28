package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import org.flixel.FlxU;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;

// Bee Class
class Bee extends Enemy
{
	public var mode:String;		// battle mode
	public var livingTime:Float;	

	// state
	public var locked:Bool;	// If this bee is in battle position
	public var timer1:FlxTimer;
	public var timer2:FlxTimer;
	public var canShot:Bool;

	// trace
	public var target:FlxObject;	// fight target
	public var faceTarget:Bool;	// Whether always facing target?

	// shooting
	public var shotCnt:Int; 	// Bullet count per shooting session
	public var shotSpan:Float;	// Time between shot
	public var shotCold:Float;	// Time between session

	// movement
	public var speed:Float;	// the moving speed value.
	public var InitPos:FlxPoint;	// Initial position
	public var FinPos:FlxPoint;	// Battle Position
	public var logPos:FlxPoint;	// Remember world pos for floating up and down
	public var flipMove:Bool;	// Just for Bomber when fly back

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);
		
		// makeGraphic(40, 40, 0xff448811);
		timer1 = new FlxTimer();
		timer2 = new FlxTimer();
		canShot = true;
	}

	public function resetMode(X:Float, Y:Float, mode:String="Monk"):Void 
	{
		this.mode = mode;
		livingTime = 0;
		locked = false;
		flipMove = false;
		
		FinPos = new FlxPoint(X, Y);
		switch(mode)
		{
		case "Monk":
			loadGraphic("assets/img/beeMonk.png", true, true);
			addAnimation("idle", [0], 1, true);
			offset.make(20, 20);
			width = 40;
			height = 40;
			play("idle", true);
			
			InitPos = new FlxPoint(FinPos.x, FinPos.y - 150);
			
			health = 3;
			shotCnt = 1;
			shotSpan = 1;
			shotCold = 3;
			faceTarget = true;
			speed = 150;
			
		case "Fighter":
			loadGraphic("assets/img/beeFighter.png", true, true);
			addAnimation("idle", [0], 1, true);
			offset.make(20, 20);
			width = 40;
			height = 40;
			play("idle", true);
			
			InitPos = new FlxPoint(((FinPos.x < (FlxG.camera.scroll.x + FlxG.width / 2))?-1:1) * 150 + FinPos.x, FinPos.y);
			health = 5;
			shotCnt = 3;
			shotSpan = 0.7;
			shotCold = 4;
			faceTarget = true;
			speed = 100;
			
		case "Bomb":
			loadGraphic("assets/img/beeBomb.png", true, true);
			addAnimation("idle", [0], 1, true);
			offset.make(20, 20);
			width = 40;
			height = 40;
			play("idle", true);
			
			//initPos = new FlxPoint(FinPos.x + 300, -40);
			//FinPos = new FlxPoint(FinPos.x, 100);
			InitPos = new FlxPoint(FlxG.camera.scroll.x + FlxG.width + 20, FlxG.camera.scroll.y + 20);
			FinPos = new FlxPoint(FlxG.camera.scroll.x - 60, FlxG.camera.scroll.y + 20);
			
			locked = true;
			health = 6;
			shotCnt = 1;
			shotSpan = 0.5;
			shotCold = 5;
			faceTarget = false;
			speed = 200;
			
		case "Blow":
			loadGraphic("assets/img/beeBlow.png", true, true);
			addAnimation("idle", [0], 1, true);
			offset.make(20, 20);
			width = 40;
			height = 40;
			play("idle", true);
			
			InitPos = new FlxPoint(FinPos.x, FinPos.y - 100);
			//initPos = new FlxPoint((FinPos.x < (FlxG.camera.scroll + FlxG.width / 2))?-1:1 * 100 + FinPos.x, FinPos.y);
			
			health = 20;
			shotCnt = 10;
			shotSpan = 0.1;
			shotCold = 6;
			faceTarget = false;
			speed = 50;
		}
		
		// Initialize shooting!
		if (mode != "Bomb")
		{
			timer1.start(shotCold, 9999, function(t:FlxTimer){
				timer2.start(shotSpan, shotCnt, function(t:FlxTimer) {
					if(canShot){
						var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
						bgb.reset(getMidpoint().x, getMidpoint().y);
						var agl:Float = FlxU.getAngle(getMidpoint(), cast(FlxG.state , Level).bot.getMidpoint());
						bgb.velocity.x = Math.cos((agl-90) / 180 * Math.PI) * 200;
						bgb.velocity.y = Math.sin((agl-90) / 180 * Math.PI) * 200;
					}
				}); 
			} );
		}
		
		logPos = new FlxPoint(InitPos.x, InitPos.y);
		
		// set facing
		if (logPos.x > FlxG.camera.scroll.x + FlxG.width / 2)
			facing = FlxObject.LEFT;
		else
			facing = FlxObject.RIGHT;
			
		x = logPos.x;
		y = logPos.y;
	}

	override public function update():Void
	{
		if (!locked)
		{
			switch(mode)
			{
				case "Monk":
				logPos.y += speed * FlxG.elapsed;
				
				case "Fighter":
				logPos.x += ((logPos.x < FinPos.x)?1: -1) * speed * FlxG.elapsed;
				
				case "Bomb":
				logPos.x += (!flipMove?-1: 1) * speed * FlxG.elapsed;
				logPos.y = FlxG.camera.scroll.y + 100 * Math.sin((logPos.x-FlxG.camera.scroll.x) * Math.PI / (550+60));
				
				if ((!flipMove && logPos.x < FinPos.x) || (flipMove && logPos.x > InitPos.x))
				{
					logPos.x = flipMove?InitPos.x:FinPos.x;
					logPos.y = flipMove?InitPos.y:FinPos.y;
					flipMove = !flipMove;
					if (flipMove)
					facing = FlxObject.RIGHT;
					else
					facing = FlxObject.LEFT;
					locked = true;
				}
				
				case "Blow":
				logPos.y += speed * FlxG.elapsed;
			}
			
			// checking lock
			if (FlxU.getDistance(logPos, FinPos) < 2)
			{
				locked = true;
			}
		}
		
		if (locked && (timer1.finished||timer1.timeLeft==0) && mode == "Bomb")
		{
			timer1.start(shotCold, 1, function(t:FlxTimer) {
				locked = false;
				timer2.start(shotSpan, 10, function(t:FlxTimer)
				{
				var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
				bgb.reset(getMidpoint().x, getMidpoint().y);
				var agl:Float = FlxU.getAngle(getMidpoint(), cast(FlxG.state , Level).bot.getMidpoint());
				bgb.velocity.x = 0;
				bgb.velocity.y = 100;
				});
			});
		}
		
		// extra motion
		livingTime += FlxG.elapsed;
		var addY:Float = Math.sin(livingTime * 2) * 10;
		this.y = logPos.y + addY;
		x = logPos.x;
		
		if (faceTarget)
		{
			if (getMidpoint().x > target.getMidpoint().x)
				facing = FlxObject.LEFT;
			else 
				facing = FlxObject.RIGHT;
		}
		
		super.update();
	}

	override public function hurt(val:Float):Void
	{
		super.hurt(val);
		flicker(0.1);
	}

	override public function kill():Void 
	{
		super.kill();
		
		timer1.stop();
		timer2.stop();
		
		var ex:FlxSprite = cast(cast(FlxG.state , Level).explo2s.recycle(FlxSprite) , FlxSprite);
		ex.loadGraphic("assets/img/explo2.png", true, false, 30, 30);
		ex.addAnimation("explo", [0, 1, 2, 3, 4, 5, 6, 7], 25, false);
		ex.addAnimationCallback(function(name:String, num:Int, id:Int) {
		if (num == 7)
			ex.kill();	// remeber use this!
		} );
		//ex.scale.make(2.5,2.5);
		ex.reset(getMidpoint().x-ex.width/2, getMidpoint().y-ex.height/2);
		ex.play("explo", true);
	}

	override public function draw():Void 
	{
		super.draw();
		
		// draw health
		
		// draw ...
	}
}