; cubenav.pro
; 17 FEB 2020 (PMF)

; Reform Neptune STIS cube from Erich Karkoschka and add navigation
; keywords and wavelength extension.

fits_read, 'hnbr.fits', data, head

;; from Erich:
;; The data go from bottom left 45 pixels to bottom right, then row
;; after row to the top.  Data number 10000 corresponds to I/F=1.
;; Pixel 45,45 is the center of Neptune, the central meridian is
;; column 45 with Neptune's north up.  The equatorial radius is 40
;; pixels.  Wavelengths go from 300.4, 300.8, ...  to 1020 nm.

nk = round((1020-300.4) / 0.4) + 1
wlen = 300.4 + 0.4 * findgen(nk)
cube = reform(data, [45,91,1930])
cube = cube[*,0:89,0:1799] / 1e4

sxaddpar, head, 'FILENAME', 'hnbr_nav.fits'
sxaddpar, head, 'DATE_OBS', '2003-08-03', ' Middle of observation'
sxaddpar, head, 'TIME_OBS', '08:00:00'
ephem_icy, 399L, 899L, '2003-08-03', '08:00:00', edata
sxaddpar, head, 'MPOLE', 0.0, ' Pole angle in image CW from Y'
sxaddpar, head, 'XCENT', 44.0, ' Planet center, zero-based'
sxaddpar, head, 'YCENT', 44.0
sxaddpar, head, 'RE_KM', 24764.0, ' Equatorial radius, km'
sxaddpar, head, 'RP_KM', 24341.0, ' Polar radius, km'
sxaddpar, head, 'SO_LAT', edata[2], ' sub-observer lat, centric'
sxaddpar, head, 'SO_LON', 0.0, ' sub-observer lon, east, CM-relative'
sxaddpar, head, 'SS_LAT', edata[4], ' sub-solar lat, centric'
sxaddpar, head, 'SS_LON', edata[5]-edata[3], ' sub-solar lon, east'
sxaddpar, head, 'RANGE', edata[6], ' earth-target dist, km'
ps = 24764.0 / 40.0 / edata[6] / !dtor * 3600
sxaddpar, head, 'PSCALE1', ps, ' pixel scale, arcsec / pixel'
sxaddpar, head, 'SUN_DIST', edata[8], ' sun-target dist, km'
au = 149597870.0
sxaddpar, head, 'AU', au, ' 1 AU, km'
sxaddpar, head, 'SUN_AU', edata[8] / au, ' sun-target dist, AU'
sxaddpar, head, 'IOVERF', 1, ' if 1, units are I/F'
sxaddpar, head, 'EXTUNIT', 'nanometers', ' WAVELENGTH extension in nm'

fits_open, 'hnbr_nav.fits', fd, /write
fits_write, fd, 0, head ; write PDU and header
fits_write, fd, cube, extname='SCI'
fits_write, fd, wlen, extname='WAVELENGTH'
fits_close, fd

end
