package ;

import org.flixel.FlxEmitter;

class BoomParticle extends FlxEmitter
{
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);
		
		makeParticles("assets/img/boomPar.png", 8, 0, true, 0);
		gravity = 400;
		setXSpeed(-50, 50);
		setYSpeed(-40, -10);
	}
	
	public function Boom(x:Float, y:Float, width:Float, height:Float)
	{
		this.width = width; this.height = height;
		this.x = x - width/2; this.y = y-height/2;
		this.emitParticle();
	}
}