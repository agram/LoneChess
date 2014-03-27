import Common;

class Piece extends Ent
{
	public var i:Int;
	public var j:Int;
	public var type:TypePiece;
	public var selected:Bool;
	public var owned:Bool;
	public var canTakeOnce:Bool;
	public var hasTaken:Bool;
	
	public function new(type:TypePiece, i, j) {
		super(i * Const.TS, j * Const.TS);
		this.type = type;
		this.i = i;
		this.j = j;

		var inter = new h2d.Interactive(64, 64, this);
		inter.enableRightButton = true;
		inter.onClick = function (e) { 
			if (e.button == 0) {
				if (hasTaken) return;
				
				for (p in game.riddle.pieces) {
					p.reset();
					if (ownable(p)) {
						p.owned = true;
						p.anim.play(switch (p.type) {
							case PION : game.gfx.pieces.pion.owned;
							case TOUR : game.gfx.pieces.tour.owned;
							case CAVALIER : game.gfx.pieces.cavalier.owned;
							case FOU : game.gfx.pieces.fou.owned;
							case ROI : game.gfx.pieces.roi.owned;
							case REINE : game.gfx.pieces.reine.owned;
						} );
					}
				}
				selected = true;
				anim.play(switch (type) {
					case PION : game.gfx.pieces.pion.select;
					case TOUR : game.gfx.pieces.tour.select;
					case CAVALIER : game.gfx.pieces.cavalier.select;
					case FOU : game.gfx.pieces.fou.select;
					case ROI : game.gfx.pieces.roi.select;
					case REINE : game.gfx.pieces.reine.select;
				} );
			}
			else {
				if (owned) {
					for (p in game.riddle.pieces.copy()) {
						if (p.selected) {
							p.i = this.i;
							p.j = this.j;
							p.x = this.x;
							p.y = this.y;
							game.riddle.pieces.remove(this);
							kill();
							switch(p.type) {
								case ROI, REINE :
									p.hasTaken = true;
								default:
							}
						}
						p.reset();
					}
					
					if (game.riddle.pieces.length == 1) {
						var m = new Message();
						m.texte.text = 'Gagné !';
					}
				}
			}
		};
		canTakeOnce = switch(type) {
			case ROI, REINE: true;
			default: false;
		}
		hasTaken = false;
	}
	
	public function reset () {

		if (hasTaken) {
			switch(type) {
				case ROI : anim.play(game.gfx.pieces.roi.hasTaken);
				case REINE : anim.play(game.gfx.pieces.reine.hasTaken);
				default:
			}
		}
		else if ( (i + j) % 2 == 1 ) {
			anim.play(switch (type) {
				case PION : game.gfx.pieces.pion.normalBlanc;
				case TOUR : game.gfx.pieces.tour.normalBlanc;
				case CAVALIER : game.gfx.pieces.cavalier.normalBlanc;
				case FOU : game.gfx.pieces.fou.normalBlanc;
				case ROI : game.gfx.pieces.roi.normalBlanc;
				case REINE : game.gfx.pieces.reine.normalBlanc;
			} );
		}
		else {
			anim.play(switch (type) {
				case PION : game.gfx.pieces.pion.normalNoir;
				case TOUR : game.gfx.pieces.tour.normalNoir;
				case CAVALIER : game.gfx.pieces.cavalier.normalNoir;
				case FOU : game.gfx.pieces.fou.normalNoir;
				case ROI : game.gfx.pieces.roi.normalNoir;
				case REINE : game.gfx.pieces.reine.normalNoir;
			} );
		}

		selected = false;
		owned = false;
	}
	
	override public function toString() {
		return type + ' : ' + ', ' + i + ', ' + j;
	}

	public function deplacementPrise () {
		// le mieux reste de faire une fonction par type de piece
		var tab = switch(type) {
			case PION : prisePion();
			case TOUR : priseTour();
			case CAVALIER : priseCavalier();
			case FOU : priseFou();
			case ROI : priseRoi();
			case REINE : priseReine();
		}
		return finalize(tab);
	}
	
	function ownable(p:Piece) {
		var tab = switch(type) {
			case PION : prisePionNormal();
			case TOUR : priseTourNormal();
			case CAVALIER : priseCavalierNormal();
			case FOU : priseFouNormal();
			case ROI : priseRoiNormal();
			case REINE : priseReineNormal();
		}
		
		for (t in tab) if (t.i == p.i && t.j == p.j) return true;
		
		return false;
	}
	
	function libre(i, j) {
		for (t in game.riddle.pieces) if (t.i == i && t.j == j) return false;
		return true;
	}
	
	function test(tab, i, j) {
		if (i >= 0 && i < 4 
		&& j >= 0 && j < 4 
		&& libre(i, j) ) {
			tab.push( { i:i, j:j } );
			return true;
		}
		return false;
	}
	
	function testNormal(tab, i, j) {
		if (i >= 0 && i < 4 
		&& j >= 0 && j < 4) {
			tab.push( { i:i, j:j } );
			return libre(i, j);
		}
		return false;
	}
	
	function finalize(tab:Array<{ i:Int, j:Int }>) {
		var n = tab.length;
		if (n == 0) return false;
		var a = tab[Std.random(n)];
		i = a.i;
		j = a.j;
		return true;
	}
	
	function prisePion() {
		var tab = [];

		test(tab, i - 1, j + 1);
		test(tab, i + 1, j + 1);
		
		return tab;
	}
	
	function prisePionNormal() {
		var tab = [];

		testNormal(tab, i - 1, j - 1);
		testNormal(tab, i + 1, j - 1);
		
		return tab;
	}
	
	function priseTour() {
		var tab = [];

		if (test(tab, i - 1, j))
			if (test(tab, i - 2, j))
				test(tab, i - 3, j);
		
		if (test(tab, i + 1, j))
			if (test(tab, i + 2, j))
				test(tab, i + 3, j);
		
		if (test(tab, i, j - 1))
			if (test(tab, i, j - 2))
				test(tab, i, j - 3);
		
		if (test(tab, i, j + 1))
			if (test(tab, i, j + 2))
				test(tab, i, j + 3);
				
		return tab;
	}
	
	function priseTourNormal() {
		var tab = [];

		if (testNormal(tab, i - 1, j))
			if (testNormal(tab, i - 2, j))
				testNormal(tab, i - 3, j);
		
		if (testNormal(tab, i + 1, j))
			if (testNormal(tab, i + 2, j))
				testNormal(tab, i + 3, j);
		
		if (testNormal(tab, i, j - 1))
			if (testNormal(tab, i, j - 2))
				testNormal(tab, i, j - 3);
		
		if (testNormal(tab, i, j + 1))
			if (testNormal(tab, i, j + 2))
				testNormal(tab, i, j + 3);
				
		return tab;
	}
	
	function priseCavalier() {
		var tab = [];
		
		test(tab, i - 2, j - 1);
		test(tab, i - 1, j - 2);
		test(tab, i + 1, j - 2);
		test(tab, i + 2, j - 1);
		test(tab, i + 2, j + 1);
		test(tab, i + 1, j + 2);
		test(tab, i - 1, j + 2);
		test(tab, i - 2, j + 1);

		return tab;
	}
	
	function priseCavalierNormal() {
		var tab = [];
		
		testNormal(tab, i - 2, j - 1);
		testNormal(tab, i - 1, j - 2);
		testNormal(tab, i + 1, j - 2);
		testNormal(tab, i + 2, j - 1);
		testNormal(tab, i + 2, j + 1);
		testNormal(tab, i + 1, j + 2);
		testNormal(tab, i - 1, j + 2);
		testNormal(tab, i - 2, j + 1);

		return tab;
	}
	
	function priseFou() {
		var tab = [];

		if (test(tab, i - 1, j - 1))
			if (test(tab, i - 2, j - 2))
				test(tab, i - 3, j - 3);
		
		if (test(tab, i + 1, j - 1))
			if (test(tab, i + 2, j - 2))
				test(tab, i + 3, j - 3);
		
		if (test(tab, i - 1, j + 1))
			if (test(tab, i - 2, j + 2))
				test(tab, i - 3, j + 3);
		
		if (test(tab, i + 1, j + 1))
			if (test(tab, i + 2, j + 2))
				test(tab, i + 3, j + 3);
		
		return tab;
	}
	
	function priseFouNormal() {
		var tab = [];

		if (testNormal(tab, i - 1, j - 1))
			if (testNormal(tab, i - 2, j - 2))
				testNormal(tab, i - 3, j - 3);
		
		if (testNormal(tab, i + 1, j - 1))
			if (testNormal(tab, i + 2, j - 2))
				testNormal(tab, i + 3, j - 3);
		
		if (testNormal(tab, i - 1, j + 1))
			if (testNormal(tab, i - 2, j + 2))
				testNormal(tab, i - 3, j + 3);
		
		if (testNormal(tab, i + 1, j + 1))
			if (testNormal(tab, i + 2, j + 2))
				testNormal(tab, i + 3, j + 3);
		
		return tab;
	}
	
	function priseRoi() {
		var tab = [];

		test(tab, i - 1, j - 1);
		test(tab, i + 1, j - 1);
		test(tab, i - 1, j + 1);
		test(tab, i + 1, j + 1);
		test(tab, i - 1, j);
		test(tab, i + 1, j);
		test(tab, i, j - 1);
		test(tab, i, j + 1);

		return tab;
	}
	
	function priseRoiNormal() {
		var tab = [];

		testNormal(tab, i - 1, j - 1);
		testNormal(tab, i + 1, j - 1);
		testNormal(tab, i - 1, j + 1);
		testNormal(tab, i + 1, j + 1);
		testNormal(tab, i - 1, j);
		testNormal(tab, i + 1, j);
		testNormal(tab, i, j - 1);
		testNormal(tab, i, j + 1);

		return tab;
	}
	
	function priseReine() {
		var tab = [];

		if (test(tab, i - 1, j))
			if (test(tab, i - 2, j))
				test(tab, i - 3, j);
		
		if (test(tab, i + 1, j))
			if (test(tab, i + 2, j))
				test(tab, i + 3, j);
		
		if (test(tab, i, j - 1))
			if (test(tab, i, j - 2))
				test(tab, i, j - 3);
		
		if (test(tab, i, j + 1))
			if (test(tab, i, j + 2))
				test(tab, i, j + 3);
		
		if (test(tab, i - 1, j - 1))
			if (test(tab, i - 2, j - 2))
				test(tab, i - 3, j - 3);
		
		if (test(tab, i + 1, j - 1))
			if (test(tab, i + 2, j - 2))
				test(tab, i + 3, j - 3);
		
		if (test(tab, i - 1, j + 1))
			if (test(tab, i - 2, j + 2))
				test(tab, i - 3, j + 3);
		
		if (test(tab, i + 1, j + 1))
			if (test(tab, i + 2, j + 2))
				test(tab, i + 3, j + 3);

		return tab;
	}
	
	function priseReineNormal() {
		var tab = [];

		if (testNormal(tab, i - 1, j))
			if (testNormal(tab, i - 2, j))
				testNormal(tab, i - 3, j);
		
		if (testNormal(tab, i + 1, j))
			if (testNormal(tab, i + 2, j))
				testNormal(tab, i + 3, j);
		
		if (testNormal(tab, i, j - 1))
			if (testNormal(tab, i, j - 2))
				testNormal(tab, i, j - 3);
		
		if (testNormal(tab, i, j + 1))
			if (testNormal(tab, i, j + 2))
				testNormal(tab, i, j + 3);
		
		if (testNormal(tab, i - 1, j - 1))
			if (testNormal(tab, i - 2, j - 2))
				testNormal(tab, i - 3, j - 3);
		
		if (testNormal(tab, i + 1, j - 1))
			if (testNormal(tab, i + 2, j - 2))
				testNormal(tab, i + 3, j - 3);
		
		if (testNormal(tab, i - 1, j + 1))
			if (testNormal(tab, i - 2, j + 2))
				testNormal(tab, i - 3, j + 3);
		
		if (testNormal(tab, i + 1, j + 1))
			if (testNormal(tab, i + 2, j + 2))
				testNormal(tab, i + 3, j + 3);

		return tab;
	}
	
	override public function kill() {
		//game.riddle.pieces.remove(this);
		super.kill();
	}
}