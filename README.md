# hamamatsu_c12880ma

Related to Hamamatsu C12880MA spectrometer module. This module is available on an Arduino compatible breakout board by GroupGets LLC.
See https://groupgets.com/products/hamamatsu-c12880ma-mems-u-spectrometer



## Calibration

Calibration sheets are available on this page and (I think) covers all the devices sold. The serial number is etched on the side of  the spectrometer can. 
My serial number is 22G03276. A0=3.120790493E+02, B1=2.681652834E+00, B2=-8.061777879E-04, B3=-1.052906745E-05, B4=1.925845957E-08, B5=-7.465510101E-12. 
Wavelength(nm) = A0 + B1 * i + B2 * i^2 + B3 * i^3 + B4 * i^4 + B5 * i^5, where i is the pixel index. 
Wavelength resolution for my device is 9.6nm (defined as maximum value of FWHM at 340nm, 400nm, 450nm, 500nm, 550nm, 600nm, 655nm, 710nm, 760nm, 810nm, 850nm wavelengths)

Checking the calibration for myself... First (very crude) attempt at calibration using pen lasers (accepting the wavelength on the pen laser label).

```
    // i is the index of the value of the returned waveform
    // i=140 lambda=650mnm +/- 10
    // i=88  lambda=532nm +/- 10
    // i=50  lambda=405nm +/- 10
    // i=27  lambda=365nm +/- ?
    // best fit line:
    // m = 2.608; c=289.2
    // lambda = 2.608*i + 289.2 (unit nm)

```

## Enclosure

OpenSCAD files to create an enclosure for the GroupGets breakout board mounted on a Arduino Uno / Duemilanova 
are in the enclosures directory. Rendering of the Arduno from 
https://github.com/kellyegan/OpenSCAD-Arduino-Mounting-Library/tree/master
