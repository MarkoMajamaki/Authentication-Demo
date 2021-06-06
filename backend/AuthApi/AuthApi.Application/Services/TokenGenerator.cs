using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using AuthApi.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace AuthApi.Application
{
    public interface ITokenGenerator
    {
        Task<JwtSecurityToken> GenerateTokenForUserAsync(ApplicationUser user);
    }

    public class TokenGenerator : ITokenGenerator
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private readonly IConfiguration _configuration;  

        public TokenGenerator(
            UserManager<ApplicationUser> userManager,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _configuration = configuration;
        }

        /// <summary>
        /// Create JWT token for user
        /// </summary>
        public async Task<JwtSecurityToken> GenerateTokenForUserAsync(ApplicationUser user)
        {
            var userRoles = await _userManager.GetRolesAsync(user);  

            var authClaims = new List<Claim>  
            {  
                new Claim(ClaimTypes.Name, user.UserName),  
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),  
            };  

            foreach (var userRole in userRoles)  
            {  
                authClaims.Add(new Claim(ClaimTypes.Role, userRole));  
            }  

            string jwtSected = _configuration["JWT:Secret"];

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSected));  

            return new JwtSecurityToken(  
                issuer: _configuration["JWT:ValidIssuer"],  
                audience: _configuration["JWT:ValidAudience"],  
                expires: DateTime.Now.AddHours(3),  
                claims: authClaims,  
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)  
                );  
        }

        /// <summary>
        /// Create JWT token for user
        /// </summary>
        public async Task<JwtSecurityToken> GenerateTokenForAdminAsync(ApplicationUser user)
        {
            var userRoles = await _userManager.GetRolesAsync(user);  

            var authClaims = new List<Claim>  
            {  
                new Claim(ClaimTypes.Name, user.UserName),  
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),  
            };  

            foreach (var userRole in userRoles)  
            {  
                authClaims.Add(new Claim(ClaimTypes.Role, userRole));  
            }  

            string jwtSected = _configuration["JWT:Secret"];

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSected));  

            return new JwtSecurityToken(  
                issuer: _configuration["JWT:ValidIssuer"],  
                audience: _configuration["JWT:ValidAudience"],  
                expires: DateTime.Now.AddHours(3),  
                claims: authClaims,  
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)  
                );  
        }
    }
}