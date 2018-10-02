// Usb_WdmDevice.cpp
// Implementation of Usb_WdmDevice device class
//
// Generated by DriverWizard version DriverStudio 2.7.0 (Build 562)
// Requires Compuware's DriverWorks classes
//

#pragma warning(disable:4065) // Allow switch statement with no cases
		  
#include <vdw.h>
#include <kusb.h>
#include "..\Usb_WdmDeviceinterface.h"

#include "Usb_Wdm.h"
#include "Usb_WdmDevice.h"
#include "..\Usb_Wdmioctl.h"

#pragma hdrstop("Usb_Wdm.pch")

extern KTrace t;			// Global driver trace object	

GUID Usb_WdmDevice_Guid = Usb_WdmDevice_CLASS_GUID;

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::Usb_WdmDevice
//
//	Routine Description:
//		This is the constructor for the Functional Device Object, or FDO.
//		It is derived from KPnpDevice, which builds in automatic
//	    dispatching of subfunctions of IRP_MJ_POWER and IRP_MJ_PNP to
//		virtual member functions.
//
//	Parameters:
//		Pdo - Physical Device Object - this is a pointer to a system
//			device object that represents the physical device.
//
//		Unit - Unit number. This is a number to append to the device's
//			base device name to form the Logical Device Object's name
//
//	Return Value:
//		None   
//
//	Comments:
//		The object being constructed contains a data member (m_Lower) of type
//		KPnpLowerDevice. By initializing it, the driver binds the FDO to the
//		PDO and creates an interface to the upper edge of the system class driver.
//

Usb_WdmDevice::Usb_WdmDevice(PDEVICE_OBJECT Pdo, ULONG Unit) :
	KPnpDevice(Pdo, &Usb_WdmDevice_Guid)
{
	t << "Entering Usb_WdmDevice::Usb_WdmDevice (constructor)\n";


	// Check constructor status
    if ( ! NT_SUCCESS(m_ConstructorStatus) )
	{
	    return;
	}

	// Remember our unit number
	m_Unit = Unit;

	// Initialize the lower device
	m_Lower.Initialize(this, Pdo);

	// Initialize the interface object.  The wizard generates code 
	// to support a single interface.  You may create and add additional 
	// interfaces.  By default, the wizard uses InterfaceNumber 0 (the 
	// first interface descriptor), ConfigurationValue 1 (the first
	// configuration descriptor), and initial interface alternate
	// setting of 0.  If your device has multiple interfaces or alternate
	// settings for an interface, you can add additional KUsbInterface
	// objects or adjust the parameters passed to this function.
	m_Interface.Initialize(
					m_Lower, //KUsbLowerDevice
					0,		 //InterfaceNumber
					1,		 //ConfigurationValue 
					0		 //Initial Interface Alternate Setting
					); 

	// Initialize each Pipe object
	m_Endpoint1IN.Initialize(m_Lower, 0x81, 16); 
	m_Endpoint1OUT.Initialize(m_Lower, 0x1, 16); 
	m_Endpoint2IN.Initialize(m_Lower, 0x82, 64); 
	m_Endpoint2OUT.Initialize(m_Lower, 0x2, 64); 

    // Inform the base class of the lower edge device object
	SetLowerDevice(&m_Lower);

	// Initialize the PnP Policy settings to the "standard" policy
	SetPnpPolicy();

// TODO:	Customize the PnP Policy for this device by setting
//			flags in m_Policies.

	// Initialize the Power Policy settings to the "standard" policy
	SetPowerPolicy();

// TODO:	Customize the Power Policy for this device by setting
//			flags in m_PowerPolicies.

}


////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::~Usb_WdmDevice
//
//	Routine Description:
//		This is the destructor for the Functional Device Object, or FDO.
//
//	Parameters:
//		None
//
//	Return Value:
//		None
//
//	Comments:
//		None
//

Usb_WdmDevice::~Usb_WdmDevice()
{
	t << "Entering Usb_WdmDevice::~Usb_WdmDevice() (destructor)\n";
}

////////////////////////////////////////////////////////////////////////
//  PNPMinorFunctionName
//
//	Routine Description:
//		Return a string describing the Plug and Play minor function	
//
//	Parameters:
//		mn - Minor function code
//
//	Return Value:
//		char * - Ascii name of minor function
//
//	Comments:
//		This function is used for tracing the IRPs.  Remove the function,
//		or conditionalize it for debug-only builds, if you want to save
//		space in the driver image.
//
	
char *PNPMinorFunctionName(ULONG mn)
{
	static char* minors[] = {
		"IRP_MN_START_DEVICE",
		"IRP_MN_QUERY_REMOVE_DEVICE",
		"IRP_MN_REMOVE_DEVICE",
		"IRP_MN_CANCEL_REMOVE_DEVICE",
		"IRP_MN_STOP_DEVICE",
		"IRP_MN_QUERY_STOP_DEVICE",
		"IRP_MN_CANCEL_STOP_DEVICE",
		"IRP_MN_QUERY_DEVICE_RELATIONS",
		"IRP_MN_QUERY_INTERFACE",
		"IRP_MN_QUERY_CAPABILITIES",
		"IRP_MN_QUERY_RESOURCES",
		"IRP_MN_QUERY_RESOURCE_REQUIREMENTS",
		"IRP_MN_QUERY_DEVICE_TEXT",
		"IRP_MN_FILTER_RESOURCE_REQUIREMENTS",
		"<unknown minor function>",
		"IRP_MN_READ_CONFIG",
		"IRP_MN_WRITE_CONFIG",
		"IRP_MN_EJECT",
		"IRP_MN_SET_LOCK",
		"IRP_MN_QUERY_ID",
		"IRP_MN_QUERY_PNP_DEVICE_STATE",
		"IRP_MN_QUERY_BUS_INFORMATION",
		"IRP_MN_DEVICE_USAGE_NOTIFICATION",
		"IRP_MN_SURPRISE_REMOVAL",
		"IRP_MN_QUERY_LEGACY_BUS_INFORMATION"
	};

	if (mn > 0x18) // IRP_MN_QUERY_LEGACY_BUS_INFORMATION
		return "<unknown minor function>";
	else
		return minors[mn];
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::DefaultPnp
//
//	Routine Description:
//		Default handler for IRP_MJ_PNP
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result returned from lower device
//
//	Comments:
//		This routine just passes the IRP through to the lower device. It is 
//		the default handler for IRP_MJ_PNP. IRPs that correspond to
//		any virtual members of KpnpDevice that handle minor functions of
//		IRP_MJ_PNP and that are not overridden get passed to this routine.
//

NTSTATUS Usb_WdmDevice::DefaultPnp(KIrp I) 
{
	t << "Entering Usb_WdmDevice::DefaultPnp with IRP minor function="
	  << PNPMinorFunctionName(I.MinorFunction()) << EOL;

	I.ForceReuseOfCurrentStackLocationInCalldown();
	return m_Lower.PnpCall(this, I);
}


////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::DefaultPower
//
//	Routine Description:
//		Default handler for IRP_MJ_POWER 
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result returned from lower device
//
//	Comments:
//		This routine just passes the IRP through to the lower device. It is 
//		the default handler for IRP_MJ_POWER.
//

NTSTATUS Usb_WdmDevice::DefaultPower(KIrp I) 
{
	t << "Entering Usb_WdmDevice::DefaultPower\n";

	I.IndicatePowerIrpProcessed();
	I.CopyParametersDown();
	return m_Lower.PnpPowerCall(this, I);
}

////////////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::SystemControl
//
//	Routine Description:
//		Default handler for IRP_MJ_SYSTEM_CONTROL
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result returned from lower device
//
//	Comments:
//		This routine just passes the IRP through to the next device since this driver
//		is not a WMI provider.
//

NTSTATUS Usb_WdmDevice::SystemControl(KIrp I) 
{
	t << "Entering Usb_WdmDevice::SystemControl\n";

	I.ForceReuseOfCurrentStackLocationInCalldown();
	return m_Lower.PnpCall(this, I);
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::OnStartDevice
//
//	Routine Description:
//		Handler for IRP_MJ_PNP subfcn IRP_MN_START_DEVICE
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//		Typically, the driver sends a SET CONFIGURATION request for the
//		USB device by using KUsbLowerDevice::ActivateConfiguration with
//		the ConfigurationValue to activate.  The wizard generates code to 
//		support a single configuration.  You may create and add additional 
//		configurations. 
//

NTSTATUS Usb_WdmDevice::OnStartDevice(KIrp I)
{
	t << "Entering Usb_WdmDevice::OnStartDevice\n";

	NTSTATUS status = STATUS_UNSUCCESSFUL;

	AC_STATUS acStatus = AC_SUCCESS;

	I.Information() = 0;

	// The default Pnp policy has already cleared the IRP with the lower device

	//By default, the wizard passes a ConfigurationValue of 1 to 
	//ActivateConfiguration().  This corresponds to the first configuration 
	//that the device reports in its configuration descriptor.  If the device 
	//supports multiple configurations, pass the appropriate
	//ConfigurationValue of the configuration to activate here.
	acStatus = m_Lower.ActivateConfiguration(
		1	// ConfigurationValue 1 (the first configuration)
		);

	switch (acStatus)
	{
		case AC_SUCCESS:
			t << "USB Configuration OK\n";
			status = STATUS_SUCCESS;
			break;

		case AC_COULD_NOT_LOCATE_INTERFACE:
			t << "Could not locate interface\n";
			break;

		case AC_COULD_NOT_PRECONFIGURE_INTERFACE:
			t << "Could not get configuration descriptor\n";
			break;

		case AC_CONFIGURATION_REQUEST_FAILED:
			t << "Board did not accept configuration URB\n";
			break;

		case AC_FAILED_TO_INITIALIZE_INTERFACE_OBJECT:
			t << "Failed to initialize interface object\n";
			break;

		case AC_FAILED_TO_GET_DESCRIPTOR:
			t << "Failed to get device descriptor\n";
			break;

		case AC_FAILED_TO_OPEN_PIPE_OBJECT:
			//NOTE: this may not be an error.  It could mean that
			//the device has an endpoint for which a KUsbPipe object has
			//not been instanced.  If the intention is to not use this endpoint,
			//then it's likely not a problem.  
			status = STATUS_SUCCESS;
			t << "Failed to open pipe object\n";
			break;

		default:
			t << "Unexpected error activating USB configuration\n";
			break;
	}

   return status;  // base class completes the IRP
}


////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::OnStopDevice
//
//	Routine Description:
//		Handler for IRP_MJ_PNP subfcn IRP_MN_STOP_DEVICE
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//		The system calls this when the device is stopped.
//		The driver should release any hardware resources
//		in this routine.
//
//		The base class passes the irp to the lower device.
//

NTSTATUS Usb_WdmDevice::OnStopDevice(KIrp I)
{
	NTSTATUS status = STATUS_SUCCESS;

	t << "Entering Usb_WdmDevice::OnStopDevice\n";

	m_Lower.DeActivateConfiguration();


// TODO:	Add device-specific code to stop your device   

	return status;
	
	// The following macro simply allows compilation at Warning Level 4
	// If you reference this parameter in the function simply remove the macro.
	UNREFERENCED_PARAMETER(I);
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::OnRemoveDevice
//
//	Routine Description:
//		Handler for IRP_MJ_PNP subfcn IRP_MN_REMOVE_DEVICE
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//		The system calls this when the device is removed.
//		Our PnP policy will take care of 
//			(1) giving the IRP to the lower device
//			(2) detaching the PDO
//			(3) deleting the device object
//

NTSTATUS Usb_WdmDevice::OnRemoveDevice(KIrp I)
{
	t << "Entering Usb_WdmDevice::OnRemoveDevice\n";

	// Device removed, release the system resources used by the USB lower device.
	m_Lower.ReleaseResources();




// TODO:	Add device-specific code to remove your device   

	return STATUS_SUCCESS;

	// The following macro simply allows compilation at Warning Level 4
	// If you reference this parameter in the function simply remove the macro.
	UNREFERENCED_PARAMETER(I);
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::OnDevicePowerUp
//
//	Routine Description:
//		Handler for IRP_MJ_POWER with minor function IRP_MN_SET_POWER
//		for a request to go to power on state from low power state
//
//	Parameters:
//		I - IRP containing POWER request
//
//	Return Value:
//		NTSTATUS - Status code indicating success or failure
//
//	Comments:
//		This routine implements the OnDevicePowerUp function.
//		This function was called by the framework from the completion
//		routine of the IRP_MJ_POWER dispatch handler in KPnpDevice.
//		The bus driver has completed the IRP and this driver can now
//		access the hardware device.  
//		This routine runs at dispatch level.
//	

NTSTATUS Usb_WdmDevice::OnDevicePowerUp(KIrp I)
{
	NTSTATUS status = STATUS_SUCCESS;

	t << "Entering Usb_WdmDevice::OnDevicePowerUp\n";

// TODO:	Service the device.
//			Restore any context to the hardware device that
//			was saved during the handling of a power down request.
//			See the OnDeviceSleep function.
//			Do NOT complete this IRP.
//
	return status;

	// The following macro simply allows compilation at Warning Level 4
	// If you reference this parameter in the function simply remove the macro.
	UNREFERENCED_PARAMETER(I);
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::OnDeviceSleep
//
//	Routine Description:
//		Handler for IRP_MJ_POWER with minor function IRP_MN_SET_POWER
//		for a request to go to a low power state from a high power state
//
//	Parameters:
//		I - IRP containing POWER request
//
//	Return Value:
//		NTSTATUS - Status code indicating success or failure
//
//	Comments:
//		This routine implements the OnDeviceSleep function.
//		This function was called by the framework from the IRP_MJ_POWER 
//		dispatch handler in KPnpDevice prior to forwarding to the PDO.
//		The hardware has yet to be powered down and this driver can now
//		access the hardware device.  
//		This routine runs at passive level.
//	

NTSTATUS Usb_WdmDevice::OnDeviceSleep(KIrp I)
{
	NTSTATUS status = STATUS_SUCCESS;

	t << "Entering Usb_WdmDevice::OnDeviceSleep\n";

// TODO:	Service the device.
//			Save any context to the hardware device that will be required 
//			during a power up request. See the OnDevicePowerUp function.
//			Do NOT complete this IRP.  The base class handles forwarding
//			this IRP to the PDO.
//
	return status;

	// The following macro simply allows compilation at Warning Level 4
	// If you reference this parameter in the function simply remove the macro.
	UNREFERENCED_PARAMETER(I);
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::Create
//
//	Routine Description:
//		Handler for IRP_MJ_CREATE
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//

NTSTATUS Usb_WdmDevice::Create(KIrp I)
{
	NTSTATUS status;

	t << "Entering Usb_WdmDevice::Create, " << I << EOL;

// TODO: Add driver specific create handling code here

	// Generally a create IRP is targeted at our FDO, so we don't need
	// to pass it down to the PDO.  We have found for some devices, the
	// PDO is not expecting this Irp and returns an error code.
	// The default wizard code, therefore completes the Irp here using
	// PnpComplete().  The following commented code could be used instead
	// of PnpComplete() to pass the Irp to the PDO, which would complete it.
	//
//	I.ForceReuseOfCurrentStackLocationInCalldown();
//	status = m_Lower.PnpCall(this, I);

	status = I.PnpComplete(this, STATUS_SUCCESS, IO_NO_INCREMENT);

	t << "Usb_WdmDevice::Create Status " << (ULONG)status << EOL;

	return status;
}


////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::Close
//
//	Routine Description:
//		Handler for IRP_MJ_CLOSE
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//

NTSTATUS Usb_WdmDevice::Close(KIrp I)
{
	NTSTATUS status;

	t << "Entering Usb_WdmDevice::Close, " << I << EOL;

// TODO: Add driver specific close handling code here

	// Generally a close IRP is targeted at our FDO, so we don't need
	// to pass it down to the PDO.  We have found for some devices, the
	// PDO is not expecting this Irp and returns an error code.
	// The default wizard code, therefore completes the Irp here using
	// PnpComplete().  The following commented code could be used instead
	// of PnpComplete() to pass the Irp to the PDO, which would complete it.
	//
//	I.ForceReuseOfCurrentStackLocationInCalldown();
//	status = m_Lower.PnpCall(this, I);

	status = I.PnpComplete(this, STATUS_SUCCESS, IO_NO_INCREMENT);

	t << "Usb_WdmDevice::Close Status " << (ULONG)status << EOL;

    return status;
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::Cleanup
//
//	Routine Description:
//		Handler for IRP_MJ_CLEANUP	
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//

NTSTATUS Usb_WdmDevice::CleanUp(KIrp I)
{
	t << "Entering CleanUp, " << I << EOL;

// TODO:	Insert your code to respond to the CLEANUP message.
	return I.PnpComplete(this, STATUS_SUCCESS);
}


////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::Read
//
//	Routine Description:
//		Handler for IRP_MJ_READ
//
//	Parameters:
//		I			Current IRP
//
//	Return Value:
//		NTSTATUS	Result code
//
//	Comments:
//		This routine handles read requests.
//
//		The KPnpDevice class handles restricting IRP flow
//		if the device is stopping or being removed.
//

NTSTATUS Usb_WdmDevice::Read(KIrp I) 
{
	t << "Entering Usb_WdmDevice::Read, " << I << EOL;
// TODO:	Check the incoming request.  Replace "FALSE" in the following
//			line with a check that returns TRUE if the request is not valid.

    if (FALSE)		// If (Request is invalid)
	{
		// Invalid parameter in the Read request
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_INVALID_PARAMETER);
	}

	// Always ok to read 0 elements.
	if (I.ReadSize() == 0)
	{
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_SUCCESS);
	}

	// Declare a memory object
	KMemory Mem(I.Mdl());

    ULONG dwTotalSize = I.ReadSize(CURRENT);
	ULONG dwMaxSize = m_Endpoint2IN.MaximumTransferSize();

	// If the total requested read size is greater than the Maximum Transfer
	// Size for the Pipe, request to read only the Maximum Transfer Size since
	// the bus driver will fail an URB with a TransferBufferLength of greater
	// than the Maximum Transfer Size. 
	if (dwTotalSize > dwMaxSize)
	{
		ASSERT(dwMaxSize);
		dwTotalSize = dwMaxSize;
	}

	// Allocate a new context structure for Irp completion
	USB_COMPLETION_INFO* pCompInfo = new (NonPagedPool) USB_COMPLETION_INFO;
	if (pCompInfo == NULL)
	{
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_INSUFFICIENT_RESOURCES);
	}

// TODO:	Select the correct pipe to read from

	// Create an URB to do actual Bulk read from the pipe
	PURB pUrb = m_Endpoint2IN.BuildBulkTransfer(
			    	Mem,      		// Where is data coming from?
					dwTotalSize,  	// How much data to read?
					TRUE,         	// direction (TRUE = IN)
					NULL,			// Link to next URB
					TRUE			// Allow a short transfer
					);        		

	if (pUrb == NULL)
	{
		delete pCompInfo;
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_INSUFFICIENT_RESOURCES);
	}

	// Initialize context structure
	pCompInfo->m_pClass = this;
	pCompInfo->m_pUrb = pUrb;

    // Submit the URB to our USB device
	NTSTATUS status;
	status = m_Endpoint2IN.SubmitUrb(I, pUrb, LinkTo(ReadComplete), pCompInfo, 0);
	return status;
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::ReadComplete
//
//	Routine Description:
//		Completion Handler for IRP_MJ_READ
//
//	Parameters:
//		I - IRP just completed by USB
//		pContext - Context structure containing pointer to Urb
//
//	Parameters:
//		NTSTATUS - STATUS_SUCCESS
//
//	Comments:
//		This routine is called when USBD completes the read request
//

NTSTATUS Usb_WdmDevice::ReadComplete(KIrp I, USB_COMPLETION_INFO* pContext)
{
	// Normal completion routine code to propagate pending flag

	if (I->PendingReturned) 
	{
		I.MarkPending();
	}
	
	NTSTATUS status = I.Status();
	PURB pUrb = pContext->m_pUrb;
	ULONG nBytesRead = 0;

	if ( NT_SUCCESS(status) ) 
	{
		nBytesRead = pUrb->UrbBulkOrInterruptTransfer.TransferBufferLength;
		if (nBytesRead > 0) 
			t << "Read() got " << nBytesRead<< " bytes from USB\n";
    }

	// Deallocate Urb and context structure
	delete pUrb;
	delete pContext;

	// set returned count
	I.Information() = nBytesRead;
	
	// Plug and Play accounting
	DecrementOutstandingRequestCount();

	// allow IRP completion processing
	return STATUS_SUCCESS;
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::Write
//
//	Routine Description:
//		Handler for IRP_MJ_WRITE
//
//	Parameters:
//		I - Current IRP
//
//	Return Value:
//		NTSTATUS - Result code
//
//	Comments:
//		This routine handles write requests.
//
//		The KPnpDevice class handles restricting IRP flow
//		if the device is stopping or being removed.
//

NTSTATUS Usb_WdmDevice::Write(KIrp I) 
{
	t << "Entering Usb_WdmDevice::Write, " << I << EOL;
// TODO:	Check the incoming request.  Replace "FALSE" in the following
//			line with a check that returns TRUE if the request is not valid.
    if (FALSE)
	{
		// Invalid parameter in the Write request
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_INVALID_PARAMETER);
	}

	// Always ok to write 0 elements.
	if (I.WriteSize() == 0)
	{
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_SUCCESS);
	}
	ULONG dwTotalSize = I.WriteSize(CURRENT);
	ULONG dwMaxSize = m_Endpoint2OUT.MaximumTransferSize();

	// If the total requested read size is greater than the Maximum Transfer
	// Size for the Pipe, request to read only the Maximum Transfer Size since
	// the bus driver will fail an URB with a TransferBufferLength of greater
	// than the Maximum Transfer Size. 
	if (dwTotalSize > dwMaxSize)
	{
		ASSERT(dwMaxSize);
		dwTotalSize = dwMaxSize;
	}

	// Declare a memory object
	KMemory Mem(I.Mdl());

	// Allocate a new context structure for Irp completion
	USB_COMPLETION_INFO* pCompInfo = new (NonPagedPool) USB_COMPLETION_INFO;
	if (pCompInfo == NULL)
	{
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_INSUFFICIENT_RESOURCES);
	}

// TODO:	Select the correct pipe to write to

	// Create an URB to do actual Bulk write to the pipe
	PURB pUrb = m_Endpoint2OUT.BuildBulkTransfer(
					Mem,          // Where is data coming from?
					dwTotalSize,  // How much data to read?
					FALSE,        // direction (FALSE = OUT)
					NULL		  // Link to next URB
					);	        

	if (pUrb == NULL)
	{
		delete pCompInfo;
		I.Information() = 0;
		return I.PnpComplete(this, STATUS_INSUFFICIENT_RESOURCES);
	}

	// Initialize context structure
	pCompInfo->m_pClass = this;
	pCompInfo->m_pUrb = pUrb;

    // Submit the URB to our USB device
	NTSTATUS status;
	status = m_Endpoint2OUT.SubmitUrb(I, pUrb, LinkTo(WriteComplete), pCompInfo, 0);
	return status;
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::WriteComplete
//
//	Routine Description:
//		Completion Handler for IRP_MJ_WRITE
//
//	Parameters:
//		I - IRP just completed by USB
//		pContext - Context structure containing pointer to Urb
//
//	Return Value:
//		NTSTATUS	STATUS_SUCCESS
//
//	Comments:
//		This routine is called when USBD completes the write request
//

NTSTATUS Usb_WdmDevice::WriteComplete(KIrp I, USB_COMPLETION_INFO* pContext)
{
	// Normal completion routine code to propagate pending flag

	if (I->PendingReturned) 
	{
		I.MarkPending();
	}
	
	NTSTATUS status = I.Status();
	PURB pUrb = pContext->m_pUrb;
	ULONG nBytesWritten = 0;

	if ( NT_SUCCESS(status) ) 
	{
		nBytesWritten = pUrb->UrbBulkOrInterruptTransfer.TransferBufferLength;
		if (nBytesWritten > 0) 
			t << "Wrote " << nBytesWritten	<< " bytes to USB\n";
    }

	// Deallocate Urb and context structure
	delete pUrb;
	delete pContext;

	// set returned count
	I.Information() = nBytesWritten;
	
	// Plug and Play accounting
	DecrementOutstandingRequestCount();

	// allow IRP completion processing
	return STATUS_SUCCESS;
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::DeviceControl
//
//	Routine Description:
//		Handler for IRP_MJ_DEVICE_CONTROL
//
//	Parameters:
//		I - Current IRP
// 
//	Return Value:
//		None
//
//	Comments:
//		This routine is the first handler for Device Control requests.
//		The KPnpDevice class handles restricting IRP flow
//		if the device is stopping or being removed.
//

NTSTATUS Usb_WdmDevice::DeviceControl(KIrp I) 
{
	NTSTATUS status;

	t << "Entering Usb_WdmDevice::Device Control, " << I << EOL;
	switch (I.IoctlCode())
	{
		case USB_WDM_IOCTL_Test:
			status = USB_WDM_IOCTL_Test_Handler(I);
			break;

		default:
			// Unrecognized IOCTL request
			status = STATUS_INVALID_PARAMETER;
			break;
	}

	// If the IRP's IOCTL handler deferred processing using some driver
	// specific scheme, the status variable is set to STATUS_PENDING.
	// In this case we simply return that status, and the IRP will be
	// completed later.  Otherwise, complete the IRP using the status
	// returned by the IOCTL handler.
	if (status == STATUS_PENDING)
	{
		return status;
	}
	else
	{
		return I.PnpComplete(this, status);
	}
}

////////////////////////////////////////////////////////////////////////
//  Usb_WdmDevice::USB_WDM_IOCTL_Test_Handler
//
//	Routine Description:
//		Handler for IO Control Code USB_WDM_IOCTL_Test
//
//	Parameters:
//		I - IRP containing IOCTL request
//
//	Return Value:
//		NTSTATUS - Status code indicating success or failure
//
//	Comments:
//		This routine implements the USB_WDM_IOCTL_Test function.
//		This routine runs at passive level.
//

NTSTATUS Usb_WdmDevice::USB_WDM_IOCTL_Test_Handler(KIrp I)
{
	NTSTATUS status = STATUS_SUCCESS;

	t << "Entering Usb_WdmDevice::USB_WDM_IOCTL_Test_Handler, " << I << EOL;
// TODO:	Verify that the input parameters are correct
//			If not, return STATUS_INVALID_PARAMETER

// TODO:	Handle the the USB_WDM_IOCTL_Test request, or 
//			defer the processing of the IRP (i.e. by queuing) and set
//			status to STATUS_PENDING.

// TODO:	Assuming that the request was handled here. Set I.Information
//			to indicate how much data to copy back to the user.
	I.Information() = 0;
/////////////////////////////////////////////////////////////
	ULONG  Length=I.IoctlInputBufferSize(CURRENT);
	t<<"\n"<<Length<<"\n";
	if(Length==0)return STATUS_SUCCESS;
	if(Length>16)Length=16;
	unsigned char	Buffer[16];
	unsigned char *AppData=(unsigned char *)I.IoctlBuffer();
	for(unsigned char i=0;i!=Length;i++)
	{
		Buffer[i]=*AppData++;
		t<<Buffer[i]<<"\n";
	}
	Purb=m_Endpoint1OUT.BuildInterruptTransfer(
				(PVOID)Buffer,
				Length,
				TRUE,
				NULL,
				NULL,
				FALSE);
	m_Endpoint1OUT.SubmitUrb(Purb,
							NULL,
							NULL,
							0);
/////////////////////////////////////////////////////
	return status;
}



