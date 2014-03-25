import Common;

class Riddle
{
	var nbPiece:Int;
	public var pieces:Array<Piece>; // liste des pieces en jeu sur l'echiquier
	public var listePiecesPossibles: {
		pion1:Bool,
		pion2:Bool,
		tour1:Bool,
		tour2:Bool,
		fouBlanc:Bool,
		fouNoir:Bool,
		cavalier1:Bool,
		cavalier2:Bool,
		roi:Bool,
		reine:Bool,
	};
	
	var listeRandom: Array<TypePiece>;
	
	public function new (nbPiece) 
	{
		// On commence par poser une piece au hasard sur un case au hasard
		pieces = [];
		// Pas plus de 10 pièces;
		if (nbPiece > 10) nbPiece = 10;
		this.nbPiece = nbPiece;
		
		listeRandom = [
			PION, PION, PION, PION, PION, PION, PION, PION, PION, PION, PION, 
			TOUR, TOUR, TOUR, TOUR, 
			CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, CAVALIER, 
			FOU, FOU, FOU, FOU, FOU, FOU, FOU, FOU, FOU, FOU, FOU, 
			ROI, ROI, 
			REINE,
		];
	}
	
	public function clone() {
		var r = new Riddle(nbPiece);
		r.pieces = pieces.copy();
		return r;
	}
	
	public function show() {
		for (p in Game.inst.riddle.pieces) p.reset();
	}
	
	public function generate() {
		listePiecesPossibles = {
			pion1:false,
			pion2:false,
			tour1:false,
			tour2:false,
			fouBlanc:false,
			fouNoir:false,
			cavalier1:false,
			cavalier2:false,
			roi:false,
			reine:false,
		};
		
		var compteur = 1;
		pieces = [];
		var i = Std.random(4);
		var j = Std.random(4);

		var firstPiece = new Piece(choosePiece(i, j), i, j);

		while (true) {
			pieces.push(firstPiece);
			if (compteur++ >= nbPiece) return true;
			
			var chosen = pieces[Std.random(pieces.length)];
			var save = { i:chosen.i, j:chosen.j };
			
			// On deplace la piece que l'on vient de poser en fonction de sa prise
			// s'il n'y a aucune possibilité, on arrete tout et on recommence.
			if (!chosen.deplacementPrise()) return false;

			chosen.x = chosen.i * 64;
			chosen.y = chosen.j * 64;
			
			// On cree une autre piece que l'on place sur la meme place que la précédente
			firstPiece = new Piece(choosePiece(save.i, save.j), save.i, save.j);			
		}
	}
	
	function choosePiece(i, j) {
		var listPiece = haxe.EnumTools.createAll(TypePiece);
		
		//return listeRandom[Std.random(listeRandom.length)];
		
		var couleur = (i + j) % 2; // 0 vaut blanc, 1 vaut noir (pour les fous)
		while (true) {
			var a = listeRandom[Std.random(listeRandom.length)];
			switch(a) {
			case PION: 
				if (!listePiecesPossibles.pion1) {
					listePiecesPossibles.pion1 = true;
					return PION;
				}
				else if (!listePiecesPossibles.pion2) {
					listePiecesPossibles.pion2 = true;
					return PION;
				}
			case TOUR: 
				if (!listePiecesPossibles.tour1) {
					listePiecesPossibles.tour1 = true;
					return TOUR;
				}
				else if (!listePiecesPossibles.tour2) {
					listePiecesPossibles.tour2 = true;
					return TOUR;
				}
			case CAVALIER: 
				if (!listePiecesPossibles.cavalier1) {
					listePiecesPossibles.cavalier1 = true;
					return CAVALIER;
				}
				else if (!listePiecesPossibles.cavalier2) {
					listePiecesPossibles.cavalier2 = true;
					return CAVALIER;
				}
			case ROI: 
				if (!listePiecesPossibles.roi) {
					listePiecesPossibles.roi = true;
					return ROI;
				}
			case REINE: 
				if (!listePiecesPossibles.reine) {
					listePiecesPossibles.reine = true;
					return REINE;
				}
			case FOU: 
				if (couleur == 0 && !listePiecesPossibles.fouBlanc) {
					listePiecesPossibles.fouBlanc = true;
					return FOU;
				}
				else if (couleur == 1 && !listePiecesPossibles.fouNoir) {
					listePiecesPossibles.fouNoir = true;
					return FOU;
				}
			}
		}
	}
}