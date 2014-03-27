import Common;

class Mybouton
{
	public var mcSelected:h2d.Graphics;
	var game:Game;
	public var interactive:h2d.Interactive;
	
	public function new(y, t) 
	{
		game = Game.inst;
		
		mcSelected = new h2d.Graphics(game.boardUi);
		mcSelected.beginFill(0xFF978E7E);
		mcSelected.drawRect(0, 0, 100, 20);
		mcSelected.alpha = 1;
		mcSelected.endFill();
		mcSelected.x = 280;
		mcSelected.y = y;
		
		var font = Res.Minecraftia.build(8, { antiAliasing : false } );
		var texte = new h2d.Text(font, mcSelected);
		texte.color = new h3d.Vector();
		texte.x = 5;
		texte.y = 5;
		texte.text = t;
		
		interactive = new h2d.Interactive(100, 20, mcSelected);
		interactive.onOver = function (_) {
			mcSelected.alpha = 0.6;
		}
		interactive.onOut = function (_) {
			mcSelected.alpha = 1;
		}
		interactive.onPush = function (_) {
			mcSelected.alpha = 0.3;
		}
	}
	
}

class MyNumero
{
	public var mcSelected:h2d.Graphics;
	var game:Game;
	public var interactive:h2d.Interactive;
	
	public function new(x, t) 
	{
		game = Game.inst;
		
		mcSelected = new h2d.Graphics(game.boardUi);
		mcSelected.beginFill(0xFF978E7E);
		mcSelected.drawRect(0, 0, 15, 15);
		mcSelected.alpha = 1;
		mcSelected.endFill();
		mcSelected.x = x;
		mcSelected.y = 260;
		
		var font = Res.Minecraftia.build(8, { antiAliasing : false } );
		var texte = new h2d.Text(font, mcSelected);
		texte.color = new h3d.Vector();
		texte.x = 5;
		texte.y = 1;
		texte.text = t;
		
		interactive = new h2d.Interactive(15, 15, mcSelected);
		interactive.onOver = function (_) {
			mcSelected.alpha = 0.6;
		}
		interactive.onOut = function (_) {
			mcSelected.alpha = 1;
		}
		interactive.onPush = function (_) {
			mcSelected.alpha = 0.3;
		}
	}
	
}

