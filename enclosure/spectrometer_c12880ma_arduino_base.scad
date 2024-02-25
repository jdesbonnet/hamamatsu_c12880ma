//
// Enclosure for C12880MA GroupGets breakout board mounted on a Arduino.
// Tested with Arduino Duemilanova board.
//
// Allows for attachments to spectrometer via 4 screwholes next to 
// spectrometer can. 
// 
// Holes are designed to allow M2 screw threded inserts (recommended), or adjust
// variable 'SD' for direct use of machine screws.
//
// Joe Desbonnet 2024-02-25.
//

// For printing, enable one at time. Vertical components may need to
// rotated in the slicer for reliable printing.
showMainBox = true;
showLid = true;
showUsbWall = true;



$fn = 60;

// Dimensions of main enclosure box (mm)
X=70;
Y=54;
Z=38+8;

// Thickness of wall
T=5;

// Extra bit because spectrometer protrudes out from side
S = 4;


// Screw diameter (SD) and length (SL)
SD = 3;
SL = 16-T;

// Offset of screw center from corners
R = 3;



if (showMainBox) {
    main_enclosure_box();
    // Grip layer to ensure that no detachment takes place
    color([0.5,0.5,0.5,0.1]) translate([-5,-5-S,0]) cube([T+X+T+10,T+S+Y+T+10,0.2]);
} 

if (showLid) {
    color([0.5,0.5,0.5,0.6]) lid();
    color([0.5,0.5,0.5,0.1])translate([-5,-5-S,Z+T]) cube([T+X+T+10,T+S+Y+T+10,0.2]);
}

if (showUsbWall) {
    usb_wall();
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
        translate([T+44.5,-5,20]) cube ([12,19,50]);
        

    }
}



module main_enclosure_box() {
    difference () {

        union() {
            mainblock();
        
        
            // Posts to facilitate screw diamater > wall thickness. 
            // Use sphere to round the start of the post so that there
            // is no sudden overhang
            
            translate([SD, -S+SD,Z-SL-R]) sphere(d=SD*2);
            translate([SD, -S+SD,Z-SL-R]) cylinder(h=SL+R, d=SD*2);
        
            translate([SD, T+Y+T-SD,Z-SL-R]) sphere(d=SD*2);
            translate([SD, T+Y+T-SD,Z-SL-R]) cylinder(h=SL+R, d=SD*2);
        
                
            translate([T+X+T-SD, -S+SD,Z-SL-R]) sphere(d=SD*2);
            translate([T+X+T-SD, -S+SD,Z-SL-R]) cylinder(h=SL+R, d=SD*2);
        
            translate([T+X+T-SD, T+Y+T-SD, Z-SL-R]) sphere(d=SD*2);
            translate([T+X+T-SD, T+Y+T-SD, Z-SL-R]) cylinder(h=SL+R, d=SD*2);
       
        }
 
        // Holes for lid screws
        lid_screw_holes();
           spectrometer_screw_holes();
 usb_wall_screw_holes();
    }
    
   
}


module lid_screw_holes () {        
    //translate ([    SD   , -S +  SD  , Z-15]) cylinder (d=SD,h=50);
    //translate ([T + X + T - SD   , -S +  SD  , Z-15]) cylinder (d=SD,h=50);
    //translate ([        SD, Y + 2*T - SD, Z-15]) cylinder (d=SD,h=50);
    //translate ([T + X + T - SD, T + Y + T - SD, Z-15]) cylinder (d=SD,h=50);
    
    translate ([    T/2   , -S +  T/2  , Z-15]) cylinder (d=SD,h=50);
    translate ([T + X + T - T/2   , -S +  T/2  , Z-15]) cylinder (d=SD,h=50);
    translate ([      T/2, Y + 2*T - T/2, Z-15]) cylinder (d=SD,h=50);
    translate ([T + X + T - T/2, T + Y + T - T/2, Z-15]) cylinder (d=SD,h=50);
}


module lid() {
    difference() {
        translate([0,-S,Z]) cube ([X+T*2, Y + T*2 + S, T]);
        
        lid_screw_holes();
        
        translate ([    SD   , -S +  SD  , Z+T/2]) cylinder (d=SD*2,h=50);
        translate ([T + X + T - SD   , -S +  SD  , Z+T/2]) cylinder (d=SD*2,h=50);
        translate ([        SD, Y + 2*T - SD, Z+T/2]) cylinder (d=SD*2,h=50);
        translate ([T + X + T - SD, T + Y + T - SD, Z+T/2]) cylinder (d=SD*2,h=50);
        
    }
    
    // Keep spectometer board perfecty upright
    difference(){
        translate([T+35,   5, Z-4]) cube ([30,4,4]);
        // taper
        translate([T+35-1, 3, Z-T-2]) rotate([25,0,0]) cube ([32,4,4]);
    }
}

module usb_wall_screw_holes () {
        translate ([0,T/2-S,R]) rotate ([0,90,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
        translate ([0,T/2-S,Z-14]) rotate ([0,90,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
        translate ([0,T+S+Y-T/2,R]) rotate ([0,90,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
        translate ([0,T+S+Y-T/2,Z-14]) rotate ([0,90,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
}

module spectrometer_screw_holes () {
        translate ([T+44.5-SD*2,T/2-S,22]) rotate ([90,0,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
        translate ([T+44.5-SD*2,T/2-S,42]) rotate ([90,0,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
        translate ([T+44.5+10+SD*2,T/2-S,22]) rotate ([90,0,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
        translate ([T+44.5+10+SD*2,T/2-S,42]) rotate ([90,0,0]) translate([0,0,-10]) cylinder(d=SD,h=20);
}


module usb_wall () {
    difference() {
        translate([-T , -S    , 0]) cube([4,T+Y+S+T,Z+T]);
        translate([-T*2  , T+33 , T+1]) cube ([10,14,12]);
        usb_wall_screw_holes();

        
    }
    

}
