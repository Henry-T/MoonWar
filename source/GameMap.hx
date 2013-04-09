package ;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxState;



class GameMap extends FlxState 
{
public var btnIntro:FlxButton;
public var btnLvl1:FlxButton;
public var btnLvl2:FlxButton;
public var btnLvl3:FlxButton;
public var btnLvl4:FlxButton;
public var btnLvl5:FlxButton;
public var btnLvl6:FlxButton;
public var btnLvl7:FlxButton;
public var btnLvl8:FlxButton;
public var btnEnd:FlxButton;
public var btnMenu:FlxButton;

public function new() 
{
	super();
}

override public function create():Void 
{
	super.create();
	
	btnIntro = new FlxButton(50, 10, "Intro", function() { FlxG.switchState(new IntroScreen()); } );
	btnLvl1 = new FlxButton(50, 10 + 35 * 1, "Level1", function() { FlxG.switchState(new Level1());} );
	btnLvl2 = new FlxButton(50, 10 + 35 * 2, "Level2", function() { FlxG.switchState(new Level2());} );
	btnLvl3 = new FlxButton(50, 10 + 35 * 3, "Level3", function() { FlxG.switchState(new Level3());} );
	btnLvl4 = new FlxButton(50, 10 + 35 * 4, "Level4", function() { FlxG.switchState(new Level4());} );
	btnLvl5 = new FlxButton(50, 10 + 35 * 5, "Level5", function() { FlxG.switchState(new Level5());} );
	btnLvl6 = new FlxButton(50, 10 + 35 * 6, "Level6", function() { FlxG.switchState(new Level6());} );
	btnLvl7 = new FlxButton(50, 10 + 35 * 7, "Level7", function() { FlxG.switchState(new Level7()); } );
	btnLvl8 = new FlxButton(50, 10 + 35 * 8, "Level8", function() { FlxG.switchState(new Level8()); } );
	btnEnd = new FlxButton(50, 10 + 35 * 9, "End", function() { FlxG.switchState(new EndScreen()); } );
	btnMenu = new FlxButton(50, 10 + 35 * 10, "Menu", function() { FlxG.switchState(new MainMenu()); } );
	
	add(btnIntro);
	add(btnLvl1);
	add(btnLvl2);
	add(btnLvl3);
	add(btnLvl4);
	add(btnLvl5);
	add(btnLvl6);
	add(btnLvl7);
	add(btnLvl8);
	add(btnEnd);
	add(btnMenu);
	
	// initial
	btnLvl1.visible	= (GameStatic.ProcLvl >= 0)?true: false;
	btnLvl2.visible 	= (GameStatic.ProcLvl >= 1)?true: false;
	btnLvl3.visible 	= (GameStatic.ProcLvl >= 2)?true: false;
	btnLvl4.visible 	= (GameStatic.ProcLvl >= 3)?true: false;
	btnLvl5.visible 	= (GameStatic.ProcLvl >= 4)?true: false;
	btnLvl6.visible 	= (GameStatic.ProcLvl >= 5)?true: false;
	btnLvl7.visible 	= (GameStatic.ProcLvl >= 6)?true: false;
	btnLvl8.visible 	= (GameStatic.ProcLvl >= 7)?true: false;
	btnEnd.visible 	= (GameStatic.ProcLvl >  8)?true: false;
}
}