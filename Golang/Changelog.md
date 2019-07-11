# [CE-Platform Changelog]


## Unreleased
- sp_MemberIDAccountGetList 增加權限。
- 推廣碼、推廣渠道機制重新設計。


## 1.1.2 - 2019-07-11

### Added
- [9-9] BackendGetMemberUseRecordList : 會員前台操作紀錄。

### Changed 
- [backend] : Account2ID第一次查不到後改用dbAgent.MemberIDbyAccount去查DB，如果有查到則反向加入Redis key Account2ID內。
- [backend] : a.client.HGet 排除掉 Error() != "redis: nil" 的logger。
- [11-2] BackendGetActivityList : ActivityID type 由int改為string。
- [11-6] BackendGetRewardOwnerList : 傳入參數增加Account 會員帳號。
- [11-7] BackendGetRewardMiningList : 傳入參數增加DAccount 會員帳號

### Fixed 
- [11-4] BackendGetActivityMod : 修正刪除PromotionImg會同步刪除CarouselImg的BUG。
***


## 1.1.1 - 2019-07-10

### Added
- [1-1] BackendLogin : 回傳增加Promotion(推廣碼)。
- [12-1] BackendGetActivityPromotionFile : 代理取得推廣碼、推廣網址及推廣底圖。(圖片使用Base64編碼)

### Fixed 
- [11-4] BackendGetActivityMod : 修正不能同時操作刪除照片及新增照片BUG。

### Changed 
- [11-4] BackendGetActivityMod : PromotionImg(推廣底圖)優化IO刪除操作。
***


## 1.1.0 - 2019-07-08

### Added
- [11-6] BackendGetRewardOwnerList : 擁有回饋金的玩家清單
- [11-7] BackendGetRewardMiningList : 會員礦機清單。
- [11-8] BackendGetMemberRewardList : 會員回饋金清單
- [backend] : Server OnStart Execution SetRedisMemberID(), Redis key Account2ID。
- [backend] : MemberIDbyAccount()改由Redis取得。


### Changed  
- [11-3] BackendGetActivityAdd : CarouselImg(輪播圖)限制上傳數量為1張。
- [11-3] BackendGetActivityAdd : PromotionImg(推廣底圖)限制上傳數量為5張。
***


## 1.0.5 - 2019-07-05

### Changed  
- [11-2] BackendGetActivityList	: server時間欄位time.Time → string，排序依開始時間由近至遠。
***


## 1.0.4 - 2019-07-05

### Added  
- [11-2] BackendGetActivityList	: 增加CarouselImg(輪播圖)及CarouselImg(推廣底圖)。
- [11-3] BackendGetActivityAdd : 傳入參數CarouselImg(輪播圖)、PromotionImg(推廣底圖)，PromotionImg支援多檔案上傳。
- [4-1] FrontendGetMemberRewardTotal : 玩家查詢回饋金總額
- [4-2] FrontendGetMemberReward : 玩家查詢回饋金
- [4-3] FrontendPostRewardReceive : 玩家領取回饋金
- [11-4] BackendGetActivityMod : PromotionImg(推廣底圖)、PromotionDel(刪除檔名)，、PromotionDel請以"，"串接(9886.jpg,9886.jpg,0886.jpg)

### Changed  
- [11-2] BackendGetActivityList	: 欄位FileName(string)更改為URL(string)。
- [11-3] BackendGetActivityAdd : HTTP Method 改為 POST/form-data。
- [11-4] BackendGetActivityMod : HTTP Method 改為 POST/form-data。
***


## 1.0.3 - 2019-07-04

### Added 
- [11-2] BackendGetActivityList	: 回傳參數CarouselImg(輪播圖)、PromotionImg(推廣底圖)。

### Changed  
- [11-2] BackendGetActivityList	: 傳入參數CurPageIndex(頁數)、RowCountPerPage(筆數)。
***


## 1.0.2 - 2019-07-04

### Added 
- [11-1] BackendGetActivitySetting	: 後台進入頁面時先載入相關設定。
- [11-2] BackendGetActivityList	: 後台活動列表，收尋條件ActivityID與ActivityName同時輸入，依ActivityID優先。
- [11-3] BackendGetActivityAdd	: 後台新增活動。
- [11-4] BackendGetActivityMod	: 後台修改活動。
- [11-5] BackendPostActivityModCarousel : 後台修改活動是否輪播。

### Deprecated 
- []  BackendPostInvitePermission : 之後會整合到權限管理內。 
***


## 1.0.1 - 2019-07-03

### Changed 
- [1-2] Promotion改為3位英文+4位數字，透過MemberID補足7碼後進行Format Preserving Encryption(10)，將前三碼再做一次FPE(26)後轉大寫，將轉大寫後的字母做偏移10個字母。
***


[9-9]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.gnvqo8ejd2al
[1-1]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.o0l5pxkfu5ik
[12-1]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.vo0czos23kc9
[11-6]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.202o0nvucrl
[11-7]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.pwft76vdrtnp
[11-8]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.ksp3iy7h6fjp
[1-2]: https://docs.google.com/document/d/10J9ECd5FsSVNzkz6w8pviuR9ibYLXyBUgJ7KE4otO-4/edit#heading=h.jfcuwps90r60
[11-1]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.sp1npcc63kb1
[11-2]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.b7mr1d8eswlo
[11-3]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.cin9lapulpky
[11-4]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.cfv594uez3kh
[11-5]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ/edit#heading=h.nf6g58awc94e
[4-1]: https://docs.google.com/document/d/10J9ECd5FsSVNzkz6w8pviuR9ibYLXyBUgJ7KE4otO-4/edit#heading=h.vgwg4gfiopgb
[4-2]: https://docs.google.com/document/d/10J9ECd5FsSVNzkz6w8pviuR9ibYLXyBUgJ7KE4otO-4/edit#heading=h.q5pu5ek7m2tu
[4-3]: https://docs.google.com/document/d/10J9ECd5FsSVNzkz6w8pviuR9ibYLXyBUgJ7KE4otO-4/edit#heading=h.o2m2mleh9bdp
[CE-Platform Changelog]: https://docs.google.com/document/d/1xzBjCcf-_380Nddc5yFbHkIv37iWltjYp8mebYQe0WQ
[backend]: http://www.dreammaker.game.tw/ceplatform/home1#/