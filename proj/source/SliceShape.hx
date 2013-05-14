package;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.Assets;
import org.flixel.FlxAssets;
import org.flixel.FlxSprite;
import nme.geom.Matrix;

// slice bitmap and extract to shape like panels or buttons
class SliceShape extends FlxSprite
{
	public static var MODE_BOX		 = 0;
	public static var MODE_VERTICLE	 = 1;
	public static var MODE_HERT		 = 2;
	public static var MODE_CENTER	 = 3;

	private var paddin:Int;		// for pixel art only
	public var scratchLen:Int;	// scratch space to fill
	private var pixelCache:BitmapData;	// backup before modify original bitmap

	// source slice cache
	private var _srcTopLeft:BitmapData;
	private var _srcTopRight:BitmapData;
	private var _srcBottomLeft:BitmapData;
	private var _srcBottomRight:BitmapData;
	private var _srcTop:BitmapData;
	private var _srcLeft:BitmapData;
	private var _srcBottom:BitmapData;
	private var _srcRight:BitmapData;
	private var _srcCenter:BitmapData;

	private var myBitmap:BitmapData;

	private var mode:Int;

	public function new(x:Float=0, y:Float=0, width:Float=80, height:Float=60, sourceGraphic:Dynamic=null, mode:Int=0, paddin=0){
		super(x, y);

		this.width = Std.int(width);
		this.height = Std.int(height);
		this.paddin = paddin;
		this.mode = mode;
		scratchLen = _pixels.width - paddin * 2;

		pixelCache = Assets.getBitmapData(sourceGraphic);

		if(mode == MODE_BOX){
			_srcTopLeft = new BitmapData(paddin, paddin, true);
			_srcTopLeft.copyPixels(pixelCache, new Rectangle(0, 0, paddin, paddin), _flashPointZero);
			_srcTopRight = new BitmapData(paddin, paddin, true);  
			_srcTopRight.copyPixels(pixelCache, new Rectangle(pixelCache.width - paddin, 0, paddin, paddin), _flashPointZero);
			_srcBottomLeft = new BitmapData(paddin, paddin, true); 
			_srcBottomLeft.copyPixels(pixelCache, new Rectangle(0, pixelCache.height - paddin, paddin, paddin), _flashPointZero);
			_srcBottomRight = new BitmapData(paddin, paddin, true); 
			_srcBottomRight.copyPixels(pixelCache, new Rectangle(pixelCache.width - paddin, pixelCache.height - paddin, paddin, paddin), _flashPointZero);

			_srcTop = new BitmapData(pixelCache.width-paddin*2, paddin, true); 
			_srcTop.copyPixels(pixelCache, new Rectangle(paddin, 0, pixelCache.width-paddin*2, paddin), _flashPointZero);

			_srcLeft = new BitmapData(paddin, pixelCache.height-paddin*2, true); 
			_srcLeft.copyPixels(pixelCache, new Rectangle(0, paddin, paddin, pixelCache.height-paddin*2), _flashPointZero);
			_srcBottom = new BitmapData(pixelCache.width-paddin*2, paddin, true); 
			_srcBottom.copyPixels(pixelCache, new Rectangle(paddin, pixelCache.height-paddin, pixelCache.width-paddin*2, paddin), _flashPointZero);
			_srcRight = new BitmapData(paddin, pixelCache.height-paddin*2, true); 
			_srcRight.copyPixels(pixelCache, new Rectangle(pixelCache.width-paddin, paddin, paddin, pixelCache.height-paddin*2), _flashPointZero);

			_srcCenter = new BitmapData(pixelCache.width - paddin*2, pixelCache.height - paddin*2, true);
			_srcCenter.copyPixels(pixelCache, new Rectangle(paddin, paddin, pixelCache.width-paddin*2, pixelCache.height-paddin*2), _flashPointZero);
		}
		else if(mode == MODE_HERT){
			_srcTop = new BitmapData(pixelCache.width, paddin, true); 
			_srcTop.copyPixels(pixelCache, new Rectangle(0, 0, pixelCache.width, paddin), _flashPointZero);
			_srcBottom = new BitmapData(pixelCache.width, paddin, true); 
			_srcBottom.copyPixels(pixelCache, new Rectangle(0, pixelCache.height-paddin, pixelCache.width, paddin), _flashPointZero);
			_srcCenter = new BitmapData(pixelCache.width, pixelCache.height - paddin*2, true);
			_srcCenter.copyPixels(pixelCache, new Rectangle(0, paddin, pixelCache.width, pixelCache.height-paddin*2), _flashPointZero);
		}
		else if(mode == MODE_VERTICLE){
			_srcLeft = new BitmapData(paddin, pixelCache.height, true); 
			_srcLeft.copyPixels(pixelCache, new Rectangle(0, 0, paddin, pixelCache.height), _flashPointZero);
			_srcRight = new BitmapData(paddin, pixelCache.height, true); 
			_srcRight.copyPixels(pixelCache, new Rectangle(pixelCache.width-paddin, 0, paddin, pixelCache.height), _flashPointZero);
			_srcCenter = new BitmapData(pixelCache.width - paddin*2, pixelCache.height, true);
			_srcCenter.copyPixels(pixelCache, new Rectangle(paddin, 0, pixelCache.width-paddin*2, pixelCache.height), _flashPointZero);
		}
		else if(mode == MODE_CENTER){
			_srcCenter = new BitmapData(pixelCache.width, pixelCache.height, true);
			_srcCenter.copyPixels(pixelCache, pixelCache.rect, _flashPointZero);
		}
		
		rebuildGraphic();
	}

	// update when exact pixel size changed
	public function rebuildGraphic(){
		this.makeGraphic(Math.floor(width), Math.floor(height), 0x00000000);	// NOTE: NO NOT USE 'new BitmapData' !

		if(mode == MODE_BOX){
			_pixels.copyPixels(_srcTopLeft, _srcTopLeft.rect, _flashPointZero);
			_pixels.copyPixels(_srcTopRight, _srcTopRight.rect, new Point(width - paddin, 0));
			_pixels.copyPixels(_srcBottomLeft, _srcBottomLeft.rect, new Point(0, height - paddin));
			_pixels.copyPixels(_srcBottomRight, _srcBottomRight.rect, new Point(width - paddin, height - paddin));
			var scaleTop:BitmapData = scaleBitmapData(_srcTop, (width-paddin*2)/_srcTop.width, 1);
			_pixels.copyPixels(scaleTop, scaleTop.rect, new Point(paddin, 0));
			var scaleBottom:BitmapData = scaleBitmapData(_srcBottom, (width-paddin*2)/_srcBottom.width, 1);
			_pixels.copyPixels(scaleBottom, scaleBottom.rect, new Point(paddin, height-paddin));
			var scaleLeft:BitmapData = scaleBitmapData(_srcLeft, 1, (height-paddin*2)/_srcLeft.height);
			_pixels.copyPixels(scaleLeft, scaleLeft.rect, new Point(0, paddin));
			var scaleRight:BitmapData = scaleBitmapData(_srcRight, 1, (height-paddin*2)/_srcRight.height);
			_pixels.copyPixels(scaleRight, scaleRight.rect, new Point(width-paddin, paddin));
			var scaleCenter:BitmapData = scaleBitmapData(_srcCenter, (width-paddin*2)/_srcCenter.width, (height-paddin*2)/_srcCenter.height);
			_pixels.copyPixels(scaleCenter, scaleCenter.rect, new Point(paddin, paddin));
		}
		else if(mode == MODE_HERT){
			var scaleTop:BitmapData = scaleBitmapData(_srcTop, (width-paddin*2)/_srcTop.width, 1);
			_pixels.copyPixels(scaleTop, scaleTop.rect, new Point(0, 0));

			var scaleBottom:BitmapData = scaleBitmapData(_srcBottom, (width-paddin*2)/_srcBottom.width, 1);
			_pixels.copyPixels(scaleBottom, scaleBottom.rect, new Point(0, height-paddin));

			var scaleCenter:BitmapData = scaleBitmapData(_srcCenter, width/_srcCenter.width, (height-paddin*2)/_srcCenter.height);
			_pixels.copyPixels(scaleCenter, scaleCenter.rect, new Point(0, paddin));
		}
		else if(mode == MODE_VERTICLE){
			var scaleLeft:BitmapData = scaleBitmapData(_srcLeft, 1, (height-paddin*2)/_srcLeft.height);
			_pixels.copyPixels(scaleLeft, scaleLeft.rect, new Point(0, 0));
			var scaleRight:BitmapData = scaleBitmapData(_srcRight, 1, (height-paddin*2)/_srcRight.height);
			_pixels.copyPixels(scaleRight, scaleRight.rect, new Point(width-paddin, 0));

			var scaleCenter:BitmapData = scaleBitmapData(_srcCenter, (width-paddin*2)/_srcCenter.width, height/_srcCenter.height);
			_pixels.copyPixels(scaleCenter, scaleCenter.rect, new Point(paddin, 0));
		}
		else if(mode == MODE_CENTER){
			var scaleCenter:BitmapData = scaleBitmapData(_srcCenter, width/_srcCenter.width, height/_srcCenter.height);
			_pixels.copyPixels(scaleCenter, scaleCenter.rect, _flashPointZero);
		}
	}

	public function setSize(width:Int, height:Int){
		this.width = width; this.height = height;
		rebuildGraphic();
	}

	public function scaleBitmapData(source:BitmapData, scaleX:Float, scaleY:Float):BitmapData{
		scaleX = Math.abs(scaleX);
		scaleY = Math.abs(scaleY);
		var width:Int = Std.int(source.width * scaleX);
		var height:Int = Std.int(source.height * scaleY);
		var transparent:Bool = source.transparent;
		var result:BitmapData = new BitmapData(width, height, transparent);
		var matrix:Matrix = new Matrix();
		matrix.scale(scaleX, scaleY);
		result.draw(source, matrix);
		return result;
	}
}