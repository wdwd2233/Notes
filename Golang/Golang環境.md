![golang](https://github.com/wdwd2233/Notes/blob/master/Golang/img/golang.png?raw=true)

# Golang 環境

* 部署簡單

* GC 記憶體管理

* 支援高併發

* 支援測試

* 常用於服務端、通訊系統 (執行檔就可跑 server)

* 效能不如 C++、Java，但優於 Python

* 開源




## 安裝 ##

#### 1.git [下載](https://gitforwindows.org/) (Git-2.21.0-64-bit) ####

1. 測試是否安裝完成 cmd → git version
	
 
####2. golang [下載](https://golang.org/dl/) (go1.12.windows-amd64.msi)
1. 測試是否安裝完成 cmd → cd c:/go → go version。

2.	設定專案資料夾 (E:\GitHub\golang\Main)。

 1. 再專案路徑下建立三個資料夾 (bin,pkg,src)。


3. 本機(內容) → 進階系統設定 → 環境變數 → GOPATH (E:\GitHub\golang\Main )。
		
        
####3. 安裝 VisualStudio Code [下載](https://code.visualstudio.com/)

1. 擴充功能 安裝 Go(ms-vscode.go) ,安裝完成需要重新啟動VS code。

2. 檔案總管: 開啟專案路徑，再src資料夾下新增main.go。

3. 出現Install All全部安裝。
        
    1. 測試golang專案環境
```javascript
	package main
    
    import "fmt"
    
    func main() {
        
        fmt.Println("Hello ，世界")
    
    }
```
4.	專案偏好設定 設定→開啟settings.json→工作區設定

```javascript
{
			"go.inferGopath": true,
			"go.testFlags": [
				"-v"
			]
}```
        
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

