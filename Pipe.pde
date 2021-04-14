public class Pipe {
  int x, x1, y, speed;
  GrumpyBird gb;
  AssetManager am;
  Game g;
  float h = 0, w = 102;
  float hBottom = 0;
  Body body;
  boolean delete;
  Point p;
  public Pipe(GrumpyBird gb, AssetManager am, Game g, float h) {
    this.gb = gb;
    this.am = am;
    this.g = g;
    this.h = h;
    y = 0;
    x = width-100;
    hBottom = (height - (h+150)) - 130;
    createPipe(102f, h*2);
    body.setUserData(this);
  }
  void drawPipe() {
    // We look at each body and get its screen position
    Vec2 pos = g.box2d.getBodyPixelCoord(body); 
    x1 = (int)pos.x-50; 
    fill(0);
    stroke(0);
    image(am.pipe, x1, h+150); 
    pushMatrix();
    translate(x1, pos.y);
    scale(1, -1); 
    image(am.pipe, 0, -this.h);
    popMatrix();
    body.setLinearVelocity(new Vec2(-10f*gb.getSpeed(), 0f));
  }

  void createPipe(float w, float h) {
    // Define the polygon
    PolygonShape topPs = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dWTop = g.box2d.scalarPixelsToWorld(w/2);
    float box2dHTop = g.box2d.scalarPixelsToWorld(h/2);
    // We're just a boxop, box2dHTop);
    topPs.setAsBox(box2dWTop, box2dHTop);
    PolygonShape bottomPs = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dWBottom = g.box2d.scalarPixelsToWorld(w/2);
    float box2dHBottom = g.box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    bottomPs.setAsBox(box2dWBottom, box2dHBottom, new Vec2(0, (-h-150)/10), 0);





    // 150body
    BodyDef bdTop = new BodyDef();
    bdTop.type = BodyType.DYNAMIC;
    bdTop.position.set(g.box2d.coordPixelsToWorld(x, y));
    body = g.box2d.createBody(bdTop);
    body.createFixture(topPs, 1);
    body.createFixture(bottomPs, 1);
    body.setGravityScale(0);
    body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  public boolean done() {
    if (delete) {
      killBody();
      return true;
    } 
    return false;
  }
}