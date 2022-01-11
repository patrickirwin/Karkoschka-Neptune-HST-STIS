; stis_cube_read_example.pro
; 3 JAN 2014 (PMF)

; Read and manipulate 2012 STIS Uranus cube with geometry backplanes.
; Requires IDL astronomy library for FITS file reading.

cubefile = 'hnbr_navbp.fits'
fits_info, cubefile

fits_read, cubefile, cube, head, exten_no=1, /pdu ; in I/F units
fits_read, cubefile, wlen, extname='WAVELENGTH' ; in nm
fits_read, cubefile, latc_arr, extname='LAT_CENTRIC' ; in degrees
fits_read, cubefile, latg_arr, extname='LAT_GRAPHIC' ; in degrees
fits_read, cubefile, lone_arr, extname='REL_LON_EAST' ; in degrees
fits_read, cubefile, mu_arr, extname='MU_OBS_COS' ; observer zenith angle cosine
fits_read, cubefile, muz_arr, extname='MUZ_SUN_COS' ; solar zenith angle cosine
fits_read, cubefile, az_arr, extname='AZIMUTH' ; observer-sun azimuth angle

ss = size(cube)
nx = ss[1]
ny = ss[2]
nb = ss[3]

; Display 619 nm image.
zoom = 4
window, 1, xs=nx*zoom, ys=ny*zoom

wl = 619.0
res = min(abs(wlen - wl), band)
tvscl, rebin(cube[*,*,band], nx*zoom, ny*zoom, /sample)

; Minnaert plot: I/F*mu vs mu*muz, 619 nm, 10 deg north
; (planetographic)

window, 0, xs=800, ys=600
lat = 10.0
eps = 1.5; max distance in degrees from central latitude
w = where(abs(latg_arr - lat) le eps AND mu_arr ge 0.0, npix)
print, 'pixels in selection: ', npix
im = cube[*,*,band]
pix = im[w]
plot,  mu_arr[w]*muz_arr[w], pix*mu_arr[w],/xlog, /ylog, $
       psym=1, symsize=0.7, xr=[0.02,2], /xs, yr=[0.02,.1], /ys, $
       title='Minnaert plot for 619 nm, 10 deg N', $
       xtit='mu * mu_zero', ytit='I/F * mu'

; Find pixel coordinates for pixel closest to a desired lat, lon.

latg_want = 0.0
lone_want = -60.0

coslat = cos(latg_want * !dtor)
w = where(mu_arr ge 0.0); these are the pixels on the planet
lats = latg_arr[w]
lons = lone_arr[w]
dist = min(sqrt((lats-latg_want)^2 + ((lons-lone_want)*coslat)^2), minnav)
minind = w[minnav]
xy = array_indices([nx,ny], minind, /dimensions)
xloc = xy[0]
yloc = xy[1]
print
print, 'Desired planetographic lat, relative east lon: ', latg_want, lone_want
print, 'Closest pixel (x, y): ', xloc, yloc
print, 'Planetographic Lat, relative East lon of pixel: ', latg_arr[xloc,yloc], lone_arr[xloc,yloc]
print, 'Distance from desired to returned position (deg): ', dist

; Plot location on image.
wset, 1
plots, xloc*zoom, yloc*zoom, /device, psym=6

; Plot spectrum at that location

window,2,xs=800,ys=400
plot,wlen, cube[xloc,yloc,*],xtitle='Wavelength, nm',ytitle='I/F',xr=[250,1050],yr=[0,.7],/xs,/ys

end
