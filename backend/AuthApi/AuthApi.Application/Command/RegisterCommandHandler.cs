using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Identity;

using AuthApi.Domain;

namespace AuthApi.Application
{
    public class RegisterCommand : IRequest<bool>
    {
        public string Email { get; set; }    
        public string Password { get; set; }  

        public RegisterCommand(string emain, string password)
        {
            Email = emain;
            Password = password;
        }
    }
    
    public interface IRegisterCommandHandler : IRequestHandler<RegisterCommand, bool>
    {
    }

    public class RegisterCommandHandler : IRegisterCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  

        public RegisterCommandHandler(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<bool> Handle(RegisterCommand request, CancellationToken cancellationToken)
        {
            var userExists = await _userManager.FindByEmailAsync(request.Email);  
            if (userExists != null)  
            {
                throw new UserAlreadyExistException();
            }

            var user = new ApplicationUser()  
            {  
                Email = request.Email,  
                UserName = request.Email,  
                SecurityStamp = Guid.NewGuid().ToString(),  
            };  
            
            var result = await _userManager.CreateAsync(user, request.Password);  
            
            if (!result.Succeeded)  
            {
                throw new UserCreationFailedException();
            }
  
            return true;
        }
    }
}