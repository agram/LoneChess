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
	public var boardSettings:h2d.Layers;
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
				hasTaken: Array<h2d.Tile>,
			},
			reine: {
				normalBlanc: Array<h2d.Tile>,
				normalNoir: Array<h2d.Tile>,
				select: Array<h2d.Tile>,
				owned: Array<h2d.Tile>,
				hasTaken: Array<h2d.Tile>,
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
		},
	};
	
	var pause:Bool;
	public var start:Bool;
	
	var chess:Array<h2d.Bitmap>;
	public var riddle:Riddle;
	public var riddleSave:Array<{type:TypePiece, i:Int, j:Int}>;
	
	var back:h2d.Text;
	
	override function init() {
		s2d.setFixedSize(Const.WIDTH, Const.HEIGHT);
		engine.backgroundColor = 0x68AFD8;
		ents = [];
		boardBackground = new h2d.Layers();
		board = new h2d.Layers();
		boardSettings = new h2d.Layers();
		boardUi = new h2d.Layers();
		s2d.add(boardBackground, 1);
		s2d.add(board, 2);
		s2d.add(boardSettings, 3);
		s2d.add(boardUi, 4);		
		
		board.visible = false;
		
		var tile = h2d.Tile.fromColor(0xFF5A7B96, Const.WIDTH, Const.HEIGHT);
		new h2d.Bitmap(tile, boardBackground);
		
		initGfx();
		pause = false;
		start = false;
		
		settings();
	}
	
	function startGame (nbPiece = 6) {
		start = true;
		chess = [];
		var a:h2d.Bitmap;
		for (i in 0...4) {
			for (j in 0...4) {
				if ( (i + j) % 2 == 0 ) 
					a = new h2d.Bitmap(gfx.chess.blanc[0], board);
				else 
					a = new h2d.Bitmap(gfx.chess.noir[0], board);
				a.x = i * Const.TS;
				a.y = j * Const.TS;
				chess.push(a);
			}
		}
		
		riddle = new Riddle(nbPiece);
		generate();
		
		riddle.show();
		
		save();
		
		var a = new Mybouton(20, 'Retry');
		a.interactive.onRelease = function (_) { 
			for (p in riddle.pieces) p.kill();
			riddle.pieces = [];
			for (p in riddleSave) riddle.pieces.push(new Piece(p.type, p.i, p.j));
			riddle.show();
			a.mcSelected.alpha = 0.6;
		}

		var a = new Mybouton(176, 'New Riddle');
		a.interactive.onRelease = function (_) { 
			for (p in riddle.pieces) p.kill();
			riddle.pieces = [];
			generate();
			riddle.show();
			save();
			a.mcSelected.alpha = 0.6;
		}
		
		var a = new Mybouton(206, 'Settings');
		a.interactive.onRelease = function (_) { 
			board.visible = false;
			boardSettings.visible = true;
		}
		
		var a = new Mybouton(236, 'Help');
		a.interactive.onRelease = function (_) { 
			showHelp();
			a.mcSelected.alpha = 0.6;
		}
		
		back.visible = true;
	}
	
	function showHelp() {
		var m = new Message(350, 200);
		m.texte.text = 'Left clic to select and move\n';
		m.texte.text += 'Right clic to unselect\n\n';
		m.texte.text += 'Must take on each move\n\n';
		m.texte.text += 'Win when remains only one piece \n\n';
		m.texte.text += 'King and Queen may move \nony once per riddle';		
	}
	
	function settings() {
		var font = Res.Minecraftia.build(12, { antiAliasing : false } );
		var settings = new h2d.Text(font, boardSettings);
		settings.text = 'Choose how many pieces \nyou want on chessboard\n\n';
		settings.x = 85;
		settings.y = 50;
		for (i in 3...10) {
			var a = new Mybouton.MyNumero(i * 30, '' + i);
			a.interactive.onRelease = function (_) { 
				if (start == false) startGame();
				
				riddle.nbPiece = i;
				for (p in riddle.pieces) p.kill();
				riddle.pieces = [];
				generate();
				riddle.show();
				save();
				a.mcSelected.alpha = 0.6;
				board.visible = true;
				boardSettings.visible = false;
			}
		}

		var help = new h2d.Text(font, boardSettings);
		help.text = 'Help';
		help.x = 160;
		help.y = 230;
		
		var i = new h2d.Interactive(help.text.length * 12, 20, help);
		i.onClick = function (_) {
			showHelp();
		}
		
		back = new h2d.Text(font, boardSettings);
		back.text = 'Back';
		back.x = 160;
		back.y = 200;
		
		var i = new h2d.Interactive(back.text.length * 12, 20, back);
		i.onClick = function (_) {
			board.visible = true;
			boardSettings.visible = false;
		}
		back.visible = false;
	}
	
	function instruction() {
		var font = Res.Minecraftia.build(7, { antiAliasing : false } );
		var texte = new h2d.Text(font);
		texte.color = new h3d.Vector();
		texte.x = 265;
		texte.y = 100;
		texte.text = 'Clic Gauche pour sélectionner et déplacer une pièce\n';
		texte.text += 'Clic Droit pour désélectionner\n\n';
		texte.text += 'Tu dois prendre une \npièce à chaque\ndéplacement.\nTu gagnes quand il\nne reste plus qu\'une \npièce.\nLes rois et les \nreines ne peuvent\nprendre qu\'une fois.';
		
		boardUi.addChild(texte);
		
	}
	
	function generate () {
		while (!riddle.generate()) {
			for (p in riddle.pieces) p.kill();
			riddle.pieces = [];
		}
		for (p in riddle.pieces) p.hasTaken = false;
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
					hasTaken: Tools.split(tileGfx, 4, 4, 1, w, h),
				},
				reine: {
					normalBlanc: Tools.split(tileGfx, 5, 0, 1, w, h),
					normalNoir: Tools.split(tileGfx, 5, 5, 1, w, h),
					select: Tools.split(tileGfx, 5, 2, 1, w, h),
					owned: Tools.split(tileGfx, 5, 3, 1, w, h),
					hasTaken: Tools.split(tileGfx, 5, 4, 1, w, h),
				},
			},
			chess: {
				blanc: Tools.split(tileGfx, 0, 1, 1, w, h),
				noir: Tools.split(tileGfx, 1, 1, 1, w, h),
				vert: Tools.split(tileGfx, 2, 1, 1, w, h),
				rouge: Tools.split(tileGfx, 3, 1, 1, w, h),
			},
			message: {
				main: Tools.split(tileGfx, 0, 11, 1, 24, 24),
			},
		};
		
	}
	
	// --- 
	public static function main() {	
		//hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,{compressSounds:true}));
		inst = new Game();
	}
}