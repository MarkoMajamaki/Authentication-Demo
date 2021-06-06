using System;
using System.IdentityModel.Tokens.Jwt;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Identity;

using AuthApi.Domain;

namespace AuthApi.Application
{
    public class LoginExternalCommand : IRequest<LoginResponse>
    {
        public string Token { get; private set; }  

        public IExternalAuthenticationService ExternalAuthenticationService { get; private set; }

        public LoginExternalCommand(string token, IExternalAuthenticationService externalAuthenticationService)
        {
            Token = token;
            ExternalAuthenticationService = externalAuthenticationService;
        }
    }
    
    public interface ILoginExternalCommandHandler : IRequestHandler<LoginExternalCommand, LoginResponse>
    {
    }

    public class LoginExternalCommandHandler : ILoginExternalCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private readonly ITokenGenerator _tokenGenerator;  

        public LoginExternalCommandHandler(
            UserManager<ApplicationUser> userManager, 
            ITokenGenerator tokenGenerator)
        {
            _userManager = userManager;
            _tokenGenerator = tokenGenerator;
        }

        /// <summary>
        /// Login with external provider
        /// </summary>
        public async Task<LoginResponse> Handle(LoginExternalCommand request, CancellationToken cancellationToken)
        {
            UserInfo userInfo = await request.ExternalAuthenticationService.AuthenticateAsync(request.Token);
            
            var user = await _userManager.FindByEmailAsync(userInfo.Email);

            if (user == null)
            {
                user = new ApplicationUser
                {
                    Id = Guid.NewGuid().ToString(),
                    Email = userInfo.Email,
                    UserName = userInfo.Email
                };

                var createdResult = await _userManager.CreateAsync(user);

                if (createdResult.Succeeded == false)
                {
                    throw new Exception();
                }
            }
            JwtSecurityToken token = await _tokenGenerator.GenerateTokenForUserAsync(user);

            return new LoginResponse(user.Id, token);            
        }
    }
}