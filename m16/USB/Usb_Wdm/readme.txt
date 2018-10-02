This README file is generated automatically by DriverWizard

To complete the driver, follow these steps:

 o  Build the driver
		Build | Build Usb_Wdm.sys

 o  Search for the string "TODO" and follow the instructions to complete your driver.

 o  Review the registry settings created in Usb_Wdm.inf.

The Wizard created the following files:

Files that comprise your driver:
  readme.txt
  	Contains information shown here.
  sys\Usb_Wdm.cpp
  	Driver class implementation.
  sys\Usb_Wdm.h
  	Driver class header file.
  sys\Usb_Wdm.inf
  	INF file defines driver for plug and play installation.
  Usb_Wdmioctl.h
  	Definition of control codes
  Usb_WdmDeviceInterface.h
	Header file containing the GUID for the device interface.
  sys\Usb_WdmDevice.cpp
  	Device (Usb_WdmDevice) implementation.
  sys\Usb_WdmDevice.h
  	Device (Usb_WdmDevice) header file.
  sys\function.h
  	Used by DriverWorks library to determine which
	handlers to provide.
  sys\Usb_Wdm.rc
  	Shell for resource file (used for event messages,
	version resource)

Files used by build utilities:
  sys\sources
  	Used by BUILD program to determine what files
	comprise your driver.
  sys\makefile
  	Used by BUILD program to build your driver.

Files used by the test application:
  exe\Test_Usb_Wdm.cpp
  	Console application with driver interface
  exe\OpenByIntf.cpp
	Used to open the device using a GUID interface.
  exe\sources
  	Used by BUILD program to determine what files
	comprise your test application.
  exe\makefile
  	Used by BUILD program to build your test application.
