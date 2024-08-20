import processing.serial.*;
import controlP5.*; // import library for knob

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
int peltPower = 0;

 

//int baud = 650000;
int baud = 115200;
//int baud = 230400;
//int baud = 500000;


Knob Knob1;  
Slider Slider1, Slider2, Slider3, Slider4, Slider5, Slider6, Slider7;
Bang Bang1, Bang2, Bang3, Bang4, Bang5, Bang6, Bang7;
Textlabel Textlabel1, Textlabel2, Textlabel3;
Chart Chart1;
DropdownList DropList1;
Toggle Toggle1, Toggle2, Toggle3;


//output
int sec = second();  // Values from 0 - 59hheea
int min = minute();  // Values from 0 - 59
int hour = hour();    // Values from 0 - 23
int day = day();  
int month = month();
int year = year(); 
PrintWriter output;


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
output = createWriter("log/log_"+year+"-"+month+"-"+day+"_"+hour+"-"+min+"-"+sec+".txt");

// serial
  println(Serial.list());
  DropList1 = cp5.addDropdownList("myList-DropList1")
          .setPosition(width-125, 575)
          .setSize(100, 200)
          .setHeight(210)
          .setItemHeight(40)
          .setBarHeight(50)
          .setFont(font1)
          .setColorBackground(background2)
          .setColorActive(background5)
          ;
  DropList1.getCaptionLabel().set("PORT"); //set PORT before anything is selected
  portName = Serial.list()[port]; //0 as default   
  myPort = new Serial(this, portName, baud);      
  //myPort.bufferUntil('\n');


//led
  Slider1 = cp5.addSlider("led")
               .setRange(0,255)
               .setValue(0)
               .setPosition(25,100)
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
               .setPosition(150,440)
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
  labelSlider2.getStyle().setPaddingLeft(-400);


//motor2 reset
 Bang1 = cp5.addBang("bang1")
             .setPosition(150,510)
             .setSize(80,40)
             .setLabel("reset")
             .setColorBackground(background2)
             .setColorActive(background5)
             ; 
  Label labelBang1 = Bang1.getCaptionLabel();
  labelBang1.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelBang1.getStyle().setPaddingTop(0);
  labelBang1.getStyle().setPaddingLeft(-70);
  labelBang1.toUpperCase(false);


//temp output
  Slider3 = cp5.addSlider("tempOut")
               .setRange(24,32)
               .setValue(0)
               .setLabel("set temp [°C]")
               .setPosition(150,150)
               .setSize(400,35)
               .setNumberOfTickMarks(33)
               .setFont(font2)
               .setTriggerEvent(Slider.RELEASED)
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               .setColorBackground(background2)
               ;
  Label labelSlider3 = Slider3.getCaptionLabel();
  labelSlider3.toUpperCase(false);
  labelSlider3.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelSlider3.getStyle().setPaddingLeft(-300);
  
  Slider3.addCallback(new CallbackListener() {          
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_RELEASE): case(ControlP5.ACTION_RELEASE_OUTSIDE): case(ControlP5.ACTION_WHEEL):
          println("Slider3 pressed released");
          cp5.getController("heating").setValue(1);
          write(0, 0, 8); //get current temp
          thermostat();
        break;    
      }
    }
  }); 


//heating on/off
 Toggle1 = cp5.addToggle("heating")
             .setValue(false)
             .setPosition(150, 100)
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
               .setPosition(150, 190)
               .setSize(400,35)
               .setFont(font2)
               .setColorBackground(background2)
               ;
  Label labelSlider4 = Slider4.getCaptionLabel();
  labelSlider4.toUpperCase(false);
  labelSlider4.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelSlider4.getStyle().setPaddingLeft(-300);
  //Slider4.setMultiplier(300); // change Multiplier of the Numberbox ( default is 1 )               

    
//temp chart
  Chart1 = cp5.addChart("tempInChart")
               .setPosition(150, 230)
               .setSize(400, 140)
               .setRange(22, 34)
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
               .setPosition(width-530,30) // ditance from L/T
               .setRadius(250)  // for knob
               .setLabel("Rotation [°]")
               .setScrollSensitivity(0.1/27)
               .setDragDirection(Knob.HORIZONTAL)
               .setStartAngle(4.74)
               .setConstrained(false)
               .setViewStyle(2)
               .setDecimalPrecision(1)
               ;     
  Label labelKnob1 = Knob1.getCaptionLabel();
  labelKnob1.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelKnob1.getStyle().setPaddingTop(-35);
  labelKnob1.getStyle().setPaddingLeft(-310);
  
  Knob1.addCallback(new CallbackListener() {          
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_RELEASE): case(ControlP5.ACTION_RELEASE_OUTSIDE): case(ControlP5.ACTION_WHEEL):
          println("Knob1 pressed released");
          println(cp5.getController("motor1").getValue());
          int val = Math.round(Knob1.getValue());          
          if(val > 0) {
            write(val, 0, 7);
          } 
          else if(val<0) {
            write(val, 0, 6);
          } 
        break;    
      }
    }
  });
  

//Interval
  Toggle3 = cp5.addToggle("interval")
             .setValue(false)
             .setPosition(595, 440)
             .setSize(110,35)
             .setLabel("Interval:")
             .setFont(font2)
             .setColorBackground(background2)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             ; 
  Label labelToggle3 = Toggle3.getCaptionLabel();
  labelToggle3.toUpperCase(false);
  labelToggle3.align(ControlP5.RIGHT_OUTSIDE, CENTER);
  labelToggle3.getStyle().setPaddingTop(-4);
  labelToggle3.getStyle().setPaddingLeft(-98);


//Int1
  Slider6 = cp5.addSlider("int1")
               .setRange(-180,180)
               .setValue(0)
               .setLabel("")
               .setPosition(595,485)
               .setSize(160,30)
               .setFont(font2)
               .setTriggerEvent(Slider.RELEASED)
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               .setColorBackground(background2)
               .setDecimalPrecision(1)
               .setScrollSensitivity(0.025)
               ;
  Label labelSlider6 = Slider6.getCaptionLabel();
  labelSlider6.toUpperCase(false);
  labelSlider6.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelSlider6.getStyle().setPaddingLeft(-50); 
  //Int2
  Slider7 = cp5.addSlider("int2")
               .setRange(-180,180)
               .setValue(0)
               .setLabel("")
               .setPosition(595,525)
               .setSize(160,30)
               .setFont(font2)
               .setTriggerEvent(Slider.RELEASED)
               .setColorValue(0xffaaaaaa)
               .setColorLabel(0xffffffff)
               .setColorBackground(background2)
               .setDecimalPrecision(1)
               .setScrollSensitivity(0.025)
               ;
  Label labelSlider7 = Slider7.getCaptionLabel();
  labelSlider7.toUpperCase(false);
  labelSlider7.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelSlider7.getStyle().setPaddingLeft(-50);
              
          
//text
  Textlabel1 = cp5.addTextlabel("label1")
                .setText("iCat")
                .setPosition(10,10)
                .setColorValue(0xffffffff)
                .setFont(new ControlFont(f1, 60))
                ;
  Textlabel2 = cp5.addTextlabel("label2")
                .setText("LED intensity:")
                .setPosition(20,height-52)
                .setColorValue(128)
                .setFont(new ControlFont(f1, 40))
                ;
  Textlabel3 = cp5.addTextlabel("label3")
                .setText("HEAT intensity:")
                .setPosition(width/2+40,height-52)
                .setColorValue(128)
                .setFont(new ControlFont(f1, 40))
                ;


//ArduCam
  int camH = 580;
  Bang2 = cp5.addBang("cam1")
             .setPosition(155, camH)
             .setSize(50,50)
             .setLabel("1")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang2 = Bang2.getCaptionLabel();
  labelBang2.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang2.getStyle().setPaddingTop(5);
  labelBang2.getStyle().setPaddingLeft(-30);
  
  Bang3 = cp5.addBang("cam2")
             .setPosition(210, camH)
             .setSize(50,50)
             .setLabel("2")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang3 = Bang3.getCaptionLabel();
  labelBang3.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang3.getStyle().setPaddingTop(5);
  labelBang3.getStyle().setPaddingLeft(-30);
  
  Bang4 = cp5.addBang("cam3")
             .setPosition(265, camH)
             .setSize(50,50)
             .setLabel("3")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang4 = Bang4.getCaptionLabel();
  labelBang4.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang4.getStyle().setPaddingTop(5);
  labelBang4.getStyle().setPaddingLeft(-30);
  
  Bang5 = cp5.addBang("cam4")
             .setPosition(320, camH)
             .setSize(50,50)
             .setLabel("4")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang5 = Bang5.getCaptionLabel();
  labelBang5.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang5.getStyle().setPaddingTop(5);
  labelBang5.getStyle().setPaddingLeft(-30);  

  Bang6 = cp5.addBang("cam5")
             .setPosition(375, camH)
             .setSize(50,50)
             .setLabel("5")
             .setFont(font1)
             .setColorValue(0xffaaaaaa)
             .setColorLabel(0xffffffff)
             .setColorForeground(background2)
             ; 
  Label labelBang6 = Bang6.getCaptionLabel();
  labelBang6.align(ControlP5.RIGHT_OUTSIDE, RIGHT);
  labelBang6.getStyle().setPaddingTop(5);
  labelBang6.getStyle().setPaddingLeft(-30);  
  
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
  labelBang7.getStyle().setPaddingTop(5);
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
  labelToggle2.getStyle().setPaddingTop(5);
  labelToggle2.getStyle().setPaddingLeft(-30);
  labelToggle2.toUpperCase(false);
  
  // cam vertical
  Slider5 = cp5.addSlider("camVertical")
               .setLabel("V crop:")
               .setRange(0,100)
               .setValue(0)
               .setPosition(width-125, 725)
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
  labelSlider5.getStyle().setPaddingLeft(-70);
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
    translate(900,  300);
    rotate(radians(180)); // rotate 180 degrees, alll upcoming values need to be in neg numbers
      //image(img, -150, -250, 900, 600);
      //image(img.get(0,img.height/2,img.width,img.height/2), -150, -575, 900, 300);    //img.get(crop from left, top, width, height), padding left, top, width, height
      image(img.get(0,Math.round(valVert)*img.height/200,img.width,img.height/2), -150, -575, 900, 300);    //img.get(crop from left, top, width, height), padding left, top, width, height
      //image(img.get(0,0,img.width,img.height/2), -150, -600, 900, 300);    //img.get(crop from left, top, width, height), padding left, top, width, height
  popMatrix(); // restore previous graphics matrix



  if(DropList1.isMouseOver()) {
    DropList1.clear(); //Delete all the items
    for (int i=0;i<Serial.list().length;i++) {
      DropList1.addItem(Serial.list()[i], i); //add the items in the list
    }
  }
  if ( myPort.available() > 0) {
    //println(myPort.readStringUntil('\n')); //read until new input
  } 


  output.flush();
} 


void write (int val, int append1, int append2) {
  println("theValue is: "+val); 
  output.println();
    output.printf("%02d:%02d:%02d   ", hour, min, sec);
    output.print("theValue is: "+val);
        String s0 = Integer.toString(val);
        String s1 = Integer.toString(append1);
        String s2 = Integer.toString(append2);
        String s = s0 + s1 + s2;
        int c = Integer.parseInt(s);
  println("sent: "+c);       
  output.println();
    output.printf("%02d:%02d:%02d   ", hour, min, sec);
    output.print("sent: "+c);
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
  if( val <0) {write(val, 2, 6);}
  if( val >=0) {write(val, 2, 7);}
} 

void int2(int val) {
  if( val <0) {write(val, 2, 8);}
  if( val >=0) {write(val, 2, 9);}
} 


void motor2(int val) {
  if( val >100 - diff) {write(val - 100 + diff, 0, 4);}
  if( val <100 - diff) {write(val - 100 + diff, 0, 5);}
  if( val == 100 - diff) {write(val - 100 + diff, 0, 4);}
} 


//heating
void thermostat() {
  if(cp5.getController("heating").getValue() == 1) {
    float valueOut = cp5.getController("tempOut").getValue();
    println("valueOut: " + valueOut);
    output.println();
      output.printf("%02d:%02d:%02d   ", hour, min, sec);
      output.print("valueOut: " + valueOut);
    float valueIn = cp5.getController("tempIn").getValue();
    println("valueIn: " + valueIn);
    output.println();
      output.printf("%02d:%02d:%02d   ", hour, min, sec);
      output.print("valueIn: " + valueIn);
    float valueDiff = valueOut-valueIn;
    println("valueDiff: " + valueDiff);
    output.println();    
      output.printf("%02d:%02d:%02d   ", hour, min, sec);
      output.print("valueDiff: " + valueDiff);
    
    if(valueDiff <0 ) {
      peltPower = 5;
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        println("heating OFF");
      peltColor = color(background4);
      write(peltPower, 0, 3);
    }
    if(valueDiff >=0 && valueDiff <0.2 ) {
      peltPower = 5;
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heat ON!" + peltPower);
      peltColor = color(60);
      write(peltPower, 0, 3);
    }
    if(valueDiff >=0.2 && valueDiff <0.5 ) {
      peltPower = 10;
      println("heat ON! 10");
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heat ON!" + peltPower);
      peltColor = color(60);
      write(peltPower, 0, 3);
    }
    if(valueDiff >=0.5 && valueDiff <2 ) {
      peltPower = 15;      
      println("heat ON! 15");
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heat ON!" + peltPower);
      peltColor = color(120);
      write(peltPower, 0, 3);
    }
    if(valueDiff >=2 && valueDiff <4 ) {
      peltPower = 20;      
      println("heat ON! 20");
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heat ON!" + peltPower);
      peltColor = color(180);
      write(peltPower, 0, 3);
    }
    if(valueDiff >=4 ) {
      peltPower = 30;
      println("heat ON! 30");
      output.println();      
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heat ON!" + peltPower);
      peltColor = color(240);
      write(peltPower, 0, 3);
    }
  }
  if(cp5.getController("heating").getValue() == 0) {
    cp5.getController("tempOut").setValue(24);
          println("heating OFF");
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heating OFF");
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
  
//heating  
if(theEvent.getController().getName()=="heating") {
  if(cp5.getController("heating").getValue() == 0) {
      println("heating OFF");
      output.println();
        output.printf("%02d:%02d:%02d   ", hour, min, sec);
        output.print("heating OFF");
      peltColor = color(0);
      write(0, 0, 3);
      cp5.getController("tempOut").setValue(24);
  }
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
      portName = Serial.list()[int(theEvent.getController().getValue())]; //port name is set to the selected port in the dropDownMeny
      myPort.clear(); //delete the port
      myPort.stop(); //stop the port      
      myPort = new Serial(this, portName, baud); //Create a new connection
      println("Serial index set to: " + theEvent.getController().getValue());
      millisInit = millis();
      println("millisInit: " + millisInit);
      delay(500); 
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
      thermostat();
      break;
    }
    
    case MSG_TYPE_MESSAGE:
    {
      String message = new String(data);
      println(message);
      break;
    }
    
    case MSG_TYPE_IMAGE:
    {
        try {
          //Save raw data to file
          String fname = "capture#"+picNum+"_"+day()+month()+year()+".jpg";
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
      for (int i = 0; i < HEADER_SIZE; i++) {
        print(Integer.toString(Byte.toUnsignedInt(header[i])) + ",");
      }
      println();
      messageType =  Byte.toUnsignedInt(header[1]) | (Byte.toUnsignedInt(header[0]) << 8);
      dataSize    =  Byte.toUnsignedInt(header[3]) | (Byte.toUnsignedInt(header[2]) << 8);
      println("Header received, type:" + messageType + " dataSize: " + dataSize);
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
      print("Message body received, bytes: ");
      for (int i = 0; i < dataSize; i++) {
        print(Integer.toString(Byte.toUnsignedInt(data[i])) + ",");
      }
      println();
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
