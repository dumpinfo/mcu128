// MFC_AppDlg.h : header file
//
#include <windows.h>
#include <winioctl.h>
#if !defined(AFX_MFC_APPDLG_H__1C602FF5_41A5_4606_811D_BAF701A3AA23__INCLUDED_)
#define AFX_MFC_APPDLG_H__1C602FF5_41A5_4606_811D_BAF701A3AA23__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CMFC_AppDlg dialog

class CMFC_AppDlg : public CDialog
{
// Construction
public:
	CMFC_AppDlg(CWnd* pParent = NULL);	// standard constructor
// Handle to device opened in driver.
//
	HANDLE	hDevice ;

// Class GUID used to open device
//

//////////////////////////////////////////////////
	unsigned char ShuMa[7];
// Dialog Data
	//{{AFX_DATA(CMFC_AppDlg)
	enum { IDD = IDD_MFC_APP_DIALOG };
	CString	m_shuma0;
	CString	m_shuma1;
	CString	m_shuma2;
	CString	m_shuma3;
	CString	m_shuma4;
	CString	m_shuma5;
	CString	m_message;
	BOOL	m_key0;
	BOOL	m_key1;
	BOOL	m_key2;
	BOOL	m_key3;
	BOOL	m_key4;
	BOOL	m_key5;
	BOOL	m_key6;
	BOOL	m_key7;
	BOOL	m_led0;
	BOOL	m_led1;
	BOOL	m_led2;
	BOOL	m_led3;
	BOOL	m_led4;
	BOOL	m_led5;
	BOOL	m_led6;
	BOOL	m_led7;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMFC_AppDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CMFC_AppDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnChangeEditShuma();
	afx_msg void OnCheckLed();
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MFC_APPDLG_H__1C602FF5_41A5_4606_811D_BAF701A3AA23__INCLUDED_)
