package ;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;



class GameOver extends GameScreen 
{

public var bg:FlxSprite;
public var btnAgain:FlxButton;
public var btnMap:FlxButton;
public var btnHelp:FlxButton;

public function new() 
{
	super();
}

override public function create():Void 
{
	super.create();
	
	bg = new FlxSprite(0, 0, "assets/img/lose.png");
	btnAgain = new FlxButton(275 - 80, 350, "Again", function() { FlxG.switchState(GameStatic.GetCurLvlInst() ); } );
	btnMap = new FlxButton(275, 350, "Map", function(){FlxG.switchState(new GameMap());});
	btnHelp = new FlxButton(275 + 80, 350, "Help", function(){});
	
	add(bg);
	add(btnAgain);
	add(btnMap);
	add(btnHelp);
}

override public function update():Void 
{
	super.update();
}

}