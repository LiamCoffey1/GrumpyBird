public class BackgroundMusic extends Thread { //<>//
  SoundFile s;
  boolean active;
  int x = 0;
  boolean loop;
  int lengthS;
  Game g;
  public BackgroundMusic(SoundFile s, Game g) {
    this.s = s;
    this.g = g;
    s.amp(0.4F);
    loop = false;
  }

  public BackgroundMusic(SoundFile s, int lengthS, Game g) {
    this.s = s;
    this.g = g;
    s.amp(0.4F);
    this.lengthS = lengthS;
    loop = true;
  }

  void start() {
    super.start();
  }

  void run() {
    while (active) {
      if (!g.soundEnabled)
        s.amp(0);
      else
        s.amp(0.4F);
      if (!active)
        s.stop();
      if (!loop) {
        if (x == 0) {
          s.play();
          x = 1;
        }
      } else {
        s.play();
        delay(((int)s.duration()*1000)-(2800));
      }
    }
  }


  void stopMusic() {
    s.stop();
    active = false;
  }
}
