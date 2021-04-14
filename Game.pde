import shiffman.box2d.*;
int state = 0;
Splash s;
Loading l;
Menu m;
AssetManager a;
GameManager g;
ControlP5 p5;

String event = null;

boolean music;
boolean soundEnabled = true;

void setup() {
  size(1664, 936, P2D);
  surface.setTitle("Grumpy Bird");
  a = new AssetManager(this);
  g = new GameManager(this);
  s = new Splash(this);
  l = new Loading(this, a);
  // Initia
  noStroke();
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this, 10);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -20);
  // Turn on collision listening!
  box2d.listenForCollisions();
  p5 = new ControlP5(this);
  music = true;
}

void draw() {
  switch(getState()) {
  case Constants.SPLASH:
    s.draw();
    return;
  case Constants.LOADING:
    l.draw();
    return;
  case Constants.MENU:
    if (m != null) m.draw();
    return;
  case Constants.GAME_STATE:
    g.drawGame();
    return;
  }
}

void keyPressed() {
  g.handleButtons();
  if (key == ESC) {
    setState(Constants.MENU);
    key=0;
  }
}

void keyReleased() {
  g.keyReleased();
}

void mouseClicked() {
  switch(getState()) {
  case Constants.GAME_STATE:
    g.handleInput();
    return;
  case Constants.SPLASH:
    s.mousePressed();
    return;
  }
}

void mouseReleased() {
  switch(getState()) {
  case Constants.GAME_STATE:
    g.mouseReleased();
    return;
  }
}




// Collision event functions!
void beginContact(Contact cp) {
  switch(getState()) {
  case Constants.GAME_STATE:
    g.onContact(cp);
    return;
  }
}


public void controlEvent(ControlEvent theEvent) {
  switch(getState()) {
  case Constants.GAME_STATE:
    g.controlEvent(theEvent);
    return;
  case Constants.MENU:
    m.controlEvent(theEvent);
    return;
  }
}

int getState() {
  return state;
}

boolean soundEnabled() {
  return music;
}

void setState(int state) {
  this.state = state;
}
