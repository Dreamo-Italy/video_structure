class GridPlotter extends Particle
{
  final int rows = 15;
  final int columns = 20;
  final int N = rows*columns;
  
  GridNode[] gridNodes;
  
  float hue ;
  float saturation ;
  float brightness ;
  color colore;
      

  float alpha;
  float alphaWeight = 0.05;
  float strokeWeight = 1;
  
  boolean destroying = false;
  
  public void perturbate(Vector2d pulsePosition, float intensity)
  {
    for(int i = 0; i < N; i++)
    {
      float distance = pulsePosition.distance(gridNodes[i].getPosition());
      if(intensity > distance)
      {
        gridNodes[i].setSpeed(new Vector2d(intensity/distance, gridNodes[i].getPosition().subtract(pulsePosition).getDirection(), true));
      }
    }
  }
  
  void init()
  {
     colore = pal.getLightest();          
     hue = hue(colore);
     saturation = saturation(colore);
     brightness = brightness(colore);   
     alpha = 2;
    setPersistence(true);
    
    gridNodes = new GridNode[N];
    for(int i = 0; i < N; i++)
    {
      gridNodes[i] = new GridNode();
      gridNodes[i].setPosition(new Vector2d(width/(columns - 1)*(i%columns), height/(rows - 1)*(i/columns), false));
      global_stage.getCurrentScene().addParticle(gridNodes[i]);
    }
    for(int i = 0; i < N; i++)
    {
      if((i%columns) < columns-1)
      {
        gridNodes[i].setNeighbour(gridNodes[i+1], 0);
      }
      if((i/columns) > 0)
      {
        gridNodes[i].setNeighbour(gridNodes[i-columns], 1);
      }
      if((i%columns) > 0)
      {
        gridNodes[i].setNeighbour(gridNodes[i-1], 2);
      }
      if((i/columns) < rows-1)
      {
        gridNodes[i].setNeighbour(gridNodes[i+columns], 3);
      }
    }
  }
  
  void update()
  {
    
    if(frameCount%120 == 0 ) 
      perturbate(new Vector2d((height/10*4)*sin(frameCount/500.0*TWO_PI), (frameCount%22)/21.0*TWO_PI, true).sum(new Vector2d(width/2, height/2, false)), 150);
    
    if(getSceneChanged() && !destroying)
    {
      destroying = true;
      setLifeTimeLeft(50);
    }
    
    if(destroying)
    {
      alphaWeight -= 1/50.0;
    }
    
    //hue++;
    //if(hue > 360) hue = 0;
  }
  
  void trace()
  {
    noFill();
    
    for(int i = 0; i < N; i++)
    {
      //int hshift = round(gridNodes[i].getSpeed().getDirection()/TWO_PI*20);
      //if(hshift < 0) hshift += 360;
      //if(hshift > 360) hshift -= 360;
      int ashift = round(gridNodes[i].getSpeed().getModulus()*100 );
      int swshift = round(gridNodes[i].getSpeed().getModulus()*0.1);
      if(ashift > 360) ashift = 360;
      if(swshift > 5) swshift = 5;
      
      stroke(hue +0 , saturation, brightness, round((alpha+ashift)*alphaWeight));
      strokeWeight(strokeWeight + swshift);
      if((i%columns) < columns-1)
      {
        line(gridNodes[i].getPosition().getX(), gridNodes[i].getPosition().getY(), gridNodes[i+1].getPosition().getX(), gridNodes[i+1].getPosition().getY());
      }
      if((i/columns) < rows-1)
      {
        line(gridNodes[i].getPosition().getX(), gridNodes[i].getPosition().getY(), gridNodes[i+columns].getPosition().getX(), gridNodes[i+columns].getPosition().getY());
      }
    }
    
  }
}