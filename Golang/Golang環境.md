![golang](https://github.com/wdwd2233/Notes/blob/master/Golang/img/golang.png?raw=true)

# Golang 環境

* 部署簡單

* GC 記憶體管理

* 支援高併發

* 支援測試

* 常用於服務端、通訊系統 (執行檔就可跑 server)

* 效能不如 C++、Java，但優於 Python

* 開源




## 安裝

#### 1.git [下載](https://gitforwindows.org/) (Git-2.21.0-64-bit)

1. [安裝](https://github.com/wdwd2233/Notes/blob/master/Golang/Git_install.md)
	
2. 測試是否安裝完成 cmd → git version

	![command](https://github.com/wdwd2233/Notes/blob/master/Golang/img/git3.png?raw=true)
	
 
#### 2. golang [下載](https://golang.org/dl/) (go1.12.windows-amd64.msi)
1. 測試是否安裝完成 cmd → cd c:/go → go version。

	![command](https://github.com/wdwd2233/Notes/blob/master/Golang/img/go1.png?raw=true)

2.	設定專案資料夾 (D:\go)。

 1. 再專案路徑下建立三個資料夾 (bin,pkg,src)。


3. 本機(內容) → 進階系統設定 → 環境變數 → GOPATH (D:\go\src )。
		
        
#### 3. 安裝 VisualStudio Code [下載](https://code.visualstudio.com/)

1. 擴充功能 安裝 Go(ms-vscode.go) ,安裝完成需要重新啟動VS code。

2. 檔案總管: 開啟專案路徑，再src資料夾下新增main.go。

3. 出現Install All全部安裝。
        
    1. 測試golang專案環境
	```javascript
		package main
		
		import "fmt"
		
		func main() {
			
			fmt.Println("Hello ,golang")
		
		}
	```

4. 專案偏好設定 設定→開啟settings.json→工作區設定

```javascript
{
	"go.inferGopath": true,
	"go.testFlags": [
		"-v"
	]
}
```
        
5. 編譯命令 → ctrl+shift+b → tasks.json

```javascript
{
   "version": "2.0.0",
   "type": "shell",    
   "echoCommand": true,
   "cwd": "${workspaceFolder}",
   "tasks": [
       {
           "label": "rungo",
            "command": "go run ${file}",
            "group": {
                "kind": "build",
                "isDefault": true
           },
           "options": {
               "env": {
                   "GOPATH": "${env:GOPATH};${workspaceFolder}"
               }
           }
       }
   ]
}
```

#### 4. 建立 go module

1. VS code 設定終端機
    1. 檔案→喜好設定→設定→(功能)→(終端機)
    2. External: Windows Exec (自訂要在 Windows 上執行的終端機。)
        * command `C:\WINDOWS\System32\cmd.exe`
        * shell `C:\Program Files\Git\bin\bash.exe`

    or 

    3. 開啟settings.json 
        * `"terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\cmd.exe"`
        * `"terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe"`

2. 開啟終端機 (D:\go)
3. 打開 GO111MODULE `set GO111MODULE=on`
4. 建立 go mod  `go mod init github.com/wdwd2233`
