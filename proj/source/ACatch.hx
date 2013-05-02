package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxU;
import org.flixel.FlxPoint;
import org.flixel.tmx.TmxObject;

class ACatch extends Enemy 
{
	public var hang : String;
	public static var ColdDown:Float = 1.5;
	public var ShotTimer:Float = 0;
	public var gun : FlxSprite;

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null) 
	{
		super(X, Y, SimpleGraphic);
		gun = new FlxSprite(0, 0, "assets/img/acGun.png");
		gun.origin = new FlxPoint(5, 5);
		ShotTimer = 0;
		immovable = true;
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		health = 5;
		ShotTimer = 0;
	}

	public function make(o:TmxObject):Void
	{
		reset(o.x, o.y);
		width = o.width;
		height = o.height;
		if (o.custom != null)
		{
			hang = o.custom.hang;
			if (hang == "up")
			{
				loadGraphic("assets/img/acBaseUp.png");
				gun.x = x + 15;
				gun.y = y + 15;	
			}
			else if (hang == "down")
			{
				loadGraphic("assets/img/acBaseDown.png");
				gun.x = x + 15;
				gun.y = y;
			}
			else if (hang == "left")
			{
				loadGraphic("assets/img/acBaseLeft.png");
				gun.x = x + 15;
				gun.y = y + 15;	
			}
			else if (hang == "right")
			{
				loadGraphic("assets/img/acBaseRight.png");
				gun.x = x;
				gun.y = y + 15;	
			}
		}
	}

	override public function update():Void 
	{
		if (onScreen())
		{
			var rad:Float = FlxU.getAngle(getMidpoint(), cast(FlxG.state , Level).bot.getMidpoint()) * Math.PI / 180 - Math.PI/2;
			var agl:Float = rad * 180 / Math.PI;
			while(agl > 180)	agl -= 360;
			while(agl < -180)	agl += 360;

			// checking for angle limitation
			var validAgl:Bool = false;
			if(hang == "up" && 0 <= agl && agl <= 180)
				validAgl = true;
			else if(hang == "down" && 0 >= agl && agl >= -180)
				validAgl = true;
			else if(hang == "left" && -90 <= agl && agl <= 90)
				validAgl = true;
			else if(hang == "right" && ((-90 >= agl && agl >= -180)||(agl >= 90 && agl <= 180)))
				validAgl = true;


			if(validAgl){
				gun.angle = agl;
				ShotTimer += FlxG.elapsed;
				if(ShotTimer >= ColdDown)
				{
					var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
					bgb.reset(getMidpoint().x, getMidpoint().y);
					bgb.velocity = new FlxPoint(Math.cos(rad) * 200, Math.sin(rad) * 200);
					ShotTimer -=ColdDown;
				}
			}
		}
		
		super.update();
	}

	override public function hurt(Damage:Float):Void 
	{
		super.hurt(Damage);
	}

	override public function kill():Void 
	{
		super.kill();
	}

	override public function draw():Void 
	{
		super.draw();
		
		gun.draw();
	}
}