using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Google.Apis.Auth;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace AuthApi.Application
{
    public interface IGoogleAuthenticationService
    {
        Task<GoogleJsonWebSignature.Payload> VerifyGoogleToken(string accessToken);
    }
        
    public class GoogleAuthenticationService : IGoogleAuthenticationService
    {
        private IOptions<GoogleAuthSettings> _googleAuthSettings;

        public GoogleAuthenticationService(IOptions<GoogleAuthSettings> googleAuthSettings)
        {
            _googleAuthSettings = googleAuthSettings;
        }

        public async Task<GoogleJsonWebSignature.Payload> VerifyGoogleToken(string accessToken)
        {
            var settings = new GoogleJsonWebSignature.ValidationSettings()
            {
                Audience = new List<string>() { _googleAuthSettings.Value.ClientId }
            };
            var payload = await GoogleJsonWebSignature.ValidateAsync(accessToken, settings);
            return payload;
        }
    }
}