FACEPHI FACE RECOGNITION TECHNOLOGY
====================================
Note: This example works only with appropriate face recognition SDK and licenses.

---------------------------------------------
- XCODE Example Programming (Client Side) -
---------------------------------------------

Steps:

1. Copy the following files to
FacephiSDKExample/FPhi.Example.iOS.UserControl.Local/framework
	- FPhiUCios.framework
	- FPhi.Extractor.ios.framework
	- FPhi.Matcher.ios.framework
	- FPhiUCiosResources.bundle
			add this bundle in Copy Bundle Resources menu(Build Phases tab)
	- libEntrustIGMobileSDK.a

2. In order to add the required libraries, from the “Build Phases” tab, you should add the  libraries under framework folder in the “Link Binary with Libraries” section.
In addition also add Native library: libc++.tbd and Other Linker flags set to -ObjC



2. Copy the all header files from IGMobileSDK/MacOSX_iOS/include folder to
FacephiSDKExample/FPhi.Example.iOS.UserControl.Local/include

3. Open the xcodeproj and run the app


