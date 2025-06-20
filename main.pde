import processing.serial.*;
import controlP5.*; // import library for knob
import java.io.File;
import java.util.Arrays;
import java.util.Comparator;

Serial myPort;        // Create serial port object 
ControlP5 cp5;      // defines the type "cp5" as a variable "type" defined in ControlP5 fo its objects

PFont font1;
String portName;
int ledColor = 0;
int peltColor = 0;
int knobValue = 100;
int background1 = color(25, 25, 25); //dark grey;
int background2 = color(100, 100, 100); //light gray;
int background3 = color(00, 33, 66); //blue;
int background4 = #aa0000; //dark red;
int background5 = #ff0000; //light red;
float valVert;
int diff = 0;
byte rawBytes[];
PImage img;  
long picNum = 0;
int millisInit;
int port = 0;
int HAlign1 = 25;
int HAlign2 = 110;
int HAlign3 = 540;
int HAlign4 = 1200-125;
int home = 0;
int recentValue;
boolean isReady = false; 


//int baud = 650000;
int baud = 115200;
//int baud = 230400;
//int baud = 500000;


Knob Knob1;  
Slider Slider1, Slider2, Slider3, Slider4, Slider5, Slider6, Slider7;
Bang Bang1, Bang2, Bang3, Bang4, Bang5, Bang6, Bang7, Bang8, Bang9, Bang10;
Textlabel Textlabel1, Textlabel2, Textlabel3;
Chart Chart1;
DropdownList DropList1;
Toggle Toggle1, Toggle2, Toggle3, Toggle4;


//output
int sec = second();  // Values from 0 - 59hheea
int min = minute();  // Values from 0 - 59
int hour = hour();    // Values from 0 - 23
int day = day();  
int month = month();
int year = year(); 
PrintWriter output1, output2;


void setup() {
  clear();
  size(1200,950);  
  smooth();  
  noStroke(); 
  
  cp5 = new ControlP5(this);

// font
  PFont f1 = createFont("Verdana",25); 
  ControlFont font1 = new ControlFont(f1);
  ControlFont font2 = new ControlFont(f1, 20);

// colors
  cp5.setColorForeground(background4);
  cp5.setColorBackground(background3);
  cp5.setColorActive(background5); 
  cp5.setFont(font1);

//writer
output1 = createWriter("logs/log/log_" + String.format("%04d-%02d-%02d_%02d-%02d-%02d", year, month, day, hour, min, sec) + ".txt");
output2 = createWriter("logs/rotate/rotate_" + String.format("%04d-%02d-%02d_%02d-%02d-%02d", year, month, day, hour, min, sec) + ".txt");

// serial
  DropList1 = cp5.addDropdownList("myList-DropList1")
          .setPosition(HAlign4-10, 575)
          .setSize(100, 200)
          .setHeight(210)
          .setItemHeight(35)
          .setBarHeight(40)
          .setFont(font2)
          .setColorBackground(background2)
          .setColorActive(background5)
          ;
  DropList1.getCaptionLabel().set("PORT"); //set PORT before anything is selected
  portName = Serial.list()[port]; //0 as default   
  myPort = new Serial(this, portName, baud);   
  //myPort.bufferUntil('\n');
  Label labelDropList1 = DropList1.getCaptionLabel();
  labelDropList1.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelDropList1.getStyle().setPaddingTop(5);
  labelDropList1.getStyle().setPaddingLeft(5);


//led
  Slider1 = cp5.addSlider("led")
               .setRange(0,255)
               .setValue(0)
               .setPosition(HAlign1,100)
               .setSize(50,750)
               .setNumberOfTickMarks(51)
               //.setTriggerEvent(Slider.RELEASED)
               //.setColorValue(0xffaaaaaa)
               //.setColorLabel(0xffffffff)
               ;


//motor2
  Slider2 = cp5.addSlider("motor2")
               .setRange(0,200)
               .setValue(100)
               .setLabel("Camera position")
               .setPosition(HAlign2,440)
               .setSize(400,50)
               .setTriggerEvent(Slider.RELEASED)
               .setNumberOfTickMarks(21)
               //.setFont(new ControlFont(f1, 25))
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               ;
  Label labelSlider2 = Slider2.getCaptionLabel();
  labelSlider2.align(ControlP5.RIGHT_OUTSIDE, LEFT);
  labelSlider2.getStyle().setPaddingTop(-35);
  labelSlider2.getStyle().setPaddingLeft(-390);


//motor2 reset
 Bang1 = cp5.addBang("bang1")
             .setPosition(HAlign2,510)
             .setSize(80,40)
             .setLabel("reset")
             .setColorForeground(background2)
             .setColorActive(background5)
             ; 
  Label labelBang1 = Bang1.getCaptionLabel();
  labelBang1.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelBang1.getStyle().setPaddingTop(0);
  labelBang1.getStyle().setPaddingLeft(-70);
  labelBang1.toUpperCase(false);


//temp out
  Slider3 = cp5.addSlider("tempOut")
               .setRange(24,37)
               .setValue(0)
               .setLabel("set temp [°C]")
               .setPosition(HAlign2,150)
               .setSize(400,35)
               .setNumberOfTickMarks(53)
               .setFont(font2)
               .setTriggerEvent(Slider.RELEASED)
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               .setColorBackground(background2)
               ;
  Label labelSlider3 = Slider3.getCaptionLabel();
  labelSlider3.toUpperCase(false);
  labelSlider3.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelSlider3.getStyle().setPaddingLeft(-300);
  
  Slider3.addCallback(new CallbackListener() {          
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_RELEASE): case(ControlP5.ACTION_RELEASE_OUTSIDE): case(ControlP5.ACTION_WHEEL):
          println("Slider3 pressed released");
          cp5.getController("heating").setValue(1);
          write(0, 0, 8); //get current temp
          //thermostat();
        break;    
      }
    }
  }); 


//heating on/off
 Toggle1 = cp5.addToggle("heating")
             .setValue(false)
             .setPosition(HAlign2, 100)
             .setSize(400,45)
             .setLabel("heating ON/OFF")
             .setFont(font1)
             .setColorBackground(background2)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             ; 
  Label labelToggle1 = Toggle1.getCaptionLabel();
  labelToggle1.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelToggle1.getStyle().setPaddingTop(0);
  labelToggle1.getStyle().setPaddingLeft(-320);
  //labelToggle1.toUpperCase(false);
     
     
// temp input
  Slider4 = cp5.addSlider("tempIn")
               .setLabel("current temp [°C]")
               .setPosition(HAlign2, 190)
               .setSize(400,35)
               .setFont(font2)
               .setColorBackground(background2)
               ;
  Label labelSlider4 = Slider4.getCaptionLabel();
  labelSlider4.toUpperCase(false);
  labelSlider4.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelSlider4.getStyle().setPaddingLeft(-300);
  //Slider4.setMultiplier(300); // change Multiplier of the Numberbox ( default is 1 )               

    
//temp chart
  Chart1 = cp5.addChart("tempInChart")
               .setPosition(HAlign2, 230)
               .setSize(400, 140)
               .setRange(22, 40)
               .setView(Chart.BAR) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;
  Chart1.getColor().setBackground(color(255, 100));
  Chart1.setStrokeWeight(1.5);
  Chart1.addDataSet("currentTemp");
  Chart1.setData("currentTemp", new float[500]);
  Chart1.setColors("currentTemp", color(0,0,255), color(255, 0, 0));     


//motor1
  Knob1 = cp5.addKnob("motor1")  // "method" is add(ControllerInterface<?> theElement) 
               .setRange(0,270) 
               .setValue(0)  
               .setPosition(width-500,30) // ditance from L/T
               .setRadius(220)  // for knob
               .setLabel("Rotation [°]")
               .setScrollSensitivity(1/(1.350*200))
               .setDragDirection(Knob.HORIZONTAL)
               .setStartAngle(4.74)
               .setConstrained(false)
               .setViewStyle(2)
               .setDecimalPrecision(0)
               ;     
  Label labelKnob1 = Knob1.getCaptionLabel();
  labelKnob1.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelKnob1.getStyle().setPaddingTop(-35);
  labelKnob1.getStyle().setPaddingLeft(-310); 
  
  
  Knob1.addCallback(new CallbackListener() {          
  public void controlEvent(CallbackEvent theEvent) {
    // Check if the mouse is inside the knob area
    int val;
    int action = theEvent.getAction();

    // Handle only the ACTION_WHEEL event
    if (action == ControlP5.ACTION_WHEEL ||action ==  ControlP5.ACTION_RELEASE || action == ControlP5.ACTION_RELEASE_OUTSIDE) {
      println(cp5.getController("motor1").getValue());
      val = Math.round(Knob1.getValue());
      println(val);
      val = val - recentValue;
      if(val >= 0) {
        write(val, 0, 7);
      } else if(val < 0) {
        write(val, 0, 6);
      }
    }
  }
});

last();


//Interval
  Toggle3 = cp5.addToggle("interval")
             .setValue(false)
             .setPosition(HAlign3, 440)
             .setSize(160,35)
             .setLabel("Interval:")
             .setFont(font2)
             .setColorBackground(background2)
             .setColorLabel(0xffffffff)
             ; 
  Label labelToggle3 = Toggle3.getCaptionLabel();
  labelToggle3.toUpperCase(false);
  labelToggle3.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelToggle3.getStyle().setPaddingTop(0);
  labelToggle3.getStyle().setPaddingLeft(-150);


//Int1
  Slider6 = cp5.addSlider("int1")
               .setRange(-180,180)
               .setValue(0)
               .setLabel("")
               .setPosition(HAlign3,485)
               .setSize(160,30)
               .setFont(font2)
               .setTriggerEvent(Slider.RELEASED)
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               .setColorBackground(background2)
               .setDecimalPrecision(1)
               .setScrollSensitivity(0.025)
;
  
  
//Int2
  Slider7 = cp5.addSlider("int2")
               .setRange(-180,180)
               .setValue(0)
               .setLabel("")
               .setPosition(HAlign3,525)
               .setSize(160,30)
               .setFont(font2)
               .setTriggerEvent(Slider.RELEASED)
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               .setColorBackground(background2)
               .setDecimalPrecision(1)
               .setScrollSensitivity(0.025)
               ;
     

//push interval1
 Bang8 = cp5.addBang("push1")
             .setPosition(HAlign3+160+10,485)
             .setSize(50, 30)
             .setLabel("push")
             .setFont(font2)
             .setColorForeground(background2)
             .setColorActive(background5)
             ; 
  Label labelBang8 = Bang8.getCaptionLabel();
  labelBang8.toUpperCase(false);
  labelBang8.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelBang8.getStyle().setPaddingTop(0);
  labelBang8.getStyle().setPaddingLeft(-50)
  ;


//push interval2
 Bang9 = cp5.addBang("push2")
             .setPosition(HAlign3+160+10,525)
             .setSize(50, 30)
             .setLabel("push")
             .setFont(font2)
             .setColorForeground(background2)
             .setColorActive(background5)
             ; 
  Label labelBang9 = Bang9.getCaptionLabel();
  labelBang9.toUpperCase(false);
  labelBang9.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelBang9.getStyle().setPaddingTop(0);
  labelBang9.getStyle().setPaddingLeft(-50)
  ;                  
          

//setHome
  Toggle4 = cp5.addToggle("setH")
             .setValue(0)
             .setPosition(HAlign4+20, 465)
             .setSize(70,40)
             .setLabel("set H")
             .setFont(font2)
             .setColorBackground(background2)
             .setColorLabel(0xffffffff)
             ; 
  Label labelToggle4 = Toggle4.getCaptionLabel();
  labelToggle4.toUpperCase(false);
  labelToggle4.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelToggle4.getStyle().setPaddingTop(0);
  labelToggle4.getStyle().setPaddingLeft(-60);
          
        
//goHome
 Bang10 = cp5.addBang("goH")
             .setPosition(HAlign4+20,515)
             .setSize(70, 40)
             .setLabel("go H")
             .setFont(font2)
             .setColorForeground(background2)
             .setColorActive(background5)
             ; 
  Label labelBang10 = Bang10.getCaptionLabel();
  labelBang10.toUpperCase(false);
  labelBang10.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelBang10.getStyle().setPaddingTop(0);
  labelBang10.getStyle().setPaddingLeft(-65)
  ;              
          
          
//text
  Textlabel1 = cp5.addTextlabel("label1")
                .setText("iCAT")
                .setPosition(HAlign1,20)
                .setColorValue(0xffffffff)
                .setFont(new ControlFont(f1, 60))
                ;
  Textlabel2 = cp5.addTextlabel("label2")
                .setText("LED intensity:")
                .setPosition(20,height-45)
                .setColorValue(128)
                .setFont(new ControlFont(f1, 40))
                ;
  Textlabel3 = cp5.addTextlabel("label3")
                .setText("HEAT intensity:")
                .setPosition(width/2+40,height-45)
                .setColorValue(128)
                .setFont(new ControlFont(f1, 40))
                ;


//ArduCam
  int camH = 580;
  Bang2 = cp5.addBang("cam1")
             .setPosition(HAlign2 + 5, camH)
             .setSize(50,50)
             .setLabel("1")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang2 = Bang2.getCaptionLabel();
  labelBang2.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang2.getStyle().setPaddingTop(12);
  labelBang2.getStyle().setPaddingLeft(-30);
  
  Bang3 = cp5.addBang("cam2")
             .setPosition(HAlign2 +60, camH)
             .setSize(50,50)
             .setLabel("2")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang3 = Bang3.getCaptionLabel();
  labelBang3.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang3.getStyle().setPaddingTop(12);
  labelBang3.getStyle().setPaddingLeft(-30);
  
  Bang4 = cp5.addBang("cam3")
             .setPosition(HAlign2 +115, camH)
             .setSize(50,50)
             .setLabel("3")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang4 = Bang4.getCaptionLabel();
  labelBang4.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang4.getStyle().setPaddingTop(12);
  labelBang4.getStyle().setPaddingLeft(-30);
  
  Bang5 = cp5.addBang("cam4")
             .setPosition(HAlign2 + 170, camH)
             .setSize(50,50)
             .setLabel("4")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang5 = Bang5.getCaptionLabel();
  labelBang5.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang5.getStyle().setPaddingTop(12);
  labelBang5.getStyle().setPaddingLeft(-30);  

  //Bang6 = cp5.addBang("cam5")
  //           .setPosition(375, camH)
  //           .setSize(50,50)
  //           .setLabel("5")
  //           .setFont(font1)
  //           .setColorValue(0xffaaaaaa)
  //           .setColorLabel(0xffffffff)
  //           .setColorForeground(background2)
  //           ; 
  //Label labelBang6 = Bang6.getCaptionLabel();
  //labelBang6.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  //labelBang6.getStyle().setPaddingTop(5);
  //labelBang6.getStyle().setPaddingLeft(-30);  
  
  Bang7 = cp5.addBang("camS")
             .setPosition(940, camH)
             .setSize(50,50)
             .setLabel("s")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang7 = Bang7.getCaptionLabel();
  labelBang7.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang7.getStyle().setPaddingTop(12);
  labelBang7.getStyle().setPaddingLeft(-30);
  labelBang7.toUpperCase(false);

  Toggle2 = cp5.addToggle("camC")
             .setValue(false)
             .setPosition(995, camH)
             .setSize(50,50)
             .setLabel("c")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorBackground(background2)
             ; 
  Label labelToggle2 = Toggle2.getCaptionLabel();
  labelToggle2.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelToggle2.getStyle().setPaddingTop(12);
  labelToggle2.getStyle().setPaddingLeft(-30);
  labelToggle2.toUpperCase(false);
  
  // cam vertical
  Slider5 = cp5.addSlider("camVertical")
               .setLabel("V crop:")
               .setRange(0,100)
               .setValue(0)
               .setPosition(HAlign4, 725)
               .setSize(50,150)
               .setFont(font2)
               .setNumberOfTickMarks(21)
               .setDecimalPrecision(0)
               //.setColorValue(0xffaaaaaa)
               //.setColorLabel(0xffffffff)
               .setColorBackground(background2)
               ;
  Label labelSlider5 = Slider5.getCaptionLabel();
  labelSlider5.toUpperCase(false);
  labelSlider5.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelSlider5.getStyle().setPaddingLeft(-60);
  labelSlider5.getStyle().setPaddingTop(-30);
  
  img = createImage(100, 100, RGB);
}


void draw() {   
sec = second();  // Values from 0 - 59
min = minute();  // Values from 0 - 59
hour = hour();    // Values from 0 - 23
day = day();  
month = month();
year = year(); 

  background(background1); 
  fill(ledColor); 
  rect(0,height-50,width/2-10,50);   // distance from borders L/T, width/height
  fill(peltColor); 
  rect(width/2+10,height-50,width/2-10,50);   // distance from borders L/T, width/height

  
  pushMatrix(); // remember current drawing matrix)
    translate(940,  300);
    rotate(radians(180)); // rotate 180 degrees, alll upcoming values need to be in neg numbers
      image(img.get(0,Math.round(valVert)*img.height/200,img.width,img.height/2), -HAlign2, -575, 940, 300);    //img.get(crop from left, top, width, height), padding left, top, width, height
  popMatrix(); // restore previous graphics matrix


  if(DropList1.isMouseOver()) {
    DropList1.clear(); //Delete all the items
    for (int i=0;i<Serial.list().length;i++) {
      DropList1.addItem(Serial.list()[i], i); //add the items in the list
    }
  }
  output1.flush();
  output2.flush();
  examineTemp();
} 


void write (int val, int append1, int append2) {
  println("sent value: "+val); 
  output1.println();
    output1.printf("%02d:%02d:%02d   ", hour, min, sec);
    output1.print("sent value: "+val);
        String s0 = Integer.toString(val);
        String s1 = Integer.toString(append1);
        String s2 = Integer.toString(append2);
        String s = s0 + s1 + s2;
        int c = Integer.parseInt(s);
  println("sent message: "+c);       
  output1.println();
    output1.printf("%02d:%02d:%02d   ", hour, min, sec);
    output1.print("sent message: "+c);   
  myPort.write(Integer.toString(c)); 
  myPort.write('e');
}


void led(int val) {
  ledColor = color(val);
  write(val, 0, 9);
} 


void interval(int val) {
  write(val, 2, 5);
} 

void int1(int val) {
  //val = val - recentValue;
  if( val <0) {write(val, 2, 6);}
  if( val >=0) {write(val, 2, 7);}
} 

void int2(int val) {
  //val = val - recentValue;
  if( val <0) {write(val, 2, 8);}
  if( val >=0) {write(val, 2, 9);}
} 


void push1() {
  int push = Math.round(Knob1.getValue()) + int(cp5.getController("int1").getValue());
  Knob1.setValue(push);
  push = push - recentValue;
  if( push >= 0) {write(push, 0, 7);}
  if( push < 0) {write(push, 0, 6);}

}

void push2() {
  int push = Math.round(Knob1.getValue()) + int(cp5.getController("int2").getValue());
  Knob1.setValue(push);
  push = push - recentValue;
  if( push >= 0) {write(push, 0, 7);}
  if( push < 0) {write(push, 0, 6);} 
}


void setH() {
  home = Math.round(Knob1.getValue());
  println("home set: " + home);
}


void goH() {
  if (cp5.getController("setH").getValue() == 1) {
    println("home is set: " + home);
    Knob1.setValue(home);
    home = home - recentValue;
    if( home > 0) {write(home, 0, 7);}
    if( home < 0) {write(home, 0, 6);}
  } 
  else {
    println("home is not set: " + 0);
    Knob1.setValue(0);
    home = 0 - recentValue;
    if( home > 0) {write(home, 0, 7);}
    if( home < 0) {write(home, 0, 6);}
  }
}


void motor2(int val) {
  if( val >100 - diff) {write(val - 100 + diff, 0, 4);}
  if( val <100 - diff) {write(val - 100 + diff, 0, 5);}
  if( val == 100 - diff) {write(val - 100 + diff, 0, 4);}
} 


//heating
void thermostat() {
  if(cp5.getController("heating").getValue() == 1) {
    float targetT = cp5.getController("tempOut").getValue();
    println("targetT: " + targetT);
    output1.println();
      output1.printf("%02d:%02d:%02d   ", hour, min, sec);
      output1.print("targetT: " + targetT);
    float currentT = cp5.getController("tempIn").getValue();
    println("currentT: " + currentT);
    output1.println();
      output1.printf("%02d:%02d:%02d   ", hour, min, sec);
      output1.print("currentT: " + currentT);
    float deltaT = targetT-currentT;
    println("deltaT: " + deltaT);
    output1.println();    
      output1.printf("%02d:%02d:%02d   ", hour, min, sec);
      output1.print("deltaT: " + deltaT);
    
    float multiplier = 1 + ((targetT - 28)/(1/0.20)); // multiplier increases by 0.20 for each degree Celsius above 28°C
    int hp0 = Math.round(6 * multiplier); // Heating power level 0
    int hp1 = Math.round(30); // Heating power level 1
    float deltaT0 = 0; // Delta temperature threshold at which heating power 0 (hp0) is activated, defined as the difference between the setpoint and the actual temperature 
    float deltaT1 = 4; // Delta temperature threshold at which heating power 1 (hp1) is activated, defined as the difference between the setpoint and the actual temperature 
    int hp = Math.round( (hp0 * (deltaT1 - deltaT) - hp1 * (deltaT0 - deltaT)) / (deltaT1 - deltaT0) ); // A linearly increasing heating power is applied when the actual temperature falls within the range defined by deltaT0 and deltaT1
    //println("hp0: " + hp0);
    //println("hp1: " + hp1);
    //println("hp: " + hp);
    //println("multiplier: " + multiplier);    

    
    if(deltaT < deltaT0 ) {
      println("hp0: " + hp0);
      output1.println();
        output1.printf("%02d:%02d:%02d   ", hour, min, sec);
        output1.println("heat_" + hp0);
      peltColor = color(30);
      write(hp0, 0, 3);
    }
    if(deltaT >= deltaT0 && deltaT < deltaT1) {
      println("hp: " + hp);
      output1.println();
        output1.printf("%02d:%02d:%02d   ", hour, min, sec);
        output1.print("heat_" + hp);
      peltColor = color(60);
      write(hp, 0, 3);
    }
    if(deltaT >= deltaT1) {
      println("hp: " + hp1);
      output1.println();      
        output1.printf("%02d:%02d:%02d   ", hour, min, sec);
        output1.print("heat_" + hp1);
      peltColor = color(240);
      write(hp1, 0, 3);
    }
  }
  if(cp5.getController("heating").getValue() == 0) {
    //cp5.getController("tempOut").setValue(24);
      println("heat OFF");
      output1.println();
        output1.printf("%02d:%02d:%02d   ", hour, min, sec);
        output1.print("heat_0");
      peltColor = color(0);
      write(0, 0, 3);
  }
}


void controlEvent(ControlEvent theEvent) {  
// motor2 reset
 if(theEvent.getController().getName()=="bang1") {
    println("MOTOR2 RESET");
    int value = Math.round(cp5.getController("motor2").getValue());
    diff = value - 100 + diff;
    cp5.getController("motor2").setValue(100);
    println(diff); 
  }
  
//stop heating  
if(theEvent.getController().getName()=="heating") {
  thermostat();
}



//Arducam vertical adjust
  if(theEvent.getController().getName()=="camVertical") {
    valVert = cp5.getController("camVertical").getValue();
    println("camera vertical adjust: ", valVert);
}

 
//ArduCam
  if(theEvent.getController().getName()=="cam1") {
    println("320x240");
    write(0, 1, 1);
  }
  if(theEvent.getController().getName()=="cam2") {
    println("640x480");
    write(0, 1, 2);
  }
  if(theEvent.getController().getName()=="cam3") {
    println("1024x768");
    write(0, 1, 3);
  }
  if(theEvent.getController().getName()=="cam4") {
    println("1280x960");
    write(0, 1, 4);
  }
  if(theEvent.getController().getName()=="cam5") {
    println("1600x1200");
    write(0, 1, 5);
  }
  if(theEvent.getController().getName()=="camS") {
    println("single");
    write(0, 0, 1);
  }
  if(theEvent.getController().getName()=="camC") {
    println("continuous");
    write(0, 0, 2);
  }

  if(theEvent.isController()) { 
//println
    //print("control event from : "+theEvent.getController().getName());
    //println(", value : "+theEvent.getController().getValue());

  // COM dropList    
    if (DropList1.isMouseOver()) {
      for (int i = 0; i < 2; i++) {
      portName = Serial.list()[int(theEvent.getController().getValue())]; //port name is set to the selected port in the dropDownMeny
      myPort.clear(); //delete the port
      myPort.stop(); //stop the port
      //println(portName);
      myPort = new Serial(this, portName, baud); //Create a new connection
      delay(100);
      //println(i);
      }
    millisInit = millis();
    println("millisInit: " + millisInit);
    
    println();
    println("XXXXXXXXXXXXXXX");
    println();   
    } 
  }
}


private static int HEADER_SIZE = 4;
private static final int MSG_TYPE_TEMPERATURE = 1;
private static final int MSG_TYPE_IMAGE = 2;
private static final int MSG_TYPE_MESSAGE = 3;

private static boolean headerRead = false;
private static byte[] header = new byte[HEADER_SIZE];
private static int messageType = 0;
private static int dataSize = 0;


void handleMessage(byte[] data) {
  switch (messageType) {
    case MSG_TYPE_TEMPERATURE:
    {
      // Temperature is in 2 bytes, respresenting centicelsius - 2851 = 28.51°C
      int tempCentiCelsius =  Byte.toUnsignedInt(data[0]) | (Byte.toUnsignedInt(data[1]) << 8);
      float temp = (float)tempCentiCelsius / 100f;
      println("Temperature: " + temp);
      Slider4.setValue(temp);
      Chart1.push("currentTemp", temp);
      output1.println();
        output1.printf("%02d:%02d:%02d   ", hour, min, sec);
        output1.print("Temperature: " + temp);    
      thermostat();
      break;
    }
    
    case MSG_TYPE_MESSAGE:
    {
      String message = new String(data);
      println(message);
      
      //generate log for motor1
      if (message.startsWith("Position after int")) {
        String[] parts = message.split(" "); // Split message into parts
        int output2_val = ((Integer.parseInt(parts[3]) - recentValue) * -1);
        println("output2_val: "+output2_val); 
        Knob1.setValue(output2_val);
        //output2.println();
        //  output2.printf("%02d:%02d:%02d ", hour, min, sec);
        //  output2.print("Motor1: " + output2_val);  
      }
      if (message.startsWith("Arduino: motor1")) {
        String[] parts = message.split(" "); // Split message into parts
        int output2_val = ((Integer.parseInt(parts[2]) - recentValue) * -1);
        output2.println();
          output2.printf("%02d:%02d:%02d ", hour, min, sec);
          output2.print("Motor1: " + output2_val);
      }         
    }   
    break;
    
    case MSG_TYPE_IMAGE:
    {
        try {
          //Save raw data to file
          //String fname = "capture_" + picNum + "_" + day() + month() + year() + ".jpg";
          String fname = "capture_" + picNum + "_" + String.format("%04d-%02d-%02d_%02d-%02d-%02d", year, month, day, hour, min, sec) + ".jpg";
          saveBytes("data/capture/"+fname, data);
          // Open saved picture for local display
          img = loadImage("/data/capture/"+fname);
          picNum++;
        }
        catch(RuntimeException e) {
          println(e.getMessage());
        }
        break;
    }    
  }
}


void serialEvent(Serial myPort) {
  try {
    // First, set up to receive a header
    if (!headerRead)
    {
      if (myPort.available() < HEADER_SIZE) {
        myPort.buffer(HEADER_SIZE);
        return;
      }
      // Read Header
      header = myPort.readBytes(HEADER_SIZE);
      headerRead = true;
// Log
//for (int i = 0; i < HEADER_SIZE; i++) {
//  print(Integer.toString(Byte.toUnsignedInt(header[i])) + ",");
//}
//println();
      messageType =  Byte.toUnsignedInt(header[1]) | (Byte.toUnsignedInt(header[0]) << 8);
      dataSize    =  Byte.toUnsignedInt(header[3]) | (Byte.toUnsignedInt(header[2]) << 8);
// Log
//println("Header received, type:" + messageType + " dataSize: " + dataSize);
// Set up the serial line to receive expected amount of bytes
      myPort.buffer(dataSize);
      return;
    }
    // Reading body
    else
    {
      // Check if data is available
      if (myPort.available() < dataSize) {
        throw new Exception("Not enough bytes to read data:" + myPort.available() + ", expected " + dataSize);
      }
      // Read data
      byte[] data = new byte[dataSize];
      data = myPort.readBytes(dataSize);
      
// Log 
//print("Message body received, bytes: ");
//for (int i = 0; i < dataSize; i++) { print(Integer.toString(Byte.toUnsignedInt(data[i])) + ","); }
//println();
      handleMessage(data);
    }
  }
  catch(Exception e) {
    println("Error while reading serial line: " + e.getMessage());
  }
  // Cleanup - expecting header again
  myPort.buffer(HEADER_SIZE);
  headerRead = false;
}


 void last() {
  String folderPath = dataPath(sketchPath()+"/logs/rotate"); // Replace with the path to your folder

  println();
  println("XXXXXXXXXXXXXXX");
  println();   
  
  // Get the most recent Motor1 value from the latest file
  recentValue = getMostRecentMotor1Value(folderPath);
  
  // Display the result
  if (recentValue != -1) {
    println("Most Recent Motor1 Value: " + recentValue);
    Knob1.setValue(recentValue);
    output2.printf("%02d:%02d:%02d ", hour, min, sec);
    output2.print("Motor1: " + recentValue);    
  } else {
    println("No Most Recent Motor1 Value found:" + recentValue);
  }
  
  println();
  println("XXXXXXXXXXXXXXX");
  println();
}


int getMostRecentMotor1Value(String folderPath) {
  // Get the folder and its files
  File folder = new File(folderPath);
  if (!folder.exists() || !folder.isDirectory()) {
    println("Error: Folder does not exist or is not a directory.");
    return -1; // Error case
  }
  
  // Get the .txt files in the folder
  File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".txt"));
  if (files == null || files.length == 0 || files.length == 1) {
    println("No previous .txt files found in the folder.");
    return -1; // No files
  }
  
  else {
  
  // Sort files by last modified time (most recent first)
  Arrays.sort(files, Comparator.comparingLong(File::lastModified).reversed());
  File latestFile = files[1];
  println("Most recent file: " + latestFile.getName());
  
  // Read the latest file and extract the most recent Motor1 value
  String[] lines = loadStrings(latestFile);
  if (lines == null || lines.length == 0) {
    println("Error: The file is empty.");
    return 0;
  }
  
  
  // Find the last Motor1 entry
  for (int i = lines.length - 1; i >= 0; i--) {
    String line = lines[i].trim();
    if (line.contains("Motor1")) {
      try {
        // Extract the value after "Motor1:"
        String valueStr = line.split("Motor1:")[1].trim();
        int value = Integer.parseInt(valueStr);
        return value; // Return the most recent valid value
      } catch (Exception e) {
        println("Error parsing line: " + line);
      }
    }
  }
  }
  
  // If no valid entry is found
  println("No valid Motor1 entry found in the file.");
  return -1;
  
}

// this will increase or decrease rotation angle by value in temp.txt
void examineTemp() {
  File rootFolder = new File(dataPath(sketchPath()+"/logs/temp"));
  
  // Ensure the folder exists
  if (!rootFolder.exists() || !rootFolder.isDirectory()) {
    //println("Root folder does not exist or is not a directory.");
    return;
  }

  // List files in the root folder
  File[] files = rootFolder.listFiles();
  if (files == null || files.length == 0) {
    //println("No files found in the root folder.");
    return;
  }

  // Process the first file in the folder
  for (File file : files) {
    if (file.isFile()) { // Skip directories
      String fileName = file.getName();
      //println("Found file: " + fileName);

      if(fileName.equals("temp.txt")) {
        println(fileName + " exists");
         //Read and print the file content
        try {
          String[] lines = loadStrings(file);

          if (match(lines[0], "^\\d+$") != null) {
            print(fileName + " value:");
            println(lines[0]);
            int val = Integer.parseInt(lines[0]) + Math.round(Knob1.getValue());            
            Knob1.setValue(val);
            val = val - recentValue;
            if( val >= 0) {write(val, 0, 7);}
            if( val < 0) {write(val, 0, 6);}
            
          } else {
            println("string");
          }

        } catch (Exception e) {
          println("Error reading file: " + e.getMessage());
        }

        // Rename the file
        String newFileName = "temp_" + String.format("%04d-%02d-%02d_%02d-%02d-%02d", year, month, day, hour, min, sec) + ".txt"; // Specify the new file name
        println(newFileName);
        file.renameTo(new File(file.getParent(), newFileName));
        break;
      }
    }
  }
}
