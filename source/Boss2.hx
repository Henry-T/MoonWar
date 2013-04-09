package ;
import org.flixel.FlxSprite;



class Boss2 extends FlxSprite
{
public function new(x:Float, y:Float) 
{
	super(x, y, null);
	
	loadGraphic("assets/img/hm.png", true, true, 150);
	width = 65;
	height = 95;
	offset.x = 42;
	offset.y = 30;
	
	addAnimation("idle",[0],1,true);
	addAnimation("walk",[1,2,3,4,5,6,7,8],10,true);
	addAnimation("preJump",[11,12,13],3,false);
	addAnimation("jumping",[14],1,true);
	addAnimation("slash",[15,16,1,18,19],10,false);
	addAnimation("shot",[20,21,22,23,24,25,26],3,false);
	addAnimation("air",[27,28],4,true);
	addAnimation("airShot",[29,30,31,32,33,34,35],3,false);
	addAnimation("airDash",[36,37],2,false);
	addAnimation("airDashEnd",[38],1,false);
	addAnimation("zPre",[39,40],4,false);
	addAnimation("zIdle",[40],1,false);
	addAnimation("zWalk",[41,42,43,44,45,46,47,48],20,true);
	addAnimation("zEnd",[51],2,false);
	addAnimation("fall",[52,53,54,55,56,57],2,false);
	addAnimation("airDeath",[58,59,60,60,62,63],2,false);
	
}

}