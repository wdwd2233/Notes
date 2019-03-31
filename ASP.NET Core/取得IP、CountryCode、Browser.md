

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
    
 1. 使用UserAgent 取得，先將[UserAgent](https://github.com/wdwd2233/Notes/blob/master/ASP.NET%20Core/library/UserAgent.rar) 導入專案。 
 2. 繼承 改寫 Controller
 
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
	
	
## 3. 取得IP CountryCode

	1. 使用 IPCountryFinder 取得，先將[IPCountryFinder](https://github.com/wdwd2233/Notes/blob/master/ASP.NET%20Core/library/IPCountryFinder.cs) 導入專案。
	2. 繼承 改寫 Controller
	
```javascript
public class AccountController : Controller
{
	// 新增
	 private readonly IHostingEnvironment _hostingEnvironment;

	// 新增
	public AccountController(IHostingEnvironment hostingEnvironment)
	{
		_hostingEnvironment = hostingEnvironment;
	}

	public IActionResult Index()
	{
		// 宣告 
		string DirPath = "",
		// 取得網站根目錄
		DirPath = Path.Combine(_hostingEnvironment.WebRootPath);
		// 讀取IP 國別對應資料
		Originalfile = Path.Combine(DirPath, "IpToCountry.csv");
		// 宣告使用IPCountryFinder類別
		IPCountryFinder IPArea = new IPCountryFinder(Originalfile
		// 實作
		string CountryCode = IPArea.GetCountryCode("220.134.132.79");
		
		return View();
	}
}
```
