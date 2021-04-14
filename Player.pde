import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
class Player {
  int x, y;
  int id;
  int score = 0;
  int lives;
  int bestScore = 0;
  boolean jump = false;
  boolean alive = true;
  Game g;
  Body body;
  AssetManager am;

  PImage texture;

  public Player(int id, int x, int y, AssetManager am, Game g) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.am = am;
    this.g = g;
    makeBody(new Vec2(x, y), 31, 31);
    body.setUserData(this);
    changeTextureCycle();
  }

  void drawPlayer() {
    Vec2 pos = g.box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    y = (int)pos.y;
    scale(0.15); 
    image(getTexture(), -getTexture().width/2, -getTexture().height/2);
    stroke(100);
    fill(0, 0, 0, 0.0f);
    fill(0); 
    endShape();
    popMatrix();
    body.setLinearVelocity(new Vec2(0f, body.getLinearVelocity().y));
    movePlayer();
  }

  void movePlayer() {
    if (jump == true) {
      am.playSound(am.fly);
      body.setLinearVelocity(new Vec2(body.getLinearVelocity().x, 30f));
      jump = false;
    }
  }

  // This function adds the rectangle to the box2d world
  public void makeBody(Vec2 center, float w_, float h_) {
    w_ = 63.6f; 
    h_ = 63.6f;
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3f;
    fd.restitution = 0.5f;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    body.createFixture(fd);
  }

  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }

  public void changeTextureCycle() {
    Thread t = new Thread(new Runnable() {
      public void run() {
        for (int i = 0; i < 4; i++) {
          texture = (PImage)g.a.chars.get(i);
          delay(100);
        }
        if (isAlive())
        run();
      }
    }
    );
    t.start();
  }

  void setBestScore(int score) {
    println("Saving best score");
    bestScore = score;
    PrintWriter p;
    p = createWriter("scores.txt");
    p.print(score);
    p.flush();
    p.close();
  }

  PImage getTexture() {
    return texture;
  }

  public boolean isAlive() {
    return alive;
  }

  int getBestScore() {
    BufferedReader br;
    PrintWriter p;
    try {
      br = createReader("scores.txt");
      int i = Integer.parseInt(br.readLine());
      bestScore = i;
      br.close();
      return i;
    } 
    catch(FileNotFoundException e) {
      System.err.println("File not found!");
      p = createWriter("scores.txt");
      p.print("0");
      p.flush();
      p.close();
      return 0;
    } 
    catch(IOException e) {
      System.err.println("Error Parsing file!");
      return 0;
    }
  }
}