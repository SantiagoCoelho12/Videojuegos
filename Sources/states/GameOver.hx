package states;

import gameObjects.Player;
import com.gEngine.display.Sprite;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.StaticLayer;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import kha.math.FastVector2;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameOver extends State {
	var score:String;
	var ship:Player;
	var time:Float = 0;
	var simulationLayer:Layer;

	public function new(score:String) {
		super();
		this.score = score;
	}

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		// atlas.add(new SparrowLoader("julia", "julia_xml"));
		atlas.add(new ImageLoader("gameOver"));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
		resources.add(atlas);
	}

	override function init() {
		var image = new Sprite("gameOver");
		image.x = GEngine.virtualWidth * 0.5 - image.width() * 0.5;
		image.y = 100;
		image.scaleX = image.scaleY = 1.5;
		image.offsetX = -100;
		// image.offsetY = 100;
		stage.addChild(image);
		var score = new Text(Assets.fonts.Kenney_ThickName);
		score.text = "Tu puntaje es ";
		score.x = GEngine.virtualWidth / 2 - score.width() * 0.5;
		score.y = GEngine.virtualHeight / 2;
		score.color = Color.Purple;
		stage.addChild(score);
		// simulationLayer = new Layer();
		// stage.addChild(simulationLayer);
		// ship = new Player(1024 / 2, 720 / 2, simulationLayer);
		// addChild(ship);
		// ship.damage();
	}

	override function update(dt:Float) {
		super.update(dt);
		if (Input.i.isKeyCodePressed(KeyCode.Return)) {
			changeState(new GameState());
		}
	}
}
