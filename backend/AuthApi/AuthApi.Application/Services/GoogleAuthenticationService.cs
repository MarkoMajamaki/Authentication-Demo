using System.Threading.Tasks;
using Google.Apis.Auth;

namespace AuthApi.Application
{
    public interface IGoogleAuthenticationService : IExternalAuthenticationService
    {
    }
        
    public class GoogleAuthenticationService : IGoogleAuthenticationService
    {
        public async Task<UserInfo> AuthenticateAsync(string idToken)
        {
            var user = await GoogleJsonWebSignature.ValidateAsync(idToken);
            return new UserInfo(user.Email, user.Name);
        }
    }
}