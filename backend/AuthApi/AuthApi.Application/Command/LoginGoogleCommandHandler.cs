using System;
using System.IdentityModel.Tokens.Jwt;
using System.Threading;
using System.Threading.Tasks;
using AuthApi.Domain;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;

namespace AuthApi.Application
{
    public class LoginGoogleCommand : IRequest<JwtSecurityToken>
    {
        public string Token { get; private set; }  
        public string Provider { get; private set; }

        public LoginGoogleCommand(string token, string provider)
        {
            Token = token;
            Provider = provider;
        }
    }

    public interface ILoginGoogleCommandHandler : IRequestHandler<LoginGoogleCommand, JwtSecurityToken>
    {
    }

    public class LoginGoogleCommandHandler : ILoginGoogleCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private IGoogleAuthenticationService _googleAuthenticationService;
        private readonly ITokenGenerator _tokenGenerator;  

        public LoginGoogleCommandHandler(
            UserManager<ApplicationUser> userManager, 
            IGoogleAuthenticationService googleAuthenticationService,
            ITokenGenerator tokenGenerator)
        {
            _tokenGenerator = tokenGenerator;
            _userManager = userManager;
            _googleAuthenticationService = googleAuthenticationService;
        }

        /// <summary>
        /// Login with google token. If user is not created then create new without password
        /// </summary>
        public async Task<JwtSecurityToken> Handle(LoginGoogleCommand request, CancellationToken cancellationToken)
        {
            var validationTokenResult =  await _googleAuthenticationService.VerifyGoogleToken(request.Token);

            if (validationTokenResult == null)
            {
                throw new InvalidTokenException();
            }

            var userInfo = new UserLoginInfo(request.Provider, validationTokenResult.Subject, request.Provider);
            
            var user = await _userManager.FindByLoginAsync(userInfo.LoginProvider, userInfo.ProviderKey);

            if (user == null)
            {
                user = await _userManager.FindByEmailAsync(validationTokenResult.Email);

                if (user == null)
                {
                    user = new ApplicationUser 
                    { 
                        Id = Guid.NewGuid().ToString(),
                        Email = validationTokenResult.Email, 
                        UserName = validationTokenResult.Email 
                    };

                    await _userManager.CreateAsync(user);

                    // Prepare and send an email for the email confirmation
                    await _userManager.AddToRoleAsync(user, "Viewer");
                    await _userManager.AddLoginAsync(user, userInfo);
                }
                else
                {
                    await _userManager.AddLoginAsync(user, userInfo);
                }
            }
            if (user == null)
            {
                // return BadRequest("Invalid External Authentication.");
            }

            //check for the Locked out account
            return await _tokenGenerator.GenerateTokenForUserAsync(user);
        }
    }
}