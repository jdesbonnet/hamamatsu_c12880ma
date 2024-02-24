
$fn = 60;
X=70;
Y=54;
Z=38+8;
T=4;

// Extra bit because spectrometer protrudes out from side
S = 4;


// Screw diameter and length
SD = 3;
SL = 16-T;

// Offset of screw center from corners
R = 3;

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


    
    // Spectrometer
    translate([44.5+T,-5,20]) cube ([12,19,50]);
        

}
}




difference () {

    union() {
        mainblock();
        
        
        translate([SD, -S+SD,Z-SL-R]) sphere(d=SD*2);
        translate([SD, -S+SD,Z-SL-R]) cylinder(h=SL+R, d=SD*2);
        
        translate([SD, T+Y+T-SD,Z-SL-R]) sphere(d=SD*2);
        translate([SD, T+Y+T-SD,Z-SL-R]) cylinder(h=SL+R, d=SD*2);
        
                
        translate([T+X+T-SD, -S+SD,Z-SL-R]) sphere(d=SD*2);
        translate([T+X+T-SD, -S+SD,Z-SL-R]) cylinder(h=SL+R, d=SD*2);
        
        translate([T+X+T-SD, T+Y+T-SD, Z-SL-R]) sphere(d=SD*2);
        translate([T+X+T-SD, T+Y+T-SD, Z-SL-R]) cylinder(h=SL+R, d=SD*2);
       
    }
    

        
    // Screw holes
    //translate ([    T/2   , -S +  T/2  , Z-15]) cylinder (d=SD,h=50);
    translate ([    SD   , -S +  SD  , Z-15]) cylinder (d=SD,h=50);

    //translate ([X + T + T/2   , -S +  T/2  , Z-15]) cylinder (d=SD,h=50);
    translate ([T + X + T - SD   , -S +  SD  , Z-15]) cylinder (d=SD,h=50);


    //translate ([        T/2, Y + T + T/2, Z-15]) cylinder (d=SD,h=50);
    translate ([        SD, Y + 2*T - SD, Z-15]) cylinder (d=SD,h=50);

    //translate ([X + T + T/2, Y + T + T/2, Z-15]) cylinder (d=SD,h=50);
    translate ([T + X + T - SD, T + Y + T - SD, Z-15]) cylinder (d=SD,h=50);


}

//color([1,0,1]) lid();


module lid() {
    translate([0,-S,Z]) cube ([X+T*2, Y + T*2 + S, T]);
}


translate([-5,-5-S,0]) cube([T+X+T+10,T+S+Y+T+10,0.2]);
