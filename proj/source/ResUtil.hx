package ;
import flixel.FlxG;
import flash.display.BitmapData;


class ResUtil 
{
	public static var FNT_Pixelex:String = "assets/fnt/pixelex.ttf";
	public static var FNT_Amble:String = "assets/fnt/amble.ttf";

	public static var IMG_ui_box_yellow = "assets/img/ui_box_y.png";
	public static var IMG_ui_box_act_yellow = "assets/img/ui_boxact_y.png";
	public static var IMG_ui_box_blue = "assets/img/ui_box_b.png";
	public static var IMG_ui_box_act_blue = "assets/img/ui_boxact_b.png";
	public static var IMG_ui_box_border = "assets/img/ui_boxact_border.png";
	public static var IMG_ui_pnl_blue = "assets/img/ui_slice_b.png";
	public static var IMG_ui_pnl_yellow = "assets/img/ui_slice_y.png";
	public static var IMG_ui_barh_yellow = "assets/img/ui_barh_y.png";
	public static var IMG_ui_barh_blue = "assets/img/ui_barh_b.png";
	public static var IMG_ui_barv_yellow = "assets/img/ui_barv_y.png";
	public static var IMG_ui_barv_blue = "assets/img/ui_barv_b.png";

	public static var bmpBtnBMainNormal:BitmapData;
	public static var bmpBtnBMainOver:BitmapData;
	public static var bmpBtnBMenuNormal:BitmapData;
	public static var bmpBtnBMenuOver:BitmapData;
	public static var bmpBtnBItemNormal:BitmapData;
	public static var bmpBtnBItemOver:BitmapData;

	public static var bmpBtnYMainNormal:BitmapData;
	public static var bmpBtnYMainOver:BitmapData;
	public static var bmpBtnYMenuNormal:BitmapData;
	public static var bmpBtnYMenuOver:BitmapData;
	public static var bmpBtnYItemNormal:BitmapData;
	public static var bmpBtnYItemOver:BitmapData;

	public static var bmpSelMain:BitmapData;
	public static var bmpSelMenu:BitmapData;
	public static var bmpSelItem:BitmapData;

	public static function Initial() : Void{
	}

	// Junk Function ..
	public static function BuildBitmaps(){
		bmpBtnBMainNormal 	= new SliceShape(0, 0 ,GameStatic.button_mainWidth, GameStatic.button_mainHeight, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnBMainOver 	= new SliceShape(0, 0 ,GameStatic.button_mainWidth, GameStatic.button_mainHeight, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnBMenuNormal 	= new SliceShape(0, 0 ,GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnBMenuOver 	= new SliceShape(0, 0 ,GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnBItemNormal	= new SliceShape(0, 0 ,GameStatic.button_itemWidth, GameStatic.button_itemHeight, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnBItemOver		= new SliceShape(0, 0 ,GameStatic.button_itemWidth, GameStatic.button_itemHeight, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 

		bmpBtnYMainNormal 	= new SliceShape(0, 0 ,GameStatic.button_mainWidth, GameStatic.button_mainHeight, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnYMainOver 	= new SliceShape(0, 0 ,GameStatic.button_mainWidth, GameStatic.button_mainHeight, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnYMenuNormal 	= new SliceShape(0, 0 ,GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnYMenuOver 	= new SliceShape(0, 0 ,GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnYItemNormal	= new SliceShape(0, 0 ,GameStatic.button_itemWidth, GameStatic.button_itemHeight, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		bmpBtnYItemOver		= new SliceShape(0, 0 ,GameStatic.button_itemWidth, GameStatic.button_itemHeight, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone(); 

		bmpSelMain = new SliceShape(0, 0 ,GameStatic.border_mainWidth, GameStatic.border_mainHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2).pixels.clone(); 
		bmpSelMenu = new SliceShape(0, 0 ,GameStatic.border_menuWidth, GameStatic.border_menuHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2).pixels.clone(); 
		bmpSelItem = new SliceShape(0, 0 ,GameStatic.border_itemWidth, GameStatic.border_itemHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2).pixels.clone(); 
	}

	public static function playTitle() : Void
	{
		FlxG.sound.playMusic("title");
	}

	public static function playGame1() : Void
	{
		FlxG.sound.playMusic("game");
	}
}