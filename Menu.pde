import controlP5.*;
/*
*@author Liam Coffey
 * Class controls all the menu graphics and actions
 */
class Menu {
  AssetManager a;
  GameManager gm;
  Game g;
  Circle[] c = new Circle[Constants.CIRCLE_COUNT]; // initialize circles
  SoundFile s;
  BackgroundMusic b;
  ControlP5 p5;
  boolean active = false;
  /*
  * Contructor to take in instances and setup data
   * @param a, instance of assetManager class
   * @param gm, instance of GameManager class
   * @param g, instance of Game class
   */
  Menu(AssetManager a, GameManager gm, Game g) {
    this.a = a;
    this.g = g;
    this.gm = gm;
    for (int i=0; i < Constants.CIRCLE_COUNT; i++) 
      c[i] = new Circle((int)random(200, 300));
    //for (BUTTON_DATA b : BUTTON_DATA.values())
    //  b.am = a;

    b = new BackgroundMusic( new SoundFile(this.g, "menu.wav"), 20, g);
    p5 = new ControlP5(g);
    p5.addButton("play")
      .setValue(128)
      .setPosition(635, 320)
      .setImages(a.playButton)
      .updateSize();
    p5.addButton("Exit")
      .setValue(128)
      .setId(2)
      .setPosition(635, 530)
      .setImages(a.exitButton)
      .updateSize()
      ;
    p5.addButton("music")
      .setValue(128)
      .setId(2)
      .setPosition(50, height-150)
      .setImages(a.musicButton)
      .updateSize()
      ;
  }

  /*
  * Draws graphics on screen
   *
   */
  void draw() {
    background(186, 252, 255);
    if (b != null) {
      if (!b.active) {
        b.active = true;
        b.start();
      }
    }
    if (c[0] !=null) { // null check
      for (int i = 0; i < Constants.CIRCLE_COUNT; i++) {
        c[i].draw();
        c[i].update();
      }
    }
    textSize(22);
    text("Sound: " + ((g.soundEnabled == true) ? "on" : "off"), 45, height- 150);
    tint(255, 255);
    image(a.backPlate, (width/2)-(a.backPlate.width/2), (height/2)-(a.backPlate.height/2));
    image(a.logo, (width/2)-(a.logo.width/2), (height/2)-(a.logo.height/2)-300);
  }


  void shutDown() {
    b.stopMusic();
    b = null;
    p5.remove("play");
    p5.remove("Exit");
    p5.remove("music");
    s = null;
    p5 = null;
    active = false;
  }

  public void controlEvent(ControlEvent theEvent) {
    if (theEvent.getName().equalsIgnoreCase("Play")) {
      gm.setGame(2);
      g.setState(3);
      shutDown();
    } else if (theEvent.getName().equalsIgnoreCase("Exit")) {
      exit();
    } else if (theEvent.getName().equalsIgnoreCase("music")) {
      b.s.amp(g.soundEnabled ? 0 : 0.4F);
      g.a.soundEnabled(g.soundEnabled ? false : true);
    }
  }
}
import java.lang.Math;
/*
* Class for background circles
 *
 */
class Circle {
  int x = (int)random(0, width), y = (int)random(0, height), radius;
  int r, g, b;
  int[] colourOptions = new int[5];
  int directionX = 0;
  int directionY = 0;
  int startTime;
  int changeCount;
  int speed;
  /*
  Constructor takes in the radius 
   *
   */
  Circle(int radius) {
    this.radius = radius;
    int temp = radius/2+50;
    if (x < temp)
      x+=temp;
    if (x > (width-temp))
      x-=temp;
    if (y < temp)
      y+=temp;
    if (y > (height-temp))
      y-=temp;
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
    colourOptions = new int[]{155, 1233, 4355, 355};
    speed = ~(int)random(4);
    directionX = (int)random(1);
    directionY = (int)random(1);
  }

  /*
  *Draws graphics of circle on screen
   *
   */
  void draw() {
    pushMatrix();
    translate(x, y);
    beginShape();
    fill(r, g, b);
    ellipse(0F, 50F, radius, radius);
    fill(r-20, g-20, b-20);
    ellipse(0F, 50F, radius-20, radius-20);
    endShape();
    popMatrix();
  }

  /*
  * Handles dirrection and boundarys
   *
   */
  void update() {
    if (directionY == 0)
      y+= 1*speed;
    else y-= 1*speed;
    ;
    if (y > height-radius/2-10 || y < 0+radius/2-50)
      directionY = directionY == 0 ? 1 : 0;
    if (directionX == 0)
      x+= 1*speed;
    else x-= 1*speed;
    ;
    if (x > width-radius/2-10 || x < 0+radius/2)
      directionX = directionX == 0 ? 1 : 0;
    changeCount++;
    if (((changeCount == 200))) {
      if (Math.random() > 0.9) {
        directionX = directionX == 0 ? 1 : 0;
      }
      changeCount = 0;
    }
  }
}