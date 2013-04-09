package ;
import org.flixel.FlxState;
import org.flixel.FlxSave;

import org.flixel.FlxSave;
import org.flixel.FlxState;
class GameStatic 
{
// save to player profile for state changing and session changing
public static var Save:FlxSave;			// saving instance
//public static var curLvl:Int = 0;		// current level number, for play again etc..
//public static var procLvl:Int = 0;		// saved process level number
public static var introViewed:Bool=false;	// turn this on when enter map
public static var endViewed:Bool = false;	// turn this on when end screen shown
public static var score:Int = 0;		//

//public static var ProcLvl:Int;
public static var ProcLvl(getProcLvl, setProcLvl):Int;
public static function setProcLvl(val:Int):Int { Save.data.ProcLvl = val; return val; }
public static function getProcLvl():Int { return Save.data.ProcLvl; }

//public static var CurLvl:Int;
public static var CurLvl(getCurLvl, setCurLvl):Int;
public static function setCurLvl(val:Int):Int { Save.data.CurLvl = val; return val; }
public static function getCurLvl():Int { return Save.data.CurLvl; }


public static function Load():Void
{
	Save = new FlxSave();
	Save.bind("default");
	
	// make sure all data exists or set to default value
	if (Save.data.CurLvl == null)
	Save.data.CurLvl = 0;
	if (Save.data.ProcLvl == null)
	Save.data.ProcLvl = 0;
	if (Save.data.IntroViewed == null)
	Save.data.IntroViewed = false;
	if (Save.data.EndViewed == null)
	Save.data.EndViewed = false;
	if (Save.data.Score == null)
	Save.data.Score = 0;
}

public static function ClearSavedData():Void
{
	if (Save == null)
	Save = new FlxSave();
	Save.bind("default");
	
	Save.data.CurLvl = 0;
	Save.data.ProcLvl = 0;
	Save.data.IntroViewed = false;
	Save.data.EndViewed = false;
	Save.data.Score = 0;
}

public static function GetCurLvlInst() : FlxState
{
	switch(CurLvl)
	{
	case 1:
		return new Level1();
	case 2:
		return new Level2();
	case 3:
		return new Level3();
	case 4:
		return new Level4();
	case 5:
		return new Level5();
	case 6:
		return new Level6();
	case 7:
		return new Level7();
	}
	return null;
}

public static function GetNextInst():FlxState
{
	switch(CurLvl)
	{
	case 1:
		return new Level2();
	case 2:
		return new Level3();
	case 3:
		return new Level4();
	case 4:
		return new Level5();
	case 5:
		return new Level6();
	case 6:
		return new Level7();
	case 7:
		return new Level8();
	case 8:
		return new EndScreen();
	}
	return null;
}
}