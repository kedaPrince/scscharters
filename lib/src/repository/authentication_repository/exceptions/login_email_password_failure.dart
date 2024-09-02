

class LogInWithEmailAndPasswordFailure{
  final String message;
  const LogInWithEmailAndPasswordFailure([this.message = "Unknown error occurred"]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code){
    switch(code){
      case'weak-password' :
        return const LogInWithEmailAndPasswordFailure('Please enter a strong password');
      case'invalid-email' :
        return const LogInWithEmailAndPasswordFailure('Email is not valid');
      case'email-already-in-use' :
        return const LogInWithEmailAndPasswordFailure('An Account already with that email');
      case'operation-not-allowed' :
        return const LogInWithEmailAndPasswordFailure('Operation is not allowed, please contact support');
      case'user-disabled' :
        return const LogInWithEmailAndPasswordFailure('This user has been disabled please contact support for help');
      default: return const LogInWithEmailAndPasswordFailure();

    }

  }


}