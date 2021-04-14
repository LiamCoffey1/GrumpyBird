class Loading {
  Game g;
  AssetManager a;

  Loading(Game g, AssetManager a) {
    this.g = g;
    this.a = a;
  }
  void draw() {
    background(255);
    this.getAssetManager().loadAssets();
    g.m = new Menu(a, g.g, g);
    g.m.active = true;
    g.setState(Constants.MENU);
  }
  AssetManager getAssetManager() {
    return a;
  }
}