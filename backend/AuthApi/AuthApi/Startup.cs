using System.Reflection;
using System.Text;
using MediatR;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

using AuthApi.Domain;
using AuthApi.Application;
using AuthApi.Infrastructure;
using Microsoft.AspNetCore.Authentication;

namespace AuthApi
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services.AddMediatR(Assembly.GetExecutingAssembly());
            services.AddMediatR(typeof(LoginCommand).GetTypeInfo().Assembly);
            services.AddMediatR(typeof(RegisterCommand).GetTypeInfo().Assembly);
            services.AddMediatR(typeof(RegisterAdminCommand).GetTypeInfo().Assembly);

            services.AddHttpClient();

            DatabaseSettings dbSettings = Configuration.GetSection("Database").Get<DatabaseSettings>();
            string connectionString = $"Server={dbSettings.Server},{dbSettings.Port};Initial Catalog={dbSettings.Name};User={dbSettings.User};Password={dbSettings.Password}";
            
            // For Entity Framework  
            services.AddDbContext<AuthContext>(options => options.UseSqlServer(connectionString, x => x.MigrationsAssembly("AuthApi.Infrastructure")));

            // For Identity  
            services.AddIdentity<ApplicationUser, IdentityRole>()  
                .AddEntityFrameworkStores<AuthContext>()  
                .AddDefaultTokenProviders();  

            services.AddScoped<IFacebookAuthenticationService, FacebookAuthenticationService>();
            services.AddScoped<IGoogleAuthenticationService, GoogleAuthenticationService>();
            services.AddScoped<ITokenGenerator, TokenGenerator>();
            services.Configure<FacebookAuthSettings>(Configuration.GetSection("Facebook"));  
            services.Configure<FacebookAuthSettings>(Configuration.GetSection("Google"));  

            // Add Facebook auth
            FacebookAuthSettings facebookAuth = Configuration.GetSection("Facebook").Get<FacebookAuthSettings>();
            if (facebookAuth != null)
            {
                services.AddAuthentication().AddFacebook(facebookOptions => 
                {
                    facebookOptions.AppId = facebookAuth.AppId;
                    facebookOptions.AppSecret = facebookAuth.AppSecret;
                });
            }

            // Add Google auth
            GoogleAuthSettings googleAuth = Configuration.GetSection("Google").Get<GoogleAuthSettings>();
            if (googleAuth != null)
            {
                services.AddAuthentication().AddGoogle(googleOptions =>
                {
                    googleOptions.ClientId = googleAuth.ClientId;
                    googleOptions.ClientSecret = googleAuth.ClientSecret;
                });
            }

            // Adding Jwt Bearer settings for authentication
            JwtSettings jwtSettings = Configuration.GetSection("JWT").Get<JwtSettings>();
            if (jwtSettings != null)
            {       
                services.AddAuthentication(options =>  
                {  
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;  
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;  
                    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;  
                }).AddJwtBearer(options =>  
                {  
                    options.SaveToken = true;  
                    options.RequireHttpsMetadata = false;  
                    options.TokenValidationParameters = new TokenValidationParameters()  
                    {  
                        ValidateIssuer = true,  
                        ValidateAudience = true,  
                        ValidAudience = jwtSettings.ValidAudience,  
                        ValidIssuer = jwtSettings.ValidIssuer,  
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.Secret))  
                    };  
                }); 
            }

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "AuthApi", Version = "v1" });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "AuthApi v1"));
            }

            app.UseHttpsRedirection();

            app.UseRouting();
  
            app.UseAuthentication();  
            app.UseAuthorization();  

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
