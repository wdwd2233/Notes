

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


	// 新增 Microsoft.AspNetCore.Authentication.Cookies
    services.AddAuthentication("MyCookieAuthenticationScheme")
          .AddCookie("MyCookieAuthenticationScheme", options =>
      {
          options.AccessDeniedPath = "/Account/Forbidden/";
          options.LoginPath = "/Account/Login/";
      });

	// 建議作法
    //services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    //    .AddCookie(options =>
    //{
    //    options.AccessDeniedPath = "/Account/Forbidden/";
    //    options.LoginPath = "/Account/Login/";
    //});

	 
}

public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
	// 新增 Authentication 
    app.UseAuthentication();
	
	
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
		// 新增
		var identity = new ClaimsIdentity("Account");
        identity.AddClaim(new Claim(ClaimTypes.Name, model.Account));
        ClaimsPrincipal principal = new ClaimsPrincipal(identity);
        await HttpContext.SignInAsync("MyCookieAuthenticationScheme", principal);

		// 建議作法
        //var identity = new ClaimsIdentity(CookieAuthenticationDefaults.AuthenticationScheme);
        //identity.AddClaim(new Claim(ClaimTypes.Name, model.Account));
        //await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(identity));

		
		
		return View();
	}
}
```

 4. 需要驗證的頁面
 
```javascript
namespace Example.Controllers
{
    [Authorize]
    public class ExampleController : Controller
    {
	
        public async Task<ActionResult> Index()
        {
            return View();
        }

    
    }
} 
```
