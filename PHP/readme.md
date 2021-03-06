
![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/php.png?raw=true)


## [PHP](https://windows.php.net/)

1. PHP是一種開源的通用電腦手稿語言，尤其適用於網路開發並可嵌入HTML中使用。
2. PHP的語法借鑑吸收C語言、Java和Perl等流行電腦語言的特點，易於一般程式設計師學習。
3. PHP的主要目標是允許網路開發人員快速編寫動態頁面，但PHP也被用於其他很多領域。

4. [下載](https://windows.php.net/download/)

	1. 路徑 `C:\php-7.3.9`

5. iis 是使用 FastCGI 的方式執行 PHP ，所以需要下載 `None Thread Safe`(NTS，非線程安全)的版本效率較好。
6. apache、nginx 是使用 SAPI 的方式執行 PHP ，所以建議下載 `Thread Safe`(TS，線程安全)的版本效率較好。

## Internet Information Services(IIS)部屬 PHP

1. Internet Information Services → World Wide Web 服務 → 應用程式開發功能 → CGI [v] 。

2. 左側選單 站台 → Default Web Site → 處理常式對應 → 新增模組對應 。

3. 要求路徑: `*.php` 、  模組: `FastCgiModule` 、執行檔: `C:\php-7.3.9\php-cgi.exe` 、名稱: `PHP via FastCGI` 。

4. 側選單 站台 → Default Web Site → 預設文件 → 新增 `index.php` 。

5. 重新啟動 Internet Information Services `iisreset /restart` 。


## [Composer 管理工具](https://getcomposer.org/)

![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/composer.png?raw=true)

1. Composer是PHP的軟體包管理系統，由Nils Adermann及Jordi Boggiano提出並實做，於2012年3月1日發行第一個版本。

2. [下載](https://getcomposer.org/Composer-Setup.exe)

3. 安裝 
	 * step.1 勾選 開發者模式

		![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/1583004775531.jpg?raw=true)

	 * step.2 安裝目錄 `C:\composer`

		![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/1583004821347.jpg?raw=true)

	 * step.3 預設 PHP 執行檔 位置 `C:\php-7.3.11-nts`

		![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/1583004832881.jpg?raw=true)

	 * step.4 不用設定

		![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/1583004844032.jpg?raw=true)

	* step.5 安裝完成後重開機，終端機上面打composer檢查是否安裝成功。

		![](https://github.com/wdwd2233/Notes/blob/master/PHP/images/1583004898703.jpg?raw=true)


## [Laravel 框架](https://laravel.tw/docs/4.2/quick)

1. terminal 進入 工作目錄(D:\WorkPlace\Laravel\VAWebsite)  。

2. 創建新專案 → 運行 `composer create-project laravel/laravel VAWebsite --prefer-dist` 。

3. 運行專案  → `php artisan serve` 。

## Redis dll 

1. [下載](https://pecl.php.net/package/redis)
