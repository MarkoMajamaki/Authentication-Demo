using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Identity;

using AuthApi.Domain;

namespace AuthApi.Application
{
    public class RegisterAdminCommand : IRequest<bool>
    {
        public string Email { get; set; }    
        public string Password { get; set; }  

        public RegisterAdminCommand(string emain, string password)
        {
            Email = emain;
            Password = password;
        }
    }
    
    public interface IRegisterAdminCommandHandler : IRequestHandler<RegisterAdminCommand, bool>
    {
    }

    public class RegisterAdminCommandHandler : IRegisterAdminCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private readonly RoleManager<IdentityRole> _roleManager;  

        public RegisterAdminCommandHandler(
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole> roleManager)
        {
            _userManager = userManager;
            _roleManager = roleManager;
        }

        public async Task<bool> Handle(RegisterAdminCommand request, CancellationToken cancellationToken)
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
  
            if (!await _roleManager.RoleExistsAsync(UserRoles.Admin))  
            {
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.Admin));  
            }

            if (!await _roleManager.RoleExistsAsync(UserRoles.User))  
            {
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.User));  
            }
  
            if (await _roleManager.RoleExistsAsync(UserRoles.Admin))  
            {  
                await _userManager.AddToRoleAsync(user, UserRoles.Admin);  
            }  

            return true;
        }
    }
}