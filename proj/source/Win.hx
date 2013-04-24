package ;
import org.flixel.FlxText;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;



class Win extends GameScreen 
{


public var bg:FlxSprite;
public var btnAgain:FlxButton;
public var btnMap:FlxButton;
public var btnNext:FlxButton;

public var tScore:FlxText;
public var tScoreAll:FlxText;

public function new()
{
	super();
}

override public function create():Void 
{
	super.create();
	
	bg = new FlxSprite(0, 0, "assets/img/win.png");
	btnAgain = new FlxButton(275 - 80, 350, "Again", function() { FlxG.switchState(GameStatic.GetCurLvlInst()); } );
	btnMap = new FlxButton(275, 350, "Map", function() { FlxG.switchState(new GameMap()); } );
	btnNext = new FlxButton(275 + 80, 350, "Next", function() { FlxG.switchState(GameStatic.GetNextInst()); } );
	
	tScore = new FlxText(280, 100, 100);
	tScoreAll = new FlxText(280, 140, 100);
	
	add(bg);
	add(btnAgain);
	add(btnMap);
	add(btnNext);
	add(tScore);
	add(tScoreAll);
}

override public function update():Void 
{
	super.update();
}

}