// MFC_App.h : main header file for the MFC_APP application
//

#if !defined(AFX_MFC_APP_H__712C9C8A_66EB_4B93_80A4_CA3BB94CC64F__INCLUDED_)
#define AFX_MFC_APP_H__712C9C8A_66EB_4B93_80A4_CA3BB94CC64F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CMFC_AppApp:
// See MFC_App.cpp for the implementation of this class
//

class CMFC_AppApp : public CWinApp
{
public:
	CMFC_AppApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMFC_AppApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CMFC_AppApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MFC_APP_H__712C9C8A_66EB_4B93_80A4_CA3BB94CC64F__INCLUDED_)
