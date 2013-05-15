package ;
import nme.utils.ByteArray;
import org.flixel.FlxState;
import org.flixel.FlxSave;
import org.flixel.FlxSave;
import org.flixel.FlxState;
import nme.system.Capabilities;
import org.flixel.FlxG;

class GameStatic 
{
	public static var Density_S:Float = 1;
	public static var Density_M:Float = 1.5;
	public static var Density_L:Float = 2;

	public static var RATIO_MODE_Narrow	:Int = 0;
	public static var RATIO_MODE_4_3	:Int = 1;
	public static var RATIO_MODE_Middle	:Int = 2;
	public static var RATIO_MODE_16_9	:Int = 3;
	public static var RATIO_MODE_Wide	:Int = 4;

	public static var screenWidth:Int;
	public static var screenHeight:Int;
	public static var ratioMode:Int;
	public static var ratioValue:Float;

	// save to player profile for state changing and session changing
	public static var Save:FlxSave;			// saving instance
	//public static var curLvl:Int = 0;		// current level number, for play again etc..
	//public static var procLvl:Int = 0;		// saved process level number
	public static var introViewed:Bool=false;	// turn this on when enter map
	public static var endViewed:Bool = false;	// turn this on when end screen shown
	public static var score:Int = 0;		//

	public static var AllLevelCnt:Int = 8;

	//public static var ProcLvl:Int;
	public static var ProcLvl(getProcLvl, setProcLvl):Int;
	public static function setProcLvl(val:Int):Int { Save.data.ProcLvl = val; return val; }
	public static function getProcLvl():Int { return Save.data.ProcLvl; }

	//public static var CurLvl:Int;
	public static var CurLvl(getCurLvl, setCurLvl):Int;
	public static function setCurLvl(val:Int):Int { Save.data.CurLvl = val; return val; }
	public static function getCurLvl():Int { return Save.data.CurLvl; }

	public static var screenDensity : Float;

	// Layout 
	public static var txtSize_normalButton:Int;
	public static var txtSize_menuButton:Int;
	public static var txtSize_mainButton:Int;
	public static var txtSize_dialog:Int;
	public static var button_itemWidth:Int;
	public static var button_itemHeight:Int;
	public static var border_itemWidth:Int;
	public static var border_itemHeight:Int;
	public static var button_menuWidth:Int;
	public static var button_menuHeight:Int;
	public static var border_menuWidth:Int;
	public static var border_menuHeight:Int;
	public static var button_mainWidth:Int;
	public static var button_mainHeight:Int;
	public static var border_mainWidth:Int;
	public static var border_mainHeight:Int;
	public static var offset_border:Int;

	public static var base_txtSize_normalButton:Int = 8;
	public static var base_txtSize_menuButton:Int = 12;
	public static var base_txtSize_mainButton:Int = 18;
	public static var base_txtSize_dialog:Int = 8;
	public static var base_button_itemWidth:Int = 100;
	public static var base_button_itemHeight:Int = 18;
	public static var base_border_itemWidth:Int = 102;
	public static var base_border_itemHeight:Int = 20;
	public static var base_button_menuWidth:Int = 100;
	public static var base_button_menuHeight:Int = 24;
	public static var base_border_menuWidth:Int = 102;
	public static var base_border_menuHeight:Int = 26;
	public static var base_button_mainWidth:Int = 150;
	public static var base_button_mainHeight:Int = 30;
	public static var base_border_mainWidth:Int = 152;
	public static var base_border_mainHeight:Int = 32;
	public static var base_offset_border:Int = -1;
	

	public static var width:Int;
	public static var height:Int;
	public static var widthH:Int;
	public static var heightH:Int;

	public static var useMouse:Bool;
	public static var useTouch:Bool;
	public static var useKeyboard:Bool;

	public static var helpLink:String = "http://www.youtube.com";

	public static var justStart:Bool = true;

	public static function Initial(){
		// Check Input Mode
		useMouse = true;
		useTouch = true;
		useKeyboard = true;

		#if FLX_NO_MOUSE
		useMouse = false;
		#end
		#if FLX_NO_TOUCH
		useTouch = false;
		#end
		#if FLX_NO_KEYBOARD
		useKeyboard = false;
		#end

		screenWidth = Std.int(nme.system.Capabilities.screenResolutionX);
		screenHeight = Std.int(nme.system.Capabilities.screenResolutionY);

		// Get Screen Density
		var dpi = Capabilities.screenDPI;
		if (dpi < 100)
			screenDensity = Density_S
		else if (dpi < 200)
			screenDensity = Density_M;
		else
			screenDensity = Density_L;
		//screenDensity = Density_M;

		// Check ratio mode 
		ratioValue = nme.system.Capabilities.pixelAspectRatio;
		if(ratioValue < 1.2)
			ratioMode = RATIO_MODE_Narrow;
		else if(ratioMode < 1.45)
			ratioMode = RATIO_MODE_4_3;
		else if(ratioMode < 1.6)
			ratioMode = RATIO_MODE_Middle;
		else if(ratioMode < 1.9)
			ratioMode = RATIO_MODE_16_9;
		else
			ratioMode = RATIO_MODE_Wide;

		width = FlxG.width;
		height = FlxG.height;
		widthH = Std.int(FlxG.width * 0.5);
		heightH = Std.int(FlxG.height * 0.5);

		// set layout size based on device screen
		txtSize_normalButton= Std.int(screenDensity * base_txtSize_normalButton);
		txtSize_menuButton	= Std.int(screenDensity * base_txtSize_menuButton);
		txtSize_mainButton	= Std.int(screenDensity * base_txtSize_mainButton);
		txtSize_dialog		= Std.int(screenDensity * base_txtSize_dialog);
		button_itemWidth	= Std.int(screenDensity * base_button_itemWidth);
		button_itemHeight	= Std.int(screenDensity * base_button_itemHeight);
		border_itemWidth	= button_itemWidth + 2;
		border_itemHeight	= button_itemHeight + 2;
		button_menuWidth	= Std.int(screenDensity * base_button_menuWidth);
		button_menuHeight	= Std.int(screenDensity * base_button_menuHeight);
		border_menuWidth	= button_menuWidth + 2;
		border_menuHeight	= button_menuHeight + 2;
		button_mainWidth	= Std.int(screenDensity * base_button_mainWidth);
		button_mainHeight	= Std.int(screenDensity * base_button_mainHeight);
		border_mainWidth	= button_mainWidth + 2;
		border_mainHeight	= button_mainHeight + 2;
		offset_border 		= base_offset_border;
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
			return new Level1();
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

	public static function GetNextInst():FlxState{
		return GetLvlInst(CurLvl + 1);
	}

	public static function GetMissionName(id:Int):String
	{
		switch (id) {
			case 0:
				return "FIRST BLOOD";
			case 1:
				return "TEAM DEFENCE";
			case 2:
				return "BREAK OUT";
			case 3:
				return "BROKEN INSIDE";
			case 4:
				return "SPARE CHANNEL";
			case 5:
				return "BASE ENTRANCE";
			case 6:
				return "INNER BASE";
			case 7:
				return "MOON CORE";
		}
		return "MISSION UNKNOWN";
	}

	public static function GetMissionDesc(id:Int):String
	{
		switch (id) {
			case 0:
				return "While RageMetal's pioneers approaching\rCubeBot is under it's launch test";
			case 1:
				return "RageMetal lands near Surface Base\rDr.Cube has gifts for it";
			case 2:
				return "Transport station is needed to find RageMetal\nBut we spoted the air blocked by it's force";
			case 3:
				return "RageMetal's force is filling the tunnel\nMain Tunnel is shortcut Moon Core";
			case 4:
				return "Lift in Main Tunnel is destroied by RageMetal\nWell we still have a spare channel";
			case 5:
				return "Inner Base is surrounded\nThe situation is not so good";
			case 6:
				return "Inner Base is a huge facility\nMoon Gate to Moon Core is locked";
			case 7:
				return "RageMetal absorbed energy in Moon Core\nWe will have to bury it here";
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

	public static function ScreenValidation():Bool{
		// TODO valid resolation and dpi with core gui layout
		return true;
	}
}