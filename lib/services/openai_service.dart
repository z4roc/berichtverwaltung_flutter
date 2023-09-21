import 'package:dart_openai/dart_openai.dart';

class OpenAiService {
  static Future<List<OpenAIChatCompletionChoiceModel>> onPromptSubmited(
      {required String prompt}) async {
    String basePrompt = "Kannst du mir $prompt in 4 Sätzen erklären?";

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: basePrompt,
        )
      ],
    );

    return chatCompletion.choices;
  }
}
