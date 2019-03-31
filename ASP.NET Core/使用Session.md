

![](https://github.com/wdwd2233/Notes/blob/master/ASP.NET%20Core/img/netcorelogo.png?raw=true)


## 1. 使用 Session 

 1. 新增NuGet
 
```javascript
Microsoft.AspNetCore.Session
Microsoft.AspNetCore.Http.Extensions
```
 
 2. 注入服務 Startup.cs

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

    // 新增 將 Session 存在 ASP.NET Core 記憶體中
    services.AddDistributedMemoryCache();
    services.AddMemoryCache();
    services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
    services.AddHttpContextAccessor();
    services.AddSession(options =>
    {
        //設定時間(30分鐘)
        options.IdleTimeout = TimeSpan.FromMinutes(3000);
    });
    services.Configure<CookieTempDataProviderOptions>(options =>
    {
        //Tempdata 提供者和工作階段狀態的 cookie 
        options.Cookie.IsEssential = true;
    });
	
	 
}

public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
	// 新增 Microsoft.AspNetCore.Session
    app.UseSession();
	
	app.UseMvc(routes =>
       {
           routes.MapRoute(
               name: "default",
               template: "{controller=Home}/{action=Index}/{id?}");
       });
}
```

 3. 改寫 Controller 。

```javascript
public class AccountController : Controller
{
	public IActionResult Index()
	{
		//新增 寫入 Session
		HttpContext.Session.SetString("Account", model.Account);
		HttpContext.Session.SetInt32("AccountID", model.AccountID);
		
		//新英 讀取 
		string Account = HttpContext.Session.GetString("Account");
        int? AccountID = HttpContext.Session.GetInt32("AccountID");
		
		
		return View();
	}
}
```

