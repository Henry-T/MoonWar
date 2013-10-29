package;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import org.flixel.util.FlxPoint;
import org.flixel.FlxObject;

class Bullet extends FlxSprite
{
	public var speed:Float;
	public var game:Level;

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null)
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic("assets/img/bullet.png",true);
		width = 6;
		height = 6;
		offset.x = 1;
		offset.y = 1;
		
		addAnimation("fly",[0]);
		addAnimation("poof",[1,2,3,4],50,false);

		speed = 300;
	}

	override public function update():Void
	{
		super.update();
		if(!alive)
		{
			if(finished)
				exists = false;
		}
		else if(touching!=0)
			kill();
	}

	override public function kill():Void
	{
		if(!alive)return;
		super.kill();
		if(onScreen())
		{
			FlxG.play("hit2");
			play("poof");
		}
	}

	public function shoot(Location:FlxPoint, Aim:Int):Void
	{
		FlxG.play("shoot1");
		super.reset(Location.x-width/2,Location.y-height/2);
		solid = true;
		switch(Aim)
		{
		case FlxObject.UP|FlxObject.RIGHT:
			play("fly");
			velocity.y = -speed * Math.sqrt(2) * 0.5;
			velocity.x = speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.UP|FlxObject.LEFT:
			play("fly");
			velocity.y = -speed * Math.sqrt(2)*0.5;
			velocity.x = -speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.DOWN|FlxObject.RIGHT:
			play("fly");
			velocity.y = speed * Math.sqrt(2)*0.5;
			velocity.x = speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.DOWN|FlxObject.LEFT:
			play("fly");
			velocity.y = speed * Math.sqrt(2)*0.5;
			velocity.x = -speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.UP:
			play("fly");
			velocity.y = -speed;
			
		case FlxObject.DOWN:
			play("fly");
			velocity.y = speed;
			
		case FlxObject.LEFT:
			play("fly");
			velocity.x = -speed;
			
		case FlxObject.RIGHT:
			play("fly");
			velocity.x = speed;
			
		default:
			
		}
	}
}