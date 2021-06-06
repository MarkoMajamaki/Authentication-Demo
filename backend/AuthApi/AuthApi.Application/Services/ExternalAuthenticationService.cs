using System;
using System.Threading.Tasks;

namespace AuthApi.Application
{
    public interface IExternalAuthenticationService
    {
        Task<UserInfo> AuthenticateAsync(string accessToken);
    }

    public record UserInfo(String Email, string Name);
}