import shiffman.box2d.*; //<>// //<>// //<>// //<>//
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;

class GrumpyBird {

  ArrayList<Boundary> boundaries;
  ArrayList<Pipe> pipes;
  ArrayList<Point> pointSensors;
  GameManager gm;
  Game g;
  ControlP5 p5;
  controlP5.Button rb;
  controlP5.Button eb;
  BackgroundMusic b;
  PipeManager pm;
  float grassX = 0; 
  float grassY = 816;
  float speed = 1f;
  int pipeCount = 0;
  Player player;
  Thread pipesThread;
  Thread speedThread;

  GrumpyBird(GameManager gm, Game g) {
    this.gm = gm;
    this.g = g;
    b = new BackgroundMusic(new SoundFile(this.g, "flapBg.mp3"), 100, g);
    p5 = new ControlP5(g);
    g.box2d.setGravity(0, -100);
    boundaries = new ArrayList<Boundary>();
    pipes = new ArrayList<Pipe>();
    pointSensors = new ArrayList<Point>();
    boundaries.add(new Boundary( 0, height/2, 10, height, g));
    pipes.add(new Pipe(this, g.a, g, 500f));
    pointSensors.add(new Point(this, g.a, g, 500f));
    player = new Player(0, 208, 9, g.a, g);
    pm = new PipeManager(this);
    pm.start();
    startSpeed();
    rb = p5.addButton("restart")
      .setValue(128)
      .setPosition((width/2)-(g.a.restart.width/2), height/2-(g.a.finish.height/2)+300)
      .setImages(new PImage[] {g.a.restart, g.a.restart, g.a.restart})
      .updateSize();
    rb.hide();
    eb = p5.addButton("exitFin")
      .setValue(128)
      .setPosition((width/2)-(g.a.exit.width/2), height/2-(g.a.finish.height/2)+375)
      .setImages(new PImage[] {g.a.exit, g.a.exit, g.a.exit})
      .updateSize();
    eb.hide();
  }

  void drawGame() {
    if (!b.active) {
      b.active = true;
      b.start();
    }
    background(g.a.ccBg);
    textFont(g.a.fontFlap);
    g.box2d.step();
    if (player.y > 750) {
      player.y--;
      if (player.alive)
        g.a.playSound(g.a.hit);
      killPlayer();
      player.alive = false ;
    }
    for (int i = pointSensors.size()-1; i >= 0; i--) {
      Point po = pointSensors.get(i);
      po.update();
      if (po.done()) {
        pointSensors.remove(i);
      }
    }
    for (int i = pipes.size()-1; i >= 0; i--) {
      Pipe p = pipes.get(i);
      p.drawPipe();
      if (p.done()) {
        pipes.remove(i);
      }
    }
    image(g.a.grass, grassX, grassY);
    player.drawPlayer();
    if (!player.isAlive()) {
      drawFinishScreen();
    } else {
      grassX-= 1.7*speed;
      if (grassX < -3000+width)
        grassX = -495;
      textSize(80);
      fill(0);
      text(player.score, (width/2)+5, 300+5);
      fill(255);
      text(player.score, (width/2), 300);
    }
  }

  PImage getMedal() {
    if (player.score > 40)
      return g.a.plat;
    if (player.score > 20)
      return g.a.gold;
    if (player.score > 10)
      return g.a.silver;
    if (player.score >= 0)
      return g.a.bronze;
    return null;
  }

  void drawFinishScreen() {
    noStroke();
    pm.setActive(false);
    player.body.setActive(false);
    for (Pipe p : pipes) {
      p.body.setActive(false);
    }
    for (Point po : pointSensors) {
      po.bodyMiddle.setActive(false);
    }
    rb.show();
    eb.show();
    image(g.a.finish, (width/2)-(g.a.finish.width/2), height/2-(g.a.finish.height/2));
    image(g.a.gameOver, (width/2)-(g.a.finish.width/2)-50, height/2-(g.a.finish.height/2)-150);
    image(getMedal(), (width/2)-(g.a.finish.width/2)+70, height/2-(g.a.finish.height/2)+150);
    textSize(60);
    text(player.score, (width/2)+130+5, 450+5);
    fill(255);
    text(player.score, (width/2)+130, 450);
    fill(0);
    text(player.bestScore, (width/2)+130+5, 550+5);
    fill(255);
    text(player.bestScore, (width/2)+130, 550);
  }

  void killPlayer() {
    if (player.alive) {
      if (player.score > player.getBestScore())
        player.setBestScore(player.score);
    }
  }


  void startSpeed() {
    speedThread = new Thread(new Runnable() {
      public void run() {
        speed += Constants.SPEED_MODIFIER;
        delay(Constants.SPEED_TICK);
        run();
      }
    }
    );
    speedThread.start();
  }

  void shutDown(int state) {
    rb.hide();
    eb.hide();
    b.stopMusic();
    b = null;
    g.g.setGame(-1);
    g.m = new Menu(a, g.g, g);
    g.m.active = true;
    g.setState(state);
  }


  void restart() {
    speed = 1;
    pipes = new ArrayList<Pipe>();
    pointSensors = new ArrayList<Point>();
    for (int i = pipes.size()-1; i >= 0; i--) {
      pipes.get(i).delete = true;
      pointSensors.get(i).delete = true;
      pipes.remove(i);
      pointSensors.remove(i);
      pipes.add(new Pipe(this, g.a, g, 500f));
    }
    player = null;
    player = new Player(0, 208, 9, g.a, g);
    pm.setActive(true);
  }

  public void controlEvent(ControlEvent theEvent) {
    switch(theEvent.getName()) {
      case("restart"): // numberboxA is registered with id 1
      rb.hide();
      eb.hide();
      restart();
      break;
      case("exitFin"): // numberboxA is registered with id 1
      shutDown(Constants.MENU);
      break;
    }
  }

  // Collision event functions!
  void beginContact(Contact cp) {
    // Get both shapes 
    Fixture f1 = cp.getFixtureA();
    Fixture f2 = cp.getFixtureB();
    // Get both bodies
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    if ((o1.getClass() == Pipe.class && o2.getClass() == Player.class
      ) || (o2.getClass() == Pipe.class && o1.getClass() == Player.class
      )) {
      Player p1 = (Player) (o1.getClass() == Player.class ? o1 : o2);
      if (p1.alive)
        g.a.playSound(g.a.hit);
      killPlayer();
      p1.alive = false ;
    }
    if ((o1.getClass() == Point.class && o2.getClass() == Player.class
      ) || (o2.getClass() == Point.class && o1.getClass() == Player.class)) {
      Point p1 = (Point) (o1.getClass() == Point.class ? o1 : o2);
      p1.delete = true;
      g.a.playSound(g.a.point);
      Player p2 = (Player) (o1.getClass() == Player.class ? o1 : o2);
      p2.score++;
    }
    if ((o1.getClass() == Pipe.class && o2.getClass() == Boundary.class
      ) || (o2.getClass() == Pipe.class && o1.getClass() == Boundary.class
      )) {
      Pipe p2 = (Pipe) (o1.getClass() == Pipe.class ? o1 : o2);
      p2.delete = true;
    }
  }


  void buttons() {
    if (key == ' ') 
      player.jump = true;
  }

  void keyReleased() {
    if (key == ' ') 
      player .jump = false;
  }

  void mouseAction() {
    if (mouseButton == LEFT) {
      player.jump = true;
    }
  }

  void mouseReleased() {
    if (mouseButton == LEFT) {
      player.jump = false;
    }
  }

  public float getSpeed() {
    return speed;
  }
}
