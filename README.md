# iCat: A Multifunctional Open-Source Accessory for Advanced Light Microscopy
"i" - Innovative: iCat represents an innovative approach to light microscopy, incorporating advanced features like controlled axial rotation and tracking. It introduces a novel solution for imaging and studying biological specimens with enhanced capabilities, pushing the boundaries of traditional microscopy techniques. <br>
"C" - Controlled: iCat offers precise control over specimen rotation, temperature regulation, and lighting conditions, ensuring optimal imaging conditions and experimental reproducibility. <br>
"a" - Axial: iCat's unique capability to rotate specimens along their axial axis sets it apart from conventional light microscopy techniques, allowing researchers to observe dynamic processes and capture detailed time-lapse sequences. <br>
"t" - Tilt: iCat offers the unique capability of "Controlled Axial Tilt" providing researchers with a 360-degree perspective. This groundbreaking feature empowers researchers to examine specimens in three dimensions, facilitating the exploration of dynamic cellular processes, developmental biology, and beyond. <br>
![iCat rendered-front](https://github.com/osvobo/iCat/blob/main/support/media/promo/iCat_v2a_2024-Feb-22_02-36-14PM-000_CustomizedView18085180867.png)
<br><br>


# Abstract
In the field of light microscopy, imaging specimens from multiple angles and maintaining controlled temperature conditions are crucial for comprehensive and accurate analysis. To address these challenges, we present iCat, an open-source multifunctional accessory designed to revolutionize light microscopy capabilities. iCat enables the rotation of specimens along their axial axis, incorporates an in-built thermometer and Peltier element for precise temperature control, features an integrated LED light source, and is equipped with a camera. This versatile device, controlled by an Arduino-based electronic circuit and a Processing based graphical user interface (GUI), allows researchers to capture detailed images and videos of both fixed and live specimens, such as C. Elegans, Zebrafish, Drosophila, mouse embryos etc. The iCat accessory, which can be easily 3D printed and assembled using readily available electrical components, serves as a powerful tool for investigating dynamic cellular processes and complex developmental phenomena. <br><br>

# Introduction
Light microscopy has been an invaluable tool in biological research, enabling the visualization and analysis of various biological specimens with exceptional detail. However, traditional light microscopy techniques have limitations when it comes to imaging specimens from different angles and maintaining precise temperature conditions. These limitations hinder our ability to explore dynamic cellular processes, investigate complex morphological changes, and observe real-time developmental events accurately. ZMINIT RESENI DOTED (LIGHSHEET, VAST, ….) <br>
To address these limitations and advance the capabilities of light microscopy, we introduce iCat, a novel multifunctional accessory that combines several essential features into a single, open-source device. iCat allows researchers to rotate specimens along their axial axis, regulate the temperature within a desired range, provide ample illumination through an integrated LED light source, and capture images using its built-in camera to better navigate through the specimen. This integrated approach overcomes the challenges associated with traditional light microscopy, offering researchers a versatile tool to explore the intricacies of biological systems.  <br>
![iCat-detail](support/media/pics/iCat-30.jpg)
<br><br>

# Design and Functionality
## Rotational Capabilities
The ability to capture images and videos of a specimen from multiple angles is essential for comprehensive analysis. iCat incorporates a motorized rotation mechanism that enables controlled and precise specimen rotation along its axial axis. Researchers can program the desired rotation parameters through the device's graphical user interface (GUI) and monitor the rotation progress in real-time. The iCat accessory provides unprecedented flexibility in imaging and studying dynamic processes that require specimen repositioning during time-lapse experiments, such as cell migration or morphogenesis. <br>
## Temperature Control
Maintaining a stable and controlled temperature environment is crucial for studying living specimens. iCat addresses this requirement through an in-built thermometer and a Peltier element. The thermometer constantly monitors the specimen's temperature, while the Peltier element actively regulates the temperature within a specified range. This temperature control feature ensures optimal imaging conditions and facilitates accurate analysis of temperature-sensitive biological processes, including embryonic development. <br>
## Illumination and Camera System
An appropriate and adjustable uniform light source is critical for obtaining images using the internal camera. The intensity of the LED can be adjusted via the GUI and minimizes the need for further external light sources during specimen rotation using the built-in camera. The GUI can control the image resolution, providing researchers with flexibility in controlling camera speed. <br><br>

# Fabrication and Accessibility
One of the key advantages of iCat is its open-source nature, which promotes accessibility, customization, and collaborative development. The device can be fabricated using 3D printing technology, ensuring low-cost production and ease of assembly. Additionally, all the electrical components required for iCat can be readily obtained for less than $300, making it feasible for researchers with varying resources and expertise levels to replicate and utilize the device in their laboratories. The control circuit, based on the Arduino platform, is well-documented and can be modified to accommodate specific experimental requirements. <br>
![alt text](support/media/pics/iCat-1.jpg)
<br>

# Applications and Impact
The multifunctional capabilities of iCat open up new avenues for biological research, particularly in the fields of developmental biology, neurobiology, and cellular imaging. By enabling precise specimen rotation, temperature control, illumination, and imaging, iCat empowers researchers to investigate dynamic processes, observe intricate morphological changes, and capture real-time developmental events. The device has proven particularly effective in the study of model organisms such as C. elegans, Zebrafish, where cell migration, organogenesis, and tissue development necessitate the ability to reposition specimens during time-lapse experiments. <br>
Furthermore, the open-source nature of iCat fosters collaboration and encourages the scientific community to contribute to its development and enhancement. By sharing the design, software, and documentation, we aim to accelerate scientific progress and provide a versatile tool that can be adapted and customized for specific research needs. <br><br>

# Conclusion
iCat represents a significant advancement in light microscopy, addressing the limitations of traditional techniques by offering a multifunctional accessory that combines rotation, temperature control, illumination, and imaging capabilities. The open-source nature of iCat ensures its accessibility, affordability, and adaptability, making it an invaluable tool for researchers in the biological sciences. By providing a platform to investigate dynamic processes and complex developmental phenomena, iCat contributes to our understanding of fundamental biological mechanisms and facilitates discoveries in various fields of study. <br><br>

# Methods
## Supplies
One of the key advantages of iCat is its open-source nature, which promotes accessibility, customization, and collaborative development. The device can be fabricated using 3D printing technology, ensuring low-cost production and easy assembly. All the electrical and mechanical components required for iCat can be readily obtained for less than $300, making it feasible for researchers with varying resources and expertise levels to replicate and utilize the device in their laboratories. For an overview of the required components, see the illustrative image and list below.
![alt text](support/media/pics/iCat-2.jpg)
<br><br>

### Electronics:
Arduino Uno Rev3, 1x <br>
Arducam 5MP Plus OV5642, 1x <br>
IRF520 Driver Module, 1x <br>
CNC Shield V3, 1x <br>
DRV8825 Stepper Motor Driver, 2x <br>
17HS2408 Stepper Motor, 2x <br>
Peltier plate module TEC1-12706, 1x <br>
NTC Thermistor 10K 1% 3950, 1x <br>
4.7 kOhm resistor, 1x <br>
10 kOhm resistor, 1x <br>
10K Ohm potentiometer, 1x <br>
3W High Power LED Module LED with PCB Chassis for Arduino, 1x <br>
12V 3A Power Supply, 1x <br>

### Accessories:
GT2 Pulley 16 Teeth 5mm bore 6 mm width, 1x <br>
GT2 Idler 20 Teeth 5mm bore 3 mm width without teeth, 1x <br>
GT2 Open Timing Belt 2mm Pitch 6mm Width, 1x <br>
MGN9H 100mm linear guide rail with carriage, 1x <br>
Stainless Steel DIN912 Hexagon Hex Socket Head Cap Allen Bolt Screw, M3x4 (22x), M3x5 (4x), M3x6 (8x), M3x14 (1x) <br>
M3 hex nut, 20x <br>
Microscope Cover Glass, 24x40mm, 10x <br>
Lubricant in the syringe, 1x <br>
Sleeving Cord Protector, 6-12 mm, 1x <br>
Neodymium Magnet 5mm x 2mm, 8x <br>
FEP tube clear 0.8 I.D./1.2 O.D., 10-25 m <br>
FEP tube clear - other sizes, 5 m <br>
Silicon rubber tube 1x2 mm, 3 m <br>

### Wiring:
Female Plug 12V DC Power Pigtail Cable Jack, 2x <br>
Female and Male DC Connectors 2.1x5.5mm, 1x <br>
Crimp Terminals Set Kit, 1x <br>
Dupont Line M-M + F-M + F-F Jumper Wire 10cm, 20CM, 30x <br>
WAGO Terminals Series Splicing Connector 221-413, 2x <br>
Mini Solderless Prototype Breadboard, 3x <br>
Black Jumper Caps, 2x <br>

### 3D print:
3D printer, 1x <br>
3D Printer Filament 1.75mm - transparent, black, 2x <br>

### Tools:
Pipette Pump 10ml, 1x <br>
Borosilicate Glass Pasteur Pipettes, 1x <br>
Crimping Tools SN-58B + 4 jaws, 1x <br>
Screwdriver Set, 1x <br>
*NOTE: The complete shopping list is in the [components sheet](support/support.xlsx).* <br>

## Instructions
### Part 1: 3D printing
All 3D-printed parts can be printed using PETG or PLA filaments. To print the chamber, it is recommended to use a transparent material for the first three layers in order to be able to use the transmitted light of a microscope. For the remaining parts, black filament should be used to reduce light reflections. The individual STL and 3MF files and the complete Fusion360 project are in the [3D folder](support/3d). <br>

### Part 2: iCat assembly
To assemble iCat from individual parts, follow the instructions below.
1. Insert all M3 nuts and four neodymium magnets into both 'base' parts. <br>
![alt text](support/media/pics/iCat-3.jpg)
2. Slide the linear guide into the 'base-1', put both 'base' parts together, and secure the connection between them with two M3x6 screws. Attach the 'mounting plate' using two M3x6 screws and secure the linear guide with four M3x5 screws. <br>
![alt text](support/media/pics/iCat-4.jpg)
![alt text](support/media/pics/iCat-6.jpg) <br><br>
3. Fix the 'motor plates' to NEMA motors using eighth M3x4 screws according to the image below. Attach GT2 Pulley to one of the NEMA motor. The pin connections of this NEMA motor need to be oriented vertically. <br>
![alt text](support/media/pics/iCat-5a.jpg) <br><br>

4. Secure the 'motor plates' on the 'base' using M3x4 screws. <br>
![alt text](support/media/pics/iCat-7.jpg) <br><br>
5. Insert three M3 nuts into the 'cargo plate-2' and attach the GT2 Idler to it using a M3x14 screw. Cut 33.5 cm of GT2 Timing Belt and pass it through the idler. Fasten the ends of the belt inside the 'cargo' according to the image below. <br>
![alt text](support/media/pics/iCat-8.jpg) <br><br>
6. Secure the 'cargo' to the Linear Guide Carriage using two M3x4 screws and place the belt on the GT2 Pulley that was previously attached to one of the NEMA motors. Attach the 'cargo plate-2' to the 'cargo plate-1' using prepared screws. Do not overtighten these screws, otherwise the 'base' will bend. <br>
![alt text](support/media/pics/iCat-9.jpg) <br><br>
7. Insert the M3x6 screws into the mounting holes of the Arduino Uno and plug the CNC shield onto the Arduino, ensuring that the pins are properly aligned with the corresponding headers. To adjust micro-stepping (1/16 step), set up the M2 pin of the CNC Shield HIGH by connecting the black jumper caps, as shown in the image below. Attach the DRV8825 Stepper Motor Drivers to the CNC Shield and connect the power supply wires to both the shield and the WAGO terminals. <br>
![alt text](support/media/pics/iCat-10a.jpg)
*NOTE: Before proceeding any further, the voltage reference (V<sub>REF</sub>) that corresponds to the maximum current that will flow to the stepper motors needs to be set. The maximum current of used steeper motors is 1.8 A. To calculate the Vref, use this equation:* <br>
**V<sub>REF</sub> = I<sub>max</sub>/2** <br>
**V<sub>REF</sub> = 1.8/2 = 0.9 V** <br>
*In order to set up the Vref, plug in the Arduino UNO with CNC Shield and the DRV8825 Stepper Motor Drivers to the USB port, connect the negative probe of the multimeter to the GND, connect the positive probe of the multimeter to the screwdriver tip, set the multimeter to DC Voltage measurement, and use the screwdriver to turn the potentiometer until you get the calculated voltage.* <br><br>
8. Similarly to the previous step, interconnect the WAGO terminals with the IRF520 Driver Module using additional power wires. Next, connect the wire end of the first Pigtail Cable Jack to the WAGO terminals. The wire end of the other Pigtail Cable Jack needs to be connected to the IRF520 Driver Module. If needed, crimp the ends of any wires. <br>
![alt text](support/media/pics/iCat-11.jpg) <br><br>
9. Attach the Ardunio UNO coupled with the CNC Shield and all the wirings to the 'base' using previously inserted screws. <br>
![alt text](support/media/pics/iCat-12.jpg) <br><br>
10. Install wiring components on three mini breadboards according to the image below. First, plug 10 kOhm resistor into the 'Thermistor' breadboard. Shorten the resistor leads, if necessary. Plug 10 kOhm thermistor, while one of its leads connects it with the resistor. Connect the Male-Female Dupont wire to it. This will be connected to the analog input ('Abort' pin) on the CNC shield later on. The other Dupont wires need to be connected to the other thermistor lead (ground) and to the second resistor lead (5 V). Second, prepare the 'Trigger IN' breadboard by plugging a 4.7 kOhm resistor into it and connecting its terminals to the Male DC connector. Dupont wires will be connected to both of these resistor leads later on (step 14) to the ground and to the analog input ('Hold' pin) on the CNC Shield. Third, plug 10 kOhm potentiometer into the last breadboard. Two Dupont wires will be connected to the side and the middle terminals later on, connecting it to PWM digital input ('Step Y' pin of the CNC shield) and to the IRF520 Driver Module signal input. If needed, crimp the ends of any wires. <br>
![alt text](support/media/pics/iCat-13a.jpg) <br><br>
11. Install the 'Potentiometer' breadboard and DC Female pigtail in to the 'base' and cover it with the 'base adapter'. <br>
![alt text](support/media/pics/iCat-14.jpg) <br><br>
12. Install the 'Trigger IN' breadboard and fit Male DC connector in the 'base adapter'. <br>
![alt text](support/media/pics/iCat-15.jpg) <br><br>
13. Install the IRF520 Driver Module and plug its Dupont wires (ground, 5 V). Plug the signal input as described in step 10. Fit Male DC connector connected to IRF520 Module in the upper right corner of the 'base'. Secure the potentiometer by its nut and attach the 'knob' to it. <br>
![alt text](support/media/pics/iCat-16.jpg) <br><br>
14. Install the 'Thermistor' breadboard in the 'base'. Connect Dupont wires of all the breadboards as described in step 10. Connect LED to 5 V, ground, and digital output ('Dir Y' pin) on the CNC Shield. Plug eight Dupont wires to the Arducam and connect them to the CNC Shield according to the [pinout sheet](support/support.xlsx) and the wiring diagram. Test the functionality of the device at this point before attaching the 'lid'. <br>
![alt text](support/media/pics/iCat-17.jpg)
![alt text](support/media/pics/iCat-18a.jpg)
*NOTE: It is possible to use 5 V and GND pins of unoccupied driver bays on the CNC Shield to connect the IRF520 Driver Module and the thermistor.* <br><br>
15. Attach the 'lid' to the 'base' and attach Arducam to the 'cargo' using two M3x4 screws. Install a Sleeving Cord Protector to cover the wiring of the camera. <br>
![alt text](support/media/pics/iCat-19.jpg)
![alt text](support/media/pics/iCat-20a.jpg) <br><br>
16. Use 'mounting screws' to connect the iCat's 'mounting plate' to the stage of the microscope. <br><br>
>*NOTE: If needed, check the [pinout sheet](support/support.xlsx) and the wiring diagram.*
![alt text](support/fritzing/iCat_v2.png) <br><br>

### Part 3: Chamber assembly
To install the 'cover' on the sample 'chamber', follow these steps: <br>
1. Apply grease around the perimeter of the 'chamber' window.
![alt text](support/media/pics/iCat-36.jpg) <br><br>
2. Gently place the Microscope Cover Glass onto the applied grease. Ensure that the grease spreads evenly under the coverslip and that it is centered.
![alt text](support/media/pics/iCat-37.jpg) <br><br>
3. Secure the attached cover glass with eight M3x4 screws, and tighten the screws gently.
![alt text](support/media/pics/iCat-38.jpg)
*NOTE: After the initial assembly, test the chamber by filling it with water and letting it stand overnight. There should be no leaks.* <br><br>
4. Slide the Peltier element to the back of the chamber. Place the chamber on the 'base', and connect it to the female DC connector on the side. All iCat connectors are depicted below.
![alt text](support/media/pics/iCat-21.jpg)
![alt text](support/media/pics/iCat-20a.jpg) <br><br>


### Part 4: Installation
1. Download the entire repository, or simply download the [Arduino sketch folder](main/), the [```main.pde```](main.pde) Processing sketch, and install the [Processing application]( https://processing.org/download). Alternatively, you can download the [Processing sketch folder](processing/) and run [```iCat.exe```](processing/iCat.exe) file directly, without needing to install Processing. <br>
*NOTE: If you run the [```iCat.exe```](processing/iCat.exe) file directly, you will need to install OpenJDK17, as the [Processing sketch folder](processing/) does not contain Java.* <br>
2. Install the [Arduino IDE](https://www.arduino.cc/en/software). <br>
3. Open the Arduino IDE by opening the [```main.ino```](main/main.ino) file. Next, go to the Library Manager and install the [AccelStepper]( https://www.airspayce.com/mikem/arduino/AccelStepper/) and [ArduCAM]( https://github.com/dennis-ard/ArduCAM) libraries. Once both libraries are installed, press the 'Verify' button to ensure the installation is successful. <br>
4. Check the path of ```memorysaver.h``` file by hovering the mouse over its name at row 5 in the line ```#include "memorysaver.h"```. Then navigate to its folder and replace it with the [```memorysaver.h```](main/memorysaver.h) file provided, which has the camera definition uncommented: <br>
```#define OV5642_MINI_5MP_PLUS``` <br>
5. Test the iCat by connecting the Arduino to the PC using USB-B cable, connecting the 12 V main power, the trigger IN, and the Peltier connector. Open the [```main.pde```](main.pde) and click on the arrow in the upper left corner, this will open the Graphical User Interface (GUI) of the iCat. <br>
6. Select the port to which is the iCat connected. After successful connection, the message will appear in the console: *"iCat is ready"*. <br>
![alt text](support/media/pics/processing.jpg) <br><br>

### Part 5: Usage
These instructions can be used to mount and image zebrafish embryos between 0 – 4 dpf using iCat and Zeiss AxioExaminer microscope equipped with LSM900 confocal scan head. Other specimens can be used, to image larger samples, use larger FEP tube. In such a case, the chamber needs to be modified. Using the iCat in combination with other upright microscopes should be possible, however this has not been tested. <br>
1. Cut 9 cm of FEP tube. <br>
2. Insert FEP tube inside the 'FEP adapter'. Attach 1 cm of the silicone rubber tube to the end of FEP tube.
3. Cover dechorionated embryos with 0.8 % low melting imaging grade agarose with 0.5x Tricaine mesylate on a 3 cm cell culture dish. <br>
3. Attach a borosilicate glass Pasteur pipette to pipette pump and aspirate one zebrafish embryo into the pipette. <br>
4. Insert the tip of the pipette into the silicone rubber tube and gently transfer the embryo to the center of the FEP tube. Allow the agarose in the FEP tube to solidify.
![alt text](support/media/pics/iCat-41.jpg)
![alt text](support/media/pics/iCat-40.jpg)
5. Gently insert the FEP tube into the chamber. Using a syringe, apply grease inside the openings at the top of the chamber. The grease will fill the gaps and seal the FEP tube in place. <br>
![alt text](support/media/pics/iCat-39.jpg)
3. Tight the 'FEP adapter' screw to fix it to the axial motor. Fill the chamber with water. Launch iCat and set-up desired temperature. <br>
![alt text](support/media/pics/iCat-23.jpg)
<br>

### Start imaging!
![alt text](support/media/pics/iCat-24.jpg)
<br>
