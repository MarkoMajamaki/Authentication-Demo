using Microsoft.AspNetCore.Mvc;

using MediatR;
using System.Threading.Tasks;
using System.Threading;
using AuthApi.Application;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Http;
using System;

namespace AuthApi
{
    [ApiController]
    [Route("[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IFacebookAuthenticationService _facebookAuthService;
        private readonly IGoogleAuthenticationService _googleAuthService;

        public AuthController(
        IMediator mediator, 
        IFacebookAuthenticationService facebookAuthService, 
        IGoogleAuthenticationService googleAuthService)
        {
            _mediator = mediator;
            _facebookAuthService = facebookAuthService;
            _googleAuthService = googleAuthService;
        }

        [HttpPost]  
        [Route("login")]  
        public async Task<IActionResult> Login([FromBody] LoginModel model)  
        { 
            try 
            {
                LoginResponse response = await _mediator.Send(new LoginCommand(model.Email, model.Password), new CancellationToken());
                
                return Ok(new {
                    UserId = response.UserId,
                    Token = new JwtSecurityTokenHandler().WriteToken(response.Token),  
                    Expiration = response.Token.ValidTo,
                });
            }
            catch (InvalidPasswordException)
            {
                return Unauthorized();  
            }
            catch (UserNotFoundException)
            {
                return Unauthorized();
            }
        }

        [HttpPost]  
        [Route("register")]  
        public async Task<IActionResult> Register([FromBody] RegisterModel model)  
        {  
            try 
            {
                await _mediator.Send(new RegisterCommand(model.Email, model.Password), new CancellationToken());
                
                return Ok(new {
                    Status = "Success", 
                    Message = "User created successfully!"
                });  
            }
            catch (UserAlreadyExistException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User already exists!" 
                });
            }
            catch (UserCreationFailedException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User creation failed! Please check user details and try again.!" 
                });  
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = e.Message 
                });
            }
        }

        [HttpPost]  
        [Route("register-admin")]  
        public async Task<IActionResult> RegisterAdmin([FromBody] RegisterModel model)  
        {  
            try 
            {
                await _mediator.Send(new RegisterAdminCommand(model.Email, model.Password), new CancellationToken());
                
                return Ok(new {
                    Status = "Success", 
                    Message = "User created successfully!"
                });  
            }
            catch (UserAlreadyExistException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User already exists!" 
                });  
            }
            catch (UserCreationFailedException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User creation failed! Please check user details and try again.!" 
                });  
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = e.Message 
                });
            }
        }  
        
        /// <summary>
        /// Login with facebook token. If user is not registered do registering automatically.
        /// </summary>
        [HttpPost]  
        [Route("login-facebook")]  
        public async Task<IActionResult> LoginFacebook([FromBody] AccessTokenModel model)  
        { 
            try 
            {
                LoginResponse response = await _mediator.Send(new LoginExternalCommand(model.Token, _facebookAuthService), new CancellationToken());
                
                return Ok(new {
                    UserId = response.UserId,
                    Token = new JwtSecurityTokenHandler().WriteToken(response.Token),  
                    Expiration = response.Token.ValidTo  
                });
            }
            catch (InvalidPasswordException)
            {
                return Unauthorized();  
            }
            catch 
            {
                return Unauthorized("Something go wrong!");
            }
        }


        /// <summary>
        /// Login with Google token. If user is not registered do registering automatically.
        /// </summary>
        [HttpPost]  
        [Route("login-google")]  
        public async Task<IActionResult> LoginGoogle([FromBody] AccessTokenModel model)  
        { 
            try 
            {
                LoginResponse response = await _mediator.Send(new LoginExternalCommand(model.Token, _googleAuthService), new CancellationToken());
                
                return Ok(new {
                    UserId = response.UserId,
                    Token = new JwtSecurityTokenHandler().WriteToken(response.Token),  
                    Expiration = response.Token.ValidTo  
                });
            }
            catch (InvalidPasswordException)
            {
                return Unauthorized();  
            }
            catch 
            {
                return Unauthorized("Something go wrong!");
            }
        }

        [HttpGet]
        [Route("Test")]  
        public string Test()
        {
            return "Test";
        } 
    }
}