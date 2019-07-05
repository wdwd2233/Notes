# [CE-Platform Changelog]


## Unreleased
- [11-3] BackendGetActivityAdd : CarouselImg(輪播圖)限制上傳數量。
- [11-4] BackendGetActivityMod : 更改底圖。

## 1.0.4 - 2019-07-05

### Added  
- [11-2] BackendGetActivityList	: 增加CarouselImg(輪播圖)及CarouselImg(推廣底圖)。
- [11-3] BackendGetActivityAdd : 傳入參數CarouselImg(輪播圖)、PromotionImg(推廣底圖)，PromotionImg支援多檔案上傳。
- [4-1] FrontendGetMemberRewardTotal : 玩家查詢回饋金總額
- [4-2] FrontendGetMemberReward : 玩家查詢回饋金
- [4-3] FrontendPostRewardReceive : 玩家領取回饋金


### Changed  
- [11-2] BackendGetActivityList	: 欄位FileName(string)更改為URL(string)。
- [11-3] BackendGetActivityAdd : HTTP Method 改為 POST/form-data。



## 1.0.3 - 2019-07-04

### Added 
- [11-2] BackendGetActivityList	: 回傳參數CarouselImg(輪播圖)、PromotionImg(推廣底圖)。

### Changed  
- [11-2] BackendGetActivityList	: 傳入參數CurPageIndex(頁數)、RowCountPerPage(筆數)。


## 1.0.2 - 2019-07-04

### Added 
- [11-1] BackendGetActivitySetting	: 後台進入頁面時先載入相關設定。
- [11-2] BackendGetActivityList	: 後台活動列表，收尋條件ActivityID與ActivityName同時輸入，依ActivityID優先。
- [11-3] BackendGetActivityAdd	: 後台新增活動。
- [11-4] BackendGetActivityMod	: 後台修改活動。
- [11-5] BackendPostActivityModCarousel : 後台修改活動是否輪播。

### Deprecated 
- []  BackendPostInvitePermission : 之後會整合到權限管理內。 


## 1.0.1 - 2019-07-03

### Changed 
- [1-2] Promotion改為3位英文+4位數字，透過MemberID補足7碼後進行Format Preserving Encryption(10)，將前三碼再做一次FPE(26)後轉大寫，將轉大寫後的字母做偏移10個字母。
	

[CE-Platform Changelog]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ
[1-2]: https://docs.google.com/document/d/10J9ECd5FsSVNzkz6w8pviuR9ibYLXyBUgJ7KE4otO-4/edit#heading=h.jfcuwps90r60
[11-1]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.sp1npcc63kb1
[11-2]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.b7mr1d8eswlo
[11-3]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.cin9lapulpky
[11-4]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.cfv594uez3kh
[11-5]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.nf6g58awc94e
