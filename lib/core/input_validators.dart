class InputValidator {

  static String validateChannelInput(String value) {

    return value.isEmpty ? 'Name can\'t be empty!' : null;
  }

  static String validateDescriptionInput(String value) {

    return value.isEmpty ? 'Description can\'t be empty!' : null;
  }

  static String validateTitleInput(String value) {

    return value.isEmpty ? 'Title can\'t be empty!' : null;
  }

  static String validateQuestionInput(String value) {

    return value.isEmpty ? 'Question  can\'t be empty!' : null;
  }

  static String validateChoiceInput(String value) {

    return value.isEmpty ? 'Choices can\'t be empty!' : null;
  }

  static String validateExpirationInput(String value) {

    return value.isEmpty ? 'Expiration can\'t be empty!' : null;
  }
}