import Common;
import hxd.Key in K;
import hxd.Math;

typedef AllKeys = { up : Bool, down : Bool, left : Bool, right : Bool, action : Bool, active : Bool, shift : Bool };

class Game extends hxd.App
{
	public var keysActive : AllKeys;
	
	public var width:Float;
	public var height:Float;
	
	public static var inst : Game;	
	public var ents:Array<Ent>;
	
	public var boardBackground:h2d.Layers;
	public var board:h2d.Layers;
	public var boardUi:h2d.Layers;
	
	public var gfx: {
		pieces: {
			pion: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
			},
			tour: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
			},
			cavalier: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
			},
			fou: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
			},
			roi: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
			},
			reine: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
			},
		},
		chess: {
			blanc: Array<h2d.Tile>,
			noir: Array<h2d.Tile>,
			vert: Array<h2d.Tile>,
			rouge: Array<h2d.Tile>,
		},
		message: {
			main: Array<h2d.Tile>,
			statsTroup: Array<h2d.Tile>,
		},
	};
	
	var pause:Bool;
	public var start:Bool;
	
	var chess:Array<h2d.Bitmap>;
	public var riddle:Riddle;
	public var riddleSave:Array<{type:TypePiece, i:Int, j:Int}>;
	
	override function init() {
		s2d.setFixedSize(Const.WIDTH, Const.HEIGHT);
		engine.backgroundColor = 0x0000FF;
		ents = [];
		boardBackground = new h2d.Layers();
		boardUi = new h2d.Layers();
		board = new h2d.Layers();
		s2d.add(boardBackground, 1);
		s2d.add(board, 2);
		s2d.add(boardUi, 3);		
		
		var tile = h2d.Tile.fromColor(0xFF5A7B96, Const.WIDTH, Const.HEIGHT);
		new h2d.Bitmap(tile, boardBackground);
		
		initGfx();
		pause = false;
		start = false;

		chess = [];
		var a:h2d.Bitmap;
		for (i in 0...4) {
			for (j in 0...4) {
				if ( (i + j) % 2 == 0 ) 
					a = new h2d.Bitmap(gfx.chess.blanc[0], boardBackground);
				else 
					a = new h2d.Bitmap(gfx.chess.noir[0], boardBackground);
				a.x = i * Const.TS;
				a.y = j * Const.TS;
				chess.push(a);
			}
		}
		
		riddle = new Riddle(6);
		generate();
		
		riddle.show();
		
		save();
		
		var a = new Mybouton(20, 'Recommencer');
		a.interactive.onClick = function (_) { 
			for (p in riddle.pieces) p.kill();
			riddle.pieces = [];
			for (p in riddleSave) riddle.pieces.push(new Piece(p.type, p.i, p.j));
			riddle.show();
		}
		var a = new Mybouton(50, 'Annuler');
		a.interactive.onClick = function (_) { 
			trace('Annuler');
		}
		var a = new Mybouton(80, 'Nouveau');
		a.interactive.onClick = function (_) { 
			for (p in riddle.pieces) p.kill();
			riddle.pieces = [];
			generate();
			riddle.show();
			save();
		}
		
	}
	
	function generate () {
		while (!riddle.generate()) {
			for (p in riddle.pieces) p.kill();
			riddle.pieces = [];
		}
	}
	
	function save() {
		riddleSave = [];
		for (p in riddle.pieces) {
			riddleSave.push({
				type: p.type,
				i: p.i, 
				j: p.j
			});
		}
	}
	
	override function update( dt : Float ) {}
	
	function initGfx() {	
		var tileGfx = Res.gfx.toTile();
		var w = Const.TS;
		var h = Const.TS;
		gfx =  {
			pieces: {
				pion: {
					normalBlanc: Tools.split(tileGfx, 0, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 0, 5, 1, w, h),
					select: Tools.split(tileGfx, 0, 2, 1, w, h),
					owned: Tools.split(tileGfx, 0, 3, 1, w, h),
				},
				tour: {
					normalBlanc: Tools.split(tileGfx, 1, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 1, 5, 1, w, h),
					select: Tools.split(tileGfx, 1, 2, 1, w, h),
					owned: Tools.split(tileGfx, 1, 3, 1, w, h),
				},
				cavalier: {
					normalBlanc: Tools.split(tileGfx, 2, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 2, 5, 1, w, h),
					select: Tools.split(tileGfx, 2, 2, 1, w, h),
					owned: Tools.split(tileGfx, 2, 3, 1, w, h),
				},
				fou: {
					normalBlanc: Tools.split(tileGfx, 3, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 3, 5, 1, w, h),
					select: Tools.split(tileGfx, 3, 2, 1, w, h),
					owned: Tools.split(tileGfx, 3, 3, 1, w, h),
				},
				roi: {
					normalBlanc: Tools.split(tileGfx, 4, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 4, 5, 1, w, h),
					select: Tools.split(tileGfx, 4, 2, 1, w, h),
					owned: Tools.split(tileGfx, 4, 3, 1, w, h),
				},
				reine: {
					normalBlanc: Tools.split(tileGfx, 5, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 5, 5, 1, w, h),
					select: Tools.split(tileGfx, 5, 2, 1, w, h),
					owned: Tools.split(tileGfx, 5, 3, 1, w, h),
				},
			},
			chess: {
				blanc: Tools.split(tileGfx, 0, 1, 1, w, h),
				noir: Tools.split(tileGfx, 1, 1, 1, w, h),
				vert: Tools.split(tileGfx, 2, 1, 1, w, h),
				rouge: Tools.split(tileGfx, 3, 1, 1, w, h),
			},
			message: {
				main: Tools.split(tileGfx, 0, 1, 1, 24, 24),
				statsTroup: Tools.split(tileGfx, 1, 1, 1, 24, 24),
			},
		};
		
	}
	
	// --- 
	public static function main() {	
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,{compressSounds:true}));
		inst = new Game();
	}
}