

![](https://github.com/wdwd2233/Notes/blob/master/ASP.NET%20Core/img/netcorelogo.png?raw=true)


## 1. 取得client IP

 1. 注入服務 Startup.cs

```javascript
public void ConfigureServices(IServiceCollection services)
{
    services.Configure<CookiePolicyOptions>(options =>
    {
        // This lambda determines whether user consent for non-essential cookies is needed for a given request.
        options.CheckConsentNeeded = context => true;
        options.MinimumSameSitePolicy = SameSiteMode.None;
    });

    services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

    // 新增
    services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
}
```

 2. 改寫 Controller

```javascript
public class AccountController : Controller
{
	// 新增
	private IHttpContextAccessor _accessor;

	// 新增
	public AccountController(IHttpContextAccessor accessor)
	{
		_accessor = accessor;
	}

	public IActionResult Index()
	{
		// 取得client IP
		string IP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
		
		return View();
	}
}
```

## 2. 取得瀏覽器版本 IP位置
    
 1.  使用UserAgent 取得，先將[UserAgent](https://github.com/wdwd2233/Notes/blob/master/ASP.NET%20Core/UserAgent.rar) 導入專案。 
```javascript
public class AccountController : Controller
{
	public IActionResult Index()
	{
		// 取得client瀏覽器、版本
		UserAgent Agent = new UserAgent(Request.Headers["User-Agent"]);
		string Browser = Agent.Browser.Name + " " + Agent.Browser.Version;
	
	return View();
	}
}
```
	
一个在线编辑markdown文档的编辑器

向Mac下优秀的markdown编辑器mou致敬

##MaHua有哪些功能？

* 方便的`导入导出`功能
    *  直接把一个markdown的文本文件拖放到当前这个页面就可以了
    *  导出为一个html格式的文件，样式一点也不会丢失
* 编辑和预览`同步滚动`，所见即所得（右上角设置）
* `VIM快捷键`支持，方便vim党们快速的操作 （右上角设置）
* 强大的`自定义CSS`功能，方便定制自己的展示
* 有数量也有质量的`主题`,编辑器和预览区域
* 完美兼容`Github`的markdown语法
* 预览区域`代码高亮`
* 所有选项自动记忆

##有问题反馈
在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流

* 邮件(dev.hubo#gmail.com, 把#换成@)
* QQ: 287759234
* weibo: [@草依山](http://weibo.com/ihubo)
* twitter: [@ihubo](http://twitter.com/ihubo)

##捐助开发者
在兴趣的驱动下,写一个`免费`的东西，有欣喜，也还有汗水，希望你喜欢我的作品，同时也能支持一下。
当然，有钱捧个钱场（右上角的爱心标志，支持支付宝和PayPal捐助），没钱捧个人场，谢谢各位。

##感激
感谢以下的项目,排名不分先后

* [mou](http://mouapp.com/) 
* [ace](http://ace.ajax.org/)
* [jquery](http://jquery.com)

##关于作者

```javascript
  var ihubo = {
    nickName  : "草依山",
    site : "http://jser.me"
  }
```