# hamamatsu_c12880ma
Related to Hamamatsu C12880MA spectrometer module

## Calibration

First (very crude) attempt at calibration using pen lasers (accepting the
wavelength on the pen laser label).

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
    
