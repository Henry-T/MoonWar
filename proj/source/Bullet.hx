package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxObject;

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
		
		animation.add("fly",[0]);
		animation.add("poof",[1,2,3,4],50,false);

		speed = 300;
	}

	override public function update():Void
	{
		super.update();
		if(!alive)
		{
			if(animation.finished)
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
			FlxG.sound.play("hit2");
			animation.play("poof");
		}
	}

	public function shoot(Location:FlxPoint, Aim:Int):Void
	{
		FlxG.sound.play("shoot1");
		super.reset(Location.x-width/2,Location.y-height/2);
		solid = true;
		switch(Aim)
		{
		case FlxObject.UP|FlxObject.RIGHT:
			animation.play("fly");
			velocity.y = -speed * Math.sqrt(2) * 0.5;
			velocity.x = speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.UP|FlxObject.LEFT:
			animation.play("fly");
			velocity.y = -speed * Math.sqrt(2)*0.5;
			velocity.x = -speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.DOWN|FlxObject.RIGHT:
			animation.play("fly");
			velocity.y = speed * Math.sqrt(2)*0.5;
			velocity.x = speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.DOWN|FlxObject.LEFT:
			animation.play("fly");
			velocity.y = speed * Math.sqrt(2)*0.5;
			velocity.x = -speed * Math.sqrt(2) * 0.8;// 0.5;
			
		case FlxObject.UP:
			animation.play("fly");
			velocity.y = -speed;
			
		case FlxObject.DOWN:
			animation.play("fly");
			velocity.y = speed;
			
		case FlxObject.LEFT:
			animation.play("fly");
			velocity.x = -speed;
			
		case FlxObject.RIGHT:
			animation.play("fly");
			velocity.x = speed;
			
		default:
			
		}
	}
}