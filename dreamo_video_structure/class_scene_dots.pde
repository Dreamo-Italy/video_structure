class SceneDots extends Scene
{
  

  
  void init()
  {
   
    pal.initColors();
    
    DotGenerator generator = new DotGenerator();
    
    generator.setPalette(this.pal);
    
    addParticle(generator);
    generator.setPosition(new Vector2d(width/2, height/2, false));
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    
    setParameter(0, -10.0);
    setParameter(1, 100.0);
    setParameter(2, 0.0);
  }
}