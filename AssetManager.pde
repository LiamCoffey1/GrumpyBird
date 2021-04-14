import java.util.Map;

/*
* @author Liam Coffey
 * Class preloads assets and stores them
 *
 */
class AssetManager {
  Game g;
  PImage bg;
  PImage button;
  PImage backPlate;
  PImage ccBg;
  PImage cookie;
  PImage mould;
  PImage flap;
  PImage flap2;
  PImage flap3;
  PImage flap4;
  PImage grass;
  PImage pipe;
  PImage finish;
  PImage gold;
  PImage bronze;
  PImage silver;
  PImage plat;
  PFont fontFlap;
  PImage gameOver;
  PImage restart;
  PImage exit;
  PImage logo;
  PImage[] musicButton;
  PImage[] playButton;
  PImage[] exitButton;
  //Sprite alien;
  Map images;
  Map chars;
  Map medals;
  SoundFile tick;
  SoundFile fly;
  SoundFile hit;
  SoundFile point;


  public AssetManager(Game g) {
    this.g = g;
  }


  public void loadAssets() {
    bg = loadImage("background2.png");
    button = loadImage("button.png");
    backPlate = loadImage("backplate.png");
    ccBg = loadImage("background2.png");
    cookie = loadImage("cookie.png");
    mould = loadImage("mould.png");
    flap = loadImage("flap1.png");
    flap2 = loadImage("flap2.png");
    flap3 = loadImage("flap3.png");
    flap4 = loadImage("flap4.png");
    grass = loadImage("grass.png");
    pipe = loadImage("pipe.png");
    finish = loadImage("finish.png");
    gold = loadImage("gold.png");
    bronze = loadImage("bronze.png");
    silver = loadImage("silver.png");
    plat = loadImage("plat.png");
    gameOver = loadImage("gameOver.png");
    restart = loadImage("restart.png");
    exit = loadImage("exit.png");
    logo = loadImage("gameLogo.png");
    tick = new SoundFile(g, "doomed.mp3"  );
    fly = new SoundFile(g, "flap.wav"  );
    hit = new SoundFile(g, "hit.wav"  );
    point = new SoundFile(g, "sfx_point.mp3"  );
    fontFlap = createFont("flappy.TTF", 80);
    images = new HashMap<String, PImage>();
    images.put("button", button);
    images.put("EXIT", button);
    images.put("HIGHER", button);
    chars = new HashMap<Integer, PImage>();
    chars.put(0, flap);
    chars.put(1, flap2);
    chars.put(2, flap3);
    chars.put(3, flap4);
    playButton = new PImage[]{loadImage("playBtn.png"), loadImage("playBtnH.png"), loadImage("playBtn.png")};
    exitButton = new PImage[]{loadImage("exitBtn.png"), loadImage("exitBtnH.png"), loadImage("exitBtn.png")};
    musicButton = new PImage[]{loadImage("music.png"), loadImage("musicH.png"), loadImage("music.png")};
    medals = new HashMap<Integer, PImage>();
    medals.put(0, bronze);
    medals.put(10, silver);
    medals.put(20, gold);
    medals.put(40, plat);
  }

  void playSound(SoundFile s) { 
    if (g.soundEnabled)
      s.play();
  }

  void soundEnabled(boolean b) {
    g.soundEnabled = b;
  }
}