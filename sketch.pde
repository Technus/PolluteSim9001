import g4p_controls.*;
import java.util.*;

int p[][]=new int[30][30];//"map"
int max=1;
int maxy=1;


void setup(){
  size(300,300);//screensize
  createGUI();
  (new Thread(new pollute())).start();//pollution sim code start
}

void draw(){
  //delay(1);
  background(0);
  
  
  for(int x=1;x<29;x++){//Draw boxes depending on pollution content
    for(int y=1;y<29;y++){
      stroke(p[x][y]>0?255:0);
      fill(p[x][y]>2000000 ? 256 : p[x][y]>1000000 ? 64 : 0,
           p[x][y]>750000  ? 256 : p[x][y]>550000  ? 128 : 0,
           p[x][y]*255/max);
      rect(x*10,y*10,10,10);
    }
  }
  
  stroke(255);
  fill(255);
  text(max,10,10);//print max values registered
  text(maxy,10,20);
}

class pos{
  public int x;
  public int y;
  
  pos(int x,int y){
    this.x=x;
    this.y=y;
  }
  
  int get(){
    return p[x][y];
  }
  
  void set(int i){
    p[x][y]=i;
  }
  
}

public class pollute implements Runnable{//pollution sim code
  pollute(){}
  
  public void run(){
    while(true){//loop
      //delay(10);
      try{
      p[15][15]+=Integer.parseInt(textfield1.getText());//Read from text box to integer so u can imput pollution per pollution spread calculation
      }catch(Exception e){}//p[14][15]+=9000*2;
      //p[15][16]+=30000;//some extra pollutants can be added here
      //p[14][15]+=5000;
      //p[16][15]+=5000;
      int temp=1;//for max value handling
      for(int x=1;x<29;x++){//loop over "chunks"
        for(int y=1;y<29;y++){
          temp=p[x][y]>temp?p[x][y]:temp;//max value
          p[x][y]-=3000;//de pollute
          //p[x][y]/=0.99F;//if u do it like that casting is already there, and i personally dont like that
          p[x][y]=p[x][y]<0?0:p[x][y];//less than 0 then 0
          
          if(p[x][y]>500000){//spread code (in my version starts over 500k)
            List<pos> ar=new ArrayList();//neighbors
            ar.add(new pos(x+1,y));
            ar.add(new pos(x-1,y));
            ar.add(new pos(x,y+1));
            ar.add(new pos(x,y-1));
            
            for(pos t : ar){//spread to neighbors
              if(t.get()*12<p[x][y]*10){//that is more efficient than our code x>y && 12*x>10*y ... since (think more like that 2*x>y is always more restrictive than x>y)
                 int diff=p[x][y]-t.get();
                diff=diff/20;//here 20 also my code works like that
                t.set(t.get()+diff);
                p[x][y]-=diff;
              }
            }
            
          }
        }
      }
      max=temp;
      maxy=max>maxy?max:maxy;
    }
  }
}
