package states;

import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.helper.Screen;
import js.lib.Math;
import kha.math.FastVector2;
import paths.LinearPath;
import paths.Path;
import com.loading.basicResources.FontLoader;
import kha.Assets;
import com.gEngine.display.Text;
import com.gEngine.display.StaticLayer;
import gameObjects.Bullet;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionGroup;
import kha.input.KeyCode;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import GlobalGameData.GGD;
import com.loading.basicResources.JoinAtlas;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;
import com.collision.platformer.CollisionEngine;
import gameObjects.Player;
import gameObjects.Ball;

class GameState extends State {
	static var ASTEROID_CYCLE:Float = 11;

	var screenWidth:Int;
	var screenHeight:Int;
	var background:Sprite;
	var ship:Player;
	var path:Path;
	var simulationLayer:Layer;
	var count:Int = 0;
	var score:Text;
	var touchJoystick:VirtualGamepad;
	var ballsColiision:CollisionGroup;
	var smallsBallsColiision:CollisionGroup;
	var hudLayer:StaticLayer;
	var asteroidTime:Float = 0;
	var asteroid:Sprite;
	var asteroidLevitation:Float = 0.8;
	var asteroidLevitationTimer:Float = 0;

	override function load(resources:Resources) {
		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		atlas.add(new ImageLoader("background"));
		atlas.add(new ImageLoader("ship"));
		atlas.add(new ImageLoader("ball"));
		atlas.add(new ImageLoader("bullet"));
		atlas.add(new ImageLoader("asteroid"));
		atlas.add(new SpriteSheetLoader("explosion", 51, 64, 0, [
			Sequence.at("ball", 0, 0),
			Sequence.at("explode", 1, 19),
			Sequence.at("sleep", 19, 19)
		]));
		atlas.add(new SpriteSheetLoader("shipexplosion", 255, 240, 0, [Sequence.at("explode", 0, 21)]));
		atlas.add(new FontLoader(Assets.fonts.GalaxyName, 27));
		resources.add(atlas);
	}

	override function init() {
		loadBackground();
		ballsColiision = new CollisionGroup();
		smallsBallsColiision = new CollisionGroup();
		simulationLayer = new Layer();
		hudLayer = new StaticLayer();
		stage.addChild(simulationLayer);
		createShip();
		GGD.simulationLayer = simulationLayer;
		GGD.camera = stage.defaultCamera();
		setHUD();
		createFirstBall();
		createTouchJoystick();
	}

	override function update(dt:Float) {
		if (ship.isDead() && ship.deathComplete())
			changeState(new GameOver(count));
		super.update(dt);
		CollisionEngine.overlap(ship.collision, ballsColiision, deathPlayer);
		CollisionEngine.overlap(ship.collision, smallsBallsColiision, deathPlayer);
		CollisionEngine.overlap(ship.gun.bulletsCollisions, ballsColiision, ballExplodes);
		CollisionEngine.overlap(ship.gun.bulletsCollisions, smallsBallsColiision, smallBallExplodes);
		score.text = "Puntaje " + "  " + count;
		resetGame();
		asteroidCycle(dt);
	}

	inline function asteroidCycle(dt:Float) {
		asteroidTime += dt;
		asteroidLevitationTimer += dt;
		if (asteroidTime > ASTEROID_CYCLE) {
			asteroidTime = 0;
		}
		var s:Float = asteroidTime / ASTEROID_CYCLE;
		var position = path.getPos(s);
		asteroid.x = position.x;
		asteroid.y = position.y + asteroidLevitation;
		if (asteroidLevitationTimer > 0.5) {
			asteroidLevitation *= -1;
			asteroidLevitationTimer = 0;
		}
	}

	override function render() {
		super.render();
	}

	inline function createFirstBall() {
		var ball:Ball = new Ball(simulationLayer, ballsColiision);
		addChild(ball);
	}

	inline function setHUD() {
		stage.addChild(hudLayer);
		score = new Text(Assets.fonts.GalaxyName);
		score.x = GEngine.virtualWidth / 2.5;
		score.y = 30;
		var info = new Text(Assets.fonts.GalaxyName);
		info.x = GEngine.virtualWidth * 0.33;
		info.y = 70;
		info.text = "Espacio para disparar";
		hudLayer.addChild(info);
		hudLayer.addChild(score);
	}

	inline function createShip() {
		ship = new Player(Screen.getWidth() * Math.random(), Screen.getHeight() * Player.PLAYER_Y, simulationLayer);
		addChild(ship);
		GGD.player = ship;
	}

	inline function loadBackground() {
		var backgraundLayer = new Layer();
		background = new Sprite("background");
		backgraundLayer.addChild(background);
		asteroid = new Sprite("asteroid");
		asteroid.scaleX = asteroid.scaleY = 0.30;
		backgraundLayer.addChild(asteroid);
		path = new LinearPath(new FastVector2(530, -150), new FastVector2(-600, 800));
		stage.addChild(backgraundLayer);
	}

	function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.notify(ship.onAxisChange, ship.onButtonChange);
		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(ship.onAxisChange, ship.onButtonChange);
	}

	public function ballExplodes(a:ICollider, b:ICollider) {
		var bullet:Bullet = cast a.userData;
		bullet.die();
		bullet.destroy();
		var ball:Ball = cast b.userData;
		var X:Float = ball.get_x();
		var Y:Float = ball.get_y();
		ball.explode();
		count++;
		for (i in 0...2) {
			var ball:Ball = new Ball(simulationLayer, smallsBallsColiision, X, Y, i);
			addChild(ball);
		}
	}

	public function smallBallExplodes(a:ICollider, b:ICollider) {
		var bullet:Bullet = cast a.userData;
		bullet.die();
		var ball:Ball = cast b.userData;
		if (!ball.recentlyExploded) {
			ball.explode();
			count++;
			var ball:Ball = new Ball(simulationLayer, ballsColiision);
			addChild(ball);
		}
	}

	inline function resetGame() {
		if (Input.i.isKeyCodePressed(KeyCode.Escape)) {
			changeState(new GameState());
		}
	}

	public function deathPlayer(a:ICollider, b:ICollider) {
		var player:Player = cast b.userData;
		player.die();
	}

	override function destroy() {
		touchJoystick.destroy();
	}
}
