public class PipeManager extends Thread {
  GrumpyBird gb;
  private volatile boolean active = false;
  public PipeManager(GrumpyBird gb) {
    this.gb = gb;
  }

  public void start() {
    active = true;
    super.start();
  }

  public void run() {
    if (gb.player.isAlive() || active) {
      delay((int)(Constants.PIPE_DISTANCE/gb.speed));
      int h = (int)random(250, 600);
      gb.pipes.add(new Pipe(gb, gb.g.a, gb.g, h));
      gb.pointSensors.add(new Point(gb, gb.g.a, gb.g, h));
      gb.pipeCount++;
      run();
    } else {
      delay(1000);
      run();
    }
  }

  void setActive(boolean b) {
    active = b;
  }
}