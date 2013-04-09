package ;
import org.flixel.FlxSprite;



/**
 * ...
 * @author 
 */
class Com extends FlxSprite 
{
public var onTig:Void->Void;

public function new(x:Float, y:Float, width:Int, height:Int)
{
	super(x, y);
	makeGraphic(width, height, 0x88ff5599);
}
}