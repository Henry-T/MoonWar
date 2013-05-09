package ;
import nme.utils.ByteArray;
import org.flixel.FlxState;
import org.flixel.FlxSave;
import org.flixel.FlxSave;
import org.flixel.FlxState;
import nme.system.Capabilities;

class GameStatic 
{
	// save to player profile for state changing and session changing
	public static var Save:FlxSave;			// saving instance
	//public static var curLvl:Int = 0;		// current level number, for play again etc..
	//public static var procLvl:Int = 0;		// saved process level number
	public static var introViewed:Bool=false;	// turn this on when enter map
	public static var endViewed:Bool = false;	// turn this on when end screen shown
	public static var score:Int = 0;		//

	public static var AllLevelCnt:Int = 10;

	//public static var ProcLvl:Int;
	public static var ProcLvl(getProcLvl, setProcLvl):Int;
	public static function setProcLvl(val:Int):Int { Save.data.ProcLvl = val; return val; }
	public static function getProcLvl():Int { return Save.data.ProcLvl; }

	//public static var CurLvl:Int;
	public static var CurLvl(getCurLvl, setCurLvl):Int;
	public static function setCurLvl(val:Int):Int { Save.data.CurLvl = val; return val; }
	public static function getCurLvl():Int { return Save.data.CurLvl; }

	public static var screenDensity : Float;

	public static function Initial(){

		// Get Screen Density
		var dpi = Capabilities.screenDPI;
		if (dpi < 100)
			screenDensity = 1;
		else if (dpi < 200)
			screenDensity = 1.5;
		else
			screenDensity = 2;
		screenDensity = 2;
	}

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

	public static function GetCurLvlInst() : FlxState{
		return GetLvlInst(CurLvl);
	}

	public static function GetLvlInst(id:Int) : FlxState{
		switch(id)
		{
		case 0:
			return new IntroScreen();
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
		case 8:
			return new Level8();
		case 9:
			return new EndScreen();
		}
		return null;
	}

	public static function GetNextInst():FlxState{
		return GetLvlInst(CurLvl + 1);
	}

	public static function GetMissionName(id:Int):String
	{
		switch (id) {
			case 0:
				return "INVADER";
			case 1:
				return "FIRST BLOOD";
			case 2:
				return "TEAM DEFENCE";
			case 3:
				return "BREAK OUT";
			case 4:
				return "BROKEN INSIDE";
			case 5:
				return "SPARE CHANNEL";
			case 6:
				return "BASE ENTRANCE";
			case 7:
				return "INNER BASE";
			case 8:
				return "MOON CORE";
			case 9:
				return "IT'S OVER";
		}
		return "MISSION UNKNOWN";
	}

	public static function GetMissionDesc(id:Int):String
	{
		switch (id) {
			case 0:
				return "RageMetal leads its force to conquer Moon\rPeople in Surface Base are on emergency meeting";
			case 1:
				return "While RageMetal's pioneers approaching\rCubeBot is under it's launch test";
			case 2:
				return "RageMetal lands near Surface Base\rDr.Cube has gifts for it";
			case 3:
				return "Transport station is needed to find RageMetal\nBut we spoted the air blocked by it's force";
			case 4:
				return "RageMetal's force is filling the tunnel\nMain Tunnel is shortcut Moon Core";
			case 5:
				return "Lift in Main Tunnel is destroied by RageMetal\nWell we still have a spare channel";
			case 6:
				return "Inner Base is surrounded\nThe situation is not so good";
			case 7:
				return "Inner Base is a huge facility\nMoon Gate to Moon Core is locked";
			case 8:
				return "RageMetal absorbed energy in Moon Core\nWe will have to bury it here";
			case 9:
				return "Moon is in peace again";
		}
		return "No Description";
	}

	#if flash
	public static function Clone(src:Dynamic):Dynamic
	{
		var myBA:ByteArray = new ByteArray();
		myBA.writeObject(src);
		myBA.position = 0;
		return(myBA.readObject());
	}
	#end
}