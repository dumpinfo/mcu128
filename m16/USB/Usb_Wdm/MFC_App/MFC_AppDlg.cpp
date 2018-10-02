// MFC_AppDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MFC_App.h"
#include "MFC_AppDlg.h"

#include <windows.h>

#include <winioctl.h>

#include "..\Usb_Wdmioctl.h"

#include "..\Usb_WdmDeviceinterface.h"	// Has class GUID definition

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


// This function is found in module OpenByIntf.cpp
HANDLE OpenByInterface(GUID* pClassGuid, DWORD instance, PDWORD pError);
GUID ClassGuid = Usb_WdmDevice_CLASS_GUID;
/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMFC_AppDlg dialog

CMFC_AppDlg::CMFC_AppDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMFC_AppDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMFC_AppDlg)
	m_shuma0 = _T("");
	m_shuma1 = _T("");
	m_shuma2 = _T("");
	m_shuma3 = _T("");
	m_shuma4 = _T("");
	m_shuma5 = _T("");
	m_message = _T("");
	m_key0 = FALSE;
	m_key1 = FALSE;
	m_key2 = FALSE;
	m_key3 = FALSE;
	m_key4 = FALSE;
	m_key5 = FALSE;
	m_key6 = FALSE;
	m_key7 = FALSE;
	m_led0 = FALSE;
	m_led1 = FALSE;
	m_led2 = FALSE;
	m_led3 = FALSE;
	m_led4 = FALSE;
	m_led5 = FALSE;
	m_led6 = FALSE;
	m_led7 = FALSE;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMFC_AppDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMFC_AppDlg)
	DDX_Text(pDX, IDC_EDIT_SHUMA0, m_shuma0);
	DDX_Text(pDX, IDC_EDIT_SHUMA1, m_shuma1);
	DDX_Text(pDX, IDC_EDIT_SHUMA2, m_shuma2);
	DDX_Text(pDX, IDC_EDIT_SHUMA3, m_shuma3);
	DDX_Text(pDX, IDC_EDIT_SHUMA4, m_shuma4);
	DDX_Text(pDX, IDC_EDIT_SHUMA5, m_shuma5);
	DDX_Text(pDX, IDC_EDIT_Message, m_message);
	DDX_Check(pDX, IDC_CHECK_KEY0, m_key0);
	DDX_Check(pDX, IDC_CHECK_KEY1, m_key1);
	DDX_Check(pDX, IDC_CHECK_KEY2, m_key2);
	DDX_Check(pDX, IDC_CHECK_KEY3, m_key3);
	DDX_Check(pDX, IDC_CHECK_KEY4, m_key4);
	DDX_Check(pDX, IDC_CHECK_KEY5, m_key5);
	DDX_Check(pDX, IDC_CHECK_KEY6, m_key6);
	DDX_Check(pDX, IDC_CHECK_KEY7, m_key7);
	DDX_Check(pDX, IDC_CHECK_LED0, m_led0);
	DDX_Check(pDX, IDC_CHECK_LED1, m_led1);
	DDX_Check(pDX, IDC_CHECK_LED2, m_led2);
	DDX_Check(pDX, IDC_CHECK_LED3, m_led3);
	DDX_Check(pDX, IDC_CHECK_LED4, m_led4);
	DDX_Check(pDX, IDC_CHECK_LED5, m_led5);
	DDX_Check(pDX, IDC_CHECK_LED6, m_led6);
	DDX_Check(pDX, IDC_CHECK_LED7, m_led7);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMFC_AppDlg, CDialog)
	//{{AFX_MSG_MAP(CMFC_AppDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_EN_CHANGE(IDC_EDIT_SHUMA0, OnChangeEditShuma)
	ON_BN_CLICKED(IDC_CHECK_LED0, OnCheckLed)
	ON_EN_CHANGE(IDC_EDIT_SHUMA1, OnChangeEditShuma)
	ON_EN_CHANGE(IDC_EDIT_SHUMA2, OnChangeEditShuma)
	ON_EN_CHANGE(IDC_EDIT_SHUMA3, OnChangeEditShuma)
	ON_EN_CHANGE(IDC_EDIT_SHUMA4, OnChangeEditShuma)
	ON_EN_CHANGE(IDC_EDIT_SHUMA5, OnChangeEditShuma)
	ON_BN_CLICKED(IDC_CHECK_LED1, OnCheckLed)
	ON_BN_CLICKED(IDC_CHECK_LED2, OnCheckLed)
	ON_BN_CLICKED(IDC_CHECK_LED3, OnCheckLed)
	ON_BN_CLICKED(IDC_CHECK_LED4, OnCheckLed)
	ON_BN_CLICKED(IDC_CHECK_LED5, OnCheckLed)
	ON_BN_CLICKED(IDC_CHECK_LED6, OnCheckLed)
	ON_BN_CLICKED(IDC_CHECK_LED7, OnCheckLed)
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMFC_AppDlg message handlers

BOOL CMFC_AppDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here

	CEdit *pedit=(CEdit *)GetDlgItem(IDC_EDIT_SHUMA0);
	pedit->SetLimitText(1);
	pedit=(CEdit *)GetDlgItem(IDC_EDIT_SHUMA1);
	pedit->SetLimitText(1);
	pedit=(CEdit *)GetDlgItem(IDC_EDIT_SHUMA2);
	pedit->SetLimitText(1);
	pedit=(CEdit *)GetDlgItem(IDC_EDIT_SHUMA3);
	pedit->SetLimitText(1);	
	pedit=(CEdit *)GetDlgItem(IDC_EDIT_SHUMA4);
	pedit->SetLimitText(1);
	pedit=(CEdit *)GetDlgItem(IDC_EDIT_SHUMA5);
	pedit->SetLimitText(1);	
	
	unsigned char i;
	for(i=0;i!=7;i++)ShuMa[i]=0;
	
/////////////////////////////////////////////////////
	hDevice = INVALID_HANDLE_VALUE;


	DWORD	Error;
	hDevice = OpenByInterface( &ClassGuid, 0, &Error);
	if (hDevice == INVALID_HANDLE_VALUE)
	{
		m_message.Format("ERROR opening device: (%0x) returned from CreateFile\n", GetLastError());
	}
	else
	{
		m_message.Format("Device found, handle open.\n");
		UpdateData(FALSE);
	}
	SetTimer(1,100,NULL);
	UpdateData(FALSE);
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMFC_AppDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMFC_AppDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMFC_AppDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CMFC_AppDlg::OnChangeEditShuma() 
{
	// TODO: If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.
	
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	if(m_shuma0.GetLength()!=0)ShuMa[0]=m_shuma0.GetAt(0)-'0';
	if(m_shuma1.GetLength()!=0)ShuMa[1]=m_shuma1.GetAt(0)-'0';
	if(m_shuma2.GetLength()!=0)ShuMa[2]=m_shuma2.GetAt(0)-'0';
	if(m_shuma3.GetLength()!=0)ShuMa[3]=m_shuma3.GetAt(0)-'0';
	if(m_shuma4.GetLength()!=0)ShuMa[4]=m_shuma4.GetAt(0)-'0';
	if(m_shuma5.GetLength()!=0)ShuMa[5]=m_shuma5.GetAt(0)-'0';
//////////////////////////////////////////////////////////////////////
	CHAR	bufOutput[16];	// Output from device
	ULONG	nOutput;						// Count written to bufOutput
	// Call device IO Control interface (USB_WDM_IOCTL_Test) in driver
	if (!DeviceIoControl(hDevice,
						 USB_WDM_IOCTL_Test,
						 ShuMa,
						 7,
						 bufOutput,
						 16,
						 &nOutput,
						 NULL)
	   )
	{
		m_message.Format("ERROR: DeviceIoControl returns %0x.", GetLastError());
		UpdateData(FALSE);
	}


}

void CMFC_AppDlg::OnCheckLed() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	ShuMa[6]=0;
	if(m_led0==1)ShuMa[6]+=	0x01;
	if(m_led1==1)ShuMa[6]+=	0x02;
	if(m_led2==1)ShuMa[6]+=	0x04;
	if(m_led3==1)ShuMa[6]+=	0x08;
	if(m_led4==1)ShuMa[6]+=	0x10;
	if(m_led5==1)ShuMa[6]+=	0x20;
	if(m_led6==1)ShuMa[6]+=	0x40;
	if(m_led7==1)ShuMa[6]+=	0x80;
///////////////////////////////////
	CHAR	bufOutput[16];	// Output from device
	ULONG	nOutput;						// Count written to bufOutput
	// Call device IO Control interface (USB_WDM_IOCTL_Test) in driver
	if (!DeviceIoControl(hDevice,
						 USB_WDM_IOCTL_Test,
						 ShuMa,
						 7,
						 bufOutput,
						 16,
						 &nOutput,
						 NULL)
	   )
	{
		m_message.Format("ERROR: DeviceIoControl returns %0x.", GetLastError());
		UpdateData(FALSE);
	}

}

void CMFC_AppDlg::OnTimer(UINT nIDEvent) 
{
	// TODO: Add your message handler code here and/or call default
	ULONG	nRead;
	unsigned char key=0xff;
	ReadFile(hDevice, &key, 1, &nRead, NULL);
	key&=0xff;

	m_key0=key%2;key>>=1;
	m_key1=key%2;key>>=1;
	m_key2=key%2;key>>=1;
	m_key3=key%2;key>>=1;
	m_key4=key%2;key>>=1;
	m_key5=key%2;key>>=1;
	m_key6=key%2;key>>=1;
	m_key7=key%2;
	UpdateData(FALSE);
	CDialog::OnTimer(nIDEvent);
}
