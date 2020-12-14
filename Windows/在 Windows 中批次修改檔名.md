
# PowerShell

1. Windows 的 PowerShell 的功能比命令提示字元還要強大，他可以使用管（pipe）的功能將多個指令結合起來使用，就像在 Linux shell 中一樣。


	1. 假設我沒有一些檔案，檔名中包含許多空白，以下示範將所有檔案名稱中的空白字元置換為減號（-）。
	```powershell
	Dir | Rename-Item -NewName { $_.name -replace " ", "-" }
	```

	2. 把所有的 JPG 檔案重新命名為 image_編號.jpg
	```powershell
	Get-ChildItem *.jpg | ForEach-Object -Begin {
		$count = 1
	} -Process {
		Rename-Item $_ -NewName "image_$count.jpg"
		$count++
	}
	```

	3. 將所有 *.jpeg 檔案的副檔名改為 jpg
	```powershell
	Get-ChildItem *.jpeg | Rename-Item -NewName {
		[System.IO.Path]::ChangeExtension($_.Name, ".jpg")
	}
	```

	4. 從所有的 *.jpg 檔案中，找出含有 oldstring 字眼的檔案，把 oldstring 改為 newstring
	```powershell
	Get-ChildItem *.jpg -Filter "*oldstring*" | ForEach {
		Rename-Item $_ -NewName $_.Name.Replace("oldstring","newstring")
	}	
	```