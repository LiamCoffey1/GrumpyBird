import processing.sound.*; //<>//
/*
* @author Liam Coffey
 * Class controls and draws thew splash screen
 *
 */
class Splash {
  Game g;
  PImage logo;
  int opacity;
  int startTime;
  SoundFile file;
  /*
  * Constructor creates instance of game and calls the loading
   * @param g, instance of game
   */
  Splash(Game g) {
    this.g = g;
    loadAssets();
    opacity = 0;
  }

  /*
  * Loads images for use and records start time
   *
   */
  private void loadAssets() {
    startTime = millis();
    file = new SoundFile(g, "doomed.mp3");
    file.amp(0.1F);
    file.play();
    logo = loadImage("logo.png");
  }

  /*
  * draw graphics on scene
   */
  public void draw() {
    background(0); // black
    tint(opacity, 126);
    image(logo, (width/2)-(logo.width/2), (height/2)-(logo.height/2)); //center image
    if (opacity < 256)
      opacity++; // fade in
    else opacity--;
    if (millis()/1000 - startTime/1000 == 6) //6 seconds
      changeState();
  }

  /*
  * Handles mouse actions
   */
  void mousePressed() {
    if (mouseButton == LEFT)
      changeState();
  }

  /*
  * Continous to loading screen
   */
  void changeState() {
    file.stop();
    g.setState(Constants.LOADING);
  }
}
