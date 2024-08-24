//login exceptions

class UserNotFoundException implements Exception{

}
class WrongPasswordAuthException implements Exception{

}

//register exceptions
class WeakPasswordException implements Exception{}
class EmailAlreadyinUseException implements Exception{}
class InvalidEmailAuthException implements Exception{}

//generic exception
class GenericAuthException implements Exception{}
class UsrNotLoggedInAuthException implements Exception{}

