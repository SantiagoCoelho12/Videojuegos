package states;

import paths.ComplexPath;
import paths.BezierPath;
import kha.math.FastVector2;
import paths.LinearPath;
import paths.Path;
import com.gEngine.helper.RectangleDisplay;
import com.loading.basicResources.SparrowLoader;
import com.loading.basicResources.FontLoader;
import kha.Assets;
import kha.Font;
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
	var time:Float = 0;
	var totalTime:Float = 11;
	var asteroid:Sprite;

	override function load(resources:Resources) {
		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		atlas.add(new ImageLoader("background"));
		atlas.add(new ImageLoader("ship"));
		atlas.add(new ImageLoader("ball"));
		atlas.add(new ImageLoader("bullet"));
		atlas.add(new FontLoader(Assets.fonts.GalaxyName, 27));
		atlas.add(new ImageLoader("asteroid"));
		resources.add(atlas);
	}

	override function init() {
		loadBackground();
		ballsColiision = new CollisionGroup();
		smallsBallsColiision = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		ship = new Player(1024 / 2, 570, simulationLayer);
		addChild(ship);

		GGD.player = ship;
		GGD.simulationLayer = simulationLayer;
		GGD.camera = stage.defaultCamera();

		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		score = new Text(Assets.fonts.GalaxyName);
		score.x = GEngine.virtualWidth / 2.5;
		score.y = 30;
		var info =  new Text(Assets.fonts.GalaxyName);
		info.x = GEngine.virtualWidth * 0.33;
		info.y = 70;
		info.text = "Espacio para disparar";
		hudLayer.addChild(info);
		hudLayer.addChild(score);
		var ball:Ball = new Ball(simulationLayer, ballsColiision);
		addChild(ball);
		createTouchJoystick();

	
	}

	override function update(dt:Float) {
		super.update(dt);
		CollisionEngine.overlap(ship.collision, ballsColiision, deathPlayer);
		CollisionEngine.overlap(ship.collision, smallsBallsColiision, deathPlayer);
		CollisionEngine.overlap(ship.gun.bulletsCollisions, ballsColiision, ballExplodes);
		CollisionEngine.overlap(ship.gun.bulletsCollisions, smallsBallsColiision, smallBallExplodes);
		score.text = "Puntaje " + "  " + count;
		resetGame();

		time += dt;
		if (time > totalTime) {
			time = 0;
		}
		var s:Float = time / totalTime;

		var position = path.getPos(s);
		asteroid.x = position.x;
		asteroid.y = position.y;
	}

	override function render() {
		super.render();
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
		if (!ball.recentlyExploted) {
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
		changeState(new GameOver(count));
	}
	/*#if DEBUGDRAW
		override function draw(framebuffer:kha.Canvas) {
			super.draw(framebuffer);
			var camera = stage.defaultCamera();
			CollisionEngine.renderDebug(framebuffer, camera);
		}
		#end */
}
