# JavaScript


### 今日
```javascript
$('#btn-today').on('click', function (event) {
    event.preventDefault();
        var dt = new Date();
        var sdt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
        $('#sDate').val(sdt + ' 00:00:00');
        $('#eDate').val(sdt + ' 23:59:59');
});
```

### 昨日
```javascript
$('#btn-yesterday').on('click', function (event) {
        event.preventDefault();
       
    var dt = new Date();
        dt.setDate(dt.getDate() - 1);
    var sdt = dt.getFullYear().toString()
            + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
            + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#sDate').val(sdt + ' 00:00:00');
    $('#eDate').val(sdt + ' 23:59:59');
});
```

### 本周
```javascript
$('#btn-thisweek').on('click', function (event) {
    event.preventDefault();
		
    var dt = new Date();
    var edt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#eDate').val(edt + ' 23:59:59');
    var day = dt.getDay(),
        diff = dt.getDate() - day + (day == 0 ? -6 : 1); // adjust when day is sunday
        dt.setDate(diff);
    var sdt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#sDate').val(sdt + ' 00:00:00');
});
```
	
### 上周
```javascript
$('#btn-lastweek').on('click', function (event) {
        event.preventDefault();
		
    var dt = new Date();
    var day = dt.getDay(),
    diff = dt.getDate() - day + (day == 0 ? -6 : 1) - 7;
        dt.setDate(diff);
    var sdt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#sDate').val(sdt + ' 00:00:00');
        diff = dt.getDate() + 6;
        dt.setDate(diff);
    var edt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#eDate').val(edt + ' 23:59:59');
});
```
	
### 本月。
```javascript
$('#btn-thismonth').on('click', function (event) {
        event.preventDefault();
		
    var dt = new Date();
    dt = new Date(dt.getFullYear(), dt.getMonth(), 1);
    var sdt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#sDate').val(sdt + ' 00:00:00');
		dt = new Date(dt.getFullYear(), dt.getMonth() + 1, 0);
    var edt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#eDate').val(edt + ' 23:59:59');
});
```
### 上月
```javascript
$('#btn-lastmonth').on('click', function (event) {
        event.preventDefault();
		
    var dt = new Date();
        dt = new Date(dt.getFullYear(), dt.getMonth() - 1, 1);
    var sdt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#sDate').val(sdt + ' 00:00:00');
        dt = new Date();
        dt = new Date(dt.getFullYear(), dt.getMonth() - 1 + 1, 0);
    var edt = dt.getFullYear().toString()
        + '/' + (dt.getMonth() > 8 ? dt.getMonth() + 1 : '0' + (dt.getMonth() + 1).toString())
        + '/' + (dt.getDate() > 9 ? dt.getDate().toString() : '0' + dt.getDate().toString());
    $('#eDate').val(edt + ' 23:59:59');
});
```