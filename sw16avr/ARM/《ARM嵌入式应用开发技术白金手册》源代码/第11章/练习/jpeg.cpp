void CModem1Dlg::OpenJpg()                                  //ͨ��modemԶ�̲ɼ�ͼ��
{
	CDC *pDC;
	IPicture *pPic;                                                    
	IStream *pStm; 
	CFileStatus fstatus; 
	CFile file; 
	LONG cb; 			
	unsigned int i,j;
	DWORD temp;                                              //˫�ֽڱ���
	pDC=GetDC();
	if (file.Open(filename,CFile::modeRead)&&file.GetStatus(filename,fstatus)&&((cb = fstatus.m_size) != -1)) 
	{ 
		HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, cb); 
		LPVOID pvData = NULL; 
		if (hGlobal != NULL) 
		{ 
			if ((pvData = GlobalLock(hGlobal)) != NULL) 
			{ 
		  		file.ReadHuge(pvData, cb); 
		  		GlobalUnlock(hGlobal); 
		  		CreateStreamOnHGlobal(hGlobal, TRUE, &pStm); 
				if(SUCCEEDED(OleLoadPicture(pStm,fstatus.m_size,TRUE,IID_IPicture,(LPVOID* )&pPic))) 
		 		 { 
					OLE_XSIZE_HIMETRIC hmWidth;                                 //���
					OLE_YSIZE_HIMETRIC hmHeight;                                 //�߶�
					pPic->get_Width(&hmWidth); 
					pPic->get_Height(&hmHeight); 
					if(FAILED(pPic->Render(*pDC,20,26,CIFH,CIFW,0,hmHeight,hmWidth,-hmHeight,NULL)))
					AfxMessageBox("Failed To Render The picture!"); 
					for(i=0;i<CIFW;i++)
						for(j=0;j<CIFH;j++)
						{
							temp=pDC->GetPixel(20+j,26+i);
							pixel[((CIFW-i-1)*CIFH+j)*3+0]=GetBValue(temp);           //����ֵ
							pixel[((CIFW-i-1)*CIFH+j)*3+1]=GetGValue(temp);
							pixel[((CIFW-i-1)*CIFH+j)*3+2]=GetRValue(temp);
						}
						pPic->Release();				                 //�ͷ�
						pic.SetBitmapBits(CIFW*CIFH*3,pixel);                 
		      		} 
		      		else AfxMessageBox("Error Loading Picture From Stream!");   //�������ܲɼ�ͼ��
	      		 } 
		} 
	} 
	else AfxMessageBox("Can't Open Image File!"); 	             //�������ܴ�ͼ���ļ�
}
