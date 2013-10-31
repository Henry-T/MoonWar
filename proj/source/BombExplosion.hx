package;
import flixel.FlxSprite;

class BombExplosion extends FlxSprite
{
	public static var RANDOM:Int	=	0;
	public static var RED:Int		=	1;
	public static var YELLOW:Int	=	2;
	public static var BLUE:Int		=	3;
	public static var GREEN:Int		=	4;
	public static var ORANGE:Int	=	5;
	public static var WHITE:Int		=	6;
	public static var PURPLE:Int	=	7;
	public static var PINK:Int		=	8;
	
	private var bigSprite:FlxSprite;
	private var smallSprite:FlxSprite;
	
	private var isBig:Bool;
	private var colour:Int;
	
	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null)
	{
		super(X, Y, SimpleGraphic);
		
		bigSprite = new FlxSprite(0, 0);
		bigSprite.loadGraphic("assets/img/explBig.png", true, false, 64, 64);
		smallSprite = new FlxSprite(0, 0);
		smallSprite.loadGraphic("assets/img/explSmall.png", true, false, 32, 32);
		
		var tempFrameAry:Array<Int> = [0,1,2,3,4,5,6,7];
		for (i in 0 ... 8)
		{
			bigSprite.animation.add(Std.string(i), tempFrameAry.slice(0), 20, false);
			smallSprite.animation.add(Std.string(i), tempFrameAry.slice(0), 20, false);
			for (j in 0...tempFrameAry.length) 
				tempFrameAry[j] += 8;
		}
	}

	public function make(ctrX:Float, ctrY:Float, color:Int, isBig:Bool)
	{
		if (color != 0)
			this.colour = color;
		else
			this.colour = Math.round(Math.random() * 7);

		this.isBig = isBig;
		super.reset(ctrX, ctrY);
		//if (isBig)
		{
			bigSprite.x = this.x - bigSprite.width / 2;
			bigSprite.y = this.y - bigSprite.height / 2;
			bigSprite.animation.play(Std.string(colour), true);
		}
		//else 
		{
			smallSprite.x = this.x - smallSprite.width / 2;
			smallSprite.y = this.y - smallSprite.height / 2;
			smallSprite.animation.play(Std.string(colour), true);
		}
	}
	
	override public function update() {
		super.update();
		//if (isBig)
		{
			bigSprite.animation.update();
			if (bigSprite.animation.finished)
				kill();
		}
		//else 
		{
			smallSprite.animation.update();
			if (smallSprite.animation.finished)
				kill();
		}
	}
	
	override public function draw(){
		//if (isBig)
		{
			bigSprite.draw();
		}
		//else 
		{
			smallSprite.draw();
		}
	}
}