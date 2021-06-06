using System.IdentityModel.Tokens.Jwt;

namespace AuthApi.Application
{
    public record LoginResponse(string UserId, JwtSecurityToken Token);

}