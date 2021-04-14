public class Point {
  int x, x1, y, speed;
  boolean mouldy = false;
  GrumpyBird gb;
  AssetManager am;
  Game g;
  float h = 0, w = 10;
  Body bodyMiddle;
  boolean delete;
  boolean deletePoint;

  public Point(GrumpyBird gb, AssetManager am, Game g, float h) {
    this.gb = gb;
    this.am = am;
    this.g = g;
    this.h = h;
    y = (int)h+75;
    x = width-100;
    createPoint(10, 5);
    bodyMiddle.setUserData(this);
  }
  void update() {
    Vec2 pos = g.box2d.getBodyPixelCoord(bodyMiddle);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    fill(0); 
    endShape();
    popMatrix();
    bodyMiddle.setLinearVelocity(new Vec2(-10f*gb.getSpeed(), 0f));
  }

  void createPoint(float w, float h) {
    // Define the polygon
    PolygonShape middlePs = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = g.box2d.scalarPixelsToWorld(w/2);
    float box2dH = g.box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    middlePs.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef midlleBd = new BodyDef();
    midlleBd.type = BodyType.DYNAMIC;
    midlleBd.position.set(g.box2d.coordPixelsToWorld(x, y));
    bodyMiddle = g.box2d.createBody(midlleBd);
    bodyMiddle.setGravityScale(0);
    // Attached the shape to the body using a Fixture
    bodyMiddle.createFixture(middlePs, 1 );
    bodyMiddle.setUserData(this);
  }

  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(bodyMiddle);
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