//
// Enclosure for C12880MA GroupGets breakout board mounted on a Arduino.
// Tested with Arduino Duemilanova board.
//
// Allows for attachments to spectrometer via 4 screwholes next to 
// spectrometer can. 
// 
// Holes are designed to allow M2 screw threaded inserts (recommended), or adjust
// variable 'SD' for direct use of machine screws.
//
// Joe Desbonnet 2024-02-25.
//

// For printing, enable one at time. Vertical components may need to
// rotated in the slicer for reliable printing.

// TODO changes
// X-axis separation of spectrometer attachment screw holes too narrow. Not enough space
// between screw head and spectrometer can for a decent think light-tight cavity wall.
//
// M3 threaded inserts need hole diameter 5mm (4mm was very messy). Getting inserts 
// propertly aligned isn't easy. Wondering maybe a embedded nut will work better?




include <arduino.scad>




//showMainBox = true;
//showLid = false;
//showUsbWall = false;
showSpectrometerAttachment = true;
//showArduino = true;

$fn = 60;

// Dimensions of main enclosure box (mm). This is determined by the foot print of
// the Arduino board and the height of the spectrometer breakout board which is
// inserted into the Arduino pin header socket.
X=70;
Y=54;
Z=38+8;

// Thickness of wall - set to length of threaded insert
T=3.5;

// Extra bit because spectrometer protrudes out from side
S = 4;


// Threaded M2 inserts: diameter 3.5mm (length seems more like 4mm!)
SD = 2; // Screw diameter mm
SL = 3.5; // Screw length (not including head height)

// M2 TID=3.5, TIL=4mm
// M3 TID=4.0, TIL=6mm
TID = 4.5; // Threaded insert diameter
TIL = 6.0;   // Threaded insert length

SHD = 4; // Screw head diameter
SHH = 3; // Screw head height

// Offset of screw center from corners
R = 3.5;
//R = 5;
R = TID;

// X axis distance (mm) from left wall inner surface to the center of the spectrometer window
SPX = 50.0;
SPY = 20.0;
SPW = 12.0; // Spectrometer can width (mm)
SPH = 19.0; // Spectrometer can height (mm)

if (showMainBox) {
    main_enclosure_box();
    // Grip layer to ensure that no detachment takes place
    color([0.5,0.5,0.5,0.1]) translate([-5,-5-S,0]) cube([T+X+T+10,T+S+Y+T+10,0.2]);
} 

if (showLid) {
    color([0.5,0.5,0.5,0.6]) lid();
    color([0.5,0.5,0.5,0.005])translate([-5,-5-S,Z+T]) cube([T+X+T+10,T+S+Y+T+10,0.2]);
}

if (showUsbWall) {
    usb_wall();
}

if (showSpectrometerAttachment) {
    //color([1,0,0]) translate([T+SPX,-T,SPY+SPH/2]) rotate ([90,0,0]) spectrometer_attachment();
    color([1,0,0]) spectrometer_attachment();


}

if (showArduino) {
    dueDimensions = boardDimensions( DUE );
    translate([T, Y+S, T]) rotate([0,0,-90]) arduino(UNO);
}

module mainblock() {
    difference() {

        // Main stock
        union(){
            //cube ([X+T*2,Y+T*2,Z]);
            translate([0,-S,0]) cube ([X+T*2, Y + T*2 + S, Z]);
            //translate([0,-4,0]) cube ([X+T*2,4,Z]);
        }
    
    
    
        // Mill out main cavity to base so that PCB is snug
        translate ([T,T,T/2]) cube ([X, Y, Z+T*3]);

        // Mill out the main box
        translate ([T, T-S, T]) cube ([X, Y+S, Z+T*3]);


        // Hole/slot for USB type B
        translate ([-1,T+30,T/2]) cube ([10,20,Z+3*T]);

        // DC barrel jack
        translate ([-1,T+3,T/2]) cube ([12,10,Z+3*T]);
        
        // ... actually get rid of all that wall
        translate ([-1,T,T/2]) cube ([10,40,Z+3*T]);


    
        // Hole for spectrometer can
        translate([T+SPX-SPW/2,-5,SPY]) cube ([SPW,SPH,30]);
        

    }
}



module main_enclosure_box() {
    
    // For screw holes use either threaded insert or size hole
    // to grip the screw thread directly.    
    sd = TID == undef ? SD :  TID;
    hole_depth =  TIL == undef ? SL : TIL;
    
    difference () {

        union() {
            mainblock();
        

        
        
            // Posts to facilitate screw diamater > wall thickness. 
            // Use sphere to round the start of the post so that there
            // is no sudden overhang
            
            color([1,0,1]) {
            translate([R, -S+R,    Z-hole_depth-R]) sphere(d=sd*2);
            translate([R, -S+R,    Z-hole_depth-R]) cylinder(h=hole_depth+R, d=sd*2);
        
            translate([R, T+Y+T-R, Z-hole_depth-R]) sphere(d=sd*2);
            translate([R, T+Y+T-R, Z-hole_depth-R]) cylinder(h=hole_depth+R, d=sd*2);
        
                
            translate([T+X+T-R, -S+R,Z-SL-R]) sphere(d=sd*2);
            translate([T+X+T-R, -S+R,Z-SL-R]) cylinder(h=SL+R, d=sd*2);
        
            translate([T+X+T-R, T+Y+T-R, Z-SL-R]) sphere(d=sd*2);
            translate([T+X+T-R, T+Y+T-R, Z-SL-R]) cylinder(h=SL+R, d=sd*2);
            }
       
                               
            spectrometer_screw_posts(TID == undef ? SD : TID, TIL == undef ? SL : TIL);
        
        
        }
 
        // Holes for top lid screws
        
        lid_screw_holes(TID == undef ? SD : TID, TIL == undef ? SL : TIL);
        
        spectrometer_screw_holes(TID == undef ? SD : TID, TIL == undef ? SL : TIL);

       
        
        usb_wall_screw_holes(TID == undef ? SD : TID, TIL == undef ? SL : TIL);
    }
    

        
    //color ([1,0,1]) spectrometer_screw_holes(TID == undef ? SD : TID, TIL == undef ? SL : TIL);
    //color ([1,0,1]) spectrometer_screw_posts(TID == undef ? SD : TID, TIL == undef ? SL : TIL);


    
}


module lid_screw_holes (sd,sl) {
    eps = 0.001;
    translate ([    R   , -S +  R  , Z-sl-eps]) cylinder (d=sd,h=sl+3*eps);
    translate ([T + X + T - R   , -S +  R  , Z-sl-eps]) cylinder (d=sd,h=sl+3*eps);
    translate ([    R, T + Y + T - R, Z-sl-eps]) cylinder (d=sd,h=sl+3*eps);
    translate ([T + X + T - R, T + Y + T - R, Z-sl-eps]) cylinder (d=sd,h=sl+3*eps);
}


module lid() {
    difference() {
        translate([0,-S,Z]) cube ([X+T*2, Y + T*2 + S, T]);
        
        lid_screw_holes(TID == undef ? SD : TID, TIL == undef ? SL : TIL);
        
        // Allow screw heads to be sunk so that they do not protrode over surface of lid
        translate ([    R   , -S + R  , Z+T/2]) cylinder (d=SHD,h=50);
        translate ([T + X + T - R   , -S +  R  , Z+T/2]) cylinder (d=SHD,h=50);
        translate ([        R, T + Y + T - R, Z+T/2]) cylinder (d=SHD,h=50);
        translate ([T + X + T - R, T + Y + T - R, Z+T/2]) cylinder (d=SHD,h=50);   
    }
    
    // Keep spectometer board perfecty upright
    difference(){
        translate([T+35,   5, Z-4]) cube ([30,4,4]);
        // taper
        translate([T+35-1, 3, Z-T-2]) rotate([25,0,0]) cube ([32,4,4]);
    }
}


/**
 * Screws to allow this part to be attached to main enclosure box. This wall is separate
 * because the USB type B socket protrudes a little from the Aurduino board and it may 
 * not be possible to get the board if this wall is present.
 */
module usb_wall_screw_holes (sd,sl) {
    eps = 0.01;
    translate ([0,R-S,R]) rotate ([0,90,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+2*eps);
    translate ([0,R-S,Z-14]) rotate ([0,90,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+2*eps);
    translate ([0,T+S+Y-R,R]) rotate ([0,90,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+2*eps);
    translate ([0,T+S+Y-R,Z-14]) rotate ([0,90,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+2*eps);    
}



/**
 * Screw holes to allow instrument to be mounted in line with spectrometer can.
 */
module spectrometer_screw_holes (sd,sl) {
    eps = 0.01;    
    translate ([T+SPX-SPW/2 - SD*2, -S, 22]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+eps*3);
    translate ([T+SPX-SPW/2 - SD*2, -S, 42]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+eps*3);
    translate ([T+SPX+SPW/2 + SD*2, -S, 22]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+eps*3);
    translate ([T+SPX+SPW/2 + SD*2, -S, 42]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd,h=sl+eps*3);
}

module spectrometer_screw_posts (sd,sl) {
    eps = 0.0;    
    translate ([T+SPX-SPW/2 - SD*2, -S, 22]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd*2,h=sl+eps*3);
    translate ([T+SPX-SPW/2 - SD*2, -S, 42]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd*2,h=sl+eps*3);
    translate ([T+SPX+SPW/2 + SD*2, -S, 22]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd*2,h=sl+eps*3);
    translate ([T+SPX+SPW/2 + SD*2, -S, 42]) rotate ([-90,0,0]) translate([0,0,-eps]) cylinder(d=sd*2,h=sl+eps*3);
}


module usb_wall () {
    difference() {
        
        // Main wall cube
        translate([-T , -S    , 0]) cube([T,T+Y+S+T,Z+T]);
        
        // Hole for USB B connector
        translate([-T*2  , T+32 , T+1]) cube ([10,14,12]);
        
        translate ([-T,0,0]) usb_wall_screw_holes(SD,T) ;
        
        // Allow for sunk screw heads
        translate ([-T ,0,0]) usb_wall_screw_holes(SHD, T/2);    
    }
    
       //color(1,0,0) translate ([-T,0,0]) usb_wall_screw_holes(SD,T) ;

}

module spectrometer_attachment () {
    w = SPW + SD * 4 + SD * 4;
    h = SPH + SD * 2 + 10;
    
  
    //translate([-w/2,-h/2],0) cube([w,h,T]);
    
    difference() {
        union() {
            translate([T+SPX - w/2,-T, SPY+SPH/2 - h/2]) rotate ([90,0,0]) cube([w,h,T]);
            translate([T+SPX - (SPW+4)/2, -T, SPY+SPH/2 - h/2]) rotate ([90,0,0]) cube([SPW+4,h,10]);
        }
        translate([0,-T,0]) spectrometer_screw_holes(SD, TIL == undef ? SL : TIL);
        
        // Hole for spectrometer can
        //translate([T+SPX-SPW/2,-5,SPY]) cube ([SPW,SPH,30]);
            translate([T+SPX-SPW/2,-15,SPY]) cube ([SPW,SPH,30]);

    }
    
}
