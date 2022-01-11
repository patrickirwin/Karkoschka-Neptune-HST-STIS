email from Erich Karkoschka on 14 Feb 2020, to Pat Fry

Hi Pat,

I put two files in our FTP site pirlftp.lpl.arizona.edu in directory
/pub/erich/neptune

disph.f is a Fortran program that reads the FITS file hnbr.
The output file 'junk' is an INTEGER*2 image of Neptune.  The data go
from bottom left 45 pixels to bottom right, then row after row to the top.
Data number 10000 corresponds to I/F=1.  Pixel 45,45 is the center of
Neptune, the central meridian is column 45 with Neptune's north up.
The equatorial radius is 40 pixels.  Wavelengths go from 300.4, 300.8, ...
to 1020 nm.  Note that wavelengths shorter than about 550 nm had only
13 slit positions, so I smoothed and interpolated in order to get a
reasonably looking image at each wavelength.  

Erich

