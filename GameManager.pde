class GameManager {
  Game g;
  int game;
  GrumpyBird gb;
  GameManager(Game g) {
    this.g  = g;
  }

  void drawGame() {
    switch(getGame()) {
    case 2:
      gb.drawGame();
      return;
    }
  }
  void handleInput() {
    switch(getGame()) {
    case 2:
      gb.mouseAction();
      return;
    }
  }

  void handleButtons() {
    switch(getGame()) {
    case 2:
      gb.buttons();
      return;
    }
  }

  void keyReleased() {
    switch(getGame()) {
    case 2:
      gb.keyReleased();
      return;
    }
  }

  void mouseReleased() {
    switch(getGame()) {
    case 2:
      gb.mouseReleased();
      return;
    }
  }
  void onContact(Contact c) {
    switch(getGame()) {
    case 2:
      gb.beginContact(c);
      return;
    }
  }

  public void controlEvent(ControlEvent theEvent) {
    switch(getGame()) {
    case 2:
      gb.controlEvent(theEvent);
      return;
    }
  }
  public void setGame(int i) {
    game = i;
    if (game == 2) {
      gb = new GrumpyBird(this, g);
    } else if (game == -1) {
      gb = null;
    }
  }
  public int getGame() {
    return game;
  }
  Game getG() {
    return g;
  }
}