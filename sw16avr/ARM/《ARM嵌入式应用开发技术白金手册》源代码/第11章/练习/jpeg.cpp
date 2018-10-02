void CModem1Dlg::OpenJpg()                                  //通过modem远程采集图像
{
	CDC *pDC;
	IPicture *pPic;                                                    
	IStream *pStm; 
	CFileStatus fstatus; 
	CFile file; 
	LONG cb; 			
	unsigned int i,j;
	DWORD temp;                                              //双字节变量
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
					OLE_XSIZE_HIMETRIC hmWidth;                                 //宽度
					OLE_YSIZE_HIMETRIC hmHeight;                                 //高度
					pPic->get_Width(&hmWidth); 
					pPic->get_Height(&hmHeight); 
					if(FAILED(pPic->Render(*pDC,20,26,CIFH,CIFW,0,hmHeight,hmWidth,-hmHeight,NULL)))
					AfxMessageBox("Failed To Render The picture!"); 
					for(i=0;i<CIFW;i++)
						for(j=0;j<CIFH;j++)
						{
							temp=pDC->GetPixel(20+j,26+i);
							pixel[((CIFW-i-1)*CIFH+j)*3+0]=GetBValue(temp);           //象素值
							pixel[((CIFW-i-1)*CIFH+j)*3+1]=GetGValue(temp);
							pixel[((CIFW-i-1)*CIFH+j)*3+2]=GetRValue(temp);
						}
						pPic->Release();				                 //释放
						pic.SetBitmapBits(CIFW*CIFH*3,pixel);                 
		      		} 
		      		else AfxMessageBox("Error Loading Picture From Stream!");   //报错：不能采集图形
	      		 } 
		} 
	} 
	else AfxMessageBox("Can't Open Image File!"); 	             //报错：不能打开图像文件
}
