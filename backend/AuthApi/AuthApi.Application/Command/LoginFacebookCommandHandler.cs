using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

using AuthApi.Domain;

namespace AuthApi.Application
{
    public class LoginFacebookCommand : IRequest<JwtSecurityToken>
    {
        public string Token { get; set; }  

        public LoginFacebookCommand(string token)
        {
            Token = token;
        }
    }
    
    public interface ILoginFacebookCommandHandler : IRequestHandler<LoginFacebookCommand, JwtSecurityToken>
    {
    }

    public class LoginFacebookCommandHandler : ILoginFacebookCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private readonly IFacebookAuthenticationService _facebookAuthenticationService;
        private readonly ITokenGenerator _tokenGenerator;  

        public LoginFacebookCommandHandler(
            UserManager<ApplicationUser> userManager, 
            IFacebookAuthenticationService facebookAuthenticationSercice,
            ITokenGenerator tokenGenerator)
        {
            _userManager = userManager;
            _facebookAuthenticationService = facebookAuthenticationSercice;
            _tokenGenerator = tokenGenerator;
        }

        /// <summary>
        /// Login with facebook token. If user is not created then create new without password
        /// </summary>
        public async Task<JwtSecurityToken> Handle(LoginFacebookCommand request, CancellationToken cancellationToken)
        {
            var validatedTokenResult = await _facebookAuthenticationService.ValidateAccessTokenAsync(request.Token);

            if (!validatedTokenResult.Data.IsValid)
            {
                throw new InvalidTokenException();
            }

            var userInfo = await _facebookAuthenticationService.GetUserInfoAsync(request.Token);
            
            var user = await _userManager.FindByEmailAsync(userInfo.Email);

            if (user == null)
            {
                var identityUser = new ApplicationUser
                {
                    Id = Guid.NewGuid().ToString(),
                    Email = userInfo.Email,
                    UserName = userInfo.Email
                };

                var createdResult = await _userManager.CreateAsync(identityUser);

                if (createdResult.Succeeded == false)
                {
                    throw new Exception();
                }

                return await _tokenGenerator.GenerateTokenForUserAsync(identityUser);
            }

            return await _tokenGenerator.GenerateTokenForUserAsync(user);            
        }
    }
}