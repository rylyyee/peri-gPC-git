# Script for running velocity profiles in time. 
#
# Note: you must create destination folders before beginning! 
#
import sys

WDin=sys.argv[1]
WDout=sys.argv[2]
startnum=int(float(sys.argv[3]))
endnum=int(float(sys.argv[4]))

for num in range(startnum,endnum):

	#OpenDatabase(str(WDin)+"/viz_IB2d"+str(num)+"/lag_data.visit", 0)
	#AddPlot("Mesh", "heart_race_512_vertices", 1, 0)
	#AddPlot("Mesh", "heart_tube_512_mesh", 1, 0)
	#AddPlot("Mesh", "heart_tube_512_vertices", 1, 0)
	#DrawPlots()
	OpenDatabase(str(WDin)+"/viz_IB2d"+str(num)+"/dumps.visit", 0)
	HideActivePlots()
	AddPlot("Pseudocolor", "U_magnitude", 1, 0)
	DrawPlots()
	SetActivePlots(4)
	SetActivePlots(4)
	globalLineout = GetGlobalLineoutAttributes()
	globalLineout.Dynamic=1;
	globalLineout.curveOption=0;
	SetGlobalLineoutAttributes(globalLineout)
	print globalLineout
	SetTimeSliderState(0)
	SetQueryFloatFormat("%g")
	n = TimeSliderGetNStates()
	for i in range(TimeSliderGetNStates()):
		SetActiveWindow(1)
		TimeSliderNextState()
		Query("Lineout", end_point=(0.4, 0, 0), num_samples=50, start_point=(0.3, 0, 0), use_sampling=0)
		SetActiveWindow(2)
		SetActivePlots(0)
		SaveWindowAtts = SaveWindowAttributes()
		SaveWindowAtts.outputToCurrentDirectory = 0
		SaveWindowAtts.outputDirectory = str(WDout)+"/sim"+str(num)
		SaveWindowAtts.fileName = "Um_profile"
		SaveWindowAtts.family = 1
		SaveWindowAtts.format = SaveWindowAtts.CURVE  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
		SaveWindowAtts.width = 1024
		SaveWindowAtts.height = 1024
		SaveWindowAtts.screenCapture = 0
		SaveWindowAtts.saveTiled = 0
		SaveWindowAtts.quality = 80
		SaveWindowAtts.progressive = 0
		SaveWindowAtts.binary = 0
		SaveWindowAtts.stereo = 0
		SaveWindowAtts.compression = SaveWindowAtts.PackBits  # None, PackBits, Jpeg, Deflate
		SaveWindowAtts.forceMerge = 0
		SaveWindowAtts.resConstraint = SaveWindowAtts.ScreenProportions  # NoConstraint, EqualWidthHeight, ScreenProportions
		SaveWindowAtts.advancedMultiWindowSave = 0
		SetSaveWindowAttributes(SaveWindowAtts)
		SaveWindow()
		DeleteActivePlots()
	SetActiveWindow(1)
	DeleteActivePlots()
	DeleteActivePlots()
	#DeleteActivePlots()
	#DeleteActivePlots()
	#DeleteActivePlots()

exit()
